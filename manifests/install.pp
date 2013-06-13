# == Class: minecraft::install
#
# The mincraft::install class downloads minecraft_server.jar from the
# Internet and installs it in a central location.  It also creates a
# minecraft user and group, and creates directories to house
# configuration and world data.
#
# The minecraft module bundles init and wrapper scripts to simplify
# running the Minecraft server as a system service.  These scripts are
# installed by the minecraft::install class.
#
# === Parameters
#
# The minecraft class takes one parameter.
#
# [*ensure*]
#   Valid values are installed / present / true and uninstalled /
#   present / false.  Read from Hiera.  Defaults to installed'.
#
# [*server_url*]
#   The Internet URL from which minecraft_server.jar will be
#   downloaded.  Read from Hiera.  Defaults to
#   https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar.
#
# === Examples
#
# include minecraft::install
#
# === Authors
#
# Jonathon Anderson <janderson@civilfritz.net>
#
# === Copyright
#
# Copyright 2013 Jonathon Anderson, unless otherwise noted.

class minecraft::install

(
  $ensure     = hiera('minecraft::install::ensure', 'installed'),
  $server_url = hiera('minecraft::install::server_url', $minecraft::params::server_url)
)

inherits minecraft::params

{
  $installed = $ensure ?
  {
    /^(installed|present|true)$/   => true,
    /^(uninstalled|absent|false)$/ => false,
    default                        => fail("unexpected value for ensure: ${ensure}"),
  }

  $file_ensure = $installed ?
  {
    true  => 'present',
    false => 'absent',
  }

  $user_ensure = $file_ensure
  $group_ensure = $user_ensure

  $directory_ensure = $installed ?
  {
    true  => 'directory',
    false => 'absent',
  }

  $config_directory_ensure = $installed ?
  {
    true  => 'directory',
    false => undef,
  }

  # the actual minecraft_server.jar
  if $installed
  {
    exec { 'wget minecraft_server.jar':
      command => "/usr/bin/wget -O /usr/lib/minecraft/minecraft_server.jar ${server_url} >/dev/null 1>&2",
      creates => '/usr/lib/minecraft/minecraft_server.jar',
      require => File['/usr/lib/minecraft'],
      before  => File['/usr/lib/minecraft/minecraft_server.jar'],
    }
  }

  file { '/usr/lib/minecraft/minecraft_server.jar':
    ensure => $file_ensure,
    owner  => '0',
    group  => '0',
    mode   => '0644',
  }

  file { '/usr/lib/minecraft':
    ensure => $directory_ensure,
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  if ! $installed
  {
    File['/usr/lib/minecraft/minecraft_server.jar'] -> File['/usr/lib/minecraft']
  }

  # world files and server data
  file { '/var/lib/minecraft':
    ensure => $config_directory_ensure,
    owner  => 'minecraft',
    group  => 'minecraft',
    mode   => '0755',
  }

  # pidfile and server pipe are
  file { '/var/run/minecraft':
    ensure => $directory_ensure,
    owner  => 'minecraft',
    group  => 'minecraft',
    mode   => '0755',
  }

  # init script
  file { '/etc/init.d/minecraft':
    ensure  => $file_ensure,
    source  => $minecraft::params::initscript,
    owner   => '0',
    group   => '0',
    mode    => '0755',
    require => File['/usr/bin/minecraft_server'],
  }

  # wrapper script for connecting minecraft_server.jar to an IO pipe
  file { '/usr/bin/minecraft_server':
    ensure => $file_ensure,
    source => 'puppet:///modules/minecraft/minecraft_server.sh',
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  # user and group for the Minecraft daemon
  user { 'minecraft':
    ensure => $user_ensure,
    home   => '/var/lib/minecraft',
    gid    => 'minecraft',
    shell  => '/usr/sbin/nologin',
  }

  group { 'minecraft':
    ensure => $group_ensure,
  }
}

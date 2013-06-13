# == Class: minecraft
#
# The mincraft class serves as an abstract shortcut to holistically
# configure an entire Minecraft server.  It installs the Minecraft
# server using minecraft::install, configures a server instance using
# minecraft::config, and manages the Minecraft daemon using
# minecraft::service.  Changes to the config will cause the server to
# be reloaded using minecraft::service::reload.
#
# === Parameters
#
# The minecraft class takes five parameters, most of which are passed
# directly to underlying subclasses.
#
# [*ensure*]
#   Valid values are absent / uninstalled / false, present / installed
#   / stopped, and running / true.  Controls the presence of installed
#   files via minecraft::install and minecraft::config, and the status
#   of the server daemon via minecraft::service and
#   minecraft::service::reload.  Read from Hiera.  Defaults to
#   running.
#
# [*server_url*]
#   The Internet URL from which minecraft_server.jar will be
#   downloaded.  Read from Hiera.  Defaults to the value specified in
#   minecraft::params.
#
# [*level_name*]
#   The name of the world generated or referenced by the running
#   Minecraft server.  Read from Hiera.  Defaults to 'world'.
#
# [*level_seed*]
#   The random number seed used to generate a world.  Read from Hiera.
#   Undefined by default.
#
# [*motd*]
#   The message displayed for this server in the server browser.  Read
#   from Hiera.  Undefined by default.
#
# === Examples
#
#  class { 'minecraft':
#    level_name => 'civilfritz',
#    level_seed => 'civilfritz',
#    motd       => 'civilfritz Minecraft server',
#  }
#
# === Authors
#
# Jonathon Anderson <janderson@civilfritz.net>
#
# === Copyright
#
# Copyright 2013 Jonathon Anderson, unless otherwise noted.

class minecraft

(
  $ensure     = hiera('minecraft::ensure', 'running'),
  $server_url = hiera('minecraft::server_url', $minecraft::params::server_url),
  $level_name = hiera('minecraft::level_name', 'world'),
  $level_seed = hiera('minecraft::level_seed', undef),
  $motd       = hiera('minecraft::motd', undef)
)

inherits minecraft::params

{
  $install_ensure = $ensure ?
  {
    /^(absent|uninstalled|false)$/               => 'uninstalled',
    /^(stopped|present|installed|running|true)$/ => 'installed',
    default                                      => fail("unexpected value for ensure: ${ensure}"),
  }

  $service_ensure = $ensure ?
  {
    /^(absent|uninstalled|false|stopped)$/ => 'stopped',
    /^(present|installed)$/                => undef,
    /^(running|true)$/                     => 'running',
    default                                => fail("unexpected value for ensure: ${ensure}"),
  }

  $reload = $service_ensure ?
  {
    'running' => true,
    'stopped' => false,
    undef     => false,
    default   => fail("unexpected value for ensure: ${service_ensure}"),
  }

  class { 'minecraft::install':
    ensure => $install_ensure,
  }

  class { 'minecraft::config':
    level_name => $level_name,
    level_seed => $level_seed,
    motd       => $motd,
    require    => Class['minecraft::install'],
  }

  class { 'minecraft::service':
    ensure  => $service_ensure,
    require => [
                Class['minecraft::install'],
                Class['minecraft::config'],
                ],
  }

  if $reload
  {
    class { 'minecraft::service::reload':
      require   => Class['minecraft::service'],
      subscribe => Class['minecraft::config'],
    }
  }
}

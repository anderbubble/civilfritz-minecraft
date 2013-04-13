class minecraft::install

(
  $server_url = 'https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar'
)

{
  include minecraft::params

  user { 'minecraft':
    ensure => present,
    home   => '/var/lib/minecraft',
    gid    => 'minecraft',
    shell  => '/bin/bash',
  }

  group { 'minecraft':
    ensure => present,
  }

  file { '/usr/lib/minecraft':
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  file { '/var/lib/minecraft':
    ensure => directory,
    owner  => 'minecraft',
    group  => 'minecraft',
    mode   => '0755',
  }

  file { '/var/run/minecraft':
    ensure => directory,
    owner  => 'minecraft',
    group  => 'minecraft',
    mode   => '0755',
  }

  exec { 'wget minecraft_server.jar':
    command => "/usr/bin/wget -O /usr/lib/minecraft/minecraft_server.jar ${server_url} >/dev/null 1>&2",
    creates => '/usr/lib/minecraft/minecraft_server.jar',
    require => File['/usr/lib/minecraft'],
  }

  file { '/usr/bin/minecraft_server':
    source => 'puppet:///modules/minecraft/minecraft_server.sh',
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  file { '/usr/lib/minecraft/minecraft_server.jar':
    owner   => '0',
    group   => '0',
    mode    => '0644',
    require => Exec['wget minecraft_server.jar'],
  }

  file { '/etc/init.d/minecraft':
    source  => $minecraft::params::initscript,
    owner   => '0',
    group   => '0',
    mode    => '0755',
    require => File['/usr/bin/minecraft_server'],
  }
}

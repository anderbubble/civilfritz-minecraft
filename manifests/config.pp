# == Class: minecraft::config
#
# The mincraft::config class configures an instance of a Minecraft
# server by generating a server.properties file.
#
# === Parameters
#
# The minecraft::config class takes three parameters.
#
# [*ensure*]
#   Valid values are present / true and absent / false.  Read from
#   Hiera.  Defaults to present.
#
# [*level_name*]
#   The name of the world generated or referenced by the running
#   Minecraft server. Read from Hiera. Defaults to 'world'.
#
# [*level_seed*]
#   The random number seed used to generate a world. Read from Hiera.
#   Undefined by default.
#
# [*motd*]
#   The message displayed for this server in the server browser. Read
#   from Hiera. Defaults to 'A Minecraft Server'.
#
# [*spawn_protection*]
#   The radius of the spawn protection as the number of blocks away
#   from the origin. Undefined by default.
#
# [*public*]
#   Whether the server should be displayed in the server list, or
#   not. Valid values are true and false. Undefined by default.
#
# [*difficulty*]
#   Defines the difficulty of the server. Valid values are 0, 1, 2,
#   3. 1 by default.
#
# [*white_list*]
#   Enables a whitelist on the server. Valid values are true and
#   false. Defaults to false.
#
# [*server_port*]
#   Changes the port the server is hosting (listening) on. Defaults to
#   '25565'.
#
# === Examples
#
#  class { 'minecraft::config':
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

class minecraft::config

(
  $ensure           = hiera('minecraft::config::ensure', 'present'),
  $level_name       = hiera('minecraft::config::level_name', $minecraft::params::level_name),
  $level_seed       = hiera('minecraft::config::level_seed', undef),
  $motd             = hiera('minecraft::config::motd', $minecraft::params::motd),
  $white_list       = hiera('minecraft::config::white_list', $minecraft::params::white_list),
  $difficulty       = hiera('minecraft::config::difficulty', $minecraft::params::difficulty),
  $public           = hiera('minecraft::config::public', undef),
  $spawn_protection = hiera('minecraft::config::spawn_protection', undef),
  $server_port      = hiera('minecraft::config::server_port', $minecraft::params::server_port)
)

inherits minecraft::params

{
  file { '/var/lib/minecraft/server.properties':
    ensure  => $ensure,
    content => template('minecraft/server.properties.erb'),
    owner   => 'minecraft',
    group   => 'minecraft',
    mode    => '0644',
  }

  file { '/var/lib/minecraft/ops.txt':
    owner => 'minecraft',
    group => 'minecraft',
    mode  => '0644',
  }

  file { '/var/lib/minecraft/white-list.txt':
    owner => 'minecraft',
    group => 'minecraft',
    mode  => '0644',
  }

  file { '/var/lib/minecraft/banned-ips.txt':
    owner => 'minecraft',
    group => 'minecraft',
    mode  => '0644',
  }

  file { '/var/lib/minecraft/banned-players.txt':
    owner => 'minecraft',
    group => 'minecraft',
    mode  => '0644',
  }
}

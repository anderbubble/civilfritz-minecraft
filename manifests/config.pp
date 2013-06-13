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
#   Valid values are installed / present / true and uninstalled /
#   absent / false.  Read from Hiera.  Defaults to present.
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
  $ensure     = hiera('minecraft::config::ensure', 'present'),
  $level_name = hiera('minecraft::config::level_name', $minecraft::params::level_name),
  $level_seed = hiera('minecraft::config::level_seed', undef),
  $motd       = hiera('minecraft::config::motd', undef)
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
}

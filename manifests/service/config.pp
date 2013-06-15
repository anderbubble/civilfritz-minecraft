# == Class: minecraft::service::config
#
# The mincraft::service::config class configures initialization
# parameters for the Minecraft server process.
#
# === Parameters
#
# The minecraft::service::config class takes three parameters.
#
# [*ensure*]
#   Valid values are present / true and absent / false.  Read from
#   Hiera.  Defaults to present.
#
# [*memory_init*]
#   The initial amount of memory to allocate to the server.  Read from
#   Hiera.  Undefined by default.
#
# [*memory_max*]
#   The maximum amount of memory to allocate to the server.  Read from
#   Hiera.  Undefined by default.
#
# === Examples
#
#  class { 'minecraft::service::config':
#    memory_init => '512M',
#    memory_max  => '1024M',
#  }
#
# === Authors
#
# Jonathon Anderson <janderson@civilfritz.net>
#
# === Copyright
#
# Copyright 2013 Jonathon Anderson, unless otherwise noted.

class minecraft::service::config

(
  $ensure      = hiera('minecraft::config::ensure', 'present'),
  $memory_init = hiera('minecraft::config::java_memory_init', undef),
  $memory_max  = hiera('minecraft::config::java_memory_max', undef)
)

{
  file { '/etc/default/minecraft':
    ensure  => $ensure,
    content => template('minecraft/init-default.erb'),
    owner   => '0',
    group   => '0',
    mode    => '0644',
  }
}

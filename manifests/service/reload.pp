# == Class: minecraft::service::reload
#
# The minecraft::service::reload class reloads the Minecraft server
# configuration without restarting the Minecraft server.
#
# === Examples
#
#  class { 'minecraft::service::reload':
#    subscribe => Class['minecraft::config'],
#  }
#
# === Authors
#
# Jonathon Anderson <janderson@civilfritz.net>
#
# === Copyright
#
# Copyright 2013 Jonathon Anderson, unless otherwise noted.

class minecraft::service::reload
{
  include minecraft::params

  exec { 'reload minecraft server config':
    command     => $minecraft::params::reload_command,
    refreshonly => true,
  }    
}

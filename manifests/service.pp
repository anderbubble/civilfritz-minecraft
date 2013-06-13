# == Class: minecraft::service
#
# The minecraft::service class manages the Minecraft server as a
# system service.  It depends on the bundled init script, installed by
# minecraft::install.
#
# === Parameters
#
# The minecraft class takes three parameters, all of which are passed
# through to underlying subclasses.
#
# [*ensure*]
#   Valid values are stopped / false and running / true.  Read from
#   Hiera.  Defaults to running.
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

class minecraft::service

(
  $ensure = hiera('minecraft::service::ensure', 'running'),
  $enable = hiera('minecraft::service::enable', true)
)

{
  service { 'minecraft':
    ensure    => $ensure,
    hasstatus => true,
    enable    => $enable,
  }
}

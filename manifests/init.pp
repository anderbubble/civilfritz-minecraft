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
#   / stopped, and running / true. Controls the presence of installed
#   files via minecraft::install and minecraft::config, and the status
#   of the server daemon via minecraft::service and
#   minecraft::service::reload. Read from Hiera. Defaults to
#   running.
#
# [*memory_init*]
#   The initial amount of memory to allocate to the server. Read from
#   Hiera. Undefined by default.
#
# [*memory_max*]
#   The maximum amount of memory to allocate to the server. Read from
#   Hiera. Undefined by default.
#
# [*server_url*]
#   The Internet URL from which minecraft_server.jar will be
#   downloaded. Read from Hiera. Defaults to the value specified in
#   minecraft::params.
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
  $ensure           = hiera('minecraft::ensure', 'running'),
  $memory_init      = hiera('minecraft::memory_init', undef),
  $memory_max       = hiera('minecraft::memory_max', undef),
  $server_url       = hiera('minecraft::server_url', $minecraft::params::server_url),
  $level_name       = hiera('minecraft::level_name', 'world'),
  $level_seed       = hiera('minecraft::level_seed', undef),
  $motd             = hiera('minecraft::motd', $minecraft::params::motd),
  $white_list       = hiera('minecraft::white_list', $minecraft::params::white_list),
  $difficulty       = hiera('minecraft::difficulty', $minecraft::params::difficulty),
  $public           = hiera('minecraft::public', undef),
  $spawn_protection = hiera('minecraft::spawn_protection', undef)
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
    level_name       => $level_name,
    level_seed       => $level_seed,
    motd             => $motd,
    white_list       => $white_list,
    difficulty       => $difficulty,
    public           => $public,
    spawn_protection => $spawn_protection,
    require          => Class['minecraft::install'],
  }

  class { 'minecraft::service::config':
    memory_init => $memory_init,
    memory_max  => $memory_max,
  }
    

  class { 'minecraft::service':
    ensure    => $service_ensure,
    require   => [
                  Class['minecraft::install'],
                  Class['minecraft::config'],
                  ],
    subscribe => Class['minecraft::service::config'],
  }

  if $reload
  {
    class { 'minecraft::service::reload':
      require   => Class['minecraft::service'],
      subscribe => Class['minecraft::config'],
    }
  }
}

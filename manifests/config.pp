class minecraft::config

(
  $level_name = hiera('minecraft::level_name', 'world'),
  $level_seed = hiera('minecraft::level_seed', undef),
  $motd       = hiera('minecraft::motd', undef)
)

{
  file { '/var/lib/minecraft/server.properties':
    content => template('minecraft/server.properties.erb'),
    owner   => 'minecraft',
    group   => 'minecraft',
    mode    => '0644',
  }
}

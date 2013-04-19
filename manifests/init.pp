class minecraft

(
  $level_name = hiera('minecraft::level_name', 'world'),
  $level_seed = hiera('minecraft::level_seed', undef),
  $motd       = hiera('minecraft::motd', undef)
)

{
  include minecraft::install
  class { 'minecraft::config':
    level_name => $level_name,
    level_seed => $level_seed,
    motd       => $motd,
  }
  include minecraft::service
}

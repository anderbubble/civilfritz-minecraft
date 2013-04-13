class minecraft::service
{
  service { 'minecraft':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Class['minecraft::config'],
  }
}

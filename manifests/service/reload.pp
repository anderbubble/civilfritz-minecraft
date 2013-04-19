class minecraft::service::reload
{
  include minecraft::params

  exec { 'reload minecraft server config':
    command     => $minecraft::params::reload_command,
    refreshonly => true,
  }
    
}

class minecraft::params
{
  case $::osfamily
  {
    'Debian':
    {
      $initscript = 'puppet:///modules/minecraft/init/debian.sh'
      $reload_command = '/usr/sbin/service minecraft reload'
    }

    default:
    {
      fail("unsupported operating system type: ${::osfamily}")
    }
  }
}

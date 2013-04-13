class minecraft::params
{
  case $::osfamily
  {
    'Debian':
    {
      $initscript = 'puppet:///modules/minecraft/init/debian.sh'
    }

    default:
    {
      fail("unsupported operating system type: ${::osfamily}")
    }
  }
}

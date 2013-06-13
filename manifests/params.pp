class minecraft::params
{
  $server_url = 'https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar'
  $level_name = 'world'

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

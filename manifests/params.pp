class minecraft::params
{
  $server_url = 'https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar'
  $level_name = 'world'
  $white_list = false
  $difficulty = '1'
  $server_port = '25565'
  $motd = 'A Minecraft Server'
  $max_players = '20'

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

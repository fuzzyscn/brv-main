resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

resource_type 'gametype' { name = 'Battle Royale' }

description 'Battle Royale Mode'

-- WarMenu resource
client_script "@warmenu/warmenu.lua"
server_script '@mysql-async/lib/MySQL.lua'

client_script {
  'client_menu.lua',
  'threads.lua',
  'gamertags.lua',
  'function.lua',
}

server_script {
  'server.lua',
  'player.lua',
}

dependencies { 'mapmanager' }
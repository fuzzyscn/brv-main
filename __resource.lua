resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Fun Battle Race Mode'

--client_script "@warmenu/warmenu.lua"
--server_script '@mysql-async/lib/MySQL.lua'

client_script {
  'NativeUI.lua',
  'client.lua',
  'function.lua',
  'gamertags.lua',
}

server_script {
  'server.lua',
  --'player.lua',
}
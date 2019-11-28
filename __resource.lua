--resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description 'Fun Battle Race Mode'

--client_script "@warmenu/warmenu.lua"
--server_script '@mysql-async/lib/MySQL.lua'

client_script {
  'NativeUI.lua',
  'threads.lua',
  'gamertags.lua',
  'function.lua',
}

server_script {
  'server.lua',
  'player.lua',
}
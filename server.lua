local gameHost = false
local players = {}
local safeZonesCoords = {}
local isGameStarted = false
local nbAlivePlayers = 0
local gameId = 0
local sqlDateFormat = '%Y-%m-%d %H:%M:%S'
local props = {}

RegisterServerEvent('fuzzys:playerSpawned')
AddEventHandler('fuzzys:playerSpawned', function()
  if not players[source] then
    loadPlayer(source)
  end
end)

RegisterNetEvent('fuzzys:hostGame')
AddEventHandler('fuzzys:hostGame', function(npcPlayer)
    gameHost = true
    print(npcPlayer)
end)

RegisterNetEvent('fuzzys:getplayerid')
AddEventHandler('fuzzys:getplayerid', function(i)
    print(i)
    print(os.date(sqlDateFormat))
end)

RegisterServerEvent('map:sync')
AddEventHandler('map:sync', function(pos, angle)
    for _, playerId in ipairs(GetPlayers()) do
        if tostring(source) ~= tostring(playerId) then
            TriggerClientEvent('map:create', playerId, pos, angle)
        end
    end
    tablejsonList(pos, angle)
end)

RegisterServerEvent('fuzzys:loadmap')
AddEventHandler('fuzzys:loadmap', function()
    TriggerClientEvent('map:loadmap', source, props.prop)
end)

Citizen.CreateThread(function()
    local data = LoadResourceFile(GetCurrentResourceName(), "props.json") or ""
    if data ~= "" then
        props = json.decode(data)
    else
        props = {
            prop = {}
        }
    end
    --unpackTable(props.prop)
    --table.sort(props.mission.race.chl, function(a,b))
end)

function tablejsonList(pos, angle)
	local posAngle = {
		x = pos.x,
		y = pos.y,
		z = pos.z,
		a = angle
	}
    table.insert(props.prop, posAngle)
	SaveResourceFile(GetCurrentResourceName(), "props.json", json.encode(props), -1)
end
function unpackTable(tb)
    for k, v in pairs(tb) do
        print(k)
        for k, v in pairs(v) do
            print(k .. " " .. v)
        end
    end
end

function loadPlayer(source)
  if players[source] == nil then
    local steamId = GetPlayerIdentifiers(source)[1]

    MySQL.Async.fetchAll('SELECT * FROM players WHERE steamid=@steamid LIMIT 1', {['@steamid'] = steamId}, function(playersDB) --'status,eq,1'
      local player = playersDB[1]
      if player ~= nil then
        players[source] = Player.new(player.id, steamId, player.name, player.role, source)

        --TriggerEvent('fuzzys:playerLoaded', source, players[source])
        MySQL.Async.execute('UPDATE players SET last_login=@last_login WHERE id=@id', {['@last_login'] = os.date(sqlDateFormat), ['@id'] = player.id})
      else
        MySQL.Async.execute('INSERT INTO players (steamid, role, name, created, last_login, status) VALUES (@steamid, @role, @name, @created, @last_login, @status)',
          {['@steamid'] = steamId, ['@role'] = '普通玩家', ['@name'] = GetPlayerName(source), ['@created'] = os.date(sqlDateFormat), ['@last_login'] = os.date(sqlDateFormat), ['@status'] = 1}, function()
            MySQL.Async.fetchScalar('SELECT id FROM players WHERE steamid=@steamid', {['@steamid'] = steamId}, function(id)
              players[source] = Player.new(id, steamId, GetPlayerName(source), '普通玩家', source)
             --TriggerEvent('fuzzys:playerLoaded', source, players[source])
            end)
        end)
      end
    end)
  end
end
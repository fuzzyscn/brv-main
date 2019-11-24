local gameHost = false
local players = {}
local safeZonesCoords = {}
local isGameStarted = false
local nbAlivePlayers = 0
local gameId = 0
local sqlDateFormat = '%Y-%m-%d %H:%M:%S'
local props = {}
local prop_list = {}
local no = 0

RegisterServerEvent('fuzzys:playerSpawned')
AddEventHandler('fuzzys:playerSpawned', function()
  if not players[source] then
    --loadPlayer(source)
  end
end)

RegisterNetEvent('fuzzys:loadmodel')
AddEventHandler('fuzzys:loadmodel', function(npcPlayer)
    gameHost = true
    TriggerClientEvent('map:loadmap', source, prop_list.mission.prop)
    print(npcPlayer)
end)

RegisterNetEvent('fuzzys:getplayerid')
AddEventHandler('fuzzys:getplayerid', function(i)
    print(i)
    print(os.date(sqlDateFormat))
end)

RegisterServerEvent('map:sync')
AddEventHandler('map:sync', function(pos, angle, new, rot)
    for _, playerId in ipairs(GetPlayers()) do
        if tostring(source) ~= tostring(playerId) then
            TriggerClientEvent('map:create', playerId, pos, angle)
        end
    end
    tablejsonList(new, rot)
end)

RegisterServerEvent('fuzzys:loadmap')
AddEventHandler('fuzzys:loadmap', function()
    TriggerClientEvent('map:loadmap', source, props.mission.prop)
end)

Citizen.CreateThread(function()
    local data1 = LoadResourceFile(GetCurrentResourceName(), "race.json") or ""
    if data1 ~= "" then
        props = json.decode(data1)
    end
    local data2 = LoadResourceFile(GetCurrentResourceName(), "prop_list.json") or ""
    if data2 ~= "" then
        prop_list = json.decode(data2)
    end
    no = prop_list.mission.prop.no
    --  {"mission":{"prop":{"model":[],"loc":[],"no":0,"vRot":[]}}}
    --print(props.mission.gen.propno)
    --print(prop_list.mission.prop.model[1])
    --unpackTable(prop_list.mission.prop.vRot)
    --unpackTable(prop_list.mission.prop.loc)
end)

function tablejsonList(pos, rot)
    
    local model = GetHashKey("stt_prop_ramp_jump_xs")
	local loc = {
		x = pos.x,
		y = pos.y,
		z = pos.z - 0.1,
	}
    local vRot = {
		x = rot.x,
		y = rot.y,
		z = rot.z,
	}
    no = no + 1
    prop_list.mission.prop.no = no
    table.insert(prop_list.mission.prop.model, model)
    table.insert(prop_list.mission.prop.loc, loc)
    table.insert(prop_list.mission.prop.vRot, vRot)
    --table.sort(prop_list.mission.prop)
	SaveResourceFile(GetCurrentResourceName(), "prop_list.json", json.encode(prop_list), -1)
end
function unpackTable(tb)
    for k, v in pairs(tb) do
        print(k)
        for k, v in pairs(v) do
            print(k .. " " .. v)
        end
    end
end

--[[function loadPlayer(source)
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
end]]--
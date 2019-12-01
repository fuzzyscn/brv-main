local gameHost = false
local players = {}
local sqlDateFormat = '%Y-%m-%d %H:%M:%S'
local props = {}
local prop_list = {}
local no = 0
--local countrycodes = {"zh-cn", "zh", "en", "de", "pt", "es", "es-mx", "pl", "ru", "it", "fr", "ko", "ja"}

RegisterServerEvent('fuzzys:playerSpawned')
AddEventHandler('fuzzys:playerSpawned', function()
  --if not players[source] then
    --loadPlayer(source)
  --end
  --TriggerClientEvent('map:loadmap', source, props)
end)

RegisterNetEvent('fuzzys:loadmodel')
AddEventHandler('fuzzys:loadmodel', function(npcPlayer)
    print(npcPlayer)
    gameHost = true
    TriggerClientEvent('map:loadmap', source, prop_list)
end)

RegisterNetEvent('fuzzys:getplayerid')
AddEventHandler('fuzzys:getplayerid', function(i)
    print(i)
end)

RegisterServerEvent('map:sync')
AddEventHandler('map:sync', function(pos, angle, new, rot, model, color)
    for _, playerId in ipairs(GetPlayers()) do
        if tostring(source) ~= tostring(playerId) then
            TriggerClientEvent('map:create', playerId, pos, angle, model, color)
        end
    end
    tablejsonList(new, rot, model, color)
end)

RegisterServerEvent('fuzzys:loadmap')
AddEventHandler('fuzzys:loadmap', function(mapname)
    print(os.date(sqlDateFormat) .. " 加载地图: " .. mapname)
    local data = LoadResourceFile(GetCurrentResourceName(), "/json/" .. mapname .. ".json") or ""
    if data ~= "" then
        props = json.decode(data)
    end
    TriggerClientEvent('map:loadmap', source, props)
    SaveResourceFile(GetCurrentResourceName(), "/json/fuzzys.json", json.encode(prop_list), -1)
end)

Citizen.CreateThread(function()
    local data1 = LoadResourceFile(GetCurrentResourceName(), "/json/race.json") or ""
    if data1 ~= "" then
        props = json.decode(data1)
    end
    local data2 = LoadResourceFile(GetCurrentResourceName(), "/json/prop_list.json") or ""
    if data2 ~= "" then
        prop_list = json.decode(data2)
    end
    no = prop_list.mission.prop.no
    --{"mission":{"prop":{"model":[],"prpclr":[],"loc":[],"no":0,"vRot":[]}}}
    --print(props.mission.gen.propno)
    --print(prop_list.mission.prop.model[1])
    --unpackTable(prop_list.mission.prop.vRot)
    --unpackTable(prop_list.mission.prop.loc)
end)

function tablejsonList(pos, rot, model, color)
    
    --local model = GetHashKey("stt_prop_ramp_jump_xs")
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
    table.insert(prop_list.mission.prop.prpclr, color)
    table.insert(prop_list.mission.prop.model, model)
    table.insert(prop_list.mission.prop.loc, loc)
    table.insert(prop_list.mission.prop.vRot, vRot)
    --table.sort(prop_list.mission.prop)
    --SaveResourceFile(GetCurrentResourceName(), "/json/prop_list.json", json.encode(prop_list), -1)
end
function unpackTable(tb)
    for k, v in pairs(tb) do
        print(k)
        for k, v in pairs(v) do
            print(k .. " " .. v)
        end
    end
end

AddEventHandler('chatMessage', function(source, name, message)
  local args = stringsplit(message, " ")
  if (args[1] == "/json") then
    CancelEvent()
    if (args[2] ~= nil) then
      --local playerID = tonumber(source)
      local url = tostring(args[2])      
      getJsonFromUrl(url)
      TriggerClientEvent('map:loadmap', source, props)
    end
  end
end)

function getJsonFromUrl(url)
    --for _, code in ipairs(countrycodes) do
        --json_url = url.replace("2_0.jpg","0_0_"+code+".json")
        --json_url = json_url.replace("1_0.jpg","0_0_"+code+".json")
        PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
            if errorCode == 200 then
                props = json.decode(resultData)
            else
                print("Url Error!!!" .. errorCode)
            end
        end, "GET", "", {})--"Content-Type" = 'application/x-www-form-urlencoded'
    -- end
    -- return response
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
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
RconLog({ msgType = 'serverStart', hostname = 'lovely', maxplayers = 32 })

RegisterServerEvent('rlPlayerActivated')

local names = {}

AddEventHandler('rlPlayerActivated', function()
    RconLog({ msgType = 'playerActivated', netID = source, name = GetPlayerName(source), guid = GetPlayerIdentifiers(source)[1], ip = GetPlayerEP(source) })

    names[source] = { name = GetPlayerName(source), id = source }

    TriggerClientEvent('rlUpdateNames', GetHostId())
end)

RegisterServerEvent('rlUpdateNamesResult')

AddEventHandler('rlUpdateNamesResult', function(res)
    if source ~= tonumber(GetHostId()) then
        print('bad guy')
        return
    end

    for id, data in pairs(res) do
        if data then
            if data.name then
                if not names[id] then
                    names[id] = data
                end

                if names[id].name ~= data.name or names[id].id ~= data.id then
                    names[id] = data

                    RconLog({ msgType = 'playerRenamed', netID = id, name = data.name })
                end
            end
        else
            names[id] = nil
        end
    end
end)

AddEventHandler('playerDropped', function()
    RconLog({ msgType = 'playerDropped', netID = source, name = GetPlayerName(source) })

    names[source] = nil
end)

AddEventHandler('chatMessage', function(netID, name, message)
    RconLog({ msgType = 'chatMessage', netID = netID, name = name, message = message, guid = GetPlayerIdentifiers(netID)[1] })
end)

AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "tell" then
        local target = table.remove(args, 1)
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', tonumber(target), '后台管理员', { 0, 99, 255 }, msg)
        RconPrint('Admin: ' .. msg .. "\n")

        CancelEvent()
    end
end)

AddEventHandler('rconCommand', function(commandName, args)
    if commandName == 'status' then
		local num = 0
        for netid, data in pairs(names) do
            local guid = GetPlayerIdentifiers(netid)

            if guid and guid[1] and data then
                local ping = GetPlayerPing(netid)
				num = num + 1
                RconPrint('No.'.. num .. ' ID:' .. netid .. ' ' .. guid[1] .. ' ' .. data.name .. ' IP:' .. GetPlayerEP(netid) .. ' Ping:' .. ping .. "\n")				
            end
        end

        CancelEvent()
    elseif commandName:lower() == 'kick' then
        local playerId = table.remove(args, 1)
        local msg = table.concat(args, ' 你被踢了！')
        local steamId = GetPlayerIdentifiers(playerId)[1]
        if steamId ~= nil then
            DropPlayer(playerId, msg)            
            CancelEvent()
        else
            print("ID Is Wrong!!!")
            CancelEvent()
        end
    elseif commandName:lower() == 'ban' then
        local playerId = table.remove(args, 1)
        local msg = table.concat(args, ' 你被封了！')
        local steamId = GetPlayerIdentifiers(playerId)[1]
        if steamId ~= nil then
            DropPlayer(playerId, msg)
            if server_bot_mode == '白名单' then
                for k, v in pairs(steamIdsList) do
                    if v == steamId then
                        table.remove(steamIdsList, k)
                    end
                end
            else
                table.insert(steamIdsList, steamId)
            end
            SaveResourceFile(GetCurrentResourceName(), "steamId.json", json.encode(steamIdsList), -1)
            unpackTable(steamIdsList)
            CancelEvent()
        else
            print("ID Is Wrong!!!")
            CancelEvent()
        end
    end
end)

local steamIdsList = {}

Citizen.CreateThread(function()
	server_bot_mode = GetConvar("server_bot_mode", "黑名单")
    loadSteamIdJson()
    unpackTable(steamIdsList)
    print("进服模式：" .. server_bot_mode)
end)

AddEventHandler("WebSocketServer:onConnect", function(endpoint)
    print("^2新客户端 " .. endpoint .."已连接。") 
	Wait(500)
	TriggerEvent("WebSocketServer:broadcast", "5pyN5Yqh5Zmo5bey5byA5ZCv")
end)

AddEventHandler("WebSocketServer:onMessage", function(message, endpoint)
    if message == "5Lq65pWw5p+l6K+i" then
        --print(message)
		local num = 0
        local ID = "\r\nID [CQ:emoji,id=128187]  名字  [CQ:face,id=54]  Ping"
		for netid, data in pairs(names) do
			local guid = GetPlayerIdentifiers(netid)
			if guid and guid[1] and data then
				local ping = GetPlayerPing(netid)
				num = num + 1
                ID = ID .. "\r\n" .. netid .. "  [CQ:emoji,id=128187] "  .. data.name .. " [CQ:face,id=54] " .. ping
			end
		end
        if num == 0 then
            TriggerEvent("WebSocketServer:broadcast", "当前在线：" .. num .. " [CQ:face,id=49]")
        else
            TriggerEvent("WebSocketServer:broadcast", "当前在线：" .. num .. " [CQ:face,id=49]" .. ID )
        end		
	elseif message:sub(1, 27) == "6Lii5Ye6546p5a622471332322-" then
        --print(message)
        local args = stringsplit(message, "-")
        if (args[2] ~= nil) then
            --print(args[2])
            local guid = GetPlayerIdentifiers(args[2])
            local name = GetPlayerName(args[2])
            if guid[1] ~= nil then
                DropPlayer(args[2], "你已被管理员踢出服务器！请遵守服务器规则！！！")
                print(name .. "已被管理员踢出服务器，" .. guid[1])
            else
                print("ID输入错误!")
            end
        end
    elseif message:sub(1, 27) == "5bCB56aB546p5a622471332322-" then
        --print(message)
        local args = stringsplit(message, "-")
        if (args[2] ~= nil) then
            local guid = GetPlayerIdentifiers(args[2])
            local name = GetPlayerName(args[2])
            --print(args[2] .. guid[1])
            if guid[1] ~= nil then
                DropPlayer(args[2], "你已被管理员封禁！请遵守服务器规则！！！")--临时封禁                
                if server_bot_mode == '白名单' then
                    for k, v in pairs(steamIdsList) do
                        if v == guid[1] then
                            table.remove(steamIdsList, k)
                        end
                    end
                else
                    table.insert(steamIdsList, guid[1])
                end
                SaveResourceFile(GetCurrentResourceName(), "steamId.json", json.encode(steamIdsList), -1)
                unpackTable(steamIdsList)  
                print(name .. "已被管理员封禁，" .. guid[1])
            else
                print("ID输入错误!")
            end
        end
    elseif message:sub(1, 21) == "5pyN5Yqh5Zmo6IGK5aSp-" then
        local args = stringsplit(message, "-")
        if (args[2] ~= nil) then
            TriggerClientEvent('chatMessage', -1, '🐧QQ:', { 255, 99, 0 }, args[2])
            print(args[2])
        end
    end
end)

AddEventHandler("WebSocketServer:onDisconnect", function(endpoint)
    print("^1客户端 " .. endpoint .. " 已断开。")
end)

AddEventHandler('playerConnecting', function(name, setReason)
  local steamId = GetPlayerIdentifiers(source)[1]
  local isSteam = isNativeSteamId(steamId)
  loadSteamIdJson()
  local check = inArray(steamId, steamIdsList)
  if server_bot_mode == '白名单' then
    check = not check
  end
  if not isSteam then
	setReason("请先登录steam再进入该服务器。")
	CancelEvent()
  elseif check then
    setReason(server_bot_mode .. "已开启，禁止进入该服务器，请联系管理员QQ2561417364。")
    print(name .. "被禁止进入该服务器，" .. steamId)
    CancelEvent()
  else
	local num = 0
	for netid in pairs(names) do
		num = num + 1
	end
	TriggerEvent("WebSocketServer:broadcast", name .. '加入服务器 [CQ:face,id=66] \r\n当前人数：' .. num .. " [CQ:face,id=49]")
  end
end)

AddEventHandler('playerDropped', function(reason)
    TriggerEvent("WebSocketServer:broadcast", GetPlayerName(source) .. '退出服务器 [CQ:face,id=194] \r\n原因：' .. reason .. " [CQ:face,id=146]")
end)

AddEventHandler('chatMessage', function(source, name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then
        return FALSE
    elseif message:sub(1, 2) == "qq" then
        TriggerEvent("WebSocketServer:broadcast", '有人对群说：' .. string.sub(message, 3) .. " (来自" .. name .. ")")
    else
        TriggerEvent("WebSocketServer:broadcast", name .. '：' .. message)
    end
end)

AddEventHandler('chatMessage', function(source, name, message)
  local args = stringsplit(message, " ")
  if (args[1] == "/pv") then
    CancelEvent()
    if (args[2] ~= nil) then
      local playerID = tonumber(source)
      local vehicleName = tostring(args[2])
      TriggerClientEvent('VehicleSpawn', playerID, vehicleName)
    else
      local event = 'chatMessage'
      local eventTarget = source
      local messageSender = "刷车器"
      local messageSenderColor = {200, 0, 0}
      local message = "/pv Caddy"
      TriggerClientEvent(event, eventTarget, messageSender, messageSenderColor, message)
    end
  end
end)

function inArray(value, array)
  for _,v in pairs(array) do
    v = getSteamId(v)
    if v == value then
      return true
    end
  end
  return false
end

function getSteamId(steamId)
  if not isNativeSteamId(steamId) then
    steamId = "steam:" .. string.format("%x", tonumber(steamId))
  else
    steamId = string.lower(steamId)
  end
  return steamId
end

function isNativeSteamId(steamId)
  if string.sub(steamId, 0, 6) == "steam:" then
    return true
  end
  return false
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

function unpackTable(tb)
    for k, v in pairs(tb) do
        print(k .. " - " .. v)
    end
end

function loadSteamIdJson()
	local steamId = LoadResourceFile(GetCurrentResourceName(), "steamId.json") or ""
	if steamId ~= "" then
		steamIdsList = json.decode(steamId)
	else
		steamIdsList = {}
	end
end
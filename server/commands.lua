--------------------------------------------------------------------------------
--                               BATTLE ROYALE                                --
--                               Chat commands                                --
--------------------------------------------------------------------------------
local commands = {}

-- List of all interiors
local interiors = {
  { x = 261.4586, y = -998.8196, z = -99.00863 },
  { x = -35.31277, y = -580.4199, z = 88.71221 },
  { x = -1477.14, y = -538.7499, z = 55.5264 },
  { x = -18.07856, y = -583.6725, z = 79.46569 },
  { x = -1468.14, y = -541.815, z = 73.4442 },
  { x = -915.811, y = -379.432, z = 113.6748 },
  { x = -614.86, y = 40.6783, z = 97.60007 },
  { x = -773.407, y = 341.766, z = 211.397 },
  { x = -169.286, y = 486.4938, z = 137.4436 },
  { x = 340.9412, y = 437.1798, z = 149.3925 },
  { x = 373.023, y = 416.105, z = 145.7006 },
  { x = -676.127, y = 588.612, z = 145.1698 },
  { x = -763.107, y = 615.906, z = 144.1401 },
  { x = -857.798, y = 682.563, z = 152.6529 },
  { x = 120.5, y = 549.952, z = 184.097 },
  { x = -1288.055, y = 440.748, z = 97.69459 }, -- 16
  { x = 229.9559, y = -981.7928, z = -99.66071 }, -- 17
}

-- Declares a new command
function addCommand(name, callback)
  commands[name] = callback
end

-- Calls a command callback with player and args
function callCommand(name, player, args)
  if commands[name] ~= nil then
    return commands[name](player, args)
  end
  return false
end

-- /kick playerId
-- Kicks a player out of the server
-- ADMIN ONLY
addCommand('kick', function(player, args)
  if GetPlayerName(args[1]) and player:isAdmin() then
    if args[1] == player.source then
      sendSystemMessage(player.source, '不能踢出自己的！')
    else
      local message = ''
      if args[2] == nil then
        message = '你已被踢出服务器Σ(ŎдŎ|||)'
      else
        message = args[2]
      end
      DropPlayer(args[1], message)
    end
    return true
  end

  return false
end)

-- /ban playerId
-- Disable the player and kicks him out of the server
-- ADMIN ONLY
addCommand('ban', function(player, args)
  if GetPlayerName(args[1]) and player:isAdmin() then
    if args[1] == player.source then
      sendSystemMessage(player.source, '你不能封禁自己(ÒωÓױ)！！！')
    else
      args[2] = '你已经被禁止进入服务器Σ(ŎдŎ|||)'
      MySQL.Async.execute('UPDATE players SET status=@status WHERE id=@id', {['@status'] = 0, ['@id'] = args[1]}, function()
        callCommand('kick', player, args)
      end)
    end
    return true
  end

  return false
end)

-- /skin
-- Change the skin, if the game has not already started
addCommand('p', function(player, args)
  if getIsGameStarted() and player.alive then
    sendSystemMessage(player.source, '不要在比赛中更换皮肤 →_→')
  else
    TriggerClientEvent('brv:changeSkin', player.source)
  end
  return true
end)

-- /saveskin
-- Saves the current player skin
addCommand('s', function(player, args)
  if getIsGameStarted() and player.alive then
    sendSystemMessage(player.source, '不要在比赛中保存皮肤 ←_←')
  else
    TriggerEvent('brv:saveSkin', player.source)
  end
  return true
end)

-- /vote
-- Vote for the game to start
addCommand('v', function(player, args)
  if getIsGameStarted() then
    sendSystemMessage(player.source, '比赛中不能投票，^3请观战等待下一局开始 Y(^_^)Y')
  else
    TriggerEvent('brv:voteServer', player.source)
  end
  return true
end)

-- /name
-- Change the player's name
addCommand('n', function(player, args)
  if getIsGameStarted() then
    sendSystemMessage(player.source, '比赛中途不要更改昵称吖 (●.●)')
  else
    if #args == 0 then
      sendSystemMessage(player.source, '不要使用这个昵称 -_-#')
    else
      local newName = table.concat(args, ' ')
      if string.find(newName, '%^') then
        sendSystemMessage(player.source, '有非法字符呦！')
      else
        player.name = newName
        MySQL.Async.execute('UPDATE players SET name=@name WHERE id=@id', {['@name'] = newName, ['@id'] = player.id})
        TriggerClientEvent('brv:changeName', player.source, player.name)
        sendMessage(player.source, 'SYSTEM', {255, 255, 255}, '你的新昵称是 ^4' .. newName)
      end
    end
  end
  return true
end)

-- /911
-- Send a message to the admins
addCommand('911', function(player, args)
  local players = getPlayers()

  for k, v in pairs(players) do
    if v:isAdmin() then
      sendSystemMessage(v.source, '^1911^9 : ' .. player.name .. ' (^4' .. player.source .. '^9)' .. ' : ' .. table.concat(args, ' '))
    end
  end
  return true
end)

-- /list
-- List all connected players
-- ADMIN ONLY
addCommand('list', function(player, args)
  if player:isAdmin() then
    local message = ''
    local players = getPlayers()

    for k, v in pairs(players) do
      if v:isAdmin() then
        message = '%d - %s ^4[admin]^2'
      else
        message = '%d - %s'
      end
      message = message .. ' (' .. GetPlayerPing(v.source) .. ')'
      sendSystemMessage(player.source, string.format(message, v.source, v.name))
    end
    return true
  end

  return false
end)

-- /coords
-- Saves the current coords to the database
-- ADMIN ONLY
addCommand('c', function(player, args)
  if player:isAdmin() then
    TriggerClientEvent('brv:saveCoords', player.source)
    return true
  end
  return false
end)

-- /tpi interiorIndex
-- Teleports into one of the interiors (see list above)
-- ADMIN ONLY
addCommand('tpi', function(player, args)
  if args[1] and player:isAdmin() then
    local index = tonumber(args[1])
    local coords = interiors[index]
    TriggerClientEvent('brv:playerTeleportation', player.source, coords)
    sendSystemMessage(player.source, '开启传送 n°^4' .. index)
    return true
  end
  return false
end)

-- /tpto playerId
-- Teleports next to a player
-- ADMIN ONLY
addCommand('tpto', function(player, args)
  if args[1] and player:isAdmin() then
    local target = args[1]
    if target == 'marker' then
      TriggerClientEvent('brv:playerTeleportationToMarker', player.source)
      sendSystemMessage(player.source, '已到达 ^4目标点！')
    else
      target = tonumber(target)
      if target == player.source then
        sendSystemMessage(player.source, '你不能传送到自己旁边')
      else
        TriggerClientEvent('brv:playerTeleportationToPlayer', player.source, target)
        sendSystemMessage(player.source, '传送到他(她) ^4' .. getPlayerName(target))
      end
    end
    return true
  end
  return false
end)

-- /tpfrom playerId
-- Teleports a player next to you
-- ADMIN ONLY
addCommand('tpfrom', function(player, args)
  if args[1] and player:isAdmin() then
    local source = tonumber(args[1])
    if source == player.source then
      sendSystemMessage(player.source, 'sorry不能传送自己的')
    else
      TriggerClientEvent('brv:playerTeleportationToPlayer', source, player.source)
      sendSystemMessage(player.source, '已把他她 ^4' .. getPlayerName(source) .. '^2 带到你身边！')
      sendSystemMessage(source, '是他干的→_→ ^4' .. player.name)
    end
    return true
  end
  return false
end)

-- /help
-- Displays a welcome message
addCommand('h', function(player, args)
  sendSystemMessage(player.source, "欢迎来到 ^8大逃杀服务器^2 (^4公测中^2) !")
  sendSystemMessage(player.source, "命令提示 :")
  sendSystemMessage(player.source, "^4/h^2 : 显示帮助信息")
  sendSystemMessage(player.source, "^3/v^2 : 投票开始下一局比赛")
  --sendSystemMessage(player.source, "^4/list^2 : 列出所有在线玩家信息(好像只有管理可以用)")
  sendSystemMessage(player.source, "^4/p^2 : 随机切换新的人物")
  sendSystemMessage(player.source, "^4/s^2 : 保存你的人物皮肤")
  sendSystemMessage(player.source, "^4/n 123^2 : 更改昵称为123")
  --sendSystemMessage(player.source, "^4/911 MESSAGE^2 : 发送 MESSAGE 消息给管理员")
  sendSystemMessage(player.source, "按键提示 :")
  sendSystemMessage(player.source, "^4\"长按Z键\"^2 : 显示在线玩家&排行榜")
  --sendSystemMessage(player.source, "^4\"F\"^2 : 观战模式 (^4仅靠近电视观战区可用^2)")
  --sendSystemMessage(player.source, "^4\"Z\"^2 : 在战斗中可打开大地图")
  --sendSystemMessage(player.source, "^4\"shift\"^2 : 过弯时按住开启漂移模式")
  --sendSystemMessage(player.source, "^8\"NUM 9\"^2 : 关闭开启shift漂移按键。感谢游玩！")
  return true
end)

-- /start
-- Start the Battle !
-- ADMIN ONLY
addCommand('start', function(player, args)
  if player:isAdmin() then
    TriggerEvent('brv:startGame')
    return true
  end
  return false
end)

-- /stop [1]
-- Stop the Battle !
-- ADMIN ONLY
addCommand('stop', function(player, args)
  if player:isAdmin() then
    local restart = true
    if args[1] ~= nil and args[1] == 1 then restart = false end
    TriggerEvent('brv:stopGame', restart, true)
    return true
  end
  return false
end)

-- /health
-- Sets player health, for debug purposes
-- ADMIN ONLY
addCommand('health', function(player, args)
  if args[1] and player:isAdmin() then
    TriggerClientEvent('brv:setHealth', player.source, args[1])
    return true
  end
  return false
end)

-- Parse every chat message to detect if a command was entered
AddEventHandler('chatMessage', function(source, name, message)
  if string.len(message) > 1 and string.sub(message, 1, 1) == '/' then
    local args = explode(message, ' ')

    local cmd = string.sub(table.remove(args, 1), 2)
    local player = getPlayer(source)

    if callCommand(cmd, player, args) then
      print(string.format("Command '%s' found, called by '%s'.", cmd, name))
      CancelEvent()
    end
  end
end)

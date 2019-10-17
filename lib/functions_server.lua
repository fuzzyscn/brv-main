local killedMessage = {
  "杀死了",
  "摧毁了",
  "结束了",
  "终结了",
  "弄死了",
  "清除了",
  "处死了",
  "刺杀了",
  "击杀了",
  "抹杀了",
  "宰杀了",
  "碾碎了",
  "谋杀了",
  "暗杀了",
  "操翻了",
}

function getKilledMessage()
  return killedMessage[math.random(count(killedMessage))]
end

function sendMessage(target, name, color, message)
  TriggerClientEvent('chatMessage', target, name, color, message)
  print(tostring(name) .. ' : ' .. message)
end

function sendSystemMessage(target, message)
  sendMessage(target, '', {0, 0, 0}, '^2* ' .. message)
end

function sendNotification(target, message)
  TriggerClientEvent('brv:showNotification', target, message)
end

-- Returns a random location from a predefined list
function getRandomLocation()
  local nbLocations = count(locations)
  local randLocationIndex = math.random(nbLocations)
  return locations[randLocationIndex]
end

function limitMap(coords)
  if coords.x < -3200.0 then coords.x = -3200.0 end
  if coords.x > 4000.0 then coords.x = 4000.0 end

  if coords.y < -3000.0 then coords.y = -3000.0 end
  if coords.y > 7000.0 then coords.y = 7000.0 end

  return coords
end

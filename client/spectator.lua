--------------------------------------------------------------------------------
--                               BATTLE ROYALE V                              --
--                                Spectator file                              --
--------------------------------------------------------------------------------

-- Spectator mode flag
local spectatorMode = false
local playerToSpec = nil

local spectatorBlips = { }

function isPlayerInSpectatorMode()
  return spectatorMode
end

function getSpectatingPlayer()
  return playerToSpec
end

function setPlayerInSpectatorMode(enable)
  spectatorMode = enable
  if not enable then
    playerToSpec = nil
    spectatePlayer(nil, 0, false)
  end
end

-- Spectates a player
-- player : Object send by the server
-- playerId : Local player id
-- enable : Boolean toggle
function spectatePlayer(player, playerId, enable)
  Citizen.CreateThread(function()
    local playerPed
    local players = getAlivePlayers()

    -- Remove blips for alive players
    if count(spectatorBlips) ~= 0 then
      for i, blip in pairs(spectatorBlips) do
        RemoveBlip(blip)
        spectatorBlips[i] = nil
      end
    end

    if enable then
      playerPed = GetPlayerPed(playerId)
      FreezeEntityPosition(GetPlayerPed(-1),  true)
      RequestCollisionAtCoord(GetEntityCoords(playerPed, 1))
      SetEntityVisible(GetPlayerPed(-1), false)
      NetworkSetInSpectatorMode(1, playerPed)

      -- Adds blip for alive players
      for i, v in ipairs(players) do
        spectatorBlips[i] = AddBlipForEntity(GetPlayerPed(GetPlayerFromServerId(v.source)))
        SetBlipSprite(spectatorBlips[i], 1)
        if v.id == player.id then
          SetBlipColour(spectatorBlips[i], 1)
        end

        setBlipName(spectatorBlips[i], v.name)
      end
    else
      playerPed = GetPlayerPed(-1)
      RequestCollisionAtCoord(GetEntityCoords(playerPed, 1))
      SetEntityVisible(playerPed, true)
      NetworkSetInSpectatorMode(0, playerPed)
      FreezeEntityPosition(playerPed,  false)
    end
  end)
end

-- Spectator mode
Citizen.CreateThread(function()
  local index = 1
  local playerPed = nil
  local alivePlayers = {}
  local inTVZone = false
  local tvCoords = {
    x = 3072.9,
    y = -4727.51,
    z = 15.26,
  }

  while true do
    Wait(0)
    SetEntityVisible(GetPlayerPed(-1), true)
    -- Spectator mode
    if getIsGameStarted() and isPlayerInLobby() then
      alivePlayers = getAlivePlayers()
      DrawMarker(1, tvCoords.x, tvCoords.y, tvCoords.z-1, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.06, 6, 62, 145, 100, 0, 0, 0, 0)
      if isPlayerNearCoords(tvCoords, 50.0) then
        -- TV Marker
        if isPlayerNearCoords(tvCoords, 3.5) then
          inTVZone = true
          if not spectatorMode then
            showHelp('按 ~INPUT_ENTER~ 进入观战模式')
          end
        else
          inTVZone = false
        end
      else
        inTVZone = false

        if not spectatorMode then
          showHelp('比赛正在进行中\n到电视机前观看比赛')
        end
      end

      -- Player is near the TV and pressed "F"
      if inTVZone and IsControlJustPressed(0, 23) then
        -- If there are players remaining and the current players isn't already in spectator
        if #alivePlayers > 0 and not spectatorMode then
          if playerToSpec == nil then
            index = 1
            -- Get the player to spectate
            playerToSpec = GetPlayerFromServerId(alivePlayers[index].source)
          end
          -- Triggers the spectator mode
          spectatePlayer(alivePlayers[index], playerToSpec, true)
          spectatorMode = true
        else
          -- Disable the spectator mode
          setPlayerInSpectatorMode(false)
        end
      else
        -- Player is in spectator and pressed "ARROW RIGHT"
        if spectatorMode and IsControlJustPressed(0, 190) then
          -- Increments the index, if next player does not exists, go back to the first
          index = index + 1
          if alivePlayers[index] == nil then
            index = 1
          end
          playerToSpec = GetPlayerFromServerId(alivePlayers[index].source)
          spectatePlayer(alivePlayers[index], playerToSpec, true)
        end

        -- Player is in spectator and pressed "ARROW LEFT"
        if spectatorMode and IsControlJustPressed(0, 189) then
          -- Decrements the index, if previous player does not exists, go back to the last
          index = index - 1
          if alivePlayers[index] == nil then
            index = #alivePlayers
          end
          playerToSpec = GetPlayerFromServerId(alivePlayers[index].source)
          spectatePlayer(alivePlayers[index], playerToSpec, true)
        end
      end

      -- Every frame in spectator mode
      if spectatorMode then
        if alivePlayers[index] ~= nil then
          -- Disable the radar and display some info
          drawInstructionalButtons({
            {
              button = '~INPUT_ENTER~',
              label = '退出观战'
            },
            {
              button = '~INPUT_FRONTEND_RIGHT~',
              label = '下一玩家'
            },
            {
              button = '~INPUT_FRONTEND_LEFT~',
              label = '上一玩家'
            },
          })
          showText('~h~观战模式中···', 0.5, 0.85, conf.color.white, 0, 0.5, true, true)
        else
          if #alivePlayers > 0 then
            -- Current spectated player isn't there anymore, but there are still players to spectate
            -- Goes back to the first alive player
            index = 1
            playerToSpec = GetPlayerFromServerId(alivePlayers[index].source)
            spectatePlayer(alivePlayers[index], playerToSpec, true)
            -- else, the stopGame event should be triggered
          end
        end
      end
    end
  end
end)

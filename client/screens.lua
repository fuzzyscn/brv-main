-- WASTED SCREEN
AddEventHandler('brv:wastedScreen', function(rank, kills)
  Citizen.CreateThread(function()
    local locksound = false
    while IsEntityDead(PlayerPedId()) do
      StartScreenEffect("DeathFailOut", 0, 0)
      if not locksound then
        PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true)
        locksound = true
      end
      ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)

      local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

      if HasScaleformMovieLoaded(scaleform) then

        PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
        BeginTextComponent("STRING")
        AddTextComponentString("~r~死亡")
        EndTextComponent()
        BeginTextComponent("STRING")
        AddTextComponentString('排行第 ~g~~h~#' .. rank .. '~s~ | 击杀 ~r~~h~#' .. kills .. '~s~~n~即将返回航母...')
        EndTextComponent()
        PopScaleformMovieFunctionVoid()

        Citizen.Wait(1000)

        PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
        while IsEntityDead(PlayerPedId()) do
          DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
          Wait(0)
        end

        StopScreenEffect("DeathFailOut")
        locksound = false
      end
      Wait(0)
    end
  end)
end)

-- WINNER SCREEN
AddEventHandler('brv:winnerScreen', function(rank, kills, restart)
  setGameStarted(false) -- forces stop for winner
  Citizen.CreateThread(function()
    local timeDiff = 0
    local wonAt
    local locksound = false

    while timeDiff < 10000 do
      if not wonAt then
        wonAt = GetGameTimer()
      end

      StartScreenEffect('SuccessMichael', 0, false)
      if not locksound then
        PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
        locksound = true
      end
      --ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)

      local scaleform = RequestScaleformMovie('MIDSIZED_MESSAGE')

      if HasScaleformMovieLoaded(scaleform) then

        -- scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', "~g~胜利！", '排行第 ~g~~h~#' .. rank .. '~s~ | 击杀 ~r~~h~#' .. kills .. '~s~~n~大吉大利！恭喜吃鸡！')
    	-- scaleform:RenderFullscreenTimed(6000)
    	-- scaleform:Delete()
    	
        PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
        BeginTextComponent("STRING")
        AddTextComponentString("~g~胜利！")
        EndTextComponent()
        BeginTextComponent("STRING")
        AddTextComponentString('排行第 ~g~~h~#' .. rank .. '~s~ | 击杀 ~r~~h~#' .. kills .. '~s~~n~大吉大利！恭喜吃鸡！')
        EndTextComponent()
        PopScaleformMovieFunctionVoid()

        Citizen.Wait(1000)

        PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
        while timeDiff < 10000 do
          timeDiff = GetTimeDifference(GetGameTimer(), wonAt)
          DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
          Wait(0)
        end

        StopScreenEffect("DeathFailOut")
        locksound = false
      end
      Wait(0)
    end
    TriggerServerEvent('brv:stopGameClients', getLocalPlayer().name, restart)
  end)
end)

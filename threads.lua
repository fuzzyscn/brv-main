Citizen.CreateThread(function()
  -- SetRandomSeed(GetNetworkTime())
  StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
  Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', '大逃杀模式测试')
  SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
  SetPoliceIgnorePlayer(player, true)
  SetDispatchCopsForPlayer(player, false)
  SetMaxWantedLevel(0)
  while true do
    Citizen.Wait(0)  
        DisplayRadar(false)
        DisplayHud(false)
        SetVehicleDensityMultiplierThisFrame(0.0)
		SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		-- These natives do not have to be called everyframe.
		SetGarbageTrucks(0)
		SetRandomBoats(0)

  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(50)

    NetworkOverrideClockTime(12, 30, 0)

    SetWeatherTypePersist("CLEAR")
    SetWeatherTypeNowPersist("CLEAR")
    SetWeatherTypeNow("CLEAR")
    SetOverrideWeather("CLEAR")
    
    local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
    
    if IsPedInAnyVehicle(ped, true) then
        ResetPlayerStamina(PlayerId())
    	SetVehRadioStation(vehicle, "OFF")
    	SetVehicleEngineOn(vehicle,true)
    	--SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    	--SetVehicleRadioEnabled(vehicle, false)
    end
  end
end)

local INPUT_AIM = 25
local UseFPS = false
local justpressed = 0
local lastThirdView = 0

Citizen.CreateThread( function()

  while true do

    Citizen.Wait(1)
    --if getIsGameStarted() then
        
        if GetEntityHeightAboveGround(GetPlayerPed(-1)) < 50 and IsPedInParachuteFreeFall(GetPlayerPed(-1)) then
			ForcePedToOpenParachute(GetPlayerPed(-1))
		end
        
        local playerId = PlayerId()
    
        if IsControlPressed(0, INPUT_AIM) then
          justpressed = justpressed + 1
        end
    
        if IsControlJustReleased(0, INPUT_AIM) then
        	if justpressed < 20 then
        		UseFPS = true
        	end
        	justpressed = 0
        end
    
        if UseFPS then
        	local currentView = GetFollowPedCamViewMode()
        	if currentView ~= 4 then
        		lastThirdView = currentView
        		SetFollowPedCamViewMode(4)
        		Citizen.Trace(GetFollowPedCamViewMode())
        	else
        		SetFollowPedCamViewMode(lastThirdView)
        		Citizen.Trace(GetFollowPedCamViewMode())
        	end
    		UseFPS = false
        end
      --end
    end

end)

local props = {}

Citizen.CreateThread( function()
    while true do
    Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local angle = GetEntityHeading(GetPlayerPed(-1))
        if IsControlJustPressed(0, 38) then
            CreateMap(pos, angle)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
      return
    end
    unloadJsonMap()
end)

RegisterNetEvent('map:create')
AddEventHandler('map:create', function(pos, angle)
    CreateMap(pos, angle)
end)

RegisterNetEvent('map:loadmap')
AddEventHandler('map:loadmap', function(prop)
    loadJsonMap(prop)
end)

function CreateMap(pos, angle)
    local model = "stt_prop_ramp_jump_xs"
    local hash = GetHashKey(model)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(0)
    end
    local obj = CreateObjectNoOffset(hash, pos, false, false, false)

    local min, max = GetModelDimensions(hash)
    local offset = math.abs(min.x)

    SetEntityHeading(obj, angle + 90)
    PlaceObjectOnGroundProperly(obj)

    local new = GetOffsetFromEntityInWorldCoords(obj, offset, 0, 0)
    SetEntityCoords(obj, new.x, new.y, new.z - 0.1)
    FreezeEntityPosition(obj, true)
    SetObjectTextureVariant(obj, 7)
    local rot = GetEntityRotation(obj, 2)
    TriggerServerEvent('map:sync', pos, angle, new, rot)
    table.insert(props, obj)
end

function loadJsonMap(prop)
    unloadJsonMap()
    Citizen.CreateThread(function()
        if prop.no > 0 then
            for k = 1, prop.no do
                local hash = tonumber(prop.model[k])
                local pos = vector3(tonumber(prop.loc[k].x),tonumber(prop.loc[k].y),tonumber(prop.loc[k].z))
                local rot = vector3(tonumber(prop.vRot[k].x),tonumber(prop.vRot[k].y),tonumber(prop.vRot[k].z))
                local dynamic = false
                local colorid = 0
                if prop.Dynamic then--no
                    dynamic = true
                end
                if prop.prpclr then
                    colorid = tonumber(prop.prpclr[k])
                end
                while not HasModelLoaded(hash) do
                    RequestModel(hash)
                    Wait(0)
                end
                local obj = CreateObjectNoOffset(hash, pos, false, false, dynamic)
                SetEntityRotation(obj, rot, 2, true)
                FreezeEntityPosition(obj, not dynamic)
                SetObjectTextureVariant(obj, colorid)
                -- if prop.SBA then
                    -- local sba = tonumber(prop.SBA[1])
                    -- setSBA(obj, sba)
                -- end
                table.insert(props, obj)
            end
            Citizen.Trace("FUZZYS: LOAD ".. prop.no .." NEW PROPS SUCCESS \n")
        end
    end)
end

function unloadJsonMap()
    local num = 0
    for k, v in ipairs(props) do
        DeleteObject(v)
        num = k
    end
    Citizen.Trace("fuzzys: unload ".. num .." props success \n")
    props = {}
end

--[[Citizen.CreateThread(function()
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
    end
  end
end)]]--
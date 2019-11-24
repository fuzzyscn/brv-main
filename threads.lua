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

local INPUT_AIM = 38
local prop_list = {}
local props = {}

Citizen.CreateThread( function()
    while true do
    Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local angle = GetEntityHeading(GetPlayerPed(-1))
        if IsControlJustPressed(0, INPUT_AIM) then
            CreateMap(pos, angle)
            TriggerServerEvent('map:sync', pos, angle)
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
    loadMap(prop)
end)

RegisterNetEvent('map:loadOldMap')
AddEventHandler('map:loadOldMap', function(prop)
    loadMapOld(prop)
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
    table.insert(prop_list, obj)
    return obj
end

function loadMap(prop)
Citizen.CreateThread(function()
	local props = prop
	if props ~= nil and props.no > 0 then
		for k, prop in ipairs(props) do
			local hash = tonumber(prop.model)
			local pos = vector3(tonumber(prop.loc.x),tonumber(prop.loc.y),tonumber(prop.loc.z))
			local rot = vector3(tonumber(prop.vRot.x),tonumber(prop.vRot.x),tonumber(prop.vRot.x))
			local dynamic = false
			local colorid = 0
			-- if prop.Dynamic then
				-- dynamic = true
			-- end
			-- if prop.Color then
				-- colorid = tonumber(prop.Color[1])
			-- end
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
        Citizen.Trace("fuzzys: LOAD ".. num .." NEW PROPS SUCCESS ")
	end
end)
end

function loadMapOld(prop)
    unloadJsonMap()
    local num = 0
    for k, v in pairs(prop) do
        local pos = vector3(v.x, v.y, v.z)
        CreateMap(pos, v.a)
        num = k
    end
    Citizen.Trace("fuzzys: LOAD ".. num .." OLD PROPS SUCCESS ")
end

function unloadJsonMap()
    local num = 0
	for k, prop in ipairs(prop_list) do -- delete current props
		DeleteObject(prop)
        num = k
	end
    Citizen.Trace("fuzzys: UNLOAD ".. num .." OLD PROPS SUCCESS ")
	prop_list = {}
end
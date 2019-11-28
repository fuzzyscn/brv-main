local props = {}

local function func_192(sba) -- from decompiled R* scripts
	if sba == 1 then
		return 0.3
	elseif sba == 2 then
		return 0.4
	elseif sba == 3 then
		return 0.5
	elseif sba == 4 then
		return 0.5
	elseif sba == 5 then
		return 0.5
	else
		return 0.4
	end
end

local function func_193(sba) -- from decompiled R* scripts
	if sba == 1 then
		return 15
	elseif sba == 2 then
		return 25
	elseif sba == 3 then
		return 35
	elseif sba == 4 then
		return 45
	elseif sba == 5 then
		return 100
	else
		return 25
	end
end

local function func_190(sba) -- from decompiled R* scripts
	if sba == 1 then
		return 44
	elseif sba == 2 then
		return 30
	elseif sba == 3 then
		return 16
	else
		return 30
	end
end

local function func_191(hash) -- from decompiled R* scripts
	if (hash == 346059280 or hash == 620582592 or hash == 85342060 or hash == 483832101 or hash == 930976262 or hash == 1677872320 or hash == 708828172 or hash == 950795200 or hash == -1260656854 or hash == -1875404158 or hash == -864804458 or hash == -1302470386 or hash == 1518201148 or hash == 384852939 or hash == 117169896 or hash == -1479958115) then
		return 1
	else
		return 0
	end
end

local function joaat(s)
	return GetHashKey(s)
end

local function setSBA(obj, sba) -- from decompiled R* scripts, no idea what SBA is an abbrev for
	local hash = GetEntityModel(obj)
	if (hash == joaat("stt_prop_track_speedup") or hash == joaat("stt_prop_track_speedup_t1") or hash == joaat("stt_prop_track_speedup_t2") or hash == joaat("stt_prop_stunt_tube_speed") or hash == joaat("stt_prop_stunt_tube_speedb")) then
		Citizen.InvokeNative(0x7BAC110ED504814D, obj, func_193(sba))
		Citizen.InvokeNative(0x4E91E2848E9525BB, obj, func_192(sba))
	elseif (hash == joaat("stt_prop_track_slowdown") or hash == joaat("stt_prop_track_slowdown_t1") or hash == joaat("stt_prop_track_slowdown_t2") or func_191(hash))then
		Citizen.InvokeNative(0x7BAC110ED504814D, obj, func_190(sba))
	end
end


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
AddEventHandler('map:loadmap', function(jsonTable)
    loadJsonMap(jsonTable)
end)

function CreateMap(pos, angle)
    --local model = "stt_prop_ramp_jump_xs"
    local hash = 3287988974-- -1088903588 --GetHashKey(model)
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
    TriggerServerEvent('map:sync', pos, angle, new, rot, hash)
    table.insert(props, obj)
end

function loadJsonMap(jsonTable)
    --unloadJsonMap()
    Citizen.CreateThread(function()
        local prop = jsonTable.mission.prop
        local dprop = jsonTable.mission.dprop
        
        if prop.no > 0 then
            for k = 1, prop.no do
                local hash = tonumber(prop.model[k])
                local pos = vector3(tonumber(prop.loc[k].x),tonumber(prop.loc[k].y),tonumber(prop.loc[k].z))
                local rot = vector3(tonumber(prop.vRot[k].x),tonumber(prop.vRot[k].y),tonumber(prop.vRot[k].z))
                local colorid = tonumber(prop.prpclr[k])
                while not HasModelLoaded(hash) do
                    RequestModel(hash)
                    Wait(0)
                end
                local obj = CreateObjectNoOffset(hash, pos, false, false, false)
                if prop.head then
                    local heading = tonumber(prop.head[k])
                    SetEntityHeading(obj, heading)
                end
                SetEntityRotation(obj, rot, 2, true)
                FreezeEntityPosition(obj, true)
                SetObjectTextureVariant(obj, colorid)
                if prop.prpsba then
                    local prpsba = tonumber(prop.prpsba[k])
                    setSBA(obj, prpsba)
                end
                if hash == GetHashKey("stt_prop_hoop_constraction_01a") then
                    local dict = "scr_stunts"
                    Citizen.InvokeNative(0x4B10CEA9187AFFE6, dict)
                    if Citizen.InvokeNative(0xC7225BF8901834B2, dict) then
                        Citizen.InvokeNative(0xFF62C471DC947844, dict)
                        Citizen.InvokeNative(0x2FBC377D2B29B60F, "scr_stunts_fire_ring", obj, vector3(0, 0, 25), vector3(-12.5, 0, 0), 1.0, 0,0,0)
                    end
                elseif hash == GetHashKey("stt_prop_hoop_small_01") then
                    local dict = "core"
                    Citizen.InvokeNative(0x4B10CEA9187AFFE6, dict)
                    if Citizen.InvokeNative(0xC7225BF8901834B2, dict) then
                        Citizen.InvokeNative(0xFF62C471DC947844, dict)
                        Citizen.InvokeNative(0x2FBC377D2B29B60F, "ent_amb_fire_ring", obj, vector3(0, 0, 4.5), vector3(0, 0, 90), 3.5, 0,0,0)
                    end
                end
                table.insert(props, obj)
            end
            Citizen.Trace("Fuzzys: Load ".. prop.no .." Props Success \n")
        end
        if dprop and (dprop.no > 0) then
            for k = 1, dprop.no do
                local hash = tonumber(dprop.model[k])
                local pos = vector3(tonumber(dprop.loc[k].x),tonumber(dprop.loc[k].y),tonumber(dprop.loc[k].z))
                local rot = vector3(tonumber(dprop.vRot[k].x),tonumber(dprop.vRot[k].y),tonumber(dprop.vRot[k].z))
                while not HasModelLoaded(hash) do
                    RequestModel(hash)
                    Wait(0)
                end
                local obj = CreateObjectNoOffset(hash, pos, false, false, true)
                local heading = tonumber(dprop.head[k])
                SetEntityHeading(obj, heading)
                SetEntityRotation(obj, rot, 2, true)
                FreezeEntityPosition(obj, false)
                table.insert(props, obj)
            end
            Citizen.Trace("Fuzzys: Load ".. dprop.no .." Dynamic Props Success \n")
        end
        if jsonTable.mission.race then
            local startPos = jsonTable.mission.race.grid
            SetEntityCoords(GetPlayerPed(-1), startPos.x, startPos.y, startPos.z, true, false, false, true)
        end
    end)
end

function unloadJsonMap()
    local num = 0
    for k, v in ipairs(props) do
        DeleteObject(v)
        num = k
    end
    Citizen.Trace("Fuzzys: unload ".. num .." props success \n")
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
local props = {}
local race = {}
local jsonVehicle = {}
local selectModel = "stt_prop_track_speedup"
local selectColorId = 3
local racename = "race"
-- CONFIGURATION
local cp_radius = 10.0
local cp_height = 9.5
local cp_colour = 13 -- Checkpoint colour https://pastebin.com/d9aHPbXN
local cp_icon_colour = 134 -- Checkpoint icon colour
local cp_r, cp_g, cp_b, cp_a = GetHudColour(cp_colour)
local cpi_r, cpi_g, cpi_b, cpi_a = GetHudColour(cp_icon_colour)
local next_cp_id = 1
--local race_position = 1
local current_lap = 1
RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_01", false, -1)
RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_02", false, -1)
RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_03", false, -1)
RequestAdditionalText("RACES", 0);
StatSetInt('MP0_STAMINA', 100, true)
StatSetInt('MP0_STRENGTH', 100, true)
StatSetInt('MP0_LUNG_CAPACITY', 100, true)
StatSetInt('MP0_WHEELIE_ABILITY', 100, true)
StatSetInt('MP0_FLYING_ABILITY', 100, true)
StatSetInt('MP0_SHOOTING_ABILITY', 100, true)
StatSetInt('MP0_STEALTH_ABILITY', 100, true)

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

local isFirstSpawn = true
local gameHost = false
local isGameStarted = false
local playerInLobby = false
local npcPlayer = "客户端传来的参数值"

ClientStates = {INIT = "INIT", READY="READY", COUNTDOWN="COUNTDOWN", ONGOING="ONGOING", FINISHED="FINISHED", POST="POST"}

AddEventHandler("playerSpawned", function(spawn)

    Citizen.CreateThread(function()
        local playerPed = GetPlayerPed(-1)
        -- local pedhash = joaat("a_m_y_skater_01")
        -- RequestModel(pedhash)
        -- while not HasModelLoaded(pedhash) do
            -- Citizen.Wait(0)
        -- end
        -- local ped = CreatePed(4, pedhash, 1974.85,3710.43,1000.0, 0.0, false, false)
        -- local switchingtype = 2
        -- SetEntityVisible(ped, false, 0)
        -- StartPlayerSwitch(ped, playerPed, 0, switchingtype)
        -- DeleteEntity(ped)
        -- SET_PED_COMPONENT_VARIATION(Ped ped, int componentId, int drawableId, int textureId, int paletteId)
        -- SetPedComponentVariation(playerPed, 0, 0, 0, 2) --Face
        -- SetPedComponentVariation(playerPed, 2, 11, 4, 2) --Hair 
        -- SetPedComponentVariation(playerPed, 4, 1, 5, 2) -- Pantalon
        -- SetPedComponentVariation(playerPed, 6, 1, 0, 2) -- Shoes
        -- SetPedComponentVariation(playerPed, 11, 7, 2, 2) -- Jacket
        GiveWeaponToPed(playerPed, joaat('gadget_parachute'), 1, false, false)
        SetPedRandomComponentVariation(playerPed, true)
    end)

    playerInLobby = true

    --if isFirstSpawn then
        --TriggerServerEvent('fuzzys:playerSpawned')
        --isFirstSpawn = false
    --end
end)

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("主菜单", "~b~FiveM地图编辑器", 1300, 80)
_menuPool:Add(mainMenu)

function ShowPiFuMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "皮肤菜单", "所有可用人物mod。", 1300, 80)
    local PiFu1 = NativeUI.CreateItem("孙悟空", "七龙珠主角孙悟空")
    local PiFu2 = NativeUI.CreateItem("蒂法", "最终幻想女角色")

    submenu:AddItem(PiFu1)
    submenu:AddItem(PiFu2)

    submenu.OnItemSelect = function(sender, item, index)
        if item == PiFu1 then
            changePifu('Goku')
        elseif item == PiFu2 then
            changePifu('Tifa')
        end
    end
end

--[[function ShowAllPlayer(menu)
    local submenu = _menuPool:AddSubMenu(menu, "玩家列表", "显示所有在线玩家。", 1300, 80)
    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            submenu:AddItem(NativeUI.CreateItem(GetPlayerName(i), "玩家ID:" .. GetPlayerServerId(i)))
            TriggerServerEvent('fuzzys:getplayerid', i)
        end
    end
end

function MapEditor(menu)
    local propHash = {-1088903588,3287988974,3906373800,4228722453,3124504613,993442923,4067691788,1431235846,1832852758,346059280,620582592,85342060,483832101,930976262,1677872320,708828172,950795200,3034310442,2419563138,3430162838,2992496910,1518201148,117169896,2815009181}
    local propList = NativeUI.CreateListItem("选择生成模型", propHash, 1)
    menu:AddItem(propList)
    menu.OnListChange = function(sender, item, index)
        if item == propList then
            selectModel = item:IndexToItem(index)
            ShowNotification("切换模型 ~b~" .. selectModel .. "~w~...")
        end
    end
end]]--

function MapEditor(menu)
    local submenu = _menuPool:AddSubMenu(menu, "地图编辑器", "", 1300, 80)
    local propTb = {
        "stt_prop_ramp_jump_l",
        "stt_prop_ramp_jump_m",
        "stt_prop_ramp_jump_s",
        "stt_prop_ramp_jump_xl",
        "stt_prop_ramp_jump_xs",
        "stt_prop_ramp_jump_xxl",
        "stt_prop_ramp_adj_flip_m",
        "stt_prop_ramp_adj_flip_mb",
        "stt_prop_ramp_adj_flip_s",
        "stt_prop_ramp_adj_flip_sb",
        "stt_prop_ramp_adj_hloop",
        "stt_prop_stunt_jump_l",
        "stt_prop_stunt_jump_lb",
        "stt_prop_stunt_jump_m",
        "stt_prop_stunt_jump_mb",
        "stt_prop_stunt_jump_s",
        "stt_prop_stunt_jump_sb",
        "stt_prop_track_speedup",
        "stt_prop_track_speedup_t1",
        "stt_prop_track_speedup_t2",
        "stt_prop_stunt_tube_speed",
        "stt_prop_stunt_tube_speedb",
        "stt_prop_track_slowdown",
        "stt_prop_track_slowdown_t1",
        "stt_prop_track_slowdown_t2",
        "sr_mp_spec_races_blimp_sign",
        "test_prop_gravestones_09a",
        "test_prop_gravestones_08a",
        "test_prop_gravestones_07a",
        "test_prop_gravestones_05a",
        "test_prop_gravestones_04a",
        "sm_prop_smug_cont_01a",
    }
    local propColor = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
    local name = {"stunt-chiliad","简单绕圈比赛","jichang","race","hahaha","stunt-rally","senora-freeway"}
    local propList = NativeUI.CreateListItem("选择道具", propTb, 1)
    local colorList = NativeUI.CreateListItem("选择道具颜色", propColor, 1)
    local loadRaceMap = NativeUI.CreateListItem("加载比赛", name, 1, "加载比赛地图和检查点")
    local loadProp = NativeUI.CreateItem("加载道具", "加载玩家放置的道具")
    local startRace = NativeUI.CreateItem("开始比赛", "测试中...")
    local unloadMap = NativeUI.CreateItem("卸载地图和比赛", "删除游戏中所有道具的模型和比赛地图检查点")
    submenu:AddItem(propList)
    submenu:AddItem(colorList)
    submenu:AddItem(loadRaceMap)
    submenu:AddItem(loadProp)
    submenu:AddItem(startRace)
    submenu:AddItem(unloadMap)
    
    submenu.OnListChange = function(sender, item, index)
        if item == propList then
            selectModel = item:IndexToItem(index)
            ShowNotification("切换模型 ~b~" .. selectModel .. "~w~。")
        elseif item == colorList then
            selectColorId = item:IndexToItem(index)
            ShowNotification("切换颜色 ~b~" .. selectColorId .. "~w~。")
        elseif item == loadRaceMap then
            racename = item:IndexToItem(index)
            TriggerServerEvent('fuzzys:loadmap', racename)
            ShowNotification("加载比赛 ~b~" .. racename .. "~w~。")
        end
    end
    submenu.OnItemSelect = function(sender, item, index)
        if item == loadProp then
            TriggerServerEvent('fuzzys:loadmodel', npcPlayer)
        elseif item == startRace then
            startFivemRace()
            TriggerServerEvent('fuzzys:startRace')
            gameHost = false
        elseif item == unloadMap then
            unloadJsonMap()
            gameHost = false
        end
    end
end

ShowPiFuMenu(mainMenu)
MapEditor(mainMenu)
--ShowAllPlayer(mainMenu)

_menuPool:RefreshIndex()
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(0, 244) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

Citizen.CreateThread( function()
    while true do
    Citizen.Wait(5)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local angle = GetEntityHeading(GetPlayerPed(-1))
        if IsControlJustPressed(0, 38) then
            local handle = CreateMap(pos, angle, joaat(selectModel), selectColorId)
            TriggerServerEvent('map:sync', pos, angle, handle[1], handle[2], joaat(selectModel), selectColorId)
        end
        if isFirstSpawn then
            AddTextEntry('FirstSpawnMessageHeader', '~r~FiveM创造模式')
            AddTextEntry('FirstSpawnMessageLine1', '前往圈内选择人物或举办比赛')
            AddTextEntry('FirstSpawnMessageLine2', '~y~提示:~n~~s~此模式正在开发中，M键打开交互菜单。~n~更过玩法内容正在开发中~n~')

            local Timer = GetGameTimer()
            while not (IsControlJustPressed(2, 176) or IsDisabledControlJustPressed(2, 176) or GetGameTimer() - Timer > 10000) do
                Citizen.Wait(0)
                SetWarningMessageWithHeader('FirstSpawnMessageHeader', 'FirstSpawnMessageLine1', 2, 'FirstSpawnMessageLine2', false, 0, false, 0, false)
            end

            isFirstSpawn = false
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
AddEventHandler('map:create', function(pos, angle, model, color)
    CreateMap(pos, angle, model, color)
end)

RegisterNetEvent('map:loadmap')
AddEventHandler('map:loadmap', function(jsonTable)
    loadJsonMap(jsonTable)
end)

function CreateMap(pos, angle, model, color)
    local callback = {}
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end
    local obj = CreateObjectNoOffset(model, pos, false, false, false)

    local min, max = GetModelDimensions(model)
    local offset = math.abs(min.x)

    SetEntityHeading(obj, angle + 90)
    PlaceObjectOnGroundProperly(obj)

    local new = GetOffsetFromEntityInWorldCoords(obj, offset, 0, 0)
    table.insert(callback, new)
    SetEntityCoords(obj, new.x, new.y, new.z - 0.1)
    FreezeEntityPosition(obj, true)
    SetObjectTextureVariant(obj, color)
    local rot = GetEntityRotation(obj, 2)
    table.insert(callback, rot)
    table.insert(props, obj)
    return callback
end

function loadJsonMap(jsonTable)
    unloadJsonMap()
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
                if hash == joaat("stt_prop_hoop_constraction_01a") then
                    local dict = "scr_stunts"
                    Citizen.InvokeNative(0x4B10CEA9187AFFE6, dict)
                    if Citizen.InvokeNative(0xC7225BF8901834B2, dict) then
                        Citizen.InvokeNative(0xFF62C471DC947844, dict)
                        Citizen.InvokeNative(0x2FBC377D2B29B60F, "scr_stunts_fire_ring", obj, vector3(0, 0, 25), vector3(-12.5, 0, 0), 1.0, 0,0,0)
                    end
                elseif hash == joaat("stt_prop_hoop_small_01") then
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
            race = jsonTable.mission.race
            jsonVehicle = jsonTable.mission.veh
            local gen = jsonTable.mission.gen            
            local ped = GetPlayerPed(-1)            
            SetEntityCoords(ped, gen.start.x, gen.start.y, gen.start.z, 1, 0, 0, 1)
            SetEntityHeading(ped, race.head, 1, 0, 0, 1)
            TriggerServerEvent('fuzzys:getplayerid', "比赛名字：^6" .. gen.nm .. " ^7描述：" .. gen.dec[1])
            
            -- local vname = tonumber(gen.ivm)
            -- if vname == 0 then
                -- vname = joaat("xa21")
            -- end
            local vehicle = CreateVehicle("xa21", race.grid.x, race.grid.y, race.grid.z, race.head, true, false)
            SetVehRadioStation(vehicle, "OFF")
            SetVehicleOnGroundProperly(vehicle)
            Wait(2000)
            SetPedIntoVehicle(ped, vehicle, -1)
        end
    end)
end

countdown = false
RegisterNetEvent('raceCount')
AddEventHandler('raceCount', function(a)
	num = a
	if a > 0 then
		PlaySoundFrontend(-1, "CHECKPOINT_AHEAD","HUD_MINI_GAME_SOUNDSET", 1)
	elseif a == 0 then
		PlaySoundFrontend(-1, "TENNIS_POINT_WON","HUD_AWARDS", 1)
	end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if countdown then
            scaleform = Initialize("COUNTDOWN")
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        end
        if num == 3 then
			countdown = 3
			r = 173
			g = 6
			b = 6
		elseif num == 2 then
			countdown = 2
			r = 244
			g = 215
			b = 66
		elseif num == 1 then
			countdown = 1
			r = 244
			g = 215
			b = 66
		elseif num == 0 then
			countdown = 0
			r = 80
			g = 206
			b = 49
			countdown = "GO!"
		elseif num == -1 then
			countdown = false
		end
    end
end)
Citizen.CreateThread(function()
	while true do
    Citizen.Wait(0)
        if gameHost then
            scaleform = InitializeRaceScaleform("mp_big_message_freemode")
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            --TogglePvP(false)
            local JoinedPlayers = GetPlayers()
            RenderPlayerList(JoinedPlayers)            
        end
	end
end)
function InitializeRaceScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")

	PushScaleformMovieFunctionParameterString("~b~".."比赛结束")
    PushScaleformMovieFunctionParameterString("")
    PopScaleformMovieFunctionVoid()
    return scaleform
end
function Initialize(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "FADE_MP")
    PushScaleformMovieFunctionParameterString(countdown)
	PushScaleformMovieFunctionParameterInt(r)
	PushScaleformMovieFunctionParameterInt(g)
	PushScaleformMovieFunctionParameterInt(b)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

function startFivemRace()
    if race then        
        local position = 8 --起始顺序位置
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped)
        --local vehpos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), (-1*(-1)^position)*3.0, -4.2 - position*6.0, 0.0)
        
        ClearAreaOfVehicles(race.grid.x, race.grid.y, race.grid.z, 3000.0, 0, 0, 0, 0, false)
        ClearAreaOfVehicles(race.grid.x, race.grid.y, race.grid.z, 3000.0, 0, 0, 1, 0, false)
        ClearAreaOfVehicles(race.grid.x, race.grid.y, race.grid.z, 3000.0, 0, 0, 0, 1, false)
        
        SetEntityCoords(vehicle, jsonVehicle.loc[position].x, jsonVehicle.loc[position].y, jsonVehicle.loc[position].z, 1, 0, 0, 1)
        SetEntityHeading(vehicle, jsonVehicle.head[position], 1, 0, 0, 1)
        -- while not HasCollisionLoadedAroundEntity(vehicle) do
            -- Wait(0)
        -- end
        
        SetVehicleNumberPlateText(vehicle, "racemode")
        --SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        --SetVehRadioStation(vehicle, "OFF")
        SetPedCanBeKnockedOffVehicle(ped, true)
        SetVehicleDoorsLockedForAllPlayers(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 4)
        SetEntityInvincible(vehicle, true)
        --SetVehicleOnGroundProperly(vehicle)
        --FreezeEntityPosition(vehicle, true)
        
        client_state = ClientStates.ONGOING
        
        local first_cp = race.chl[1]
        local next_cp = race.chl[2]
        cp_handle = CreateCheckpoint(5, first_cp.x, first_cp.y, first_cp.z+5.0, next_cp.x, next_cp.y, next_cp.z, cp_radius, cp_r, cp_g, cp_b, 180, 0)
        SetCheckpointCylinderHeight(cp_handle, cp_height, cp_height, 100.0);
        SetCheckpointIconRgba(cp_handle, cpi_r, cpi_g, cpi_b, cpi_a)
        
        cp_blip_handle = AddBlipForCoord(first_cp.x, first_cp.y, first_cp.z)
        SetBlipSprite(cp_blip_handle, 1)
        SetBlipColour(cp_blip_handle, 66)
        
        next_cp_blip_handle = AddBlipForCoord(next_cp.x, next_cp.y, next_cp.z)
        SetBlipSprite(next_cp_blip_handle, 1)
        SetBlipColour(next_cp_blip_handle, 66)
        SetBlipScale(next_cp_blip_handle, 0.5)
        
        StartRaceOnTick()
    end
end

function StartRaceOnTick()
Citizen.CreateThread(function()
    next_cp_id = 1
    current_lap = 1
    
    local respawnKey_start = nil
    local laps = race.lap
    if laps < 1 then
        laps = 1 -- 1 lap means point to point
    end
    local textscale = 0.5
    local fontid = 1
    local respawn_hold_time = 1500
    local race_vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    while client_state == ClientStates.ONGOING do

        if IsControlJustPressed(0, 75) then
            respawnKey_start = GetNetworkTime()
        end
        if IsControlJustReleased(0, 75) then
            respawnKey_start = nil
        end
        if respawnKey_start then
            elapsed = GetNetworkTime() - respawnKey_start
            DrawRect(0.5, 0.5, elapsed/respawn_hold_time, 0.05, 0, 0, 255, 100)
            BeginTextCommandWidth("STRING")
            AddTextComponentSubstringPlayerName("按住 重生")
            SetTextFont(fontid)
            SetTextScale(textscale, textscale)
            local width = EndTextCommandGetWidth(1)
            local height = GetTextScaleHeight(textscale, fontid)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName("按住 重生")
            SetTextFont(fontid)
            --SetTextProportional(1)
            SetTextScale(textscale, textscale)
            SetTextColour(255, 255, 255, 255)
            EndTextCommandDisplayText(0.5 - (width/2.0), 0.5 - (height/2.0))
            if elapsed >= respawn_hold_time then
                local p, h
                if next_cp_id == 1 then -- still have to pass first CP
                    p = race.grid
                    h = race.head
                else
                    p = race.chl[next_cp_id-1]
                    h = race.chh[next_cp_id-1]
                end
                SetEntityCoords(race_vehicle, p.x, p.y, p.z, 1, 0, 0, 1)
                SetEntityHeading(race_vehicle, h, 1, 0, 0, 1)
                SetVehicleFixed(race_vehicle)
                SetVehicleDeformationFixed(race_vehicle)
                SetVehicleDirtLevel(race_vehicle, 0)
                SetVehicleEngineHealth(race_vehicle, 1000.0)
                SetVehiclePetrolTankHealth(race_vehicle, 1000.0)
                SetVehicleUndriveable(race_vehicle, false)
                SetVehicleEngineCanDegrade(race_vehicle, false)
                SetVehicleEngineOn(race_vehicle, true)
                SetPedIntoVehicle(GetPlayerPed(-1), race_vehicle, -1)
                SetGameplayCamRelativeHeading(0.0)
                SetVehicleForwardSpeed(race_vehicle, 15.0)
                if IsThisModelAHeli(GetEntityModel(race_vehicle)) then -- if helicopter race, set blades to full speed etc
                    SetHeliBladesFullSpeed(race_vehicle)
                end
                StartScreenEffect("SwitchShortNeutralIn", 0, 0);
                PlaySoundFrontend(-1, "Hit", "RESPAWN_ONLINE_SOUNDSET", 1);
                respawnKey_start = nil
            end
        end-- END RESPAWNING KEY
        
        if IsPlayerWithinCPTrigger(race.chl[next_cp_id]) then
            --TriggerServerEvent("racing:passedCP", next_cp_id)
            FadeoutAndDeleteCheckpoint(cp_handle)
            -- if next_cp_id < race.chp*laps then
                -- next_cp_id-race.chp = 1
            -- end
            if current_lap < laps then -- 2 < 2  16 finished a lap 圈数问题
                if next_cp_id == race.chp then
                    local first_cp = race.chl[1]
                    local next_cp = race.chl[2]
                    cp_handle = CreateCheckpoint(5, first_cp.x, first_cp.y, first_cp.z+5.0, next_cp.x, next_cp.y, next_cp.z, cp_radius, cp_r, cp_g, cp_b, 180, 0)
                    SetCheckpointCylinderHeight(cp_handle, cp_height, cp_height, 100.0);
                    SetCheckpointIconRgba(cp_handle, cpi_r, cpi_g, cpi_b, cpi_a)
                    
                    PlaySoundFrontend(-1, "Checkpoint_Lap", "DLC_Stunt_Race_Frontend_Sounds", 1)
                    
                    RemoveBlip(cp_blip_handle)
                    cp_blip_handle = next_cp_blip_handle
                    SetBlipScale(cp_blip_handle, 1.0)
                    
                    next_cp_blip_handle = AddBlipForCoord(race.chl[2].x, race.chl[2].y, race.chl[2].z)
                    SetBlipSprite(next_cp_blip_handle, 1)
                    SetBlipColour(next_cp_blip_handle, 66)
                    SetBlipScale(next_cp_blip_handle, 0.5)
                    
                    current_lap = current_lap + 1
                    ShowNotification("第~b~" .. current_lap .. "~w~圈。")
                    next_cp_id = 1
                else
                    PlaySoundFrontend(-1, "Checkpoint", "DLC_Stunt_Race_Frontend_Sounds", 0)
                    next_cp_id = next_cp_id + 1
                    
                    RemoveBlip(cp_blip_handle)
                    cp_blip_handle = next_cp_blip_handle
                    SetBlipScale(cp_blip_handle, 1.0)
                    
                    local previous_cp = race.chl[next_cp_id]
                    local next_cp = race.chl[next_cp_id+1]
                    if next_cp_id == race.chp then
                        next_cp = race.chl[1]
                    end
                    local chtype = 5
                    local z_offset = 5.0
                    local radius = cp_radius
                    if race.rndchk and race.rndchk[next_cp_id] then
                        chtype = 10
                        z_offset = 10.0
                        radius = 20.0
                    elseif race.cpbs1 and (race.cpbs1[next_cp_id] > 1) then
                        chtype = 10
                        z_offset = 10.0
                        radius = 20.0
                    end
                    chtype = chtype + GetNumberOfArrowsToDraw(next_cp_id)
                    cp_handle = CreateCheckpoint(chtype, previous_cp.x, previous_cp.y, previous_cp.z + z_offset, next_cp.x, next_cp.y, next_cp.z, radius, cp_r, cp_g, cp_b, 180, 0)
                    SetCheckpointCylinderHeight(cp_handle, cp_height, cp_height, 100.0);
                    SetCheckpointIconRgba(cp_handle, cpi_r, cpi_g, cpi_b, cpi_a)
                    
                    if next_cp_id == race.chp then
                        local next_cp = race.chl[1]
                        next_cp_blip_handle = AddBlipForCoord(next_cp.x, next_cp.y, next_cp.z)
                    else
                        next_cp_blip_handle = AddBlipForCoord(race.chl[next_cp_id+1].x, race.chl[next_cp_id+1].y, race.chl[next_cp_id+1].z)
                    end
                    SetBlipSprite(next_cp_blip_handle, 1)
                    SetBlipColour(next_cp_blip_handle, 66)
                    SetBlipScale(next_cp_blip_handle, 0.5)
                end
            else
                if next_cp_id == race.chp then -- PASSED THE FINISH                    
                    PlaySoundFrontend(-1, "Checkpoint_Finish", "DLC_Stunt_Race_Frontend_Sounds", 0)
                    RemoveBlip(cp_blip_handle)
                    gameHost = true
                    break
                else
                    PlaySoundFrontend(-1, "Checkpoint", "DLC_Stunt_Race_Frontend_Sounds", 0)
                    next_cp_id = next_cp_id + 1
                    
                    RemoveBlip(cp_blip_handle)
                    cp_blip_handle = next_cp_blip_handle
                    SetBlipScale(cp_blip_handle, 1.0)
                    
                    if next_cp_id == race.chp then -- creating the finish marker
                        local cp = race.chl[next_cp_id]
                        cp_handle = CreateCheckpoint(4, cp.x, cp.y, cp.z, cp.x, cp.y, cp.z, cp_radius, cp_r, cp_g, cp_b, 180, 0)
                        SetCheckpointIconRgba(cp_handle, cpi_r, cpi_g, cpi_b, cpi_a)
                    else
                        local previous_cp = race.chl[next_cp_id]
                        local next_cp = race.chl[next_cp_id+1]
                        local chtype = 5
                        local z_offset = 5.0
                        local radius = cp_radius
                        if race.rndchk and race.rndchk[next_cp_id] then
                            chtype = 10
                            z_offset = 10.0
                            radius = 20.0
                        elseif race.cpbs1 and (race.cpbs1[next_cp_id] > 1) then
                            chtype = 10
                            z_offset = 10.0
                            radius = 20.0
                        end
                        chtype = chtype + GetNumberOfArrowsToDraw(next_cp_id)
                        cp_handle = CreateCheckpoint(chtype, previous_cp.x, previous_cp.y, previous_cp.z + z_offset, next_cp.x, next_cp.y, next_cp.z, radius, cp_r, cp_g, cp_b, 180, 0)
                        SetCheckpointCylinderHeight(cp_handle, cp_height, cp_height, 100.0);
                        SetCheckpointIconRgba(cp_handle, cpi_r, cpi_g, cpi_b, cpi_a)
                        if next_cp_id+1 == race.chp  then -- creating the finish blip
                            next_cp_blip_handle = AddBlipForCoord(race.chl[next_cp_id+1].x, race.chl[next_cp_id+1].y, race.chl[next_cp_id+1].z)
                            SetBlipSprite(next_cp_blip_handle, 38)
                        else
                            next_cp_blip_handle = AddBlipForCoord(race.chl[next_cp_id+1].x, race.chl[next_cp_id+1].y, race.chl[next_cp_id+1].z)
                            SetBlipSprite(next_cp_blip_handle, 1)
                            SetBlipColour(next_cp_blip_handle, 66)
                            SetBlipScale(next_cp_blip_handle, 0.5)
                        end
                    end
                end
            end
        end
        -- if got_boost and IsControlJustPressed(0, 51) then
            -- DoBoost()
        -- elseif got_rockets and IsControlJustPressed(0, 51) then
            -- DoRockets()
        -- end
        Citizen.Wait(0)--删了会死循环 卡死游戏...
    end
end)
end

function IsPlayerWithinCPTrigger(cp)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local cp_center = vector3(cp.x, cp.y, cp.z)
    local trigger_radius = cp_radius + 2.0
    if race.rndchk and race.rndchk[next_cp_id] then
        cp_center = cp_center + vector3(0.0,0.0,10.0)
        trigger_radius = 20.0
    elseif race.cpbs1 and (race.cpbs1[next_cp_id] > 1) then
        cp_center = cp_center + vector3(0.0,0.0,10.0)
        trigger_radius = 20.0
    end
    local distanceToCheckpoint = Vdist(pos.x, pos.y, pos.z, cp_center.x, cp_center.y, cp_center.z)
    return (distanceToCheckpoint < trigger_radius)
end

function GetNumberOfArrowsToDraw(cp)
    thisCP = vector2(race.chl[cp].x, race.chl[cp].y)
    previousCP = vector2(race.chl[cp-1].x, race.chl[cp-1].y)
    if cp == race.chp then
        nextCP = vector2(race.chl[1].x, race.chl[1].y)
    else
        nextCP = vector2(race.chl[cp+1].x, race.chl[cp+1].y)
    end
    prevToNow = thisCP - previousCP
    nowToNext = nextCP - thisCP
    angle = GetAngleBetween_2dVectors(prevToNow.x, prevToNow.y, nowToNext.x, nowToNext.y)
    angle = Absf(angle)
    if angle < 80.0 then
        return 0
    elseif angle < 140.0 then
        return 1
    elseif angle < 180.0 then
        return 2
    else
        return 0
    end
end

function FadeoutAndDeleteCheckpoint(cp)
Citizen.CreateThread(function()
    SetCheckpointRgba(cp, 255, 255, 255, 0)
    local fadeout_duration = 500
    local start_fadeout = GetNetworkTime()
    while GetNetworkTime() - start_fadeout < 500 do
        local alpha = Round(((500 - (GetNetworkTime() - start_fadeout))/500)*255)
        SetCheckpointIconRgba(cp, 255, 255, 255, alpha)
        Citizen.Wait(0)
    end
    DeleteCheckpoint(cp)
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
    race = {}
end

--[[Citizen.CreateThread(function()
    local menuOpen = false

    WarMenu.CreateMenu('MainMenu', '主菜单')
    WarMenu.CreateSubMenu('PiFuMenu', 'MainMenu', '皮肤菜单')
    WarMenu.CreateSubMenu('AllPlayer', 'MainMenu', '玩家菜单')
    WarMenu.SetTitleBackgroundColor('MainMenu', 30,144,255, 255)
    WarMenu.SetTitleBackgroundColor('PiFuMenu', 30,144,255, 255)
    WarMenu.SetTitleBackgroundColor('AllPlayer', 30,144,255, 255)
    WarMenu.SetTitleColor('MainMenu', 255, 255, 255)
    WarMenu.SetTitleColor('PiFuMenu', 255, 255, 255)
    WarMenu.SetTitleColor('AllPlayer', 255, 255, 255)
    WarMenu.SetTitleBackgroundSprite('MainMenu', 'shopui_title_exec_vechupgrade', 'shopui_title_exec_vechupgrade')
    WarMenu.SetTitleBackgroundSprite('PiFuMenu', 'shopui_title_exec_vechupgrade', 'shopui_title_exec_vechupgrade')
    WarMenu.SetTitleBackgroundSprite('AllPlayer', 'shopui_title_exec_vechupgrade', 'shopui_title_exec_vechupgrade')
        
    while true do
    
      if not isGameStarted then
        if IsPlayerDead(PlayerId()) then
            WarMenu.CloseMenu()
        elseif WarMenu.IsMenuOpened('MainMenu') then
            if WarMenu.MenuButton("更换人物", "PiFuMenu") then
            elseif WarMenu.MenuButton("所有玩家", "AllPlayer") then
            elseif WarMenu.Button('加载模型') then
                TriggerServerEvent('fuzzys:loadmodel', npcPlayer)
                gameHost = true
            elseif WarMenu.Button('加载比赛地图') then
                TriggerServerEvent('fuzzys:loadmap')
                gameHost = false
            elseif WarMenu.Button('卸载地图') then
                unloadJsonMap()
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('PiFuMenu') then
            if WarMenu.Button('孙悟空') then
                changePifu('Goku')
            elseif WarMenu.Button('蒂法') then
                changePifu('Tifa')   
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('AllPlayer') then
            for i = 0, 32 do
                if NetworkIsPlayerActive(i) then
                    --local player = GetPlayerServerId(i)
                    if WarMenu.Button(GetPlayerName(i)) then
                        TriggerServerEvent('fuzzys:getplayerid', i)
                    end
                end
            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 244) or menuOpen then
            WarMenu.OpenMenu('MainMenu')
        else
            gameHost = false
            --RenderScriptCams(false, 0, 3000, 1, 0)
        end
        
        TogglePvP(false)
        local Players = GetPlayers()
        local playerCoords = GetEntityCoords(GetPlayerPed(-1), true)
        local markCoords = {x=1979.17, y = 3708.92, z = 31.12}
        
        if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, markCoords.x, markCoords.y, markCoords.z, true) <= 10.0 then
            DrawMarker(1, markCoords.x, markCoords.y, markCoords.z, 0, 0, 0, 0, 0, 0, 4.0, 3.6, 2.0, 30,144,255, 180, 0, 0, 2, 0, 0, 0, 0)
            --DrawMarker(9, markCoords.x, markCoords.y, markCoords.z + 0.59, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 30,144,255, 180, 0, 0, 2, 0, 0, 0, 0)
            --DrawMarker(37, markCoords.x, markCoords.y, markCoords.z + 1.5, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 4.0, 30,144,255, 180, 0, 0, 2, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, markCoords.x, markCoords.y, markCoords.z, true) <= 3.0 then
                menuOpen = true
                Draw3DText(markCoords.x, markCoords.y, markCoords.z - 2.0, "~b~创建比赛", 5, 0.25, 0.25)
            else
                --WarMenu.CloseMenu()                
                menuOpen = false
            end
        end        
        
        if isFirstSpawn then
            AddTextEntry('FirstSpawnMessageHeader', '~r~FiveM创造模式')
            AddTextEntry('FirstSpawnMessageLine1', '前往圈内选择人物或举办比赛')
            AddTextEntry('FirstSpawnMessageLine2', '~y~提示:~n~~s~此模式正在开发中，M键打开交互菜单。~n~更过玩法内容正在开发中~n~')

            local Timer = GetGameTimer()
            while not (IsControlJustPressed(2, 176) or IsDisabledControlJustPressed(2, 176) or GetGameTimer() - Timer > 10000) do
                Citizen.Wait(0)
                SetWarningMessageWithHeader('FirstSpawnMessageHeader', 'FirstSpawnMessageLine1', 2, 'FirstSpawnMessageLine2', false, 0, false, 0, false)
            end

            isFirstSpawn = false
        end
        
        if gameHost == true then
            --garage_cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1979.17, 3708.92, 32.12, 10.0, 0.0, 10.0, 40.0, 2, 2)
            --SetCamActive(garage_cam, true)
            --RenderScriptCams(true, 0, 3000, 1, 0)
            RenderPlayerList(Players)
            --RenderScriptCams(false, 0, 3000, 1, 0)
        end
        Wait(0)
      end
    end
end)

Citizen.CreateThread(function()
  -- SetRandomSeed(GetNetworkTime())
  StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
  Citizen.InvokeNative(joaat("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', '大逃杀模式测试')
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
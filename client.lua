local props = {}
local selectModelHash = -1088903588

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
local npcPlayer = 123

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
    --TriggerServerEvent('fuzzys:playerSpawned')
    -- if isFirstSpawn then
        -- isFirstSpawn = false
    -- end
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

function ShowAllPlayer(menu)
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
    local newitem = NativeUI.CreateListItem("选择生成模型", propHash, 1)
    menu:AddItem(newitem)
    menu.OnListChange = function(sender, item, index)
        if item == newitem then
            selectModelHash = item:IndexToItem(index)
            ShowNotification("切换模型 ~b~" .. selectModelHash .. "~w~...")
        end
    end
end

function loadRaceMap(menu)
    local submenu = _menuPool:AddSubMenu(menu, "地图编辑器", "", 1300, 80)
    local loadProp = NativeUI.CreateItem("加载玩家地图", "")
    local loadMap = NativeUI.CreateItem("加载比赛地图", "")
    local unloadMap = NativeUI.CreateItem("卸载地图", "")
    submenu:AddItem(loadProp)
    submenu:AddItem(loadMap)
    submenu:AddItem(unloadMap)

    submenu.OnItemSelect = function(sender, item, index)
        if item == loadProp then
            TriggerServerEvent('fuzzys:loadmodel', npcPlayer)
            gameHost = false
        elseif item == loadMap then
            TriggerServerEvent('fuzzys:loadmap')
            gameHost = true
        elseif item == unloadMap then
            unloadJsonMap()
        end
    end
end

ShowPiFuMenu(mainMenu)
--ShowAllPlayer(mainMenu)
MapEditor(mainMenu)
loadRaceMap(mainMenu)

_menuPool:RefreshIndex()
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(0, 244) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

Citizen.CreateThread( function()
    while true do
    Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local angle = GetEntityHeading(GetPlayerPed(-1))
        if IsControlJustPressed(0, 38) then
            CreateMap(pos, angle, selectModelHash)
        end
        
        -- if gameHost == true then
            -- TogglePvP(false)
            -- local Players = GetPlayers()
            -- RenderPlayerList(Players)
        -- end
        
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
AddEventHandler('map:create', function(pos, angle, model)
    CreateMap(pos, angle, model)
end)

RegisterNetEvent('map:loadmap')
AddEventHandler('map:loadmap', function(jsonTable)
    loadJsonMap(jsonTable)
end)

function CreateMap(pos, angle, model)
    --local model = "stt_prop_ramp_jump_xs"
    --local model = joaat(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end
    local obj = CreateObjectNoOffset(model, pos, false, false, false)

    local min, max = GetModelDimensions(model)
    local offset = math.abs(min.x)

    SetEntityHeading(obj, angle + 90)
    --PlaceObjectOnGroundProperly(obj)

    local new = GetOffsetFromEntityInWorldCoords(obj, offset, 0, 0)
    SetEntityCoords(obj, new.x, new.y, new.z - 0.2)
    FreezeEntityPosition(obj, true)
    SetObjectTextureVariant(obj, 3)
    local rot = GetEntityRotation(obj, 2)
    TriggerServerEvent('map:sync', pos, angle, new, rot, model)
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
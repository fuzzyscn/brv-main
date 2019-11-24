AddEventHandler('onClientMapStart', function()
  exports.spawnmanager:setAutoSpawn(true)
  exports.spawnmanager:forceRespawn()
end)

local isFirstSpawn = true
local gameHost = false
local isGameStarted = false
local playerInLobby = false
local Players = {}
local npcPlayer = 10

AddEventHandler("playerSpawned", function(spawn)

    Citizen.CreateThread(function()
        local playerPed = GetPlayerPed(-1)
        -- local pedhash = GetHashKey("a_m_y_skater_01")
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
        GiveWeaponToPed(playerPed, GetHashKey('gadget_parachute'), 1, false, false)
        SetPedRandomComponentVariation(playerPed, true)
    end)

    playerInLobby = true
    TriggerServerEvent('fuzzys:playerSpawned')
    -- if isFirstSpawn then
        -- isFirstSpawn = false
    -- end
end)

Citizen.CreateThread(function()
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
            elseif WarMenu.Button('创建比赛-加载模型') then
                TriggerServerEvent('fuzzys:loadOldMap', npcPlayer)
                gameHost = true
            elseif WarMenu.Button('加载比赛地图') then
                TriggerServerEvent('fuzzys:loadmap')
                gameHost = false
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
                    local player = GetPlayerServerId(i)
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
            AddTextEntry('FirstSpawnMessageHeader', '~r~大逃杀模式')
            AddTextEntry('FirstSpawnMessageLine1', '前往圈内选择人物或举办比赛')
            AddTextEntry('FirstSpawnMessageLine2', '~y~游玩提示:~n~~s~玩法参考绝地求生大逃杀模式，右键打开第一人称。~n~更过内容正在开发中~n~')

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

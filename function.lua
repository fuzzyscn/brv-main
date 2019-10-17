function GetPlayers()
	local Players = {}
	for i = 0, 31 do
		if NetworkIsPlayerConnected(i) and NetworkIsPlayerActive(i) then
			table.insert(Players, i)
		end
	end
    return Players
end

function RenderPlayerList(Players)
	local x = 0.825
	local y = 0.1
	DrawTxt('~y~玩家总数: ' .. #Players, x, y)
	y = y + 0.03
	DrawTxt('~b~准备中:', x, y)
	y = y + 0.03
	for Key, id in pairs(Players) do
			DrawTxt('~r~' .. id, x, y)
			DrawTxt('~g~' .. GetPlayerName(id), x+0.011, y)
		y = y + 0.03
	end
	DrawRect(x + 0.075, (0.1 + (y - 0.1) / 2), 0.16, 0.03 + (y - 0.1), 0, 0, 0, 150)
end

function DrawTxt(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.35)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry('STRING')
	AddTextComponentString(text)
	EndTextCommandDisplayText(x, y)
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY) -- A function tells what to do 
     local px,py,pz=table.unpack(GetGameplayCamCoords())
     local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

     local scale = (1/dist)*20
     local fov = (1/GetGameplayCamFov())*100
     local scale = scale*fov

     SetTextScale(scaleX*scale, scaleY*scale)
     SetTextFont(fontId)
     SetTextProportional(1)
     SetTextColour(255, 255, 255, 250)
     SetTextDropshadow(1, 1, 1, 1, 255)
     SetTextEdge(2, 0, 0, 0, 150)
     SetTextDropShadow()
     SetTextOutline()
     SetTextEntry("STRING")
     SetTextCentre(1)
     AddTextComponentString(textInput)
     SetDrawOrigin(x,y,z+5.0, 0)
     DrawText(0.0, 0.0)
     ClearDrawOrigin()
end

function TogglePvP(Toggle)
    NetworkSetFriendlyFireOption(Toggle)
    SetCanAttackFriendly(PlayerPedId(), Toggle, Toggle)
end

function changePifu(name)
    local hash = GetHashKey(name)
    
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		Citizen.Wait(0)
	end
    
    SetPlayerModel(PlayerId(), hash)
    SetPedRandomComponentVariation(GetPlayerPed(-1), true)
    
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('gadget_parachute'), 1, false, false)
end
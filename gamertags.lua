Citizen.CreateThread(function()
	local PlayerTags = {}
	while true do
		Citizen.Wait(0)
		for Player = 0, 31 do
			--if Player ~= PlayerId() then
				local IsConnected = NetworkIsPlayerConnected(Player)
				local IsTagActive = IsMpGamerTagActive(PlayerTags[Player])

				if IsConnected and (not PlayerTags[Player] or (PlayerTags[Player] and not IsTagActive)) then
					PlayerTags[Player] = CreateMpGamerTag(GetPlayerPed(Player), GetPlayerName(Player), false, false, '', false)
				elseif IsConnected and PlayerTags[Player] and IsTagActive then
					SetMpGamerTagVisibility(PlayerTags[Player], 0, true)
                    SetMpGamerTagVisibility(PlayerTags[Player], 2, true)
					SetMpGamerTagVisibility(PlayerTags[Player], 4, NetworkIsPlayerTalking(Player))				
				elseif PlayerTags[Player] then
					if IsTagActive then
						RemoveMpGamerTag(PlayerTags[Player])
					end
					PlayerTags[Player] = nil
				end
            --end
		end
	end
end)

-- Thanks to @nobody
Citizen.CreateThread(function()
	while true do
		-- These natives has to be called every frame.
		SetVehicleDensityMultiplierThisFrame(0.0)
		SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		Citizen.Wait(1)
	end
end)


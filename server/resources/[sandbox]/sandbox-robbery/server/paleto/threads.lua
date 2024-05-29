local _threading = false

function StartPaletoThreads()
	if _threading then
		return
	end
	_threading = true

	Citizen.CreateThread(function()
		while _threading do
			if _pbGlobalReset ~= nil then
				if os.time() > _pbGlobalReset then
					Logger:Info("Robbery", "Paleto Bank Heist Has Been Reset")
					ResetPaleto()
				end
			end
			Citizen.Wait(30000)
		end
	end)
end

local _powerThreading = false
function RestorePowerThread()
	if IsPaletoPowerDisabled() then
		if _powerThreading then
			return
		end
		_powerThreading = true

		Citizen.CreateThread(function()
			Logger:Info("Robbery", "Paleto Blackout Started")
			GlobalState["Sync:PaletoBlackout"] = true
			Citizen.Wait(1000 * (60 * 30))
			GlobalState["Sync:PaletoBlackout"] = false
			_powerThreading = false
			Logger:Info("Robbery", "Paleto Blackout Ended")
		end)
	end
end

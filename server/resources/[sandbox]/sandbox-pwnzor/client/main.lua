local _r = false

AddEventHandler("Pwnzor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
	Input = exports["sandbox-base"]:FetchComponent("Input")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Pwnzor", {
		"Callbacks",
		"Notification",
		"Weapons",
		"Input",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		if not _r then
			_r = true
			RegisterEvents()
			RegisterCommands()

			-- Callbacks:ServerCallback("Commands:ValidateAdmin", {}, function(isAdmin)
			-- 	if not isAdmin then
			-- 		Citizen.CreateThread(function()
			-- 			while _r do
			-- 				Citizen.Wait(1)
			-- 				local ped = PlayerPedId()
			-- 				SetPedInfiniteAmmoClip(ped, false)
			-- 				SetEntityInvincible(ped, false)
			-- 				SetEntityCanBeDamaged(ped, true)
			-- 				ResetEntityAlpha(ped)
			-- 				local fallin = IsPedFalling(ped)
			-- 				local ragg = IsPedRagdoll(ped)
			-- 				local parac = GetPedParachuteState(ped)
			-- 				if parac >= 0 or ragg or fallin then
			-- 					SetEntityMaxSpeed(ped, 80.0)
			-- 				else
			-- 					SetEntityMaxSpeed(ped, 7.1)
			-- 				end
			-- 			end
			-- 		end)
			-- 	end
			-- end)
		end
	end)
end)

AddEventHandler("onResourceStart", function(resourceName)
	if GetGameTimer() >= 10000 then
		TriggerServerEvent("Pwnzor:Server:ResourceStarted", resourceName)
	end
end)

AddEventHandler("onResourceStopped", function(resourceName)
	TriggerServerEvent("Pwnzor:Server:ResourceStopped", resourceName)
end)

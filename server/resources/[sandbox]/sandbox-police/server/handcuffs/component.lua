AddEventHandler("Handcuffs:Shared:DependencyUpdate", HandcuffsComponents)
function HandcuffsComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Handcuffs = exports["sandbox-base"]:FetchComponent("Handcuffs")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
end

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	local playerState = Player(source).state
	playerState.isCuffed = false
	playerState.isHardCuffed = false
end)

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Handcuffs", {
		"Middleware",
		"Callbacks",
		"Logger",
		"Fetch",
		"Sounds",
		"Handcuffs",
		"Inventory",
		"Chat",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		HandcuffsComponents()
		HandcuffItems()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Handcuffs", _HANDCUFFS)
end)

function DoCuff(source, target, isHardCuffed, isForced)
	TriggerClientEvent("Handcuffs:Client:CuffingAnim", source)
	Callbacks:ClientCallback(target, "Handcuffs:DoCuff", {
		cuffer = source,
		isHardCuffed = isHardCuffed,
		forced = isForced,
	}, function(result)
		if result == -1 then
			Execute:Client(source, "Notification", "Error", "Unable To Cuff Player")
		else
			local playerState = Player(target).state
			local ped = GetPlayerPed(target)
			if result then
				ClearPedTasksImmediately(GetPlayerPed(target))
				ClearPedTasksImmediately(GetPlayerPed(source))

				Execute:Client(source, "Notification", "Error", "Suspect Broke Out Of The Cuffs")
				Sounds.Play:Distance(target, 10, "handcuff_break.ogg", 0.35)
				--Sounds.Play:One(target, "handcuff_break.ogg", 0.35)
				playerState.isCuffed = false
				playerState.isHardCuffed = false
				SetPedConfigFlag(ped, 120, false)
				SetPedConfigFlag(ped, 121, false)
			else
				Execute:Client(source, "Notification", "Success", "You Cuffed A Player")
				Sounds.Play:Distance(target, 10, "handcuff_on.ogg", 0.55)
				Citizen.CreateThread(function()
					Citizen.Wait(1050)
					Sounds.Play:Distance(target, 10, "handcuff_on.ogg", 0.55)
				end)
				SetPedConfigFlag(ped, 120, true)
				SetPedConfigFlag(ped, 121, isHardCuffed)
				playerState.isCuffed = true
				playerState.isHardCuffed = isHardCuffed
				--FreezeEntityPosition(ped, false)
				TriggerClientEvent("Handcuffs:Client:CuffThread", target)
			end
		end
	end)
end

RegisterNetEvent("Handcuffs:Server:HardCuff", function(target)
	local src = source

	if not target then
		return
	end

	local mPos = GetEntityCoords(GetPlayerPed(src))
	local tPos = GetEntityCoords(GetPlayerPed(target))

	if #(vector3(mPos.x, mPos.y, mPos.z) - vector3(tPos.x, tPos.y, tPos.z)) <= 1.5 then
		if Inventory.Items:HasAnyItems(src, Config.CuffItems) then
			if
				not Player(target).state.isCuffed
				or (Player(target).state.isCuffed and not Player(target).state.isHardCuffed)
			then
				Handcuffs:HardCuffTarget(src, target, false)
			else
				Execute:Client(source, "Notification", "Error", "Target Already Hard Cuffed")
			end
		end
	else
		Execute:Client(source, "Notification", "Error", "Target Too Far")
	end
end)

RegisterNetEvent("Handcuffs:Server:SoftCuff", function(target)
	local src = source

	if not target then
		return
	end

	local mPos = GetEntityCoords(GetPlayerPed(src))
	local tPos = GetEntityCoords(GetPlayerPed(target))

	if #(vector3(mPos.x, mPos.y, mPos.z) - vector3(tPos.x, tPos.y, tPos.z)) <= 1.5 then
		if Inventory.Items:HasAnyItems(src, Config.CuffItems) then
			local pState = Player(target).state
			if not pState.isCuffed or (pState.isCuffed and pState.isHardCuffed) then
				Handcuffs:SoftCuffTarget(src, target, false)
			end
		else
			--missing items
		end
	else
		--target too far
	end
end)

RegisterNetEvent("Handcuffs:Server:Uncuff", function(target)
	local src = source

	if not target then
		return
	end

	local mPos = GetEntityCoords(GetPlayerPed(src))
	local tPos = GetEntityCoords(GetPlayerPed(target))

	if #(vector3(mPos.x, mPos.y, mPos.z) - vector3(tPos.x, tPos.y, tPos.z)) <= 1.5 then
		if Inventory.Items:HasAnyItems(src, Config.CuffItems) then
			if Player(target).state.isCuffed then
				Handcuffs:UncuffTarget(src, target)
			end
		end
	else
		--target too far
	end
end)

_HANDCUFFS = {
	SelfToggle = function(self, source)
		if source ~= nil then
			if not Player(source).state.isCuffed then
				DoCuff(source, source, false, false)
				Execute:Client(source, "Notification", "Error", "Nobody Around To Cuff")
			else
				Handcuffs:UncuffTarget(source, source)
			end
		else
			Execute:Client(source, "Notification", "Error", "Nobody To Cuff")
		end
	end,
	ToggleCuffs = function(self, source)
		Callbacks:ClientCallback(source, "HUD:GetTargetInfront", {}, function(target)
			if target ~= nil then
				if not Player(target).state.isCuffed then
					local myPos = GetEntityCoords(GetPlayerPed(source))
					local pos = GetEntityCoords(GetPlayerPed(target))
					if #(vector3(myPos.x, myPos.y, myPos.z) - vector3(pos.x, pos.y, pos.z)) <= 1.25 then
						DoCuff(source, target, false, false)
						return
					end
					Execute:Client(source, "Notification", "Error", "Nobody Around To Cuff")
				else
					Handcuffs:UncuffTarget(source, target)
				end
			else
				Execute:Client(source, "Notification", "Error", "Nobody To Cuff")
			end
		end)
	end,
	SoftCuff = function(self, source)
		Callbacks:ClientCallback(source, "HUD:GetTargetInfront", {}, function(target)
			if target ~= nil then
				if not Player(target).state.isCuffed then
					local myPos = GetEntityCoords(GetPlayerPed(source))
					local pos = GetEntityCoords(GetPlayerPed(target))
					if #(vector3(myPos.x, myPos.y, myPos.z) - vector3(pos.x, pos.y, pos.z)) <= 1.25 then
						DoCuff(source, target, false, false)
						return
					end
					Execute:Client(source, "Notification", "Error", "Nobody Around To Cuff")
				else
					Execute:Client(source, "Notification", "Error", "Player Already Cuffed")
				end
			else
				Execute:Client(source, "Notification", "Error", "Nobody To Cuff")
			end
		end)
	end,
	SoftCuffTarget = function(self, source, target, forced)
		local myPos = GetEntityCoords(GetPlayerPed(source))
		local pos = GetEntityCoords(GetPlayerPed(target))
		if #(vector3(myPos.x, myPos.y, myPos.z) - vector3(pos.x, pos.y, pos.z)) <= 1.25 then
			DoCuff(source, target, false, forced)
			return
		end
		Execute:Client(source, "Notification", "Error", "Nobody Around To Cuff")
	end,
	HardCuff = function(self, source)
		Callbacks:ClientCallback(source, "HUD:GetTargetInfront", {}, function(target)
			if target ~= nil then
				if not Player(target).state.isCuffed then
					local myPos = GetEntityCoords(GetPlayerPed(source))
					local pos = GetEntityCoords(GetPlayerPed(target))
					if #(vector3(myPos.x, myPos.y, myPos.z) - vector3(pos.x, pos.y, pos.z)) <= 1.25 then
						DoCuff(source, target, true, false)
						return
					end
					Execute:Client(source, "Notification", "Error", "Nobody Around To Cuff")
				else
					Execute:Client(source, "Notification", "Error", "Player Already Cuffed")
				end
			else
				Execute:Client(source, "Notification", "Error", "Nobody To Cuff")
			end
		end)
	end,
	HardCuffTarget = function(self, source, target, forced)
		local myPos = GetEntityCoords(GetPlayerPed(source))
		local pos = GetEntityCoords(GetPlayerPed(target))
		if #(vector3(myPos.x, myPos.y, myPos.z) - vector3(pos.x, pos.y, pos.z)) <= 1.25 then
			DoCuff(source, target, true, forced)
			return
		end
		Execute:Client(source, "Notification", "Error", "Nobody Around To Cuff")
	end,
	Uncuff = function(self, source)
		Callbacks:ClientCallback(source, "HUD:GetTargetInfront", {}, function(target)
			if target ~= nil then
				if Player(target).state.isCuffed then
					Handcuffs:UncuffTarget(source, target)
				else
					Execute:Client(source, "Notification", "Error", "Player Is Not Cuffed")
				end
			else
				Execute:Client(source, "Notification", "Error", "Nobody To Cuff")
			end
		end)
	end,
	UncuffTarget = function(self, source, target)
		Callbacks:ClientCallback(target, "Handcuffs:VehCheck", {}, function(inVeh)
			if not inVeh then
				if source ~= -1 then
					TriggerClientEvent("Handcuffs:Client:UncuffingAnim", source)
					Citizen.Wait(2200)
				end
				Sounds.Play:Distance(target, 10, "handcuff_remove.ogg", 0.15)
				local playerState = Player(target).state
				local ped = GetPlayerPed(target)
				FreezeEntityPosition(ped, false)
				playerState.isCuffed = false
				playerState.isHardCuffed = false
				SetPedConfigFlag(ped, 120, false)
				SetPedConfigFlag(ped, 121, false)
			else
				if source ~= -1 then
					Execute:Client(source, "Notification", "Error", "Unable To Uncuff Player")
				end
			end
		end)
	end,
}

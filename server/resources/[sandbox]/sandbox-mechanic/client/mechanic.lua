_repairingVehicle = false

AddEventHandler("Mechanic:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	Mechanic = exports["sandbox-base"]:FetchComponent("Mechanic")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Mechanic", {
		"Logger",
		"Fetch",
		"Callbacks",
		"Game",
		"Menu",
		"Mechanic",
		"Targeting",
		"Notification",
		"Utils",
		"Animations",
		"Polyzone",
		"Jobs",
		"Progress",
		"Vehicles",
		"Targeting",
		"ListMenu",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		CreateMechanicZones()
		CreateMechanicDutyPoints()

		Callbacks:RegisterClientCallback("Mechanic:StartInstall", function(data, cb)
			local part = data?.part
			local quantity = data?.quantity
			if part and quantity and LocalPlayer.state.loggedIn and not _repairingVehicle and type(quantity) == "number" and quantity > 0 then
				local duty = LocalPlayer.state.onDuty
				if duty and _mechanicJobs[duty] then
					local installingPartData = _mechanicItemsToParts[part]
					local target = Targeting:GetEntityPlayerIsLookingAt()
					if
						installingPartData
						and target
						and target.entity
						and DoesEntityExist(target.entity)
						and IsEntityAVehicle(target.entity)
						and (
							(#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
							or Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
							or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
						)
					then
						local vehEnt = Entity(target.entity)
						local vehClass = vehEnt.state.Class
						local vehDamage = vehEnt.state.DamagedParts

						if not vehDamage or vehDamage[installingPartData.part] >= 99 then
							Notification:Error("Vehicle Part Doesn't Need Repairing")
							return cb(false)
						end

						local requiresHighGradeParts = false
						if vehClass then
							requiresHighGradeParts = _highPerformanceClasses[vehClass]
						end

						if
							(not requiresHighGradeParts and installingPartData.regular)
							or (requiresHighGradeParts and installingPartData.hperformance)
						then
							if GetIsVehicleEngineRunning(target.entity) then
								Notification:Error("Turn Off the Engine")
								return cb(false)
							end

							if IsPedInAnyVehicle(LocalPlayer.state.ped, false) then
								Notification:Error("Can't Repair Whilst in a Vehicle")
								return cb(false)
							end

							TaskTurnPedToFaceEntity(LocalPlayer.state.ped, target.entity, 1.0)
							Citizen.Wait(750)

							local repairLength = (installingPartData.time or 15) * quantity

							Progress:ProgressWithStartAndTick({
								name = "veh_mech_repair",
								duration = repairLength * 1000,
								label = "Repairing Vehicle",
								canCancel = true,
								tickrate = 1000,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									anim = installingPartData.anim or "mechanic",
								},
								disarm = true,
							}, function()
								_repairingVehicle = true
							end, function()
								if
									not DoesEntityExist(target.entity)
									or not (
										Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
										or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
										or (#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
									)
								then
									Progress:Cancel()
								end
							end, function(wasCancelled)
								_repairingVehicle = false
								if not wasCancelled then
									if
										Vehicles.Repair:Part(
											target.entity,
											installingPartData.part,
											(installingPartData.amount * quantity)
										)
									then
										cb(true)
										Notification:Success("Part Repaired")
									else
										cb(false)
										Notification:Error("Failed to Repair Part")
									end
								else
									cb(false)
								end
							end)

							return
						else
							Notification:Error("This Part Doesn't Fit! Stupid Mechanic!")
						end
					end
				end
			end
			cb(false)
		end)

		Callbacks:RegisterClientCallback("Mechanic:StartUpgradeInstall", function(part, cb)
			if LocalPlayer.state.loggedIn and not _repairingVehicle then
				local duty = LocalPlayer.state.onDuty
				if duty and _mechanicJobs[duty] then
					local target = Targeting:GetEntityPlayerIsLookingAt()
					if
						target
						and target.entity
						and DoesEntityExist(target.entity)
						and IsEntityAVehicle(target.entity)
						and (
							(#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
							or Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
							or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
						)
					then
						if
							GlobalState["PoliceCars"][GetEntityModel(target.entity)]
							or GlobalState["EMSCars"][GetEntityModel(target.entity)]
						then
							Notification:Error("Vehicle cannot be modified.")
							return
						end
						if GetIsVehicleEngineRunning(target.entity) then
							Notification:Error("Turn Off the Engine")
							return cb(false)
						end

						SetVehicleModKit(target.entity, 0)

						if part.toggleMod and IsToggleModOn(target.entity, part.modType) then
							Notification:Error("Vehicle Already Has Upgrade of That Level")
							return cb(false)
						end

						if not part.toggleMod then
							local maxUpgradable = GetNumVehicleMods(target.entity, part.modType) - 1
							local currentUpgrade = GetVehicleMod(target.entity, part.modType)
							if part.modIndex > maxUpgradable then
								Notification:Error("Vehicle Does Not Support That Upgrade")
								return cb(false)
							end

							if currentUpgrade >= part.modIndex then
								Notification:Error("Vehicle Already Has Upgrade of That Level")
								return cb(false)
							end
						end

						if IsPedInAnyVehicle(LocalPlayer.state.ped, false) then
							Notification:Error("Can't Repair Whilst in a Vehicle")
							return cb(false)
						end

						TaskTurnPedToFaceEntity(LocalPlayer.state.ped, target.entity, 1.0)
						Citizen.Wait(750)

						local repairLength = part.time or 25

						Progress:ProgressWithStartAndTick({
							name = "veh_mech_install",
							duration = repairLength * 1000,
							label = "Installing " .. part.part .. " Upgrade",
							canCancel = true,
							tickrate = 1000,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								anim = part.anim or "mechanic",
							},
							disarm = true,
						}, function()
							_repairingVehicle = true
						end, function()
							if
								not DoesEntityExist(target.entity)
								or not (
									Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
									or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
									or (#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
								)
							then
								Progress:Cancel()
							end
						end, function(wasCancelled)
							_repairingVehicle = false
							if not wasCancelled then
								if part.toggleMod then
									ToggleVehicleMod(target.entity, part.modType, true)
								else
									SetVehicleMod(target.entity, part.modType, part.modIndex, false)
								end

								cb(true, VehToNet(target.entity))
								Notification:Success("Part Installed")
							else
								cb(false)
							end
						end)
						return
					end
				end
			end
			cb(false)
		end)

		Callbacks:RegisterClientCallback("Mechanic:StartUpgradeRemoval", function(part, cb)
			if LocalPlayer.state.loggedIn and not _repairingVehicle then
				local duty = LocalPlayer.state.onDuty
				if duty and _mechanicJobs[duty] then
					local target = Targeting:GetEntityPlayerIsLookingAt()
					if
						target
						and target.entity
						and DoesEntityExist(target.entity)
						and IsEntityAVehicle(target.entity)
						and (
							(#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
							or Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
							or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
						)
					then
						if
							GlobalState["PoliceCars"][GetEntityModel(target.entity)]
							or GlobalState["EMSCars"][GetEntityModel(target.entity)]
						then
							Notification:Error("Vehicle cannot be modified.")
							return
						end
						if GetIsVehicleEngineRunning(target.entity) then
							Notification:Error("Turn Off the Engine")
							return cb(false)
						end

						SetVehicleModKit(target.entity, 0)

						local currentUpgrade = GetVehicleMod(target.entity, part.partType)

						if currentUpgrade == -1 then
							Notification:Error("This vehicle part cannot be removed.")
							return cb(false)
						end

						if IsPedInAnyVehicle(LocalPlayer.state.ped, false) then
							Notification:Error("Can't Repair Whilst in a Vehicle")
							return cb(false)
						end

						TaskTurnPedToFaceEntity(LocalPlayer.state.ped, target.entity, 1.0)
						Citizen.Wait(750)

						local repairLength = part.time or 25

						Progress:ProgressWithStartAndTick({
							name = "veh_mech_removal",
							duration = repairLength * 1000,
							label = "Removing " .. part.partName .. " Upgrade",
							canCancel = true,
							tickrate = 1000,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								anim = part.anim or "mechanic",
							},
							disarm = true,
						}, function()
							_repairingVehicle = true
						end, function()
							if
								not DoesEntityExist(target.entity)
								or not (
									Vehicles.Utils:IsCloseToRearOfVehicle(target.entity)
									or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)
									or (#(GetEntityCoords(target.entity) - LocalPlayer.state.myPos) <= 5.0)
								)
							then
								Progress:Cancel()
							end
						end, function(wasCancelled)
							_repairingVehicle = false
							if not wasCancelled then
								SetVehicleMod(target.entity, part.partType, -1, false)

								cb(true, VehToNet(target.entity))
								Notification:Success("Part Uninstalled")
							else
								cb(false)
							end
						end)
						return
					end
				end
			end
			cb(false)
		end)
	end)
end)

RegisterNetEvent("Mechanic:Client:ForcePerformanceProperty", function(vehicle, modType, modIndex)
	if NetworkDoesEntityExistWithNetworkId(vehicle) then
		local veh = NetToVeh(vehicle)
		if DoesEntityExist(veh) then
			SetVehicleModKit(veh, 0)

			if type(modIndex) == "boolean" then
				ToggleVehicleMod(veh, modType, modIndex)
			else
				SetVehicleMod(veh, modType, modIndex, false)
			end
		end
	end
end)

_MECHANIC = {
	CanAccessVehicleAsMechanic = function(self, vehicle)
		local vehCoords = GetEntityCoords(vehicle)
		local myDuty = LocalPlayer.state.onDuty
		if myDuty and _mechanicJobs[myDuty] then
			local inMechanicZone, mechanicZone = GetMechanicZoneAtCoords(vehCoords)
			if inMechanicZone and mechanicZone == myDuty then
				return true
			end
		end
		return false
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Mechanic", _MECHANIC)
end)

-- Regular Engine/Body Repair

AddEventHandler("Mechanic:Client:StartRegularRepair", function(entityData)
	if entityData and entityData.entity and DoesEntityExist(entityData.entity) and not _repairingVehicle then
		if GetIsVehicleEngineRunning(entityData.entity) then
			return Notification:Error("Turn Off the Engine")
		end

		if IsPedInAnyVehicle(LocalPlayer.state.ped, false) then
			return Notification:Error("Can't Repair Whilst in a Vehicle")
		end

		TaskTurnPedToFaceEntity(LocalPlayer.state.ped, entityData.entity, 1.0)
		Citizen.Wait(750)

		local repairLength = 20
		Animations.Emotes:Play("mechanic", false, repairLength * 1000, true)
		Progress:ProgressWithStartAndTick({
			name = "veh_mech_repair",
			duration = repairLength * 1000,
			label = "Repairing Vehicle",
			canCancel = true,
			tickrate = 1000,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			disarm = true,
		}, function()
			_repairingVehicle = true
		end, function()
			if
				not DoesEntityExist(entityData.entity)
				or not (
					Vehicles.Utils:IsCloseToRearOfVehicle(entityData.entity)
					or Vehicles.Utils:IsCloseToFrontOfVehicle(entityData.entity)
				)
			then
				Progress:Cancel()
			end
		end, function(wasCancelled)
			_repairingVehicle = false
			Animations.Emotes:ForceCancel()
			if not wasCancelled then
				if Vehicles.Repair:Normal(entityData.entity) then
					Notification:Success("Regular Repair Complete")
				else
					Notification:Error("Regular Repair Failed")
				end
			end
		end)
	end
end)

-- Citizen.CreateThread(function()
--     local fridge = `v_res_fridgemoda`

--     loadModel(fridge)
--     local lol = CreateObject(fridge, -578.07, -911.8, 22.89, false, false)
--     FreezeEntityPosition(lol, true)
--     SetEntityLodDist(lol, 50)
-- end)

function loadModel(model)
	if IsModelInCdimage(model) then
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(5)
		end
	end
end

local partNames = {
	Axle = "Axle",
	Radiator = "Radiator",
	Transmission = "Transmission",
	FuelInjectors = "Fuel Injectors",
	Brakes = "Brakes",
	Clutch = "Clutch",
	Electronics = "Electronics",
}

AddEventHandler("Mechanic:Client:RunDiagnostics", function(entityData)
	if entityData and entityData.entity and DoesEntityExist(entityData.entity) then
		local vehEnt = Entity(entityData.entity)
		local vehDamage = vehEnt.state.DamagedParts
		local vehClass = vehEnt.state.Class

		local requiresHighGradeParts = false
		local requiresTypeShit = "regular"
		if vehClass then
			requiresTypeShit = "hperformance"
			requiresHighGradeParts = _highPerformanceClasses[vehClass]
		end

		local menu = {
			main = {
				label = "Vehicle Diagnostics",
				items = {
					{
						label = "Vehicle Class",
						description = vehEnt.state.Class or "Unknown",
						event = false,
					},
					{
						label = "Vehicle Mileage",
						description = (vehEnt.state.Mileage and Utils:Round(vehEnt.state.Mileage, 2) or 0) .. " Miles",
						event = false,
					},
				},
			},
		}

		if requiresHighGradeParts then
			table.insert(menu.main.items, {
				label = "High Grade Parts",
				description = "This Vehicle Requires High Grade Repair Parts",
				event = false,
			})
		end

		for k, v in pairs(partNames) do
			if vehDamage and vehDamage[k] then
				local partData

				for partId, part in pairs(_mechanicItemsToParts) do
					if
						part.part == k
						and (
							(not requiresHighGradeParts and part.regular)
							or (requiresHighGradeParts and part.hperformance)
						)
					then
						partData = part
						partData.item = partId
					end
				end

				table.insert(menu.main.items, {
					label = v,
					description = Utils:Round(vehDamage[k], 2) .. "%",
					event = false,
				})

				if partData and partData.item then
					local itemCount = Inventory.Items:GetCount(partData.item)
					local itemData = Inventory.Items:GetData(partData.item)
					local percentToFull = 100 - vehDamage[k]
					local requiredToFix = math.ceil(percentToFull / partData.amount)

					if itemData and requiredToFix > 0 then
						table.insert(menu.main.items, {
							label = string.format("Fully Repair %s", v),
							description = string.format(
								"Repair To Full - This Requires %sx %s",
								requiredToFix,
								itemData.label
							),
							event = "Mechanic:Client:InstallMultipleRepairParts",
							disabled = (requiredToFix > itemCount),
							data = {
								part = partData.item,
								quantity = requiredToFix,
							},
						})
					end
				end
			else
				table.insert(menu.main.items, {
					label = v,
					description = "100%",
					event = false,
				})
			end
		end

		ListMenu:Show(menu)
	end
end)

AddEventHandler("Mechanic:Client:InstallMultipleRepairParts", function(data)
	Callbacks:ServerCallback("Mechanic:InstallMultipleRepairParts", data, function(success)
		if not success then
			Notification:Error("Unable to Install Multiple Parts")
		end
	end)
end)

AddEventHandler("Mechanic:Client:RemovePerformanceUpgrade", function(data)
	Callbacks:ServerCallback("Mechanic:RemovePerformanceUpgrade", data, function(success)
		if not success then
			Notification:Error("Unable to Remove Upgrade")
		end
	end)
end)

function GetVehicleUpgradeLabel(level)
	if level == -1 then
		return "Stock"
	end

	return "Level " .. (level + 1)
end

local modShit = {
	[11] = "Engine",
	[13] = "Transmission",
	[12] = "Brakes",
	[15] = "Suspension",
}

AddEventHandler("Mechanic:Client:RunPerformanceDiagnostics", function(entityData)
	if entityData and entityData.entity and DoesEntityExist(entityData.entity) then
		SetVehicleModKit(entityData.entity, 0)
		local vehEnt = Entity(entityData.entity)

		local menu = {
			main = {
				label = "Vehicle Performance Parts",
				items = {},
			},
		}

		for k, v in pairs(modShit) do
			local upgradeSub = "upgrade-" .. k
			table.insert(menu.main.items, {
				label = v,
				description = GetVehicleUpgradeLabel(GetVehicleMod(entityData.entity, k)),
				submenu = upgradeSub,
				event = false,
			})
			local subItems = {}
			if GetVehicleMod(entityData.entity, k) ~= -1 then
				table.insert(subItems, {
					label = string.format("Remove %s", v),
					description = string.format(
						"Remove %s Upgrade",
						GetVehicleUpgradeLabel(GetVehicleMod(entityData.entity, k))
					),
					event = "Mechanic:Client:RemovePerformanceUpgrade",
					data = {
						partType = k,
						partName = v,
					},
				})
			else
				table.insert(subItems, {
					label = string.format("Remove %s", v),
					description = string.format("%s has no upgrades.", v),
				})
			end
			menu[upgradeSub] = {
				label = v,
				items = subItems,
			}
		end

		table.insert(menu.main.items, {
			label = "Turbo",
			description = IsToggleModOn(entityData.entity, 18) and "Yes" or "No",
			event = false,
		})

		ListMenu:Show(menu)
	end
end)

_placedProps = {}

AddEventHandler("Objects:Shared:DependencyUpdate", RetrieveObjectsComponents)
function RetrieveObjectsComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	ObjectPlacer = exports["sandbox-base"]:FetchComponent("ObjectPlacer")
	Objects = exports["sandbox-base"]:FetchComponent("Objects")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Objects", {
		"Callbacks",
		"Notification",
		"Targeting",
		"Inventory",
		"ObjectPlacer",
		"Objects",
	}, function(error)
		if #error > 0 then
			exports["sandbox-base"]:FetchComponent("Logger"):Critical("Objects", "Failed To Load All Dependencies")
			return
		end
		RetrieveObjectsComponents()

		Callbacks:RegisterClientCallback("Objects:StartPlacement", function(data, cb)
			ObjectPlacer:Start(data.model, "Objects:Client:FinishPlacement", data.data, true, nil, true)
			cb()
		end)
	end)
end)

AddEventHandler("Objects:Client:FinishPlacement", function(data, endCoords)
	TriggerServerEvent("Objects:Server:Create", data, endCoords)
end)

RegisterNetEvent("Objects:Client:SetupObjects", function(objs)
	for k, v in pairs(objs) do
		Objects:Create(k, v.type, v.creator, v.model, v.coords, v.heading, v.rotation, v.isFrozen, v.nameOverride)
	end
end)

RegisterNetEvent("Characters:Client:Logout", function()
	for k, v in pairs(_placedProps) do
		Objects:Delete(k)
	end
end)

RegisterNetEvent("Objects:Client:Create", function(id, type, creator, model, coords, heading, rotation, isFrozen, nameOverride)
	Objects:Create(id, type, creator, model, coords, heading, rotation, isFrozen, nameOverride)
end)

RegisterNetEvent("Objects:Client:Delete", function(id)
	Objects:Delete(id)
end)

_OBJECTS = {
	Create = function(self, id, type, creator, model, coords, heading, rotation, isFrozen, nameOverride)
		loadModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)

		if rotation and rotation.x then
			SetEntityRotation(obj, rotation.x, rotation.y, rotation.z)
		elseif heading then
			SetEntityHeading(obj, heading + 0.0)
		end

		FreezeEntityPosition(obj, isFrozen)
		while not DoesEntityExist(obj) do
			Citizen.Wait(1)
		end

		local entState = Entity(obj).state
		entState.isPlacedProp = true
		entState.objectId = id

		_placedProps[id] = {
			id = id,
			type = type,
			creator = creator,
			entity = obj,
			model = model,
			coords = coords,
			heading = heading,
			rotation = rotation,
			isFrozen = isFrozen,
			nameOverride = nameOverride,
		}

		Targeting:AddEntity(obj, "draw-square", {
			{
				icon = "eye",
				text = "Open",
				event = "Objects:Client:OpenInventory",
				data = {
					id = id,
					type = type,
					creator = creator,
					entity = obj,
					model = model,
					coords = coords,
					heading = heading,
					rotation = rotation,
					isFrozen = isFrozen,
					nameOverride = nameOverride,
				},
				isEnabled = function(data, entity)
					local eState = Entity(entity.entity).state
					return eState.isPlacedProp and _placedProps[entState.objectId].type == 1
				end,
			},
			{
				icon = "trash",
				text = "Delete Object",
				event = "Objects:Client:DeleteObject",
				data = {
					id = id,
					type = type,
					creator = creator,
					entity = obj,
					model = model,
					coords = coords,
					heading = heading,
					rotation = rotation,
					isFrozen = isFrozen,
					nameOverride = nameOverride,
				},
				isEnabled = function(data, entity)
					local eState = Entity(entity.entity).state
					return eState.isPlacedProp
						and (LocalPlayer.state.IsStaff or LocalPlayer.state.isAdmin or LocalPlayer.state.Character:GetData(
							"SID"
						) == _placedProps[entState.objectId].creator)
						and _placedProps[entState.objectId].type ~= 2
				end,
			},
			{
				icon = "info",
				text = "View Object Details",
				event = "Objects:Client:ViewData",
				data = {
					id = id,
					type = type,
					creator = creator,
					entity = obj,
					model = model,
					coords = coords,
					heading = heading,
					rotation = rotation,
					isFrozen = isFrozen,
					nameOverride = nameOverride,
				},
				isEnabled = function(data, entity)
					local eState = Entity(entity.entity).state
					return eState.isPlacedProp
						and (LocalPlayer.state.isStaff or LocalPlayer.state.isAdmin)
						and _placedProps[entState.objectId].type ~= 2
				end,
			},
		}, 3.0, true)
	end,
	Delete = function(self, id)
		if _placedProps[id] ~= nil then
			DeleteEntity(_placedProps[id].entity)
			_placedProps[id] = nil
		else
			return false
		end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Objects", _OBJECTS)
end)

AddEventHandler("Objects:Client:DeleteObject", function(entity, data)
	if Entity(entity.entity).state.isPlacedProp then
		TriggerServerEvent("Objects:Server:Delete", Entity(entity.entity).state.objectId)
	end
end)

AddEventHandler("Objects:Client:ViewData", function(entity, data)
	TriggerServerEvent("Objects:Server:View", Entity(entity.entity).state.objectId)
end)

AddEventHandler("Objects:Client:OpenInventory", function(entity, data)
	Inventory.Dumbfuck:Open({
		invType = 138,
		owner = Entity(entity.entity).state.objectId,
	})
end)

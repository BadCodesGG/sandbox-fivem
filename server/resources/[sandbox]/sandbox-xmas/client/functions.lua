function SetupTree(treeData, hasLooted)
	if _existingTree ~= nil then
		DeleteEntity(_existingTree.entity)
		Targeting:RemoveEntity(_existingTree.entity)
		Blips:Remove("xmas_tree")
		_existingTree = nil
	end

	loadModel(treeData.model)

	local obj =
		CreateObject(treeData.model, treeData.location.x, treeData.location.y, treeData.location.z, false, true, true)
	PlaceObjectOnGroundProperly(obj)
	FreezeEntityPosition(obj, true)
	SetCanClimbOnEntity(obj, false)

	Targeting:AddEntity(obj, "tree-christmas", {
		{
			icon = "gift",
			text = "Pickup Gift",
			event = "Xmas:Client:Tree",
			isEnabled = function(data, entity)
				return _existingTree ~= nil and not _existingTree.hasLooted
			end,
		},
	})

	Blips:Add(
		"xmas_tree",
		"Christmas Tree",
		vector3(treeData.location.x, treeData.location.y, treeData.location.z),
		36,
		25,
		0.85
	)

	SetModelAsNoLongerNeeded(treeData.model)

	_existingTree = treeData
	_existingTree.hasLooted = hasLooted
	_existingTree.entity = obj
end

AddEventHandler("Xmas:Client:RegisterStartups", function()
	Interaction:RegisterMenu("pickup-snowball", "Pickup Snowball", "ball-pile", function(data)
		Interaction:Hide()
		SNOWBALLS.Pickup()
	end, function()
		return SNOWBALLS.CanPickup()
	end)
end)

SNOWBALLS = {
	Pickup = function(self)
		Progress:Progress({
			name = "snowball_pickup",
			duration = 5000,
			label = "Making a snowball",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "anim@mp_snowball",
				anim = "pickup_snowball",
				flags = 49,
			},
		}, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("Xmas:Server:PickupSnowball", {}, function(s) end)
			end
		end)
	end,
	CanPickup = function(self)
		return CheckZone()
	end,
}

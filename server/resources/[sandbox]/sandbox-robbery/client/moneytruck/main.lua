_, driverHash = AddRelationshipGroup("BOBCAT_SECURITY_DRIVER")
SetRelationshipBetweenGroups(5, relHash, `PLAYER`)
SetRelationshipBetweenGroups(5, `PLAYER`, relHash)

AddEventHandler("Robbery:Client:Setup", function()
	Callbacks:RegisterClientCallback("Robbery:Moneytruck:CheckForTruck", function(data, cb)
		local startPos = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0, 0.5, 0)
		local endPos = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0, 5.0, 0)
		local rayHandle = StartShapeTestRay(
			startPos.x,
			startPos.y,
			startPos.z,
			endPos.x,
			endPos.y,
			endPos.z,
			-1,
			LocalPlayer.state.ped,
			0
		)
		local rayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
		if hit then
			if GetEntityHealth(entityHit) > 0 then
				local model = GetEntityModel(entityHit)
				if model == `stockade` then
					return cb(1, VehToNet(entityHit))
				elseif model == `stockade2` then
					return cb(2, VehToNet(entityHit))
				end
			end
		end

		return cb(nil)
	end)

	Callbacks:RegisterClientCallback("Robbery:Moneytruck:Thermite:Door", function(data, cb)
		local ent = NetworkGetEntityFromNetworkId(data.vNet)
		NetworkRequestControlOfEntity(ent)
		local truckCoords = GetEntityCoords(ent)
		local thermiteCoords = GetOffsetFromEntityInWorldCoords(ent, 0.0, -3.55, 0.0)
		_memPass = 1
		ThermiteShit(
			{
				x = thermiteCoords.x,
				y = thermiteCoords.y,
				z = thermiteCoords.z + 1.0,
				h = GetEntityHeading(ent),
			},
			data,
			function(success)
				cb(success, GetOffsetFromEntityInWorldCoords(ent, 0.0, -5.0, 0.0))
			end
		)
	end)

	Callbacks:RegisterClientCallback("Robbery:Moneytruck:Spawn:Get", function(data, cb)
		if LocalPlayer.state.loggedIn then
			local randomLoc = FindRandomPointInSpace(LocalPlayer.state.ped)
			local found, loc, heading =
				GetClosestVehicleNodeWithHeading(randomLoc.x, randomLoc.y, randomLoc.z, 12, 3.0, 0)

			if found then
				if #(randomLoc - loc) <= 300 then
					cb(loc, heading)
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterClientCallback("Robbery:MoneyTruck:MarkTruck", function(data, cb)
		local ent = NetworkGetEntityFromNetworkId(data)

		local text = "Bobcat Truck"
		if GetEntityModel(ent) == `stockade` then
			text = "Gruppe 6 Truck"
		end

		if ent ~= 0 then
			local blip = AddBlipForEntity(ent)

			SetBlipSprite(blip, 477)
			SetBlipColour(blip, 69)
			SetBlipScale(blip, 0.85)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(text)
			EndTextCommandSetBlipName(blip)

			Citizen.SetTimeout((1000 * 60) * 10, function()
				RemoveBlip(blip)
			end)

			cb(true)
		else
			cb(false)
		end
	end)
end)

AddEventHandler("Robbery:Client:MoneyTruck:GrabLoot", function(entity, data)
	Callbacks:ServerCallback("Robbery:MoneyTruck:CheckLoot", VehToNet(entity.entity), function(s)
		if s then
			Progress:Progress({
				name = "moneytruck_loot",
				duration = (math.random(15, 30) + 15) * 1000,
				label = "Grabbing Fat Lewts",
				useWhileDead = false,
				canCancel = true,
				ignoreModifier = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					anim = "type",
				},
			}, function(status)
				if not status then
					Callbacks:ServerCallback("Robbery:MoneyTruck:Loot", VehToNet(entity.entity), function(s2) end)
				else
					Callbacks:ServerCallback("Robbery:MoneyTruck:CancelLoot", VehToNet(entity.entity), function(s2) end)
				end
			end)
		end
	end)
end)

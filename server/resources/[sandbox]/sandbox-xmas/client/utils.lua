function loadModel(model)
	RequestModel(model)
	local attempts = 0
	while not HasModelLoaded(model) and attempts < 100 do
		RequestModel(model)
		Citizen.Wait(10)
		attempts += 1
	end

	return HasModelLoaded(model)
end

function GetGroundHash()
	local plantingTargetOffset = vector3(0, 2.0, -3.0)
	local plantingSpaceAbove = vector3(0, 0, 5.0)
	local rayFlagsLocation = 17
	local rayFlagsObstruction = 273
	local ped = PlayerPedId()
	local playerCoord = GetEntityCoords(ped)
	local target = GetOffsetFromEntityInWorldCoords(ped, plantingTargetOffset)
	local testRay = StartExpensiveSynchronousShapeTestLosProbe(playerCoord, target, rayFlagsLocation, ped, 7)
	local _, hit, hitLocation, surfaceNormal, material, _ = GetShapeTestResultIncludingMaterial(testRay)
	return _, hit, hitLocation, surfaceNormal, material
end

local Debug = false

function CheckZone()
	local onGround = false
	local _, hit, hitLocation, surfaceNormal, material = GetGroundHash()
	if hit == 1 then
		if Debug then
			print("Material:", material)
			print("Hit location:", hitLocation)
			print("Surface normal:", surfaceNormal)
		end
		if SoilTypes[material] then
			if Debug then
				print("Soil quality:", SoilTypes[material])
			end
			if flatEnough(surfaceNormal) then
				if Debug then
					print("Flat Enough.")
				end
				onGround = true
			end
		end
	end
	return onGround
end

function flatEnough(surfaceNormal)
	local x = math.abs(surfaceNormal.x)
	local y = math.abs(surfaceNormal.y)
	local z = math.abs(surfaceNormal.z)
	return (x <= 0.6 and y <= 0.6 and z >= 1.0 - 0.6)
end

SoilTypes = {
	[-1595148316] = true, -- snow grass
	-- rest of these should be ok since they detect soil
	[-1942898710] = true, -- usually around grandmas house
	[951832588] = true,
	[2409420175] = true,
	[1187676648] = false, -- cement/sidewalk
	[752131025] = true,
	[282940568] = false, -- possible cement??
	-- [951832588] = 0.5,
	[3008270349] = true,
	[3833216577] = true,
	[223086562] = true,
	[1333033863] = true,
	[4170197704] = true,
	[3594309083] = true,
	[2461440131] = true,
	[1109728704] = true,
	[2352068586] = true,
	[1144315879] = true,
	[581794674] = true,
	[2128369009] = true,
	[-461750719] = true,
	[-1286696947] = true,
}

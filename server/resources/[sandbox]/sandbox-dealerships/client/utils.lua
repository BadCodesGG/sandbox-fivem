function GetClosestAvailableParkingSpace(pedCoords, parkingSpaces)
	table.sort(parkingSpaces, function(a, b)
		local distA = #(a.xyz - pedCoords)
		local distB = #(b.xyz - pedCoords)
		return distA > distB
	end)

	local nearestCoords = false

	for k, v in ipairs(parkingSpaces) do
		if IsParkingSpaceFree(v) then
			nearestCoords = v
		end
	end

	return nearestCoords
end

function IsParkingSpaceFree(spaceCoords)
	return GetClosestVehicleWithinRadius(spaceCoords.xyz, 2.0) == false
end

-- Because the normal one doesn't fucking work
function GetClosestVehicleWithinRadius(coords, radius)
	if not radius then
		radius = 5.0
	end

	local poolVehicles = GetGamePool("CVehicle")
	local lastDist = radius
	local lastVeh = false

	for k, v in ipairs(poolVehicles) do
		if DoesEntityExist(v) then
			local dist = #(coords - GetEntityCoords(v))
			if dist <= lastDist then
				lastDist = dist
				lastVeh = v
			end
		end
	end

	return lastVeh
end

function format_int(number)
	local i, j, minus, int, fraction = tostring(number):find("([-]?)(%d+)([.]?%d*)")

	-- reverse the int-string and append a comma to all blocks of 3 digits
	int = int:reverse():gsub("(%d%d%d)", "%1,")

	-- reverse the int-string back remove an optional comma and put the
	-- optional minus and fractional part back
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

function RegisterMiddleware()
	Middleware:Add("Characters:Creating", function(source, cData)
		return { {
			Apartment = 1,
		} }
	end)

	-- Middleware:Add("Characters:Spawning", function(source)
	-- 	local char = Fetch:CharacterSource(source)
	-- 	if char then
	-- 		GlobalState[string.format("Apartment:Interior:%s", char:GetData("SID"))] = char:GetData("Apartment") or 1
	-- 	end
	-- end, 2)

	Middleware:Add("Characters:GetSpawnPoints", function(source, charId, cData)
		local spawns = {}

		local apt = _aptData[cData.Apartment or 1]
		table.insert(spawns, {
			id = string.format("APT:%s:%s", apt, cData.SID),
			label = apt.name,
			location = apt.interior.wakeup,
			icon = "building",
			event = "Apartment:SpawnInside",
		})

		return spawns
	end, 2)
end

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	if GlobalState[string.format("%s:Apartment", source)] ~= nil then
		GlobalState[string.format("%s:Apartment", source)] = nil
	end
end)

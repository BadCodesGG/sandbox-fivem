local _ATMRobberyCDs = {}

local _robberyTerminal = {
	coords = vector3(699.5, -1261.68, 26.24),
	length = 0.6,
	width = 0.6,
	options = {
		heading = 0,
		--debugPoly=true,
		minZ = 22.44,
		maxZ = 26.64,
	},
}

local _robberyAreas = {
	{
		coords = vector3(-1421.514, -164.651, 47.587),
		radius = 400.0,
		city = true,
	},
	{
		coords = vector3(-236.920, -862.055, 30.423),
		radius = 400.0,
		city = true,
	},
	{
		coords = vector3(-49.921, -1751.744, 29.421),
		radius = 400.0,
		city = true,
	},
	{
		coords = vector3(1099.503, 2687.090, 38.721),
		radius = 400.0,
	},
	{
		coords = vector3(1856.481, 3732.085, 33.137),
		radius = 400.0,
	},
	{
		coords = vector3(1721.703, 6405.138, 37.410),
		radius = 400.0,
	},
	{
		coords = vector3(-303.475, 6231.736, 38.460),
		radius = 400.0,
	},
	{
		coords = vector3(-974.370, -1835.689, 21.205),
		radius = 400.0,
	},
	{
		coords = vector3(-1116.592, 2673.240, 18.349),
		radius = 400.0,
	},
	{
		coords = vector3(202.766, 6616.819, 31.656),
		radius = 400.0,
	},
	{
		coords = vector3(1671.253, 4843.808, 42.052),
		radius = 400.0,
	},
	{
		coords = vector3(3.202, -920.910, 29.530),
		radius = 200.0,
		city = true,
	},
	{
		coords = vector3(3.202, -920.910, 29.530),
		radius = 90.0,
		city = true,
	},
	{
		coords = vector3(-1272.29, -662.39, 15.97),
		radius = 150.0,
		city = true,
	},
	{
		coords = vector3(-1272.29, -662.39, 15.97),
		radius = 150.0,
		city = true,
	},
	{
		coords = vector3(-260.337, 173.989, 88.353),
		radius = 400.0,
		city = true,
	},
}

local _maxRobberies = 15
local _atmLoot = {
	{ 85, { name = "moneyroll", min = 10, max = 20 } },
	{ 15, { name = "moneyband", min = 1, max = 3 } },
}

local _atmLootHigh = {
	{ 80, { name = "moneyroll", min = 15, max = 25 } },
	{ 20, { name = "moneyband", min = 1, max = 4 } },
}

AddEventHandler("Robbery:Server:Setup", function()
	GlobalState["ATMRobberyTerminal"] = _robberyTerminal
	GlobalState["ATMRobberyAreas"] = _robberyAreas

	Reputation:Create("ATMRobbery", "ATM Hacking", {
		{ label = "Newbie", value = 1000 },
		{ label = "Okay", value = 2000 },
		{ label = "Good", value = 4000 },
		{ label = "Pro", value = 10000 },
		{ label = "Expert", value = 16000 },
		{ label = "God", value = 25000 },
	}, false)

	Callbacks:RegisterServerCallback("Robbery:ATM:StartJob", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local inATM = Player(source).state.ATMRobbery

		if
			char and (not inATM or inATM <= 0) and not GlobalState["ATMRobberyStartCD"]
			or (os.time() > GlobalState["ATMRobberyStartCD"]) and GlobalState["Sync:IsNight"]
		then
			if GlobalState["RobberiesDisabled"] then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Temporarily Disabled, Please See City Announcements",
					6000
				)
				return
			end
			if data then
				local personalMax = GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] or 0
				if personalMax < _maxRobberies then
					Player(source).state.ATMRobbery = math.random(4, 6)
					GlobalState["ATMRobberyStartCD"] = os.time() + (60 * math.random(2, 5)) -- Cooldown

					local repLvl = Reputation:GetLevel(source, "ATMRobbery")

					local location = GetNewATMLocation(repLvl)
					Player(source).state.ATMRobberyZone = location.id

					cb(true, location)
				else
					cb(false, true)
				end
			else
				GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] = 10
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:ATM:HackATM", function(source, difficulty, cb)
		local char = Fetch:CharacterSource(source)
		local inATM = Player(source).state.ATMRobbery

		if
			char and inATM and inATM > 0 and not _ATMRobberyCDs[char:GetData("SID")]
			or (os.time() > _ATMRobberyCDs[char:GetData("SID")])
		then
			if GlobalState["RobberiesDisabled"] then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Temporarily Disabled, Please See City Announcements",
					6000
				)
				return
			end
			local newATMRobbery = inATM - 1
			Player(source).state.ATMRobbery = newATMRobbery
			_ATMRobberyCDs[char:GetData("SID")] = os.time() + 60

			local personalMax = GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] or 0
			GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] = personalMax + 1

			Reputation.Modify:Add(source, "ATMRobbery", 100)

			local repLvl = Reputation:GetLevel(source, "ATMRobbery")

			if repLvl >= 4 then
				Loot:CustomWeightedSetWithCount(_atmLootHigh, char:GetData("SID"), 1)
			else
				Loot:CustomWeightedSetWithCount(_atmLoot, char:GetData("SID"), 1)
			end

			local chance = 15
			if repLvl >= 4 then
				chance = 22
			end
			if math.random(100) < chance and repLvl >= 2 then
				Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
					CryptoCoin = "HEIST",
					Quantity = math.random(2, repLvl + 1),
				}, 1)
			end

			local reward = math.floor((difficulty or 5) * 100 / 4)
			Wallet:Modify(source, (math.random(150) + reward))

			if newATMRobbery > 0 then
				local location = GetNewATMLocation(repLvl, Player(source).state.ATMRobberyZone)
				Player(source).state.ATMRobberyZone = location.id

				cb(true, location)
			else
				cb(true, false)
			end

			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:ATM:FailHackATM", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local inATM = Player(source).state.ATMRobbery

		if char and inATM and inATM > 0 then
			Player(source).state.ATMRobbery = false

			if not data.alarm then
				Robbery:TriggerPDAlert(source, data.coords, "10-90", "ATM Robbery", {
					icon = 521,
					size = 0.9,
					color = 31,
					duration = (60 * 5),
				})
			end

			local personalMax = GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] or 0
			GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] = personalMax + 1

			Reputation.Modify:Remove(source, "ATMRobbery", 65)

			cb(true)
		else
			cb(false)
		end
	end)

	Middleware:Add("Characters:Spawning", function(source)
		Player(source).state.ATMRobbery = false
	end, 10)
end)

function GetNewATMLocation(repLvl, lastZoneId)
	local availableLocations = {}

	for k, v in ipairs(_robberyAreas) do
		v.id = k

		if repLvl >= 3 or v.city and v.id ~= lastZoneId then
			table.insert(availableLocations, v)
		end
	end

	local randLocation = availableLocations[math.random(#availableLocations)]
	return randLocation
end

RegisterNetEvent("Robbery:Server:ATM:AlertPolice", function(coords)
	local src = source
	Robbery:TriggerPDAlert(src, coords, "10-90", "ATM Robbery", {
		icon = 521,
		size = 0.9,
		color = 31,
		duration = (60 * 5),
	})
end)

local objects = {}

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source)
	Player(source).state.SignRobbery = false
end)
AddEventHandler("Characters:Server:PlayerDropped", PaletoClearSourceInUse)

AddEventHandler("Robbery:Server:Setup", function()
	Reputation:Create("SignRobbery", "Sign Robbery", {
		{ label = "Newbie", value = 1000 },
		{ label = "Okay", value = 2000 },
		{ label = "Good", value = 4000 },
		{ label = "Pro", value = 10000 },
		{ label = "Expert", value = 16000 },
		{ label = "God", value = 25000 },
		{ label = "Pls Stop", value = 35000 },
	}, false)

	Middleware:Add("Characters:Spawning", function(source)
		TriggerLatentClientEvent("Robbery:Signs:GetObjects", source, 50000, objects)
	end)

	Callbacks:RegisterServerCallback("Robbery:Signs:RemoveSign", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local atSign = Player(source).state.SignRobbery
		if char and not atSign then
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

			local sourceCoords = GetEntityCoords(GetPlayerPed(source))
			if #(sourceCoords - data.coords) < 4 then
				Player(source).state.SignRobbery = true
				objects[#objects + 1] = { coords = data.coords, model = data.model }
				TriggerClientEvent("Robbery:Client:DeleteSign", -1, data)
				Inventory:AddItem(char:GetData("SID"), data.item, 1, {}, 1)
				Reputation.Modify:Add(source, "SignRobbery", math.random(35, 75))
				Player(source).state.SignRobbery = false
				cb(true)
				return
			end
			cb(false)
		else
			cb(false)
		end
	end)
end)

RegisterNetEvent("Robbery:Server:Signs:AlertPolice", function(coords)
	local src = source
	Robbery:TriggerPDAlert(src, coords, "10-90", "Street Sign Robbery", {
		icon = 652,
		size = 0.9,
		color = 1,
		duration = (60 * 5),
	})
end)

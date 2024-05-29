PHONE.Chopper = PHONE.Chopper or {}

local marketItems = {
	{
		item = "chopping_invite",
		coin = "MALD",
		price = 600,
		vpn = true,
		ep = "Chopping",
		repLvl = 3,
		limited = {
			id = 1,
			qty = 1,
		},
	},
}

local _blacklistedJobs = {
	police = true,
	ems = true,
	government = true,
}

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Vendor:Create("ChoperItems", "ped", "Items", `U_M_Y_SmugMech_01`, {
		coords = vector3(-623.589, -1681.736, 19.101),
		heading = 228.222,
		scenario = "WORLD_HUMAN_TOURIST_MOBILE",
	}, marketItems, "badge-dollar", "View Offers", false, false, true)

	Inventory.Items:RegisterUse("chopping_invite", "LSUNDG", function(source, item, itemData)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local pState = Player(source).state
			if not pState.onDuty or not _blacklistedJobs[pState.onDuty] then
				if not hasValue(char:GetData("States") or {}, "ACCESS_CHOPPER") then
					if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
						local states = char:GetData("States") or {}
						table.insert(states, "ACCESS_CHOPPER")
						char:SetData("States", states)

						char:SetData("Apps", Phone.Store.Install:Do("chopper", char:GetData("Apps"), "force"))

						Citizen.SetTimeout(5000, function()
							Phone.Notification:Add(source, "App Installed", nil, os.time(), 6000, "chopper", {
								view = "",
							}, nil)
						end)
					end
				else
					Execute:Client(source, "Notification", "Error", "You already have access to that app")
				end
			else
				Execute:Client(source, "Notification", "Error", "You Can't Use This Item")
			end
		end
	end)
end)
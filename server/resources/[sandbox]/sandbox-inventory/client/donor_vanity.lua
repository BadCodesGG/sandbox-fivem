function CreateDonorVanityItems()
	for k, v in ipairs(_donorVanitys) do
		PedInteraction:Add("donor_vanity_" .. k, v.ped.model, v.ped.location.xyz, v.ped.location.w, 50.0, {
			{
				icon = "boxes-stacked",
				text = "Donator Item Purchases",
				event = "DonorVanity:Client:Open",
			},
			{
				icon = "receipt",
				text = "View Unredeemed Purchases",
				event = "DonorVanity:Client:ViewPending",
			},
		}, "comment-dollar", v.ped.scenario)
	end
end

AddEventHandler("DonorVanity:Client:ViewPending", function(entityData, data)
	Callbacks:ServerCallback("Inventory:DonorSales:GetPending", {}, function(menu)
		ListMenu:Show(menu)
	end)
end)

AddEventHandler("DonorVanity:Client:Open", function(entityData, data)
	Callbacks:ServerCallback("Inventory:DonorSales:GetTokens", {}, function(data)
		if not data or data.available == 0 then
			return Notification:Error("No Pending Donator Purchases to Redeem")
		end

		GenerateNewVanityItem()
	end)
end)

AddEventHandler("DonorVanity:Client:SubmitInput", function(data)
	Callbacks:ServerCallback("Inventory:DonorSales:SubmitVanityItem", data, function() end)
end)

AddEventHandler("DonorDealer:Client:StartPurchase", function(data)
	Confirm:Show(
		"Confirm Donator Vehicle Purchase",
		{
			yes = "DonorDealer:Client:ConfirmPurchase",
			no = "",
		},
		string.format(
			[[
		Are you sure that you want to buy this vehicle, you will not be able to use your donator vehicle purchase on another character once you confirm this purchase.<br>
		Vehicle: %s %s<br>
		Class: %s<br>
	]],
			data.make or "Unknown",
			data.model or "Unknown",
			data.class or "?"
		),
		data,
		"Deny",
		"Confirm"
	)
end)

AddEventHandler("DonorDealer:Client:ConfirmPurchase", function(data)
	Callbacks:ServerCallback("Dealerships:DonorSales:Purchase", data)
end)

local vanityPromise
function GenerateNewVanityItem()
	vanityPromise = promise.new()
	Input:Show("New Vanity Item", "Vanity Item", {
		{
			id = "vanity_item_label",
			type = "text",
			options = {
				inputProps = {
					pattern = "([ a-zA-Z])+",
					maxlength = 24,
				},
				label = "Item Label",
				helperText = "Vanity label cannot include numbers and must include at least 3 characters.",
			},
		},
		{
			id = "vanity_item_image",
			type = "text",
			options = {
				inputProps = {
					pattern = [[((https?:\/\/(www\.)?(cdn\.discordapp\.com\/attachments\/[a-zA-Z\d]+\/[a-zA-z0-9_-]+)?)((i\.)?imgur\.com)?\/[a-zA-z0-9-_]+(\.png|\.jpg|\.jpeg|\.gif)?)]],
					maxlength = 240,
				},
				label = "Item Image URL",
				helperText = "Images must end in jpg, jpeg, png, or gif. Use imgur or discordapp for uploads. Max Length: 100",
			},
		},
		{
			id = "vanity_item_amount",
			type = "number",
			options = {
				inputProps = {
					defaultValue = "1",
					min = 1,
					max = 20,
				},
				label = "Item Amount",
				helperText = "Min: 1, Max: 20; MAKE SURE THERES ROOM 1 ITEM PER SLOT",
			},
		},
		{
			id = "vanity_item_description",
			type = "text",
			options = {
				inputProps = {
					pattern = "([ a-zA-Z0-9!$%./&,-])+",
					maxlength = 100,
				},
				label = "Item Description",
				helperText = "Description of item when hovered over. Max Length: 100",
			},
		},
		{
			id = "vanity_item_action",
			type = "select",
			select = {
				{
					label = "No action",
					value = "no_action",
				},
				{
					label = "Self-Flashing",
					value = "overlay",
				},
				{
					label = "Vicinity Flash",
					value = "overlayall",
				},
			},
			options = {
				label = "Item Action",
				inputProps = {
					defaultValue = "no_action",
				},
			},
		},
	}, "DonorVanity:Client:SubmitInput", {})

	return Citizen.Await(vanityPromise)
end

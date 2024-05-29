local _sellers = {
	{
		coords = vector3(182.720, 2790.476, 44.612),
		heading = 7.687,
		model = `S_M_M_DockWork_01`,
	},
}

AddEventHandler("Businesses:Client:Startup", function()
	for k, v in ipairs(_sellers) do
		PedInteraction:Add(string.format("GarconPawn%s", k), v.model, v.coords, v.heading, 25.0, {
			{
				icon = "ring",
				text = "Sell Pawn Goods",
				event = "GarconPawn:Client:Sell",
				jobPerms = {
					{
						job = "garcon_pawn",
					},
				},
			},
		}, "sack-dollar")
	end
end)

AddEventHandler("GarconPawn:Client:Sell", function(e, data)
	Callbacks:ServerCallback("GarconPawn:Sell", {})
end)

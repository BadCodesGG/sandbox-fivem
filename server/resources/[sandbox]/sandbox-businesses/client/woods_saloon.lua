AddEventHandler("Businesses:Client:Startup", function()
	Targeting.Zones:AddBox("woods-saloon-clockinoff", "chess-clock", vector3(-307.4, 6268.38, 31.53), 1, 1, {
		heading = 314,
		--debugPoly=true,
		minZ = 31.48,
		maxZ = 32.28,
	}, GetBusinessClockInMenu("woods_saloon"), 3.0, true)

	Targeting.Zones:AddBox("woods-saloon-clockinoff2", "chess-clock", vector3(-302.77, 6272.48, 31.53), 1, 1, {
		heading = 313,
		--debugPoly=true,
		minZ = 31.48,
		maxZ = 32.28,
	}, GetBusinessClockInMenu("woods_saloon"), 3.0, true)
end)

AddEventHandler("Businesses:Client:Startup", function()
	Polyzone.Create:Box("burgershot_drivethru", vector3(-1196.14, -909.33, 13.77), 7.2, 7.6, {
		heading = 348,
		--debugPoly=true,
		minZ = 12.57,
		maxZ = 15.97,
	})
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if id == "burgershot_drivethru" then
		Sounds.Play:Distance(25, "bell.ogg", 0.3)
	end
end)

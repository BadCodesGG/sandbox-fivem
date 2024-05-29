AddEventHandler("Killzones:Client:Setup", function()
	Polyzone.Create:Box("prison_killzone_fence_1", vector3(1761.75, 2524.87, 45.57), 8.2, 3.0, {
		heading = 345,
		--debugPoly=true,
		minZ = 44.57,
		maxZ = 54.37,
	}, {
		isDeath = true,
		tpCoords = vector3(1757.761, 2525.792, 45.565),
	})
	Polyzone.Create:Box("prison_killzone_fence_2", vector3(1730.66, 2507.08, 45.56), 8.2, 3.0, {
		heading = 256,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1731.299, 2510.764, 45.565),
	})
	Polyzone.Create:Box("prison_killzone_fence_3", vector3(1710.79, 2485.71, 45.56), 8.2, 3.0, {
		heading = 314,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1707.870, 2488.629, 45.565),
	})
	Polyzone.Create:Box("prison_killzone_fence_4", vector3(1675.15, 2485.74, 45.56), 8.2, 3.0, {
		heading = 44,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1678.120, 2489.158, 45.565),
	})
	Polyzone.Create:Box("prison_killzone_fence_5", vector3(1649.66, 2491.96, 45.56), 8.2, 3.0, {
		heading = 94,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1649.240, 2496.237, 45.565),
	})

	Polyzone.Create:Box("prison_killzone_fence_6", vector3(1622.43, 2514.86, 45.56), 8.2, 3.0, {
		heading = 7,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1627.735, 2515.517, 45.565),
	})

	Polyzone.Create:Box("prison_killzone_fence_7", vector3(1614.5, 2535.89, 45.56), 8.2, 3.0, {
		heading = 43,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1617.467, 2539.075, 45.565),
	})

	Polyzone.Create:Box("prison_killzone_fence_8", vector3(1614.46, 2571.52, 45.56), 8.2, 3.0, {
		heading = 318,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1617.471, 2568.884, 45.565),
	})

	Polyzone.Create:Box("prison_killzone_fence_9", vector3(1677.29, 2564.75, 45.56), 8.2, 3.0, {
		heading = 273,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1676.934, 2560.494, 45.565),
	})

	Polyzone.Create:Box("prison_killzone_fence_10", vector3(1704.51, 2564.52, 45.56), 8.2, 3.0, {
		heading = 270,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1704.694, 2561.117, 45.565),
	})

	Polyzone.Create:Box("prison_killzone_fence_11", vector3(1740.19, 2562.24, 45.57), 8.2, 3.0, {
		heading = 270,
		--debugPoly=true,
		minZ = 44.56,
		maxZ = 54.36,
	}, {
		isDeath = true,
		tpCoords = vector3(1740.336, 2558.793, 45.565),
	})
end)

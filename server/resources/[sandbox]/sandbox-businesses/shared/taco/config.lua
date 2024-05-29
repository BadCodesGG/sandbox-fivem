_tacoConfig = {
	dropOffInfo = {
		id = "",
		name = "Delivery Location",
		coords = nil,
		sprite = 501,
		colour = 0,
		scale = 0.8,
		zoneId = "",
	},
	tacoPricing = {
		[0] = 30,
		[1] = 40,
		[2] = 50,
		[3] = 60,
		[4] = 70,
		[5] = 80,
		[6] = 90,
	},
	storage = {
		{
			id = "taco_shop-storage-1",
			type = "box",
			coords = vector3(8.0, -1603.23, 29.38),
			length = 1.8,
			width = 1.6,
			options = {
				heading = 320,
				--debugPoly=true,
				minZ = 26.58,
				maxZ = 30.58,
			},
			data = {
				inventory = {
					invType = 995,
					owner = "taco_shop-storage-1",
				},
			},
		},
	},
	sharedPickup = {
		{
			coords = vector3(14.91, -1601.54, 29.38),
			length = 4.3,
			width = 0.7,
			options = {
				heading = 320,
				--debugPoly=true,
				minZ = 25.78,
				maxZ = 29.88,
			},
			data = {
				inventory = {
					invType = 997,
					owner = "taco_shop-pickup-1",
				},
			},
			driveThru = false,
		},
		{
			coords = vector3(15.08, -1596.2, 29.38),
			length = 0.8,
			width = 1.2,
			options = {
				heading = 320,
				--debugPoly=true,
				minZ = 29.48,
				maxZ = 30.68,
			},
			data = {
				inventory = {
					invType = 998,
					owner = "taco_shop-pickup-2",
				},
			},
			driveThru = true,
		},
	},
}

_tacoPickUp = {
	coords = vector3(11.1, -1605.86, 29.4),
	length = 2.5,
	width = 0.8,
	options = {
		heading = 320,
		--debugPoly=true,
		minZ = 27.2,
		maxZ = 31.3,
	},
}

_tacoQueue = {
	coords = vector3(9.66, -1604.68, 29.38),
	length = 2.5,
	width = 0.8,
	options = {
		heading = 320,
		--debugPoly=true,
		minZ = 27.18,
		maxZ = 31.28,
	},
	maxQueue = 5,
}

_tacoFoodItems = {
	[1] = {
		item = "jugo",
		label = "Jugo Fruit Punch",
	},
	[2] = {
		item = "taco_soda",
		label = "Southside Soda",
	},
	[3] = {
		item = "beef_taco",
		label = "Beef Taco",
	},
	[4] = {
		item = "tostada",
		label = "Tostada",
	},
	[5] = {
		item = "quesadilla",
		label = "Quesadilla",
	},
	[6] = {
		item = "burrito",
		label = "Burrito",
	},
	[7] = {
		item = "enchilada",
		label = "Enchilada",
	},
	[8] = {
		item = "carne_asada",
		label = "Carne Asada",
	},
	[9] = {
		item = "torta",
		label = "Torta",
	},
}

_tacoDropOffs = {

	{
		coords = vector3(-35.81, -1555.26, 30.68),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-1",
			heading = 320,
			--debugPoly=true,
			minZ = 28.08,
			maxZ = 32.08,
		},
	},

	{
		coords = vector3(-44.55, -1547.15, 30.69),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-2",
			heading = 230,
			--debugPoly=true,
			minZ = 30.49,
			maxZ = 32.89,
		},
	},

	{
		coords = vector3(-36.01, -1537.0, 30.69),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-3",
			heading = 230,
			--debugPoly=true,
			minZ = 30.49,
			maxZ = 32.89,
		},
	},

	{
		coords = vector3(-26.61, -1544.25, 30.68),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-4",
			heading = 140,
			--debugPoly=true,
			minZ = 29.68,
			maxZ = 32.08,
		},
	},

	{
		coords = vector3(-19.65, -1550.76, 30.68),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-5",
			heading = 50,
			--debugPoly=true,
			minZ = 29.68,
			maxZ = 32.08,
		},
	},

	{
		coords = vector3(-24.76, -1556.88, 30.69),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-6",
			heading = 50,
			--debugPoly=true,
			minZ = 29.69,
			maxZ = 32.09,
		},
	},

	{
		coords = vector3(-33.5, -1567.26, 33.02),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-7",
			heading = 50,
			--debugPoly=true,
			minZ = 32.02,
			maxZ = 34.42,
		},
	},

	{
		coords = vector3(-35.79, -1555.22, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-8",
			heading = 320,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-44.58, -1547.15, 34.62),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-9",
			heading = 230,
			--debugPoly=true,
			minZ = 33.62,
			maxZ = 36.02,
		},
	},

	{
		coords = vector3(-36.07, -1537.02, 34.62),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-10",
			heading = 230,
			--debugPoly=true,
			minZ = 33.62,
			maxZ = 36.02,
		},
	},

	{
		coords = vector3(-26.57, -1544.24, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-11",
			heading = 140,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-14.0, -1544.12, 33.02),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-12",
			heading = 50,
			--debugPoly=true,
			minZ = 32.02,
			maxZ = 34.42,
		},
	},

	{
		coords = vector3(-19.69, -1550.74, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-13",
			heading = 50,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-77.66, -1515.18, 34.25),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-14",
			heading = 50,
			--debugPoly=true,
			minZ = 33.25,
			maxZ = 35.65,
		},
	},

	{
		coords = vector3(-71.76, -1508.15, 33.44),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-15",
			heading = 50,
			--debugPoly=true,
			minZ = 32.44,
			maxZ = 34.84,
		},
	},

	{
		coords = vector3(-65.13, -1512.91, 33.44),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-16",
			heading = 320,
			--debugPoly=true,
			minZ = 32.44,
			maxZ = 34.84,
		},
	},

	{
		coords = vector3(-60.05, -1517.22, 33.45),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-17",
			heading = 320,
			--debugPoly=true,
			minZ = 32.45,
			maxZ = 34.85,
		},
	},

	{
		coords = vector3(-53.28, -1523.64, 33.44),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-18",
			heading = 230,
			--debugPoly=true,
			minZ = 32.44,
			maxZ = 34.84,
		},
	},

	{
		coords = vector3(-59.17, -1530.7, 34.24),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-19",
			heading = 230,
			--debugPoly=true,
			minZ = 33.24,
			maxZ = 35.64,
		},
	},

	{
		coords = vector3(-62.26, -1532.55, 34.24),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-20",
			heading = 140,
			--debugPoly=true,
			minZ = 33.24,
			maxZ = 35.64,
		},
	},

	{
		coords = vector3(-69.29, -1526.67, 34.25),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-21",
			heading = 140,
			--debugPoly=true,
			minZ = 33.25,
			maxZ = 35.65,
		},
	},

	{
		coords = vector3(-62.32, -1532.66, 37.42),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-22",
			heading = 140,
			--debugPoly=true,
			minZ = 36.42,
			maxZ = 38.82,
		},
	},

	{
		coords = vector3(-59.09, -1530.78, 37.42),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-23",
			heading = 50,
			--debugPoly=true,
			minZ = 36.42,
			maxZ = 38.82,
		},
	},

	{
		coords = vector3(-53.21, -1523.71, 36.62),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-24",
			heading = 50,
			--debugPoly=true,
			minZ = 35.62,
			maxZ = 38.02,
		},
	},

	{
		coords = vector3(-59.94, -1517.09, 36.62),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-25",
			heading = 320,
			--debugPoly=true,
			minZ = 35.62,
			maxZ = 38.02,
		},
	},

	{
		coords = vector3(-65.18, -1512.96, 36.62),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-26",
			heading = 320,
			--debugPoly=true,
			minZ = 35.62,
			maxZ = 38.02,
		},
	},

	{
		coords = vector3(-71.87, -1508.07, 36.62),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-27",
			heading = 230,
			--debugPoly=true,
			minZ = 35.62,
			maxZ = 38.02,
		},
	},

	{
		coords = vector3(-77.7, -1515.19, 37.42),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-28",
			heading = 230,
			--debugPoly=true,
			minZ = 36.42,
			maxZ = 38.82,
		},
	},

	{
		coords = vector3(-93.6, -1607.2, 32.31),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-29",
			heading = 230,
			--debugPoly=true,
			minZ = 31.31,
			maxZ = 33.71,
		},
	},

	{
		coords = vector3(-87.89, -1601.41, 32.31),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-30",
			heading = 140,
			--debugPoly=true,
			minZ = 31.31,
			maxZ = 33.71,
		},
	},

	{
		coords = vector3(-80.19, -1607.79, 31.48),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-31",
			heading = 140,
			--debugPoly=true,
			minZ = 30.48,
			maxZ = 32.88,
		},
	},

	{
		coords = vector3(-83.57, -1623.02, 31.48),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-32",
			heading = 50,
			--debugPoly=true,
			minZ = 30.48,
			maxZ = 32.88,
		},
	},

	{
		coords = vector3(-89.46, -1629.97, 31.51),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-33",
			heading = 50,
			--debugPoly=true,
			minZ = 30.51,
			maxZ = 32.91,
		},
	},

	{
		coords = vector3(-97.1, -1639.11, 32.1),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-34",
			heading = 50,
			--debugPoly=true,
			minZ = 31.1,
			maxZ = 33.5,
		},
	},

	{
		coords = vector3(-105.52, -1632.64, 32.91),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-35",
			heading = 320,
			--debugPoly=true,
			minZ = 31.91,
			maxZ = 34.31,
		},
	},

	{
		coords = vector3(-109.79, -1628.45, 32.91),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-36",
			heading = 230,
			--debugPoly=true,
			minZ = 31.91,
			maxZ = 34.31,
		},
	},

	{
		coords = vector3(-97.92, -1612.26, 32.31),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-37",
			heading = 230,
			--debugPoly=true,
			minZ = 31.31,
			maxZ = 33.71,
		},
	},

	{
		coords = vector3(-109.73, -1628.43, 36.29),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-38",
			heading = 230,
			--debugPoly=true,
			minZ = 35.29,
			maxZ = 37.69,
		},
	},

	{
		coords = vector3(-105.62, -1632.7, 36.29),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-39",
			heading = 140,
			--debugPoly=true,
			minZ = 35.29,
			maxZ = 37.69,
		},
	},

	{
		coords = vector3(-98.08, -1638.93, 35.49),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-40",
			heading = 140,
			--debugPoly=true,
			minZ = 34.49,
			maxZ = 36.89,
		},
	},

	{
		coords = vector3(-96.92, -1639.19, 35.49),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-41",
			heading = 50,
			--debugPoly=true,
			minZ = 34.49,
			maxZ = 36.89,
		},
	},

	{
		coords = vector3(-89.44, -1630.05, 34.69),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-42",
			heading = 50,
			--debugPoly=true,
			minZ = 33.69,
			maxZ = 36.09,
		},
	},

	{
		coords = vector3(-83.62, -1622.96, 34.69),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-43",
			heading = 50,
			--debugPoly=true,
			minZ = 33.69,
			maxZ = 36.09,
		},
	},

	{
		coords = vector3(-80.24, -1607.77, 34.69),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-44",
			heading = 320,
			--debugPoly=true,
			minZ = 33.69,
			maxZ = 36.09,
		},
	},

	{
		coords = vector3(-87.79, -1601.24, 35.49),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-45",
			heading = 320,
			--debugPoly=true,
			minZ = 34.49,
			maxZ = 36.89,
		},
	},

	{
		coords = vector3(-93.61, -1607.24, 35.49),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-46",
			heading = 230,
			--debugPoly=true,
			minZ = 34.49,
			maxZ = 36.89,
		},
	},

	{
		coords = vector3(-97.9, -1612.3, 35.49),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-47",
			heading = 230,
			--debugPoly=true,
			minZ = 34.49,
			maxZ = 36.89,
		},
	},

	{
		coords = vector3(-118.76, -1586.12, 34.22),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-48",
			heading = 230,
			--debugPoly=true,
			minZ = 33.22,
			maxZ = 35.62,
		},
	},

	{
		coords = vector3(-114.05, -1579.49, 34.19),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-49",
			heading = 140,
			--debugPoly=true,
			minZ = 33.19,
			maxZ = 35.59,
		},
	},

	{
		coords = vector3(-120.0, -1574.47, 34.19),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-50",
			heading = 140,
			--debugPoly=true,
			minZ = 33.19,
			maxZ = 35.59,
		},
	},

	{
		coords = vector3(-134.37, -1580.4, 34.21),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-51",
			heading = 50,
			--debugPoly=true,
			minZ = 33.21,
			maxZ = 35.61,
		},
	},

	{
		coords = vector3(-140.28, -1587.37, 34.24),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-52",
			heading = 50,
			--debugPoly=true,
			minZ = 33.24,
			maxZ = 35.64,
		},
	},

	{
		coords = vector3(-147.94, -1596.45, 34.83),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-53",
			heading = 50,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 36.23,
		},
	},

	{
		coords = vector3(-140.37, -1599.66, 34.83),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-54",
			heading = 340,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 36.23,
		},
	},

	{
		coords = vector3(-123.1, -1591.16, 34.22),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-55",
			heading = 230,
			--debugPoly=true,
			minZ = 33.22,
			maxZ = 35.62,
		},
	},

	{
		coords = vector3(-140.36, -1599.63, 38.21),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-56",
			heading = 160,
			--debugPoly=true,
			minZ = 37.21,
			maxZ = 39.61,
		},
	},

	{
		coords = vector3(-147.42, -1597.05, 38.21),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-57",
			heading = 160,
			--debugPoly=true,
			minZ = 37.21,
			maxZ = 39.61,
		},
	},

	{
		coords = vector3(-148.08, -1596.28, 38.21),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-58",
			heading = 50,
			--debugPoly=true,
			minZ = 37.21,
			maxZ = 39.61,
		},
	},

	{
		coords = vector3(-140.32, -1587.37, 37.41),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-59",
			heading = 50,
			--debugPoly=true,
			minZ = 36.41,
			maxZ = 38.81,
		},
	},

	{
		coords = vector3(-134.28, -1580.44, 37.41),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-60",
			heading = 50,
			--debugPoly=true,
			minZ = 36.41,
			maxZ = 38.81,
		},
	},

	{
		coords = vector3(-119.9, -1574.39, 37.41),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-61",
			heading = 320,
			--debugPoly=true,
			minZ = 36.41,
			maxZ = 38.81,
		},
	},

	{
		coords = vector3(-113.92, -1579.35, 37.41),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-62",
			heading = 320,
			--debugPoly=true,
			minZ = 36.41,
			maxZ = 38.81,
		},
	},

	{
		coords = vector3(-118.79, -1586.06, 37.41),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-63",
			heading = 230,
			--debugPoly=true,
			minZ = 36.41,
			maxZ = 38.81,
		},
	},

	{
		coords = vector3(-123.01, -1591.24, 37.41),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-64",
			heading = 230,
			--debugPoly=true,
			minZ = 36.41,
			maxZ = 38.81,
		},
	},

	{
		coords = vector3(-167.45, -1534.46, 35.11),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-65",
			heading = 140,
			--debugPoly=true,
			minZ = 34.11,
			maxZ = 36.51,
		},
	},

	{
		coords = vector3(-174.41, -1528.38, 34.35),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-66",
			heading = 140,
			--debugPoly=true,
			minZ = 33.35,
			maxZ = 35.75,
		},
	},

	{
		coords = vector3(-180.26, -1534.37, 34.35),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-67",
			heading = 50,
			--debugPoly=true,
			minZ = 33.35,
			maxZ = 35.75,
		},
	},

	{
		coords = vector3(-184.46, -1539.49, 34.35),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-68",
			heading = 50,
			--debugPoly=true,
			minZ = 33.35,
			maxZ = 35.75,
		},
	},

	{
		coords = vector3(-196.32, -1555.72, 34.96),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-69",
			heading = 50,
			--debugPoly=true,
			minZ = 33.96,
			maxZ = 36.36,
		},
	},

	{
		coords = vector3(-192.1, -1559.81, 34.95),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-70",
			heading = 320,
			--debugPoly=true,
			minZ = 33.95,
			maxZ = 36.35,
		},
	},

	{
		coords = vector3(-187.25, -1563.39, 35.76),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-71",
			heading = 230,
			--debugPoly=true,
			minZ = 34.76,
			maxZ = 37.16,
		},
	},

	{
		coords = vector3(-179.56, -1554.29, 35.13),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-72",
			heading = 235,
			--debugPoly=true,
			minZ = 34.13,
			maxZ = 36.53,
		},
	},

	{
		coords = vector3(-173.63, -1547.25, 35.13),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-73",
			heading = 230,
			--debugPoly=true,
			minZ = 34.13,
			maxZ = 36.53,
		},
	},

	{
		coords = vector3(-184.5, -1539.5, 37.54),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-74",
			heading = 230,
			--debugPoly=true,
			minZ = 36.54,
			maxZ = 38.94,
		},
	},

	{
		coords = vector3(-180.28, -1534.39, 37.54),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-75",
			heading = 230,
			--debugPoly=true,
			minZ = 36.54,
			maxZ = 38.94,
		},
	},

	{
		coords = vector3(-174.38, -1528.37, 37.54),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-76",
			heading = 145,
			--debugPoly=true,
			minZ = 36.54,
			maxZ = 38.94,
		},
	},

	{
		coords = vector3(-167.47, -1534.46, 38.33),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-77",
			heading = 140,
			--debugPoly=true,
			minZ = 37.33,
			maxZ = 39.73,
		},
	},

	{
		coords = vector3(-173.68, -1547.28, 38.33),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-78",
			heading = 50,
			--debugPoly=true,
			minZ = 37.33,
			maxZ = 39.73,
		},
	},

	{
		coords = vector3(-179.62, -1554.24, 38.33),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-79",
			heading = 50,
			--debugPoly=true,
			minZ = 37.33,
			maxZ = 39.73,
		},
	},

	{
		coords = vector3(-187.17, -1563.31, 39.13),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-80",
			heading = 50,
			--debugPoly=true,
			minZ = 38.13,
			maxZ = 40.53,
		},
	},

	{
		coords = vector3(-188.23, -1563.18, 39.13),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-81",
			heading = 320,
			--debugPoly=true,
			minZ = 38.13,
			maxZ = 40.53,
		},
	},

	{
		coords = vector3(-192.23, -1559.9, 38.34),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-82",
			heading = 320,
			--debugPoly=true,
			minZ = 37.34,
			maxZ = 39.74,
		},
	},

	{
		coords = vector3(-196.22, -1555.66, 38.34),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-83",
			heading = 230,
			--debugPoly=true,
			minZ = 37.34,
			maxZ = 39.74,
		},
	},

	{
		coords = vector3(-112.58, -1479.39, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-84",
			heading = 230,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-107.5, -1473.43, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-85",
			heading = 230,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-113.49, -1467.76, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-86",
			heading = 140,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-122.89, -1459.93, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-87",
			heading = 140,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-132.34, -1462.78, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-88",
			heading = 50,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-125.84, -1473.75, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-89",
			heading = 320,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-120.15, -1478.5, 33.82),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-90",
			heading = 320,
			--debugPoly=true,
			minZ = 32.82,
			maxZ = 35.22,
		},
	},

	{
		coords = vector3(-119.61, -1486.81, 36.98),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-91",
			heading = 320,
			--debugPoly=true,
			minZ = 35.98,
			maxZ = 38.38,
		},
	},

	{
		coords = vector3(-112.6, -1479.39, 36.99),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-92",
			heading = 230,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.39,
		},
	},

	{
		coords = vector3(-107.51, -1473.42, 36.99),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-93",
			heading = 230,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.39,
		},
	},

	{
		coords = vector3(-113.41, -1467.72, 36.99),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-94",
			heading = 140,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.39,
		},
	},

	{
		coords = vector3(-120.25, -1478.57, 36.99),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-95",
			heading = 140,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.39,
		},
	},

	{
		coords = vector3(-125.91, -1473.83, 36.99),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-96",
			heading = 140,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.39,
		},
	},

	{
		coords = vector3(-138.25, -1470.78, 36.99),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-97",
			heading = 140,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.39,
		},
	},

	{
		coords = vector3(-132.57, -1462.6, 36.99),
		length = 1,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-98",
			heading = 50,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.39,
		},
	},

	{
		coords = vector3(-127.63, -1456.87, 37.79),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-99",
			heading = 50,
			--debugPoly=true,
			minZ = 36.79,
			maxZ = 39.19,
		},
	},

	{
		coords = vector3(-122.78, -1459.83, 36.99),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-100",
			heading = 320,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.39,
		},
	},

	{
		coords = vector3(-209.98, -1607.09, 34.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-101",
			heading = 260,
			--debugPoly=true,
			minZ = 33.87,
			maxZ = 36.27,
		},
	},

	{
		coords = vector3(-212.08, -1617.65, 34.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-102",
			heading = 260,
			--debugPoly=true,
			minZ = 33.87,
			maxZ = 36.27,
		},
	},

	{
		coords = vector3(-212.81, -1618.2, 34.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-103",
			heading = 175,
			--debugPoly=true,
			minZ = 33.87,
			maxZ = 36.27,
		},
	},

	{
		coords = vector3(-223.18, -1617.6, 34.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-104",
			heading = 90,
			--debugPoly=true,
			minZ = 33.87,
			maxZ = 36.27,
		},
	},

	{
		coords = vector3(-223.25, -1601.15, 34.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-105",
			heading = 90,
			--debugPoly=true,
			minZ = 33.87,
			maxZ = 36.27,
		},
	},

	{
		coords = vector3(-223.24, -1585.86, 34.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-106",
			heading = 90,
			--debugPoly=true,
			minZ = 33.87,
			maxZ = 36.27,
		},
	},

	{
		coords = vector3(-219.33, -1579.96, 34.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-107",
			heading = 55,
			--debugPoly=true,
			minZ = 33.87,
			maxZ = 36.27,
		},
	},

	{
		coords = vector3(-215.68, -1576.16, 34.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-108",
			heading = 320,
			--debugPoly=true,
			minZ = 33.87,
			maxZ = 36.27,
		},
	},

	{
		coords = vector3(-205.59, -1585.58, 38.06),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-109",
			heading = 260,
			--debugPoly=true,
			minZ = 37.06,
			maxZ = 39.46,
		},
	},

	{
		coords = vector3(-215.7, -1576.12, 38.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-110",
			heading = 143,
			--debugPoly=true,
			minZ = 37.05,
			maxZ = 39.45,
		},
	},

	{
		coords = vector3(-219.37, -1579.91, 38.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-111",
			heading = 53,
			--debugPoly=true,
			minZ = 37.05,
			maxZ = 39.45,
		},
	},

	{
		coords = vector3(-223.11, -1585.83, 38.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-112",
			heading = 93,
			--debugPoly=true,
			minZ = 37.05,
			maxZ = 39.45,
		},
	},

	{
		coords = vector3(-223.06, -1601.17, 38.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-113",
			heading = 93,
			--debugPoly=true,
			minZ = 37.05,
			maxZ = 39.45,
		},
	},

	{
		coords = vector3(-223.13, -1617.62, 38.06),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-114",
			heading = 93,
			--debugPoly=true,
			minZ = 37.06,
			maxZ = 39.46,
		},
	},

	{
		coords = vector3(-212.84, -1618.22, 38.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-115",
			heading = 3,
			--debugPoly=true,
			minZ = 37.05,
			maxZ = 39.45,
		},
	},

	{
		coords = vector3(-211.93, -1617.61, 38.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-116",
			heading = 83,
			--debugPoly=true,
			minZ = 37.05,
			maxZ = 39.45,
		},
	},

	{
		coords = vector3(-209.74, -1607.1, 38.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-117",
			heading = 80,
			--debugPoly=true,
			minZ = 37.05,
			maxZ = 39.45,
		},
	},

	{
		coords = vector3(-208.67, -1600.56, 38.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-118",
			heading = 80,
			--debugPoly=true,
			minZ = 37.05,
			maxZ = 39.45,
		},
	},

	{
		coords = vector3(-151.31, -1622.39, 33.65),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-119",
			heading = 52,
			--debugPoly=true,
			minZ = 32.65,
			maxZ = 35.05,
		},
	},

	{
		coords = vector3(-150.24, -1625.63, 33.65),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-120",
			heading = 52,
			--debugPoly=true,
			minZ = 32.65,
			maxZ = 35.05,
		},
	},

	{
		coords = vector3(-144.93, -1618.68, 36.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-121",
			heading = 52,
			--debugPoly=true,
			minZ = 35.05,
			maxZ = 37.45,
		},
	},

	{
		coords = vector3(-146.13, -1614.54, 36.05),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-122",
			heading = 70,
			--debugPoly=true,
			minZ = 35.05,
			maxZ = 37.45,
		},
	},

	{
		coords = vector3(-152.56, -1623.88, 36.85),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-123",
			heading = 50,
			--debugPoly=true,
			minZ = 35.85,
			maxZ = 38.25,
		},
	},

	{
		coords = vector3(-150.19, -1625.66, 36.85),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-124",
			heading = 50,
			--debugPoly=true,
			minZ = 35.85,
			maxZ = 38.25,
		},
	},

	{
		coords = vector3(-161.15, -1638.85, 34.03),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-125",
			heading = 323,
			--debugPoly=true,
			minZ = 33.03,
			maxZ = 35.43,
		},
	},

	{
		coords = vector3(-160.01, -1636.22, 34.03),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-126",
			heading = 323,
			--debugPoly=true,
			minZ = 33.03,
			maxZ = 35.43,
		},
	},

	{
		coords = vector3(-153.54, -1641.12, 36.85),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-127",
			heading = 323,
			--debugPoly=true,
			minZ = 35.85,
			maxZ = 38.25,
		},
	},

	{
		coords = vector3(-161.73, -1638.54, 37.25),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-128",
			heading = 323,
			--debugPoly=true,
			minZ = 36.25,
			maxZ = 38.65,
		},
	},

	{
		coords = vector3(-160.0, -1636.25, 37.25),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-129",
			heading = 323,
			--debugPoly=true,
			minZ = 36.25,
			maxZ = 38.65,
		},
	},

	{
		coords = vector3(-216.52, -1674.36, 34.46),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-130",
			heading = 2,
			--debugPoly=true,
			minZ = 33.46,
			maxZ = 35.86,
		},
	},

	{
		coords = vector3(-224.38, -1674.58, 34.46),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-131",
			heading = 2,
			--debugPoly=true,
			minZ = 33.46,
			maxZ = 35.86,
		},
	},

	{
		coords = vector3(-224.87, -1666.27, 34.46),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-132",
			heading = 267,
			--debugPoly=true,
			minZ = 33.46,
			maxZ = 35.86,
		},
	},

	{
		coords = vector3(-216.53, -1648.6, 34.46),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-133",
			heading = 182,
			--debugPoly=true,
			minZ = 33.46,
			maxZ = 35.86,
		},
	},

	{
		coords = vector3(-212.32, -1660.64, 34.46),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-134",
			heading = 92,
			--debugPoly=true,
			minZ = 33.46,
			maxZ = 35.86,
		},
	},

	{
		coords = vector3(-212.27, -1668.02, 34.46),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-135",
			heading = 92,
			--debugPoly=true,
			minZ = 33.46,
			maxZ = 35.86,
		},
	},

	{
		coords = vector3(-224.97, -1666.29, 37.64),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-136",
			heading = 92,
			--debugPoly=true,
			minZ = 36.64,
			maxZ = 39.04,
		},
	},

	{
		coords = vector3(-224.31, -1674.52, 37.64),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-137",
			heading = 2,
			--debugPoly=true,
			minZ = 36.64,
			maxZ = 39.04,
		},
	},

	{
		coords = vector3(-216.56, -1674.46, 37.64),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-138",
			heading = 2,
			--debugPoly=true,
			minZ = 36.64,
			maxZ = 39.04,
		},
	},

	{
		coords = vector3(-212.27, -1668.01, 37.64),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-139",
			heading = 272,
			--debugPoly=true,
			minZ = 36.64,
			maxZ = 39.04,
		},
	},

	{
		coords = vector3(-212.26, -1660.6, 37.64),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-140",
			heading = 272,
			--debugPoly=true,
			minZ = 36.64,
			maxZ = 39.04,
		},
	},

	{
		coords = vector3(-216.58, -1648.5, 37.64),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-141",
			heading = 182,
			--debugPoly=true,
			minZ = 36.64,
			maxZ = 39.04,
		},
	},

	{
		coords = vector3(-224.04, -1648.56, 38.44),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-142",
			heading = 182,
			--debugPoly=true,
			minZ = 37.44,
			maxZ = 39.84,
		},
	},

	{
		coords = vector3(-224.97, -1653.97, 37.64),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-143",
			heading = 92,
			--debugPoly=true,
			minZ = 36.64,
			maxZ = 39.04,
		},
	},

	{
		coords = vector3(-157.98, -1679.75, 33.84),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-144",
			heading = 52,
			--debugPoly=true,
			minZ = 32.84,
			maxZ = 35.24,
		},
	},

	{
		coords = vector3(-148.08, -1687.54, 32.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-145",
			heading = 322,
			--debugPoly=true,
			minZ = 31.87,
			maxZ = 34.27,
		},
	},

	{
		coords = vector3(-146.98, -1688.52, 32.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-146",
			heading = 320,
			--debugPoly=true,
			minZ = 31.87,
			maxZ = 34.27,
		},
	},

	{
		coords = vector3(-141.73, -1692.85, 32.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-147",
			heading = 320,
			--debugPoly=true,
			minZ = 31.87,
			maxZ = 34.27,
		},
	},

	{
		coords = vector3(-141.64, -1693.56, 32.87),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-148",
			heading = 230,
			--debugPoly=true,
			minZ = 31.87,
			maxZ = 34.27,
		},
	},

	{
		coords = vector3(-141.49, -1693.67, 36.17),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-149",
			heading = 230,
			--debugPoly=true,
			minZ = 35.17,
			maxZ = 37.57,
		},
	},

	{
		coords = vector3(-141.69, -1692.82, 36.17),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-150",
			heading = 140,
			--debugPoly=true,
			minZ = 35.17,
			maxZ = 37.57,
		},
	},

	{
		coords = vector3(-146.93, -1688.45, 36.17),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-151",
			heading = 140,
			--debugPoly=true,
			minZ = 35.17,
			maxZ = 37.57,
		},
	},

	{
		coords = vector3(-148.02, -1687.55, 36.17),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-152",
			heading = 140,
			--debugPoly=true,
			minZ = 35.17,
			maxZ = 37.57,
		},
	},

	{
		coords = vector3(-157.94, -1679.26, 36.97),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-153",
			heading = 140,
			--debugPoly=true,
			minZ = 35.97,
			maxZ = 38.37,
		},
	},

	{
		coords = vector3(-158.62, -1679.29, 36.97),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-154",
			heading = 50,
			--debugPoly=true,
			minZ = 35.97,
			maxZ = 38.37,
		},
	},

	{
		coords = vector3(-186.35, -1701.83, 32.77),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-155",
			heading = 310,
			--debugPoly=true,
			minZ = 31.77,
			maxZ = 34.17,
		},
	},

	{
		coords = vector3(-114.21, -1659.66, 32.5),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-156",
			heading = 235,
			--debugPoly=true,
			minZ = 31.5,
			maxZ = 33.9,
		},
	},

	{
		coords = vector3(-124.04, -1671.23, 32.56),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-157",
			heading = 231,
			--debugPoly=true,
			minZ = 31.56,
			maxZ = 33.96,
		},
	},

	{
		coords = vector3(-131.59, -1665.56, 32.56),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-158",
			heading = 141,
			--debugPoly=true,
			minZ = 31.56,
			maxZ = 33.96,
		},
	},

	{
		coords = vector3(-138.79, -1658.89, 33.34),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-159",
			heading = 51,
			--debugPoly=true,
			minZ = 32.34,
			maxZ = 34.74,
		},
	},

	{
		coords = vector3(-129.15, -1647.23, 33.31),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-160",
			heading = 51,
			--debugPoly=true,
			minZ = 32.31,
			maxZ = 34.71,
		},
	},

	{
		coords = vector3(-121.21, -1653.22, 32.56),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-161",
			heading = 321,
			--debugPoly=true,
			minZ = 31.56,
			maxZ = 33.96,
		},
	},

	{
		coords = vector3(-107.33, -1651.52, 34.88),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-162",
			heading = 231,
			--debugPoly=true,
			minZ = 33.88,
			maxZ = 36.28,
		},
	},

	{
		coords = vector3(-114.27, -1659.71, 35.71),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-163",
			heading = 231,
			--debugPoly=true,
			minZ = 34.71,
			maxZ = 37.11,
		},
	},

	{
		coords = vector3(-121.26, -1653.21, 35.71),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-164",
			heading = 141,
			--debugPoly=true,
			minZ = 34.71,
			maxZ = 37.11,
		},
	},

	{
		coords = vector3(-128.97, -1647.4, 36.51),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-165",
			heading = 51,
			--debugPoly=true,
			minZ = 35.51,
			maxZ = 37.91,
		},
	},

	{
		coords = vector3(-138.69, -1658.93, 36.51),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-166",
			heading = 51,
			--debugPoly=true,
			minZ = 35.51,
			maxZ = 37.91,
		},
	},

	{
		coords = vector3(-131.59, -1665.59, 35.71),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-167",
			heading = 321,
			--debugPoly=true,
			minZ = 34.71,
			maxZ = 37.11,
		},
	},

	{
		coords = vector3(-123.93, -1671.32, 35.71),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-168",
			heading = 231,
			--debugPoly=true,
			minZ = 34.71,
			maxZ = 37.11,
		},
	},

	{
		coords = vector3(-130.93, -1679.53, 34.91),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-169",
			heading = 231,
			--debugPoly=true,
			minZ = 33.91,
			maxZ = 36.31,
		},
	},

	{
		coords = vector3(87.6, -1670.47, 29.13),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-170",
			heading = 256,
			--debugPoly=true,
			minZ = 28.13,
			maxZ = 30.53,
		},
	},

	{
		coords = vector3(95.9, -1682.33, 29.23),
		length = 1.0,
		width = 1.8,
		options = {
			name = "taco-delivery-loc-171",
			heading = 318,
			--debugPoly=true,
			minZ = 28.23,
			maxZ = 30.63,
		},
	},

	{
		coords = vector3(125.85, -1704.66, 29.28),
		length = 1.0,
		width = 1.8,
		options = {
			name = "taco-delivery-loc-172",
			heading = 318,
			--debugPoly=true,
			minZ = 28.28,
			maxZ = 30.68,
		},
	},

	{
		coords = vector3(139.18, -1716.86, 29.26),
		length = 1.0,
		width = 1.8,
		options = {
			name = "taco-delivery-loc-173",
			heading = 318,
			--debugPoly=true,
			minZ = 28.26,
			maxZ = 30.66,
		},
	},

	{
		coords = vector3(143.41, -1722.02, 29.22),
		length = 1.0,
		width = 1.8,
		options = {
			name = "taco-delivery-loc-174",
			heading = 320,
			--debugPoly=true,
			minZ = 28.22,
			maxZ = 30.62,
		},
	},

	{
		coords = vector3(131.09, -1772.23, 29.73),
		length = 1.0,
		width = 2.8,
		options = {
			name = "taco-delivery-loc-175",
			heading = 320,
			--debugPoly=true,
			minZ = 28.73,
			maxZ = 31.13,
		},
	},

	{
		coords = vector3(195.48, -1764.03, 29.33),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-176",
			heading = 280,
			--debugPoly=true,
			minZ = 28.33,
			maxZ = 30.73,
		},
	},

	{
		coords = vector3(213.38, -1779.74, 29.07),
		length = 1.0,
		width = 1.2,
		options = {
			name = "taco-delivery-loc-177",
			heading = 320,
			--debugPoly=true,
			minZ = 28.07,
			maxZ = 30.47,
		},
	},

	{
		coords = vector3(206.07, -1773.9, 29.21),
		length = 1.0,
		width = 2.2,
		options = {
			name = "taco-delivery-loc-178",
			heading = 320,
			--debugPoly=true,
			minZ = 28.21,
			maxZ = 30.61,
		},
	},

	{
		coords = vector3(226.66, -1791.38, 28.48),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-179",
			heading = 335,
			--debugPoly=true,
			minZ = 27.28,
			maxZ = 30.48,
		},
	},

	{
		coords = vector3(169.91, -1799.73, 29.18),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-180",
			heading = 320,
			--debugPoly=true,
			minZ = 27.78,
			maxZ = 30.98,
		},
	},

	{
		coords = vector3(194.52, -1820.9, 28.54),
		length = 1.0,
		width = 1.6,
		options = {
			name = "taco-delivery-loc-181",
			heading = 320,
			--debugPoly=true,
			minZ = 26.94,
			maxZ = 30.74,
		},
	},

	{
		coords = vector3(205.25, -1828.15, 27.98),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-182",
			heading = 320,
			--debugPoly=true,
			minZ = 25.78,
			maxZ = 29.58,
		},
	},

	{
		coords = vector3(209.43, -1831.73, 27.73),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-183",
			heading = 320,
			--debugPoly=true,
			minZ = 25.53,
			maxZ = 29.33,
		},
	},

	{
		coords = vector3(213.83, -1835.35, 27.48),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-184",
			heading = 320,
			--debugPoly=true,
			minZ = 25.28,
			maxZ = 29.08,
		},
	},

	{
		coords = vector3(218.03, -1838.98, 27.29),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-185",
			heading = 320,
			--debugPoly=true,
			minZ = 25.09,
			maxZ = 28.89,
		},
	},

	{
		coords = vector3(222.52, -1842.77, 27.04),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-186",
			heading = 320,
			--debugPoly=true,
			minZ = 24.84,
			maxZ = 28.64,
		},
	},

	{
		coords = vector3(-20.51, -1472.89, 30.72),
		length = 1.0,
		width = 2.0,
		options = {
			name = "taco-delivery-loc-187",
			heading = 5,
			--debugPoly=true,
			minZ = 28.52,
			maxZ = 32.32,
		},
	},

	{
		coords = vector3(-37.74, -1473.6, 31.52),
		length = 1.0,
		width = 1.4,
		options = {
			name = "taco-delivery-loc-188",
			heading = 5,
			--debugPoly=true,
			minZ = 29.32,
			maxZ = 33.12,
		},
	},

	{
		coords = vector3(-42.59, -1474.81, 31.83),
		length = 1.0,
		width = 2.2,
		options = {
			name = "taco-delivery-loc-189",
			heading = 5,
			--debugPoly=true,
			minZ = 29.63,
			maxZ = 33.43,
		},
	},

	{
		coords = vector3(-115.67, -1772.81, 29.86),
		length = 1.5,
		width = 1.2,
		{
			name = "taco-delivery-loc-190",
			heading = 320,
			--debugPoly=true,
			minZ = 28.06,
			maxZ = 32.06,
		},
	},

	{
		coords = vector3(-50.2, -1783.11, 28.3),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-191",
			heading = 316,
			--debugPoly=true,
			minZ = 25.7,
			maxZ = 29.7,
		},
	},

	{
		coords = vector3(-41.92, -1792.03, 27.82),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-192",
			heading = 316,
			--debugPoly=true,
			minZ = 25.22,
			maxZ = 29.22,
		},
	},

	{
		coords = vector3(-34.33, -1846.98, 26.19),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-193",
			heading = 320,
			--debugPoly=true,
			minZ = 23.59,
			maxZ = 27.59,
		},
	},

	{
		coords = vector3(-20.24, -1859.07, 25.41),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-194",
			heading = 320,
			--debugPoly=true,
			minZ = 22.81,
			maxZ = 26.81,
		},
	},

	{
		coords = vector3(-4.61, -1872.34, 24.15),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-195",
			heading = 322,
			--debugPoly=true,
			minZ = 21.55,
			maxZ = 25.55,
		},
	},

	{
		coords = vector3(21.5, -1844.8, 24.6),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-196",
			heading = 321,
			--debugPoly=true,
			minZ = 22.0,
			maxZ = 26.0,
		},
	},

	{
		coords = vector3(5.47, -1884.44, 23.7),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-197",
			heading = 321,
			--debugPoly=true,
			minZ = 21.1,
			maxZ = 25.1,
		},
	},

	{
		coords = vector3(30.18, -1854.94, 24.06),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-198",
			heading = 316,
			--debugPoly=true,
			minZ = 21.46,
			maxZ = 25.46,
		},
	},

	{
		coords = vector3(46.37, -1863.87, 23.28),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-199",
			heading = 316,
			--debugPoly=true,
			minZ = 20.68,
			maxZ = 24.68,
		},
	},

	{
		coords = vector3(54.62, -1872.85, 22.81),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-200",
			heading = 316,
			--debugPoly=true,
			minZ = 20.21,
			maxZ = 24.21,
		},
	},

	{
		coords = vector3(38.82, -1911.46, 21.95),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-201",
			heading = 319,
			--debugPoly=true,
			minZ = 19.35,
			maxZ = 23.35,
		},
	},

	{
		coords = vector3(56.44, -1922.86, 21.91),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-202",
			heading = 319,
			--debugPoly=true,
			minZ = 19.31,
			maxZ = 23.31,
		},
	},

	{
		coords = vector3(72.09, -1939.15, 21.37),
		length = 1.3,
		width = 2.2,
		{
			name = "taco-delivery-loc-203",
			heading = 315,
			--debugPoly=true,
			minZ = 18.77,
			maxZ = 22.77,
		},
	},

	{
		coords = vector3(101.02, -1912.17, 21.41),
		length = 1.3,
		width = 2.2,
		{
			name = "taco-delivery-loc-204",
			heading = 335,
			--debugPoly=true,
			minZ = 18.81,
			maxZ = 22.81,
		},
	},

	{
		coords = vector3(118.55, -1921.15, 21.32),
		length = 1.3,
		width = 1.6,
		{
			name = "taco-delivery-loc-205",
			heading = 324,
			--debugPoly=true,
			minZ = 18.72,
			maxZ = 22.72,
		},
	},

	{
		coords = vector3(126.81, -1930.04, 21.38),
		length = 1.3,
		width = 1.6,
		{
			name = "taco-delivery-loc-206",
			heading = 303,
			--debugPoly=true,
			minZ = 18.78,
			maxZ = 22.78,
		},
	},

	{
		coords = vector3(114.48, -1961.42, 21.32),
		length = 1.3,
		width = 1.6,
		{
			name = "taco-delivery-loc-207",
			heading = 293,
			--debugPoly=true,
			minZ = 18.72,
			maxZ = 22.72,
		},
	},

	{
		coords = vector3(86.17, -1959.91, 21.12),
		length = 1.3,
		width = 1.6,
		{
			name = "taco-delivery-loc-208",
			heading = 323,
			--debugPoly=true,
			minZ = 18.52,
			maxZ = 22.52,
		},
	},

	{
		coords = vector3(76.16, -1948.02, 21.17),
		length = 1.3,
		width = 1.6,
		{
			name = "taco-delivery-loc-209",
			heading = 320,
			--debugPoly=true,
			minZ = 18.57,
			maxZ = 22.57,
		},
	},

	{
		coords = vector3(103.85, -1885.6, 24.3),
		length = 1.3,
		width = 1.6,
		{
			name = "taco-delivery-loc-210",
			heading = 230,
			--debugPoly=true,
			minZ = 23.1,
			maxZ = 25.7,
		},
	},

	{
		coords = vector3(115.48, -1887.96, 23.93),
		length = 1.3,
		width = 1.6,
		{
			name = "taco-delivery-loc-211",
			heading = 335,
			--debugPoly=true,
			minZ = 22.73,
			maxZ = 25.33,
		},
	},

	{
		coords = vector3(128.38, -1897.02, 23.67),
		length = 1.3,
		width = 1.6,
		{
			name = "taco-delivery-loc-212",
			heading = 335,
			--debugPoly=true,
			minZ = 22.47,
			maxZ = 25.07,
		},
	},

	{
		coords = vector3(148.75, -1904.5, 23.53),
		length = 1.3,
		width = 2.2,
		{
			name = "taco-delivery-loc-213",
			heading = 335,
			--debugPoly=true,
			minZ = 22.33,
			maxZ = 24.93,
		},
	},

	{
		coords = vector3(208.69, -1895.41, 24.81),
		length = 1.3,
		width = 1.2,
		{
			name = "taco-delivery-loc-214",
			heading = 320,
			--debugPoly=true,
			minZ = 23.61,
			maxZ = 26.21,
		},
	},

	{
		coords = vector3(192.6, -1882.72, 25.05),
		length = 2.1,
		width = 1.0,
		{
			name = "taco-delivery-loc-215",
			heading = 243,
			--debugPoly=true,
			minZ = 23.85,
			maxZ = 26.45,
		},
	},

	{
		coords = vector3(171.81, -1871.55, 24.4),
		length = 1.9,
		width = 1.4,
		{
			name = "taco-delivery-loc-216",
			heading = 243,
			--debugPoly=true,
			minZ = 23.2,
			maxZ = 25.8,
		},
	},

	{
		coords = vector3(150.16, -1864.54, 24.59),
		length = 1.5,
		width = 1.2,
		{
			name = "taco-delivery-loc-217",
			heading = 155,
			--debugPoly=true,
			minZ = 23.39,
			maxZ = 25.99,
		},
	},

	{
		coords = vector3(130.56, -1853.25, 25.23),
		length = 1.5,
		width = 2.2,
		{
			name = "taco-delivery-loc-218",
			heading = 149,
			--debugPoly=true,
			minZ = 24.03,
			maxZ = 26.63,
		},
	},
}

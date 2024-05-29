_performanceUpgrades = {
	engine = 11,
	transmission = 13,
	brakes = 12,
	suspension = 15,
	turbo = 18,
}

--[[

Performance Parts

-1 is Stock
0 is Level 1
1 is Level 2
... You get the point

THE LOWEST LEVEL IS DEFAULT SO PUT THE STUFF BACK TO NORMAL

handling

Array of objects containing the changes
fieldType - Float, Vector, Int
multiplier - if true is a multiplier of the current value

]]

_pursuitModeConfig = {
	-- [`example`] = {
	--     {
	--         name = 'A',
	--         performance = {
	--             engine = -1,
	--             transmission = -1,
	--             brakes = -1,
	--             suspension = -1,
	--             turbo = false,
	--         },
	--         handling = false, -- Reset
	--     },
	--     {
	--         name = 'A+',
	--         performance = {
	--             engine = -1,
	--             transmission = -1,
	--             brakes = -1,
	--             suspension = -1,
	--             turbo = true,
	--         },
	--         handling = {
	--             {
	--                 field = 'fInitialDriveForce',
	--                 fieldType = 'Float',
	--                 multiplier = false,
	--                 value = 10.0,
	--             },
	--         }
	--     },
	--     {
	--         name = 'S',
	--     },
	--     {
	--         name = 'S+',
	--     }
	-- }
	[`nkstx`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.275,
				},
			},
		},
		{
			name = "S",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 2,
				turbo = true,
			},
			topSpeed = 170.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.32,
				},
			},
		},
	},
	[`nkvstr`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.275,
				},
			},
		},
		{
			name = "S",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 2,
				turbo = true,
			},
			topSpeed = 170.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.32,
				},
			},
		},
	},
	[`NKVIGERO2`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.285,
				},
			},
		},
		{
			name = "S",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 2,
				turbo = true,
			},
			topSpeed = 170.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.33,
				},
			},
		},
	},
	[`NKDOMINATOR3`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.275,
				},
			},
		},
		{
			name = "S",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 2,
				turbo = true,
			},
			topSpeed = 170.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.33,
				},
			},
		},
	},
	[`nkcaracara2`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.275,
				},
			},
		},
	},
	[`nkballer7`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.275,
				},
			},
		},
	},
	[`nktenf`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.285,
				},
			},
		},
		{
			name = "S",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 2,
				turbo = true,
			},
			topSpeed = 170.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.33,
				},
			},
		},
	},
	[`nktraining`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.275,
				},
			},
		},
	},
	[`NKGRANGER2`] = {
		{
			name = "D",
			performance = {
				engine = -1,
				transmission = -1,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			handling = false, -- Reset
			topSpeed = 120.0,
		},
		{
			name = "C",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 130.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.20,
				},
			},
		},
		{
			name = "B",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = false,
			},
			topSpeed = 150.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.23,
				},
			},
		},
		{
			name = "A",
			performance = {
				engine = 3,
				transmission = 3,
				brakes = 3,
				suspension = 0,
				turbo = true,
			},
			topSpeed = 160.0,
			handling = {
				{
					field = "fInitialDriveForce",
					fieldType = "Float",
					multiplier = false,
					value = 0.275,
				},
			},
		},
	},
	-- [`policebretro`] = {
	-- 	{
	-- 		name = "D",
	-- 		performance = {
	-- 			engine = -1,
	-- 			transmission = -1,
	-- 			brakes = -1,
	-- 			suspension = -1,
	-- 			turbo = false,
	-- 		},
	-- 		handling = false, -- Reset
	-- 		topSpeed = 120.0,
	-- 	},
	-- 	{
	-- 		name = "C",
	-- 		performance = {
	-- 			engine = -1,
	-- 			transmission = -1,
	-- 			brakes = -1,
	-- 			suspension = -1,
	-- 			turbo = false,
	-- 		},
	-- 		handling = {
	-- 			{
	-- 				field = "fInitialDriveForce",
	-- 				fieldType = "Float",
	-- 				multiplier = false,
	-- 				value = 0.20,
	-- 			},
	-- 		},
	-- 		topSpeed = 130.0,
	-- 	},
	-- 	{
	-- 		name = "B",
	-- 		performance = {
	-- 			engine = -1,
	-- 			transmission = -1,
	-- 			brakes = -1,
	-- 			suspension = -1,
	-- 			turbo = false,
	-- 		},
	-- 		handling = {
	-- 			{
	-- 				field = "fInitialDriveForce",
	-- 				fieldType = "Float",
	-- 				multiplier = false,
	-- 				value = 0.23,
	-- 			},
	-- 		},
	-- 		topSpeed = 150.0,
	-- 	},
	-- 	{
	-- 		name = "A",
	-- 		performance = {
	-- 			engine = -1,
	-- 			transmission = -1,
	-- 			brakes = -1,
	-- 			suspension = -1,
	-- 			turbo = false,
	-- 		},
	-- 		handling = {
	-- 			{
	-- 				field = "fInitialDriveForce",
	-- 				fieldType = "Float",
	-- 				multiplier = false,
	-- 				value = 0.275,
	-- 			},
	-- 		},
	-- 		topSpeed = 160.0,
	-- 	},
	-- },
}

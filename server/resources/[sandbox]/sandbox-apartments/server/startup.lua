_aptData = {
	{
		name = "Richard's Tower",
		invEntity = 13,
		coords = vector3(-1274.351, 315.095, 64.512),
		heading = 153.319,
		length = 8.4,
		width = 4.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 63.21,
			maxZ = 67.21,
		},
		interior = {
			wakeup = {
				x = 285.733,
				y = -928.362,
				z = -23.954,
				h = 268.463,
			},
			spawn = {
				x = 291.069,
				y = -924.995,
				z = -22.995,
				h = 174.465,
			},
			locations = {
				exit = {
					coords = vector3(291.04, -924.59, -23.0),
					length = 1.0,
					width = 1.6,
					options = {
						heading = 0,
						--debugPoly=true,
						minZ = -24.0,
						maxZ = -21.4
					},
				},
				wardrobe = {
					coords = vector3(287.15, -922.39, -23.0),
					length = 1.0,
					width = 2.0,
					options = {
						heading = 270,
						--debugPoly=true,
						minZ = -24.0,
						maxZ = -21.6
					},
				},
				stash = {
					coords = vector3(288.89, -924.91, -23.0),
					length = 0.8,
					width = 2.4,
					options = {
						heading = 0,
						--debugPoly=true,
						minZ = -24.0,
						maxZ = -22.0
					},
				},
				logout = {
					coords = vector3(284.92, -928.52, -23.0),
					length = 2.6,
					width = 2.2,
					options = {
						heading = 0,
						--debugPoly=true,
						minZ = -24.0,
						maxZ = -22.8
					},
				},
			},
		},
	},
}

function Startup()
	local aptIds = {}

	for k, v in ipairs(_aptData) do
		v.id = k
		GlobalState[string.format("Apartment:%s", k)] = v
		table.insert(aptIds, k)
	end

	GlobalState["Apartments"] = aptIds
end

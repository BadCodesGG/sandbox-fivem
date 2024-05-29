_defaultJobData = {}

-- These job duty counts are stored in globalstate because they are used on clients frequently
_globalStateDutyCounts = {
	police = true,
	ems = true,
	tow = true,
}

_metalDetectorLocations = {
	["vanilla_unicorn_01"] = {
		coords = vector3(129.49, -1299.94, 29.23),
		width = 1.0,
		length = 1.4,
		options = {
			heading = 27,
			--debugPoly=true,
			minZ = 26.83,
			maxZ = 30.83,
		},
		propInfo = {
			model = `ch_prop_ch_metal_detector_01a`,
			coords = vector4(129.486, -1299.938, 29.233, 27.173), -- leave z cause i do math
		},
	},
}

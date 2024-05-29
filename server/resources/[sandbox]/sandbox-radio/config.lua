local policeRestriction = {
	type = "job",
	job = "police",
	workplace = false,
	level = 0,
	jobPermission = false,
	reqDuty = true,
}

local correctionsRestriction = {
	type = "job",
	job = "prison",
	workplace = false,
	level = 0,
	jobPermission = false,
	reqDuty = true,
}

local emsRestriction = {
	type = "job",
	job = "ems",
	workplace = false,
	level = 0,
	jobPermission = false,
	reqDuty = true,
}

_emergencyRestriction = {
	policeRestriction,
	emsRestriction,
	correctionsRestriction,
}

_tunaRestriction = {
	type = "job",
	job = "blackline",
	workplace = false,
	level = 0,
	jobPermission = false,
	reqDuty = true,
}

-- _restrictedRadioChannels = {
--     [11] = {
--         name = 'Corrections',
--         radio = 1,
--         restriction = emergencyRestriction,
--     },
-- }

-- for i = 1, 10, 1 do
--     _restrictedRadioChannels[i] = {
--         name = 'Emergency #'.. i,
--         radio = 1,
--         restriction = emergencyRestriction,
--     }
-- end

_radioData = {
	{ -- Encrypted Radio
		min = 1,
		max = 9999,
		job = {
			'police',
			'ems',
			'prison',
			'dgang',
			'blackline',
		},
	},
	{ -- Extendy Radio
		min = 100,
		max = 2000,
	},
	{ -- Civ Radio
		min = 100,
		max = 1000,
	},
}

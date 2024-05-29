_donorDealerships = {
	{
		ped = {
			model = `ig_money`,
			location = vector4(-4.662, -1088.891, 26.046, 72.014),
		},
		availableVehicles = "pdm", -- The "host" dealership used
		flags = {
			depleteStockOnPurchase = true,
			payDealershipOnPurchase = true,
		},
		storage = { -- Should probably be the same as the dealer it is outside of
			Type = 1,
			Id = "pdm_delivery",
		},
	},
	{
		ped = {
			model = `s_m_m_movspace_01`,
			location = vector4(155.099, -3005.448, 6.031, 7.396),
		},
		availableVehicles = "tuna", -- The "host" dealership used
		flags = {
			depleteStockOnPurchase = true,
			payDealershipOnPurchase = true,
		},
		storage = { -- Should probably be the same as the dealer it is outside of
			Type = 1,
			Id = "tuna_delivery",
		},
	},
}

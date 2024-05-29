COMPONENTS.Config = {
	Discord = {
		Server = "",
	},
	Groups = {
		management = {
			Id = "management",
			Name = "Management",
			Abv = "Management",
			Queue = {
				Priority = 100,
			},
			Permission = {
				Group = "admin", -- Can restart resources
				Level = 100,
			},
		},
		dev = {
			Id = "dev",
			Name = "Developer",
			Abv = "Dev",
			Queue = {
				Priority = 50,
			},
			Permission = {
				Group = "admin",
				Level = 100,
			},
		},
		admin = {
			Id = "admin",
			Name = "Admin",
			Abv = "Admin",
			Queue = {
				Priority = 50,
			},
			Permission = {
				Group = "staff",
				Level = 50,
			},
		},
		operations = {
			Id = "operations",
			Name = "Operations",
			Abv = "Operations",
			Queue = {
				Priority = 50,
			},
			Permission = {
				Group = "",
				Level = 0,
			},
		},
		whitelisted = {
			Id = "whitelisted",
			Name = "Whitelisted",
			Abv = "Whitelisted",
			Queue = {
				Priority = 0,
			},
			Permission = {
				Group = "",
				Level = 0,
			},
		},
	},
	Server = {
		ID = os.time(),
		Name = "Server Name",
		Access = GetConvar("sv_access_role", 0),
	},
}

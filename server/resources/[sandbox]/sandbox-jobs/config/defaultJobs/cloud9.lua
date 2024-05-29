table.insert(_defaultJobData, {
	Type = "Company",
	LastUpdated = 1691091648,
	Id = "cloud9",
	Name = "Cloud9 Drift",
	Salary = 600,
	SalaryTier = 1,
	Grades = {
		{
			Id = "employee",
			Name = "Employee",
			Level = 2,
			Permissions = {
				JOB_STORAGE = true,
				FLEET_VEHICLES_0 = true,
			},
		},
		{
			Id = "manager",
			Name = "Manager",
			Level = 5,
			Permissions = {
				JOB_STORAGE = true,
				FLEET_VEHICLES_0 = true,
				JOB_HIRE = true,
				JOB_FIRE = true,
			},
		},
		{
			Id = "owner",
			Name = "Owner",
			Level = 99,
			Permissions = {
				JOB_MANAGEMENT = true,
				JOB_MANAGE_EMPLOYEES = true,
				JOB_HIRE = true,
				JOB_FIRE = true,
				JOB_STORAGE = true,
				FLEET_VEHICLES_0 = true,
				FLEET_MANAGEMENT = true,
				TABLET_TWEET = true,
				JOB_DRIFT_LICENSE = true,
			},
		},
	},
})

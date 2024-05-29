table.insert(_defaultJobData, {
	Type = "Company",
	LastUpdated = 1683673432,
	Id = "lsfc",
	Name = "Los Santos Fight Club",
	Salary = 600,
	SalaryTier = 1,
	Hidden = true,
	Grades = {
		{
			Id = "employee",
			Name = "Employee",
			Level = 1,
			Permissions = {
				JOB_STORAGE = true,
			},
		},
		{
			Id = "manager",
			Name = "Manager",
			Level = 5,
			Permissions = {
				JOB_STORAGE = true,
				JOB_HIRE = true,
				JOB_FIRE = true,
				JOB_CRAFTING = true,
				JOB_DOORS = true,
			},
		},
		{
			Id = "ceo",
			Name = "CEO",
			Level = 99,
			Permissions = {
				JOB_MANAGEMENT = true,
				JOB_MANAGE_EMPLOYEES = true,
				JOB_HIRE = true,
				JOB_FIRE = true,
				JOB_STORAGE = true,
				JOB_CRAFTING = true,
				JOB_DOORS = true,
			},
		},
	},
})

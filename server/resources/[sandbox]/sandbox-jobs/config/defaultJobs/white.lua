table.insert(_defaultJobData, {
	Type = "Company",
	LastUpdated = 1683673432,
	Id = "white",
	Name = "White & Associates",
	Salary = 650,
	SalaryTier = 1,
	Grades = {
		{
			Id = "employee",
			Name = "Employee",
			Level = 2,
			Permissions = {
				JOB_STORAGE = true,
				JOB_CRAFTING = true,
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
				TABLET_TWEET = true,
			},
		},
	},
})

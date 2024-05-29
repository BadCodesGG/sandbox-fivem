table.insert(_defaultJobData, {
	Type = "Company",
	LastUpdated = 1683997150,
	Id = "tow",
	Name = "Towing",
	Salary = 600,
	SalaryTier = 1,
	Grades = {
		{
			Id = "employee",
			Name = "Employee",
			Level = 1,
			Permissions = {
				tow_alerts = true,
				impound = true,
			},
		},
	},
})

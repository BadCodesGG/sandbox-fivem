local _startup = false

local defaultOrganizationAccounts = {
	{
		accountId = "police",
		accountName = "Law Enforcement Shared Account",
		startingBalance = 200000,
		jobAccess = {
			{
				Job = "police",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "police-lspd",
		accountName = "LSPD Account",
		startingBalance = 200000,
		jobAccess = {
			{
				Job = "police",
				Workplace = "lspd",
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "police-guardius",
		accountName = "Guardius Account",
		startingBalance = 200000,
		jobAccess = {
			{
				Job = "police",
				Workplace = "guardius",
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "police-bcso",
		accountName = "BCSO Account",
		startingBalance = 200000,
		jobAccess = {
			{
				Job = "police",
				Workplace = "bcso",
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "police-sast",
		accountName = "SAST Account",
		startingBalance = 200000,
		jobAccess = {
			{
				Job = "police",
				Workplace = "sast",
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "ems",
		accountName = "EMS Account",
		startingBalance = 325000,
		jobAccess = {
			{
				Job = "ems",
				Workplace = "safd",
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "doctors",
		accountName = "St Fiacre Medical Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "ems",
				Workplace = "doctors",
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "prison",
		accountName = "Department of Corrections Account",
		startingBalance = 500000,
		jobAccess = {
			{
				Job = "prison",
				Workplace = "corrections",
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "doj",
		accountName = "DOJ Account",
		startingBalance = 100000,
		jobAccess = {
			{
				Job = "government",
				Workplace = "doj",
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "casino-bets",
		accountName = "Diamond Casino Bets",
		startingBalance = 0,
		jobAccess = {
			{
				Job = "casino",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	-- Businesses
	{
		accountId = "cloud9",
		accountName = "Cloud9 Account",
		startingBalance = 100000,
		jobAccess = {
			{
				Job = "cloud9",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "digitalden",
		accountName = "Digital Den Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "digitalden",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "pepega_pawn",
		accountName = "Pepega Pawn Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "pepega_pawn",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "garcon_pawn",
		accountName = "Garcon Pawn Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "garcon_pawn",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "sagma",
		accountName = "Sagma Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "sagma",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "jewel",
		accountName = "The Jeweled Dragon Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "jewel",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "vangelico",
		accountName = "Vangelico Jewelry Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "vangelico",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "vangelico_grapeseed",
		accountName = "Vangelico Grapeseed Jewelry Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "vangelico_grapeseed",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "securoserv",
		accountName = "SecuroServ Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "securoserv",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "avast_arcade",
		accountName = "Avast Arcade Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "avast_arcade",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "bakery",
		accountName = "Bakery Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "bakery",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "beanmachine",
		accountName = "Bean Machine Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "beanmachine",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "bowling",
		accountName = "Bobs Balls Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "bowling",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "taxicab",
		accountName = "Downtown Cab Co. Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "taxicab",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "casino",
		accountName = "Diamond Casino & Resort Account",
		startingBalance = 100000,
		jobAccess = {
			{
				Job = "casino",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "demonetti_storage",
		accountName = "Demonetti Storage Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "demonetti_storage",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "golddiggers",
		accountName = "Gold Diggers Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "golddiggers",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "greycat_shipping",
		accountName = "Greycat Shipping Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "greycat_shipping",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "lostmc",
		accountName = "The Lost MC Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "lostmc",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "odmc",
		accountName = "Odins Disciples MC Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "odmc",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "saints",
		accountName = "The Saints Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "saints",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "lsfc",
		accountName = "Los Santos Fight Club Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "lsfc",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "dgang",
		accountName = "Lua Holdings LLC Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "dgang",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "tuna",
		accountName = "Tuner Shop Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "tuna",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "redline",
		accountName = "Redline Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "redline",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "blackline",
		accountName = "Blackline Mechanics Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "blackline",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "tirenutz",
		accountName = "Tire Nutz Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "tirenutz",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "hayes",
		accountName = "Hayes Autos Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "hayes",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "atomic",
		accountName = "Atomic Mechanics Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "atomic",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "harmony",
		accountName = "Harmony Repairs Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "harmony",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "superperformance",
		accountName = "Super Performance Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "superperformance",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "autoexotics",
		accountName = "Auto Exotics Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "autoexotics",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "ottos",
		accountName = "Ottos Auto's Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "ottos",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "bennys",
		accountName = "Benny's Account",
		startingBalance = 50000,
		jobAccess = {
			{
				Job = "bennys",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "noodle",
		accountName = "Noodle Exchange Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "noodle",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "pdm",
		accountName = "Premium Deluxe Motorsport Account",
		startingBalance = 25000,
		jobAccess = {
			{
				Job = "pdm",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "realestate",
		accountName = "Dynasty 8 Account",
		startingBalance = 25000,
		jobAccess = {
			{
				Job = "realestate",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "burgershot",
		accountName = "Burger Shot Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "burgershot",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "rustybrowns",
		accountName = "Rusty Browns Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "rustybrowns",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "cluckinbell",
		accountName = "Cluckin' Bell Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "cluckinbell",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "lasttrain",
		accountName = "The Last Train Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "lasttrain",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "uwu",
		accountName = "UwU Cafe Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "uwu",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "woods_saloon",
		accountName = "Black Woods Saloon Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "woods_saloon",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "pizza_this",
		accountName = "Pizza This Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "pizza_this",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "prego",
		accountName = "Cafe Prego Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "prego",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "rockford_records",
		accountName = "Rockford Records Account",
		startingBalance = 5000,
		jobAccess = {
			{
				Job = "rockford_records",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "tequila",
		accountName = "Tequil-La-La Account",
		startingBalance = 10000,
		jobAccess = {
			{
				Job = "tequila",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "tow",
		accountName = "Towing Account",
		startingBalance = 0,
		jobAccess = {
			{
				Job = "tow",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "triad",
		accountName = "Triad Records Account",
		startingBalance = 5000,
		jobAccess = {
			{
				Job = "triad",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "bahama",
		accountName = "Bahama Mamas Account",
		startingBalance = 25000,
		jobAccess = {
			{
				Job = "bahama",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "unicorn",
		accountName = "Vanilla Unicorn Account",
		startingBalance = 25000,
		jobAccess = {
			{
				Job = "unicorn",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
	{
		accountId = "weed",
		accountName = "Smoke on the Water Account",
		startingBalance = 5000,
		jobAccess = {
			{
				Job = "weed",
				Workplace = false,
				Permissions = GetDefaultBankAccountPermissions(),
			},
		},
	},
}

function RunBankingStartup()
	if _startup then
		return
	end
	_startup = true

	local stateAccount = MySQL.single.await("SELECT * FROM bank_accounts WHERE type = ? AND account = ?", {
		"organization",
		100000,
	})

	if not stateAccount then
		local stateAccountPermissons = {
			BALANCE = "STATE_ACCOUNT_BALANCE",
			MANAGE = "STATE_ACCOUNT_MANAGE",
			WITHDRAW = "STATE_ACCOUNT_WITHDRAW",
			DEPOSIT = "STATE_ACCOUNT_DEPOSIT",
			TRANSACTIONS = "STATE_ACCOUNT_TRANSACTIONS",
			BILL = "STATE_ACCOUNT_BILL",
		}

		stateAccount = CreateBankAccount(
			"organization",
			"government",
			500000, -- Government Should Probably Have Some Starter Money
			"San Andreas State Account",
			100000,
			{
				{
					Job = "government",
					Workplace = "doj",
					Permissions = stateAccountPermissons,
				},
				{
					Job = "government",
					Workplace = "mayoroffice",
					Permissions = stateAccountPermissons,
				},
			}
		)
	end

	CreateOrganizationBankAccounts()

	local info = MySQL.single.await("SELECT SUM(balance) as total, COUNT(*) as accounts FROM bank_accounts")
	if info and info.total then
		Logger:Info("Banking", string.format("Total Balance Across %s Accounts: ^2$%s^7", info.accounts, info.total))
	end

	Logger:Info("Banking", "Loaded State Government Account - Balance: ^2$" .. stateAccount.balance .. "^7")

	local d = MySQL.query.await("DELETE FROM bank_accounts_transactions WHERE timestamp < now() - interval 30 DAY")

	if d.affectedRows > 0 then
		Logger:Info("Banking", "Cleared ^2" .. d.affectedRows .. "^7" .. " Old Bank Transactions")
	end
end

AddEventHandler("Finance:Server:Startup", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:CharacterSource(source)
		if char and not char:GetData("BankAccount") then
			local stateId = char:GetData("SID")
			local bankAccountData = Banking.Accounts:CreatePersonal(stateId)
			if bankAccountData then
				Logger:Trace(
					"Banking",
					string.format(
						"Personal Bank Account (%s) Created for Character: %s",
						bankAccountData.Account,
						stateId
					)
				)
				char:SetData("BankAccount", bankAccountData.Account)
			end
		end
	end, 3)

	RegisterBankingCallbacks()
end)

AddEventHandler("Jobs:Server:CompleteStartup", function()
	RunBankingStartup()
end)

function CreateOrganizationBankAccounts()
	local orgBankAccounts = MySQL.query.await("SELECT account, owner FROM bank_accounts WHERE type = ?", {
		"organization",
	})

	local accountsByJob = {}
	for k, v in ipairs(orgBankAccounts) do
		accountsByJob[v.owner] = true
	end

	local created = 0

	for k, v in ipairs(defaultOrganizationAccounts) do
		if v.accountId and not accountsByJob[v.accountId] then
			local success =
				CreateBankAccount("organization", v.accountId, v.startingBalance, v.accountName, nil, v.jobAccess)
			if success then
				accountsByJob[v.accountId] = true
				created = created + 1
			end
		end
	end

	local allJobs = Jobs:GetAll()
	if not allJobs then
		return
	end

	for k, v in pairs(allJobs) do
		if v.Type ~= "Government" and not accountsByJob[v.Id] then
			local success = CreateBankAccount("organization", v.Id, 0, v.Name, nil, {
				{
					Job = v.Id,
					Workplace = v.Workplace,
					Permissions = GetDefaultBankAccountPermissions(),
				},
			})

			if success then
				created = created + 1
			end
		end
	end

	if created > 0 then
		Logger:Trace("Banking", "Created ^2" .. created .. "^7 Default Organization Accounts")
	end
end

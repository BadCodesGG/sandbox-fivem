AddEventHandler("Fuel:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet")
	Banking = exports["sandbox-base"]:FetchComponent("Banking")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
end

local threading = false
local bankAcc = nil
local depositData = {
	amount = 0,
	transactions = 0,
}

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Fuel", {
		"Callbacks",
		"Database",
		"Utils",
		"Fetch",
		"Logger",
		"Wallet",
		"Banking",
		"Phone",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()

		if not threading then
			Citizen.CreateThread(function()
				while true do
					Citizen.Wait(1000 * 60 * 10)
					if depositData.amount > 0 then
						Logger:Trace(
							"Fuel",
							string.format("Depositing ^2$%s^7 To ^3%s^7", math.abs(depositData.amount), bankAcc)
						)
						Banking.Balance:Deposit(bankAcc, math.abs(depositData.amount), {
							type = "deposit",
							title = "Fuel Services",
							description = string.format(
								"Payment For Fuel Services For %s Vehicles",
								depositData.transactions
							),
							data = {},
						}, true)
						depositData = {
							amount = 0,
							transactions = 0,
						}
					end
				end
			end)
			threading = true
		end

		Citizen.Wait(2000)
		local f = Banking.Accounts:GetOrganization("dgang")
		if f ~= true then
			bankAcc = f.Account
		end
	end)
end)

function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Fuel:CheckBank", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and data?.cost then
			cb(Banking.Balance:Has(char:GetData("BankAccount"), data.cost))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Fuel:CompleteFueling", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and data and data.vehNet and type(data.vehClass) == "number" and type(data.fuelAmount) == "number" then
			local veh = NetworkGetEntityFromNetworkId(data.vehNet)
			if veh and DoesEntityExist(veh) then
				local vehState = Entity(veh)
				local totalCost = CalculateFuelCost(data.vehClass, data.fuelAmount)

				if vehState and vehState.state and totalCost then
					local paymentSuccess = false
					if data.useBank then
						paymentSuccess = Banking.Balance:Charge(char:GetData("BankAccount"), math.abs(totalCost), {
							type = 'bill',
							title = 'Fuel Purchase',
							description = 'Fuel Purchase',
							data = {
								vehicle = vehState.state.VIN,
								fuel = data.fuelAmount,
							}
						})

						if paymentSuccess then
							Phone.Notification:Add(source, string.format("Fuel Purchase of $%s Successful", math.ceil(totalCost)), false, os.time(), 3000, "bank", {})
						end
					else
						paymentSuccess = Wallet:Modify(source, -math.abs(totalCost), true)
					end

					if paymentSuccess then
						-- TODO: Incorporate the shop bank accounts where possible so money
						-- is sent to those accounts instead of a static one
						depositData.amount += math.abs(totalCost)
						depositData.transactions += 1
	
						vehState.state.Fuel = math.min(math.ceil(vehState.state.Fuel + data.fuelAmount), 100)
						cb(true, totalCost)
						return
					end
				end
			end
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Fuel:CompleteJerryFueling", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and data and data.vehNet and type(data.newAmount) == "number" then
			local veh = NetworkGetEntityFromNetworkId(data.vehNet)
			if veh and DoesEntityExist(veh) then
				local vehState = Entity(veh)

				if vehState and vehState.state then
					vehState.state.Fuel = math.min(data.newAmount, 100)
					cb(true)
					return
				end
			end
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Fuel:FillCan", function(source, data, cb)
		local totalCost = CalculateFuelCost(0, math.floor(100 - (data.pct * 100)))
		cb(totalCost and Wallet:Modify(source, -math.abs(totalCost), true))
	end)
end

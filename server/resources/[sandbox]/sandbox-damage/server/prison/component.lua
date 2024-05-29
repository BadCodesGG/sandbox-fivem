AddEventHandler("Damage:Shared:DependencyUpdate", PrisonHospitalComponents)
function PrisonHospitalComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Billing = exports["sandbox-base"]:FetchComponent("Billing")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Handcuffs = exports["sandbox-base"]:FetchComponent("Handcuffs")
	Ped = exports["sandbox-base"]:FetchComponent("Ped")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
	Banking = exports["sandbox-base"]:FetchComponent("Banking")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("PrisonHospital", {
		"Callbacks",
		"Middleware",
		"Fetch",
		"Damage",
		"Hospital",
		"Crypto",
		"Phone",
		"Execute",
		"Chat",
		"Billing",
		"Inventory",
		"Labor",
		"Jobs",
		"Handcuffs",
		"Ped",
		"Routing",
		"Pwnzor",
		"Banking",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		PrisonHospitalComponents()
		PrisonHospitalCallbacks()
	end)
end)

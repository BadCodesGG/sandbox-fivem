_DRUGS = _DRUGS or {}
local _addictionTemplate = {
	Meth = {
		LastUse = false,
		Factor = 0.0,
	},
	Coke = {
		LastUse = false,
		Factor = 0.0,
	},
	Moonshine = {
		LastUse = false,
		Factor = 0.0,
	},
}

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Drugs = exports["sandbox-base"]:FetchComponent("Drugs")
	Vendor = exports["sandbox-base"]:FetchComponent("Vendor")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Drugs", {
		"Fetch",
		"Logger",
		"Callbacks",
		"Middleware",
		"Execute",
		"Chat",
		"Inventory",
		"Crypto",
		"Vehicles",
		"Drugs",
		"Vendor",
	}, function(error)
		if #error > 0 then
			exports["sandbox-base"]:FetchComponent("Logger"):Critical("Drugs", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()
		RegisterItemUse()
		RunDegenThread()

		Middleware:Add("Characters:Spawning", function(source)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local addictions = char:GetData("Addiction")
				if char:GetData("Addiction") == nil then
					char:SetData("Addiction", _addictionTemplate)
				else
					for k, v in pairs(_addictionTemplate) do
						if addictions[k] == nil then
							addictions[k] = table.copy(v)
						end
					end
					char:SetData("Addiction", addictions)
				end
			end
		end, 1)

		TriggerEvent("Drugs:Server:Startup")
		TriggerEvent("Drugs:Server:StartCookThreads")
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Drugs", _DRUGS)
end)

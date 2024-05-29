Callbacks = nil
Status = nil

local _statuses = {}

AddEventHandler("Status:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Status = exports["sandbox-base"]:FetchComponent("Status")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	RegisterChatCommands()
	registerUsables()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Status", {
		"Callbacks",
		"Fetch",
		"Utils",
		"Chat",
		"Status",
		"Inventory",
		"Wallet",
		"Execute",
		"Middleware",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()

		
		Middleware:Add("Characters:Logout", function(source)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local p = promise.new()
				Callbacks:ClientCallback(source, "Status:StoreValues", {}, function(vals)
					local status = char:GetData("Status") or {}
					for k, v in pairs(vals) do
						status[k] = v
					end
					char:SetData("Status", status)
					p:resolve(true)
				end)
				Citizen.Await(p)
			end
		end, 1)
	end)
end)

STATUS = {
	Register = function(self, name, max, icon, tick, modify)
		table.insert(_statuses, {
			name = name,
			max = max,
			icon = icon,
			tick = tick,
			modify = modify,
		})
	end,
	Get = {
		All = function(self)
			return _statuses
		end,
		Single = function(self, name)
			for k, v in ipairs(_statuses) do
				if v.name == name then
					return v
				end
			end
		end,
	},
	Modify = {
		Add = function(self, source, name, value, addCd, isForced)
			Callbacks:ClientCallback(source, "Status:Modify", {
				name = name,
				value = math.abs(value),
				addCd = addCd,
				isForced = isForced,
			})
		end,
		Remove = function(self, source, name, value, addCd, isForced)
			Callbacks:ClientCallback(source, "Status:Modify", {
				name = name,
				value = -(math.abs(value)),
				addCd = addCd,
				isForced = isForced,
			})
		end,
	},
	Set = function(self, source, name, value)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local status = char:GetData("Status")
			if status == nil then
				status = {}
			end
			status[name] = value
			char:SetData("Status", status)
			TriggerClientEvent("Status:Client:Update", source, name, value)
		end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Status", STATUS)
end)

RegisterServerEvent("Status:Server:Update", function(data)
	local char = Fetch:CharacterSource(source)
	if char ~= nil then
		local status = char:GetData("Status")
		if status == nil then
			status = {}
		end
		status[data.status] = data.value
		char:SetData("Status", status)
	end
end)

RegisterServerEvent("Status:Server:StoreAll", function(data)
	local char = Fetch:CharacterSource(source)
	if char ~= nil then
		local status = char:GetData("Status") or {}
		for k, v in pairs(data) do
			status[k] = v
		end
		char:SetData("Status", status)
	end
end)
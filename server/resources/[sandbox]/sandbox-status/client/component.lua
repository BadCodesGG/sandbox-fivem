Callbacks = nil
Status = nil
Hud = nil

local _statuses = {}
local _recentCd = {}
local _noResets = {}
local _statusCount = 0
local isEnabled = true

local _statusVals = {}

AddEventHandler("Status:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Hud = exports["sandbox-base"]:FetchComponent("Hud")
	Buffs = exports["sandbox-base"]:FetchComponent("Buffs")
	Status = exports["sandbox-base"]:FetchComponent("Status")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Status", {
		"Callbacks",
		"Logger",
		"Damage",
		"Hud",
		"Buffs",
		"Status",
		"Utils",
		"Polyzone",
		"Notification",
		"Progress",
		"Action",
		"Blips",
		"Animations",
		"Interaction",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterStatuses()
		RegisterOxygenCallbacks()
		RegisterOxygenMenus()
		CreateStressPolys()
		RegisterDrunkCallbacks()

		Callbacks:RegisterClientCallback("Status:Modify", function(data, cb)
			if data.value > 0 then
				Status.Modify:Add(data.name, data.value, data.addCd, data.isForced)
			else
				Status.Modify:Remove(data.name, data.value, data.addCd, data.isForced)
			end
		end)

		Callbacks:RegisterClientCallback("Status:StoreValues", function(data, cb)
			cb(_statusVals)
		end)
	end)
end)

STATUS = {
	Register = function(self, name, max, icon, color, flash, modify, options)
		local update = false
		if _statuses[name] ~= nil then
			update = true
		end

		_statuses[name] = {
			name = name,
			max = max,
			icon = icon,
			color = color,
			flash = flash,
			modify = modify,
			options = options,
		}

		if options ~= nil and options.noReset then
			_noResets[name] = true
		end

		if not update then
			_statusCount = _statusCount + 1
		end
	end,
	GetRegistered = function(self)
		return _statuses
	end,
	Get = {
		All = function(self)
			for k, v in pairs(_statuses) do
				local statuses = _statuses
				for k, v in pairs(_statuses) do
					statuses[k].value = _statusVals[v.name]
				end
				return statuses
			end
		end,
		Single = function(self, name)
			local statuses = _statuses
			for k, v in pairs(_statuses) do
				if v.name == name then
					statuses[k].value = _statusVals[v.name]
					return statuses[k]
				end
			end
		end,
	},
	Set = { -- Really much more performant to just interact directly with Decor natives ... but available just in case?
		All = function(self, entity, value)
			for k, v in pairs(_statuses) do
				_statusVals[v.name] = value
				TriggerEvent("Status:Client:Update", v.name, value)
			end
		end,
		Single = function(self, name, value)
			if _statuses[name] ~= nil then
				_statusVals[name] = value
				TriggerEvent("Status:Client:Update", name, value)
			end
		end,
	},
	Reset = function(self, entity, value)
		for k, v in pairs(_statuses) do
			if not _noResets[v.name] then
				_statusVals[v.name] = v.max
				TriggerEvent("Status:Client:Update", v.name, v.max)
			end
		end
	end,
	Modify = {
		Add = function(self, status, value, addCd, force)
			if _statuses[status] ~= nil then
				if
					_statuses[status].max <= 0
					and (
						LocalPlayer.state[string.format("ignore%s", status)] ~= nil
						and LocalPlayer.state[string.format("ignore%s", status)] > 0
					)
				then
					return
				end

				_statuses[status].modify(math.abs(value), force)

				if addCd then
					_recentCd[status] = 1
				end
			else
				Logger:Error("Status", "Attempt To Add To Non-Existent Status")
			end
		end,
		Remove = function(self, status, value, force)
			if
				_statuses[status].max >= 0
				and (
					LocalPlayer.state[string.format("ignore%s", status)] ~= nil
					and LocalPlayer.state[string.format("ignore%s", status)] > 0
				)
			then
				return
			end

			if _statuses[status] ~= nil then
				_statuses[status].modify(-(math.abs(value)), force)
			else
				Logger:Error("Status", "Attempt To Remove From Non-Existent Status")
			end
		end,
	},
	Toggle = function(self)
		isEnabled = not isEnabled
	end,
	Check = function(self)
		return isEnabled
	end,
}

local spawned = false

RegisterNetEvent("Status:Client:Reset", function()
	Callbacks:ServerCallback("Commands:ValidateAdmin", {}, function(isAdmin)
		if isAdmin then
			for k, v in pairs(_statuses) do
				Status.Set:Single(v.name, v.max)
			end
		end
	end)
end)

local _ts = nil
RegisterNetEvent("Characters:Client:Spawn", function()
	spawned = true
	isEnabled = true

	local ffs = GetCloudTimeAsInt()
	_ts = ffs

	Callbacks:ServerCallback("Status:Get", {}, function(results)
		results = results or {}
		for k, v in pairs(Status:GetRegistered()) do
			local val = results[v.name] or v.max
			_statusVals[v.name] = val
			Hud:RegisterStatus(v.name, val, v.max, v.icon, v.color, v.flash, false, v.options)
		end
	end)

	Citizen.CreateThread(function()
		Citizen.Wait(60000)
		while LocalPlayer.state.loggedIn and _ts == ffs do
			TriggerServerEvent("Status:Server:StoreAll", _statusVals)
			Citizen.Wait(60000)
		end
	end)

	--Spawn Tick Thread
	Citizen.CreateThread(function()
		Citizen.Wait(300000) -- Wait 5 mins before we start ticks
		while LocalPlayer.state.loggedIn and _ts == ffs do
			if isEnabled then
				for k, v in pairs(_statuses) do
					if _recentCd[v.name] == nil or _recentCd[v.name] > 10 then
						_recentCd[v.name] = nil
						v.modify()
					else
						_recentCd[v.name] = _recentCd[v.name] + 1
					end
					Citizen.Wait((100000 / _statusCount)) -- Split tick events across the second-long tick to try to avoid spiking
				end
			end
			Citizen.Wait(0) -- Im just here so you dont crash
		end
	end)

	CreateStressBlips()
end)

AddEventHandler("UI:Client:ResetFinished", function(manual)
	if manual then
		Callbacks:ServerCallback("Status:Get", {}, function(results)
			for k, v in pairs(Status:GetRegistered()) do
				local val = results[v.name] or v.max
	
				_statusVals[v.name] = val
				Hud:RegisterStatus(v.name, val, v.max, v.icon, v.color, v.flash, false, v.options)
			end
		end)
	end
end)

RegisterNetEvent("Characters:Client:Logout", function()
	_ts = nil
	spawned = false
	isEnabled = true
	Hud:ResetStatus()
	_statusVals = {}
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Status", STATUS)
end)

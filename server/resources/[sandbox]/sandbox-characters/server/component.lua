ONLINE_CHARACTERS = {}

AddEventHandler("Characters:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	DataStore = exports["sandbox-base"]:FetchComponent("DataStore")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	GlobalConfig = exports["sandbox-base"]:FetchComponent("Config")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Sequence = exports["sandbox-base"]:FetchComponent("Sequence")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	Apartment = exports["sandbox-base"]:FetchComponent("Apartment")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Punishment = exports["sandbox-base"]:FetchComponent("Punishment")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	RegisterCommands()
	_spawnFuncs = {}
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Characters", {
		"Callbacks",
		"Database",
		"Middleware",
		"DataStore",
		"Logger",
		"Database",
		"Fetch",
		"Logger",
		"Chat",
		"Config",
		"Routing",
		"Sequence",
		"Reputation",
		"Apartment",
		"Phone",
		"Damage",
		"Punishment",
		"Execute",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		RegisterMiddleware()
		Startup()
	end)
end)

CHARACTERS = {
	GetLastLocation = function(self, source)
		return _tempLastLocation[source] or false
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Characters", CHARACTERS)
end)
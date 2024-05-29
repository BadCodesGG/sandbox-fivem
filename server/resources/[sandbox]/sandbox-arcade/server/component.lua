AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Arcade", {
		"Fetch",
		"Database",
		"Callbacks",
		"Logger",
		"Chat",
		"Middleware",
		"Execute",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Callbacks:RegisterServerCallback("Arcade:Open", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				if Player(source).state.onDuty == "avast_arcade" then
					GlobalState["Arcade:Open"] = true
				end
			end
		end)

		Callbacks:RegisterServerCallback("Arcade:Close", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				if Player(source).state.onDuty == "avast_arcade" then
					GlobalState["Arcade:Open"] = false
				end
			end
		end)
	end)
end)

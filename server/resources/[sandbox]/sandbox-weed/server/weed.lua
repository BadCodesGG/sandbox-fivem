_plants = {}

AddEventHandler("Weed:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Locations = exports["sandbox-base"]:FetchComponent("Locations")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	Weed = exports["sandbox-base"]:FetchComponent("Weed")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Tasks = exports["sandbox-base"]:FetchComponent("Tasks")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	WaitList = exports["sandbox-base"]:FetchComponent("WaitList")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Status = exports["sandbox-base"]:FetchComponent("Status")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Weed", {
		"Database",
		"Callbacks",
		"Logger",
		"Middleware",
		"Logger",
		"Execute",
		"Utils",
		"Locations",
		"Game",
		"Routing",
		"Fetch",
		"Weed",
		"Inventory",
		"Routing",
		"Tasks",
		"Wallet",
		"Reputation",
		"WaitList",
		"Chat",
		"Status",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		Startup()
		RegisterMiddleware()
		RegisterCallbacks()
		RegisterTasks()
		RegisterItems()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Weed", WEED)
end)

function getStageByPct(pct)
	local stagePct = 100 / (#Plants - 1)
	return math.floor((pct / stagePct) + 1.5)
end

function checkNearPlant(source, id)
	local coords = GetEntityCoords(GetPlayerPed(source))
	if _plants[id] ~= nil then
		return #(
				vector3(coords.x, coords.y, coords.z)
				- vector3(_plants[id].plant.location.x, _plants[id].plant.location.y, _plants[id].plant.location.z)
			) <= 5
	else
		return false
	end
end

WEED = {
	Planting = {
		Set = function(self, id, isUpdate, skipEvent)
			if _plants[id] ~= nil then
				local stage = getStageByPct(_plants[id].plant.growth)
				_plants[id].stage = stage

				if skipEvent then
					return { id = id, plant = _plants[id], update = isUpdate }
				else
					TriggerClientEvent("Weed:Client:Objects:Update", -1, id, _plants[id], isUpdate)
				end
			end
		end,
		Delete = function(self, id, skipRemove)
			if _plants[id] ~= nil then
				_plants[id] = nil
				TriggerClientEvent("Weed:Client:Objects:Delete", -1, id)
			end
		end,
		Create = function(self, isMale, location, material)
			local p = promise.new()
			local weed = {
				isMale = isMale,
				location = location,
				growth = 0,
				output = 1,
				material = material,
				planted = os.time(),
				water = 100.0,
			}
			Database.Game:insertOne({
				collection = "weed",
				document = weed,
			}, function(success, results, insertedIds)
				if not success then
					return p:resolve(nil)
				end
				weed._id = insertedIds[1]
				return p:resolve(weed)
			end)
			return Citizen.Await(p)
		end,
	},
}

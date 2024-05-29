_requests = {}
_requestors = {}

AddEventHandler("Apartment:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Apartment = exports["sandbox-base"]:FetchComponent("Apartment")
	Police = exports["sandbox-base"]:FetchComponent("Police")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Apartment", {
		"Fetch",
		"Middleware",
		"Callbacks",
		"Logger",
		"Routing",
		"Inventory",
		"Apartment",
		"Police",
		"Pwnzor",
	}, function(error)
		if #error > 0 then
            
			return
		end
		RetrieveComponents()
		RegisterCallbacks()
		RegisterMiddleware()
		Startup()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Apartment", _APTS)
end)

_APTS = {
	Enter = function(self, source, targetType, target, wakeUp)
		local f = false
		local rTarget = target
		if rTarget == -1 then
			local char = Fetch:CharacterSource(source)
			rTarget = char:GetData("SID")
			f = true
		end

		if not f then
			if _requestors[source] ~= nil then
				for k, v in ipairs(_requests[_requestors[source]]) do
					if v.source == source then
						f = true
					end
				end
			end

			if Police:IsInBreach(source, "apartment", rTarget) then
				f = true
			end
		end

		if f then

			Player(source).state.inApartment = {
				type = targetType,
				id = rTarget
			}

			local routeId = Routing:RequestRouteId(string.format("Apartment:%s", rTarget), false)
			Pwnzor.Players:TempPosIgnore(source)
			Routing:AddPlayerToRoute(source, routeId)
			GlobalState[string.format("%s:Apartment", source)] = rTarget
			TriggerClientEvent("Apartment:Client:InnerStuff", source, targetType or 1, rTarget, wakeUp)

			local apartment = GlobalState[string.format("Apartment:%s", targetType or 1)]
			if apartment?.coords then
				Player(source).state.tpLocation = {
					x = apartment.coords.x,
					y = apartment.coords.y,
					z = apartment.coords.z,
				}
			end

			return targetType
		end

		return false
	end,
	Exit = function(self, source)
		Routing:RoutePlayerToGlobalRoute(source)
		GlobalState[string.format("%s:Apartment", source)] = nil
		Pwnzor.Players:TempPosIgnore(source)
		Player(source).state.inApartment = nil
		Player(source).state.tpLocation = nil

		return true
	end,
	GetInteriorLocation = function(self, apartment)
		local apartment = GlobalState[string.format("Apartment:%s", apartment or 1)]
		return apartment?.interior?.spawn
	end,
	Requests = {
		Get = function(self, source)
			if GlobalState[string.format("%s:Apartment", source)] ~= nil then
				return _requests[GlobalState[string.format("%s:Apartment", source)]]
			else
				return {}
			end
		end,
		Create = function(self, source, target, inZone)
			if source == target then return end

			local char = Fetch:CharacterSource(source)
			local tChar = Fetch:SID(target)

			if tChar ~= nil and string.format("apt-%s", tChar:GetData("Apartment") or 1) == inZone then
				_requests[target] = _requests[target] or {}
				for k, v in ipairs(_requests[target]) do
					if v.source == source then
						return
					end
				end
	
				_requestors[source] = target
				table.insert(_requests[target], {
					source = source,
					SID = char:GetData("SID"),
					First = char:GetData("First"),
					Last = char:GetData("Last"),
				})
			end
		end,
	},
}
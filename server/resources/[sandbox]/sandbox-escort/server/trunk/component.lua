AddEventHandler("Trunk:Shared:DependencyUpdate", TrunkComponents)
function TrunkComponents()
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Trunk = exports["sandbox-base"]:FetchComponent("Trunk")
	Escort = exports["sandbox-base"]:FetchComponent("Escort")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Trunk", {
		"Middleware",
		"Callbacks",
		"Trunk",
		"Escort",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		TrunkComponents()

		Callbacks:RegisterServerCallback("Trunk:PutIn", function(source, data, cb)
			local t = Player(source).state.isEscorting

			if t ~= nil then
				Escort:Stop(source)
				Callbacks:ClientCallback(t, "Trunk:GetPutIn", data)
			end
		end)

		Callbacks:RegisterServerCallback("Trunk:PullOut", function(source, data, cb)
			local ent = NetworkGetEntityFromNetworkId(data)
			local entState = Entity(ent).state

			if entState.trunkOccupied then
				Callbacks:ClientCallback(entState.trunkOccupied, "Trunk:GetPulledOut", {}, function()
					Citizen.Wait(500)
					Escort:Do(source, {
						target = entState.trunkOccupied,
						inVeh = false,
					})
				end)
			end
		end)
	end)
end)


local _trunkOccupied = {}
_TRUNK = {
	Enter = function(self, source, netId)
		local pState = Player(source).state
		pState.trunkVeh = netId

		local ent = NetworkGetEntityFromNetworkId(netId)
		if ent then
			local entState = Entity(ent).state
			if not entState.trunkOccupied then
				entState.trunkOccupied = source

				-- GlobalState[string.format("PlayerTrunk:%s", source)] = netId
				-- local t = GlobalState[string.format("Trunk:%s", netId)] or {}
				-- table.insert(t, source)
				-- GlobalState[string.format("Trunk:%s", netId)] = t
			end
		end
	end,
	Exit = function(self, source, netId)
		local pState = Player(source).state

		if pState.trunkVeh then
			local ent = NetworkGetEntityFromNetworkId(pState.trunkVeh)
			if ent then
				local entState = Entity(ent).state
				if entState?.trunkOccupied and entState?.trunkOccupied == source then
					entState.trunkOccupied = nil
				end
			end

			TriggerClientEvent("Trunk:Client:Exit", source)
			pState.trunkVeh = nil
		end

		-- if GlobalState[string.format("Trunk:%s", netId)] ~= nil then
		-- 	local newTable = {}
		-- 	for k, v in ipairs(GlobalState[string.format("Trunk:%s", netId)]) do
		-- 		if source == v then
		-- 			GlobalState[string.format("PlayerTrunk:%s", source)] = nil
		-- 			TriggerClientEvent("Trunk:Client:Exit", source)
		-- 		else
		-- 			table.insert(newTable, v)
		-- 		end
		-- 	end

		-- 	GlobalState[string.format("Trunk:%s", netId)] = newTable
		-- elseif GlobalState[string.format("PlayerTrunk:%s", source)] then -- Car Probably Deleted
		-- 	GlobalState[string.format("PlayerTrunk:%s", source)] = nil
		-- 	TriggerClientEvent("Trunk:Client:Exit", source)
		-- end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Trunk", _TRUNK)
end)

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	local pState = Player(source).state
	if pState.inTrunk then
		Trunk:Exit(source, GlobalState[string.format("PlayerTrunk:%s", source)])
	end
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source, cData)
	local pState = Player(source).state
	if pState.inTrunk then
		Trunk:Exit(source, GlobalState[string.format("PlayerTrunk:%s", source)])
	end
end)

RegisterNetEvent("Trunk:Server:Enter", function(netId)
	Trunk:Enter(source, netId)
end)

RegisterNetEvent("Trunk:Server:Exit", function(netId)
	Trunk:Exit(source, netId)
end)

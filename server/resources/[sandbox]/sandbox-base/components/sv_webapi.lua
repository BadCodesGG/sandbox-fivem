local function _b64enc(data)
	-- character table string
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	return (
		(data:gsub(".", function(x)
			local r, b = "", x:byte()
			for i = 8, 1, -1 do
				r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and "1" or "0")
			end
			return r
		end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
			if #x < 6 then
				return ""
			end
			local c = 0
			for i = 1, 6 do
				c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
			end
			return b:sub(c + 1, c + 1)
		end) .. ({ "", "==", "=" })[#data % 3 + 1]
	)
end

COMPONENTS.WebAPI = {
	_required = { "Enabled", "GetMember" },
	_name = "base",
	Enabled = true,
	Request = function(self, method, endpoint, params, jsondata)
		COMPONENTS.Logger:Trace("WebAPI", "Endpoint Called: " .. method .. " - " .. endpoint)

		local first = true
		if params ~= nil then
			for k, v in pairs(params) do
				if first then
					endpoint = endpoint .. "?" .. k .. "=" .. v
					first = false
				else
					endpoint = endpoint .. "&" .. k .. "=" .. v
				end
			end
		end

		local p = promise.new()

		PerformHttpRequest(
			COMPONENTS.Convar.API_ADDRESS.value .. endpoint,
			function(errorCode, resultData, resultHeaders)
				data = {
					data = resultData,
					code = errorCode,
					headers = resultHeaders,
				}

				-- if data.code ~= nil and data.code ~= 200 then
				-- 	COMPONENTS.Logger:Error("WebAPI", "Error: " .. data.code, { console = true })
				-- end

				if data.data ~= nil then
					data.data = json.decode(data.data)
				end

				p:resolve(data)
			end,
			method,
			#jsondata > 0 and json.encode(jsondata) or "",
			{
				["Content-Type"] = "application/json",
				["Authorization"] = "Basic " .. _b64enc(
					string.format("%s:%s", COMPONENTS.Convar.API_ID.value, COMPONENTS.Convar.API_SECRET.value)
				),
			}
		)

		return Citizen.Await(p)
	end,
	-- Validate = function(self)
	-- 	COMPONENTS.Logger:Trace("Core", "Validating API Key With Authentication Services", {
	-- 		console = true,
	-- 	})

	-- 	local res = COMPONENTS.WebAPI:Request("GET", "admin/startup", nil, {})

	-- 	if res.code ~= 200 then
	-- 		COMPONENTS.Logger:Critical("Core", "Failed Validation, Shutting Down Server", {
	-- 			console = true,
	-- 			file = true,
	-- 		})
	-- 		COMPONENTS.Core:Shutdown("Failed Validation, Shutting Down Server")

	-- 		return false
	-- 	else
	-- 		COMPONENTS.Config.Server = {
	-- 			ID = res.data.id,
	-- 			Name = res.data.name,
	-- 			Access = res.data.restricted,
	-- 			Channel = res.data.channel,
	-- 			Region = res.data.region,
	-- 		}
	-- 		COMPONENTS.Config.Game = {
	-- 			ID = res.data.game.id,
	-- 			Name = res.data.game.name,
	-- 			Short = res.data.game.short,
	-- 		}

	-- 		COMPONENTS.Config.Groups = res.data.groups

	-- 		GlobalState.IsProduction = res.data.channel:upper() ~= "DEV"
	-- 		if COMPONENTS.Config.Server.Access then
	-- 			COMPONENTS.Logger:Trace(
	-- 				"Core",
	-- 				string.format(
	-- 					"Server ^2#%s^7 - ^2%s^7 Authenticated, Running With Access Restrictions",
	-- 					tostring(COMPONENTS.Config.Server.ID),
	-- 					COMPONENTS.Config.Server.Name
	-- 				),
	-- 				{ console = true }
	-- 			)
	-- 		else
	-- 			COMPONENTS.Logger:Info(
	-- 				"Core",
	-- 				string.format(
	-- 					"Server ^2#%s^7 - ^2%s^7 Authenticated, Running With No Access Restriction",
	-- 					tostring(COMPONENTS.Config.Server.ID),
	-- 					COMPONENTS.Config.Server.Name
	-- 				),
	-- 				{ console = true }
	-- 			)
	-- 		end

	-- 		COMPONENTS.Logger:Trace("WebAPI", "Loaded ^5" .. tostring(res.data.count) .. "^7 Group Configurations")

	-- 		return true
	-- 	end
	-- end,
}

COMPONENTS.WebAPI.GetMember = {
	Identifier = function(self, identifier)
		if identifier ~= nil then
			local data = COMPONENTS.WebAPI:Request("GET", "serverAPI/user/identifier", {
				license = identifier,
			}, {})

			if data.code == 200 then
				return data.data
			end
		end
		return nil
	end,
}

-- Endpoint for getting server information to display publicly

local handlerSetup = false
local pendingRestartTime = false

function SetupAPIHandler()
	if not handlerSetup then
		handlerSetup = true

		SetHttpHandler(function(req, res)
			if req.path == "/data" then
				local data = {
					Restart = pendingRestartTime,
					Uptime = GetGameTimer(),
					Players = COMPONENTS.Fetch:Count(),
					MaxPlayers = GlobalState.MaxPlayers or 64,
				}

				if COMPONENTS.Queue then
					data.Queue = COMPONENTS.Queue.Queue:GetCount()
				end

				res.send(json.encode(data))
			end
		end)
	end
end

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
	if type(eventData.secondsRemaining) == "number" then
		pendingRestartTime = os.time() + eventData.secondsRemaining
	end
end)

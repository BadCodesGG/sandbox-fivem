local objects = {}

local signObjects = {
	[1] = {
		model = `prop_sign_road_01a`,
		label = "Stop Sign",
		item = "sign_stop",
	},
	[2] = {
		model = `prop_sign_road_05a`,
		label = "Walking Man Sign",
		item = "sign_walkingman",
	},
	[3] = {
		model = `prop_sign_road_03e`,
		label = "Do Not Block Sign",
		item = "sign_dontblock",
	},
	[4] = {
		model = `prop_sign_road_05e`,
		label = "Left Turn Sign",
		item = "sign_leftturn",
	},
	[5] = {
		model = `prop_sign_road_04a`,
		label = "No Parking Sign",
		item = "sign_nopark",
	},
	[6] = {
		model = `prop_sign_road_restriction_10`,
		label = "No Tresspassing Sign",
		item = "sign_notresspass",
	},
	[7] = {
		model = `prop_sign_road_02a`,
		label = "Yield Sign",
		item = "sign_yield",
	},
	[8] = {
		model = `prop_sign_road_05f`,
		label = "Right Turn Sign",
		item = "sign_rightturn",
	},
	[9] = {
		model = `prop_sign_road_03m`,
		label = "U-Turn Sign",
		item = "sign_uturn",
	},
}

RegisterNetEvent("Robbery:Signs:GetObjects", function(incObjects)
	objects = incObjects
end)

RegisterNetEvent("Characters:Client:Spawned", function()
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			for k = 1, #objects, 1 do
				local v = objects[k]
				local ent =
					GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 0.1, v.model, false, false, false)
				if DoesEntityExist(ent) then
					SetEntityAsMissionEntity(ent, 1, 1)
					DeleteObject(ent)
					SetEntityAsNoLongerNeeded(ent)
				end
			end
			Wait(1000)
		end
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	LocalPlayer.state.ATMRobbery = false
	objects = {}
end)

AddEventHandler("Robbery:Client:Setup", function()
	for k, v in ipairs(signObjects) do
		Targeting:AddObject(v.model, "user-secret", {
			{
				text = string.format("Steal %s", v.label),
				icon = "eye-evil",
				event = "Robbery:Client:Signs:StealSign",
				data = {
					label = v.label,
					model = v.model,
					item = v.item,
				},
				minDist = 2.0,
				isEnabled = function(data, entity)
					if
						entity?.entity
						and not HasObjectBeenBroken(entity?.entity)
						and not LocalPlayer.state.ATMRobbery
					then
						return true
					end
				end,
			},
		}, 3.0)
	end
end)

function DoStealSignsProgress(label, duration, anim, canCancel, cb)
	Progress:Progress({
		name = "robbing_sign",
		duration = duration,
		label = label,
		useWhileDead = false,
		canCancel = canCancel,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = anim,
		},
	}, function(status)
		if cb then
			cb(status)
		end
	end)
end

AddEventHandler("Robbery:Client:Signs:StealSign", function(data, entity)
	local coords = GetEntityCoords(LocalPlayer.state.ped)
	local entityCoords = GetEntityCoords(data.entity)
	local alarm = false
	if not IsSignValid(entity.model) then
		Notification:Error("Not a valid sign.")
		return
	end

	if math.random(100) >= 85 then
		alarm = true
		if coords ~= nil then
			Citizen.SetTimeout(1000, function()
				TriggerServerEvent("Robbery:Server:Signs:AlertPolice", coords)
			end)
		end
	end

	DoStealSignsProgress(
		string.format("Stealing %s", entity.label),
		(math.random(10) + 20) * 1000,
		"weld",
		true,
		function(status)
			if status then
				return
			end

			Minigame.Play:RoundSkillbar(1.0, 5, {
				onSuccess = function(data)
					while LocalPlayer.state.doingAction do -- Apparently this is dumb
						Citizen.Wait(100)
					end

					DoStealSignsProgress(
						string.format("Removing %s from Ground", entity.label),
						(math.random(10) + 10) * 1000,
						"stealsign",
						false,
						function(status)
							Callbacks:ServerCallback(
								"Robbery:Signs:RemoveSign",
								{ coords = entityCoords, model = entity.model, item = entity.item },
								function(success)
									if success then
										TriggerServerEvent("Robbery:Server:Signs:AlertPolice", coords)
									end
								end
							)
						end
					)
				end,
				onFail = function(data)
					while LocalPlayer.state.doingAction do -- Apparently this is dumb
						Citizen.Wait(100)
					end
					TriggerServerEvent("Robbery:Server:Signs:AlertPolice", coords)
				end,
			}, {
				playableWhileDead = false,
				animation = {
					anim = "stealsign",
				},
			}, {})
		end
	)
end)

RegisterNetEvent("Robbery:Client:DeleteSign", function(object)
	objects[#objects + 1] = { coords = object.coords, model = object.model }
	local ent = GetClosestObjectOfType(
		object.coords.x,
		object.coords.y,
		object.coords.z,
		0.1,
		object.model,
		false,
		false,
		false
	)
	if DoesEntityExist(ent) then
		SetEntityAsMissionEntity(ent, 1, 1)
		DeleteObject(ent)
		SetEntityAsNoLongerNeeded(ent)
	end
end)

function IsSignValid(model)
	local _retval = false
	for k, v in ipairs(signObjects) do
		if v.model == model then
			_retval = true
		end
	end
	return _retval
end

function PrintTable(table, indent)
	if type(table) == "table" then
		if not indent then
			indent = 0
		end
		for k, v in pairs(table) do
			formatting = string.rep("  ", indent) .. k .. ": "
			if type(v) == "table" then
				print(formatting)
				PrintTable(v, indent + 1)
			elseif type(v) == "boolean" then
				if v then
					print(formatting .. "true")
				else
					print(formatting .. "false")
				end
			elseif type(v) == "nil" then
				print(formatting .. "nil")
			elseif type(v) == "function" then
				print(formatting .. "function")
			else
				print(formatting .. tostring(v) .. " (" .. type(v) .. ")")
			end
		end
	elseif type(table) == "boolean" then
		if table then
			print("true")
		else
			print("false")
		end
	elseif type(table) == "nil" then
		print("nil")
	elseif type(table) == "function" then
		print("function")
	else
		print(tostring(table) .. " (" .. type(table) .. ")")
	end
end

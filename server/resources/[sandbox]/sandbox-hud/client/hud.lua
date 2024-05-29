local _toggled = false
local _paused = false
local _vehToggled = false
local _overlayToggled = false
local _statuses = {}
local _statusCount = 0

local _idsCd = false
local _zoomLevel = GetResourceKvpInt("zoomLevel") or 3

local _zoomLevels = {
	900,
	1000,
	1100,
	1200,
	1300,
	1400,
}

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(4000)
-- 	if not GetResourceKvpInt("zoomLevel") then
-- 		SetResourceKvpInt("zoomLevel", 3)
-- 		_zoomLevel = 3
-- 		SetRadarZoom(_zoomLevels[3])
-- 	end

-- 	SetRadarZoom(_zoomLevels[_zoomLevel])
-- end)

function GetMinimapAnchor()
	local minimap = {}
	local resX, resY = GetActiveScreenResolution()
	local aspectRatio = GetAspectRatio()
	local scaleX = 1/resX
	local scaleY = 1/resY
	local minimapRawX, minimapRawY
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))
	if IsBigmapActive() then
		minimapRawX, minimapRawY = GetScriptGfxPosition(-0.003975, 0.022 + (-0.460416666))
		minimap.width = scaleX*(resX/(2.52*aspectRatio))
		minimap.height = scaleY*(resY/(2.3374))
	else
		minimapRawX, minimapRawY = GetScriptGfxPosition(-0.0045, -0.0245 + (-0.188888))
		minimap.width = scaleX*(resX/(4*aspectRatio))
		minimap.height = scaleY*(resY/(5.674))
	end
	ResetScriptGfxAlign()
	minimap.leftX = minimapRawX
	minimap.rightX = minimapRawX+minimap.width
	minimap.topY = minimapRawY
	minimap.bottomY = minimapRawY+minimap.height
	minimap.X = minimapRawX+(minimap.width/2)
	minimap.Y = minimapRawY+(minimap.height/2)
	return minimap
end

AddEventHandler("Hud:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Hud = exports["sandbox-base"]:FetchComponent("Hud")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
	Jail = exports["sandbox-base"]:FetchComponent("Jail")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Admin = exports["sandbox-base"]:FetchComponent("Admin")
	Buffs = exports["sandbox-base"]:FetchComponent("Buffs")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hud", {
		"Hud",
		"Callbacks",
		"Action",
		"Progress",
		"Keybinds",
		"ListMenu",
		"Notification",
		"Minigame",
		"Interaction",
		"Utils",
		"Phone",
		"Inventory",
		"Weapons",
		"Jail",
		"Animations",
		"Admin",
		"Buffs",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		-- Hud.Minimap:Set()

	
        SetBlipAlpha(GetNorthRadarBlip(), 0.0)

		SetMinimapComponentPosition("minimap", "L", "B", -0.0045, -0.0245, 0.150, 0.18888)
		SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020, 0.022, 0.111, 0.159)
		SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03, 0.002, 0.266, 0.237)

		SetRadarBigmapEnabled(true, false)
		Citizen.Wait(0)
		SetRadarBigmapEnabled(false, false)
		DisplayRadar(0)

		SendNUIMessage({
			type = "UPDATE_MM_POS",
			data = { position = GetMinimapAnchor() },
		})

		Keybinds:Add("show_interaction", "F1", "keyboard", "Hud - Show Interaction Menu", function()
			Interaction:Show()
		end)

		-- Keybinds:Add("map_zoom_in", "PageUp", "keyboard", "Minimap - Zoom In", function()
		-- 	Hud.Minimap:In()
		-- end)

		-- Keybinds:Add("map_zoom_out", "PageDown", "keyboard", "Minimap - Zoom Out", function()
		-- 	Hud.Minimap:Out()
		-- end)

		Keybinds:Add("ui_toggle", "F11", "keyboard", "Hud - Toggle HUD", function()
			Hud:Toggle()
		end)

		Keybinds:Add("ids_toggle", "u", "keyboard", "Hud - Toggle IDs", function()
			if not _idsCd then
				Hud.ID:Toggle()
			end
		end)

		Callbacks:RegisterClientCallback("HUD:GetTargetInfront", function(data, cb)
			local originCoords = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0, 0.5, -0.5)
			local destinationCoords = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0, 1.0, -0.5)
			local castedRay = StartShapeTestSweptSphere(originCoords, destinationCoords, 1.0, 8, LocalPlayer.state.ped, 4)
			local _, hitting, endCoords, surfaceNormal, entity = GetShapeTestResult(castedRay)

			if hitting == 1 then
				local playerId = NetworkGetPlayerIndexFromPed(entity)
				if playerId ~= 0 then
					cb(GetPlayerServerId(playerId))
				else
					cb(nil)
				end
			else
				cb(nil)
			end
		end)

		Callbacks:RegisterClientCallback("HUD:PutOnBlindfold", function(data, cb)
			Progress:Progress({
				name = "blindfold_action",
				duration = 6000,
				label = data,
				useWhileDead = false,
				canCancel = true,
				disarm = false,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "random@mugging4",
					anim = "struggle_loop_b_thief",
					flags = 49,
				},
			}, function(cancelled)
				cb(not cancelled)
			end)
		end)
	end)
end)

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function hasValue(tbl, value)
	for k, v in ipairs(tbl or {}) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

HUD = {
	_required = { "IsDisabled", "IsDisabledAllowDead", "Show", "Hide", "Toggle", "Vehicle", "RegisterStatus" },
	IsDisabled = function(self)
		return (
				LocalPlayer.state.isDead
				or LocalPlayer.state.isCuffed
				or LocalPlayer.state.doingAction
				or LocalPlayer.state.inventoryOpen
				or LocalPlayer.state.phoneOpen
				or LocalPlayer.state.crafting
				or LocalPlayer.state.isHospitalized
				or LocalPlayer.state.myEscorter ~= nil
				or LocalPlayer.state.InventoryDisabled
			)
	end,
	IsDisabledAllowDead = function(self)
		return (
				LocalPlayer.state.isCuffed
				or LocalPlayer.state.inventoryOpen
				or LocalPlayer.state.phoneOpen
				or LocalPlayer.state.crafting
				or LocalPlayer.state.isHospitalized
				or LocalPlayer.state.InventoryDisabled
			)
	end,
	ForceHP = function(self)
		SendNUIMessage({
			type = "UPDATE_HP",
			data = {
				hp = (GetEntityHealth(LocalPlayer.state.ped) - 100),
				maxHp = (GetEntityMaxHealth(LocalPlayer.state.ped) - 100),
				armor = GetPedArmour(LocalPlayer.state.ped),
			},
		})
	end,
	Show = function(self)
		if _toggled then
			return
		end

		local fuel = nil
		if GLOBAL_VEH ~= nil and DoesEntityExist(GLOBAL_VEH) then
			local vehState = Entity(GLOBAL_VEH).state
			fuel = vehState.Fuel
		end

		local ped = PlayerPedId()
		SendNUIMessage({
			type = "SHOW_HUD",
			data = {
				hp = (GetEntityHealth(ped) - 100),
				maxHp = (GetEntityMaxHealth(ped) - 100),
				armor = GetPedArmour(ped),
				fuel = fuel,
			},
		})
		_toggled = true
		StartThreads()

		if GLOBAL_VEH ~= nil then
			Hud.Vehicle:Show()
		end
	end,
	Hide = function(self)
		if not _toggled then
			return
		end

		SendNUIMessage({
			type = "HIDE_HUD",
		})
		_toggled = false

		if Phone ~= nil and not Phone:IsOpen() then
			DisplayRadar(false)
		end
		Hud.Vehicle:Hide()
	end,
	Toggle = function(self)
		SendNUIMessage({
			type = "TOGGLE_HUD",
		})
		_toggled = not _toggled
		if _toggled then
			StartThreads()

			if GLOBAL_VEH ~= nil then
				Hud.Vehicle:Show()
			else
				Hud.Vehicle:Hide()
			end
		else
			if Phone ~= nil and not Phone:IsOpen() and not hasValue(LocalPlayer.state.Character:GetData("States"), "GPS") then
				DisplayRadar(false)
			end
			Hud.Vehicle:Hide()
		end
	end,
	ShiftLocation = function(self, status)
		SendNUIMessage({
			type = "SHIFT_LOCATION",
			data = { shift = status, position = GetMinimapAnchor() },
		})
	end,
	Overlay = {
		Show = function(self, data)
			if _overlayToggled then
				return
			end

			SendNUIMessage({
				type = "SHOW_OVERLAY",
				data = { data },
			})
			_overlayToggled = true
		end,
		Hide = function(self, data)
			if not _overlayToggled then
				return
			end

			SendNUIMessage({
				type = "HIDE_OVERLAY",
			})
			_overlayToggled = false
		end,
	},
	Vehicle = {
		Show = function(self)
			if _vehToggled then
				return
			end

			SendNUIMessage({
				type = "SHOW_VEHICLE",
				data = {
					position = GetMinimapAnchor()
				}
			})
			_vehToggled = true
			StartVehicleThreads()
		end,
		Hide = function(self)
			if not _vehToggled then
				return
			end

			SendNUIMessage({
				type = "HIDE_VEHICLE",
			})
			_vehToggled = false
		end,
		Toggle = function(self)
			SendNUIMessage({
				type = "TOGGLE_VEHICLE",
			})
			_vehToggled = not _vehToggled
			if _vehToggled then
				StartVehicleThreads()
			end
		end,
	},
	RegisterStatus = function(self, name, current, max, icon, color, flash, update, options)
		local data = {
			name = name,
			max = max,
			value = current,
			icon = icon,
			color = color,
			flash = flash,
			options = options,
		}

		if update then
			SendNUIMessage({
				type = "UPDATE_STATUS",
				data = { status = data },
			})
		else
			SendNUIMessage({
				type = "REGISTER_STATUS",
				data = { status = data },
			})
			_statusCount = _statusCount + 1
		end

		_statuses[name] = data
	end,
	ResetStatus = function(self)
		SendNUIMessage({
			type = "RESET_STATUSES",
		})
	end,
	ID = {
		Toggle = function(self)
			if not _showingIds then
				if not _idsCd then
					ShowIds()
					_idsCd = true
					Citizen.SetTimeout(6000, function()
						HUD.ID:Toggle()
					end)
				end
			else
				_showingIds = false
				Citizen.SetTimeout(10000, function()
					_idsCd = false
				end)
			end
		end,
	},
	-- Minimap = {
	-- 	Set = function(self)
	-- 		SetRadarZoom(_zoomLevels[_zoomLevel])
	-- 	end,
	-- 	In = function(self)
	-- 		if _zoomLevel == 1 then
	-- 			_zoomLevel = #_zoomLevels
	-- 		else
	-- 			_zoomLevel = _zoomLevel - 1
	-- 		end
	-- 		SetResourceKvpInt("zoomLevel", _zoomLevel)
	-- 		SetRadarZoom(_zoomLevels[_zoomLevel])
	-- 	end,
	-- 	Out = function(self)
	-- 		if _zoomLevel == #_zoomLevels then
	-- 			_zoomLevel = 1
	-- 		else
	-- 			_zoomLevel = _zoomLevel + 1
	-- 		end
	-- 		SetResourceKvpInt("zoomLevel", _zoomLevel)
	-- 		SetRadarZoom(_zoomLevels[_zoomLevel])
	-- 	end,
	-- },
	Dead = function(self, state)
		SendNUIMessage({
			type = "SET_DEAD",
			data = {
				state = state,
			},
		})
	end,
	GemTable = {
		Open = function(self, quality)
			SendNUIMessage({
				type = "SHOW_GEM_TABLE",
				data = {
					info = quality
				}
			})
		end,
		Close = function(self)
			SendNUIMessage({
				type = "CLOSE_GEM_TABLE",
				data = {},
			})
		end
	},
	Meth = {
		Open = function(self, config)
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(false)
			SendNUIMessage({
				type = "OPEN_METH",
				data = {
					config = config,
				}
			})
		end,
		Close = function(self)
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			SendNUIMessage({
				type = "CLOSE_METH",
				data = {},
			})
		end,
	},
	DeathTexts = {
		Show = function(self, type, deathTime, timer, keyOverride)
			SendNUIMessage({
				type = "DO_DEATH_TEXT",
				data = {
					key = Keybinds:GetKey(keyOverride or "secondary_action") or 'Unknown',
					f1Key = Keybinds:GetKey(keyOverride or "show_interaction") or 'Unknown',
					type = type,
					deathTime = deathTime,
					timer = timer,
					medicalPrice = 1500 -- (not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0) and 150 or 5000
				},
			})
		end,
		Release = function(self)
			SendNUIMessage({
				type = "DO_DEATH_RELEASING",
				data = {},
			})
		end,
		Hide = function(self)
			SendNUIMessage({
				type = "HIDE_DEATH_TEXT",
				data = {},
			})
		end,
	},
	Flashbang = {
		Do = function(self, duration, strength)
			SendNUIMessage({
				type = "SET_FLASHBANGED",
				data = {
					duration = duration,
					strength = strength,
				}
			})
		end,
		End = function(self)
			SendNUIMessage({
				type = "CLEAR_FLASHBANGED",
			})
		end,
	},
	UpdateVoip = function(self, level, talking, iconOverride)
		SendNUIMessage({
			type = "SET_VOIP_LEVEL",
			data = {
				level = level,
				talking = talking,
				icon = iconOverride,
			}
		})
	end,
	NOS = function(self, level)
		SendNUIMessage({
			type = "UPDATE_NOS",
			data = {
				nos = level,
			}
		})
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Hud", HUD)
end)


AddEventHandler("Characters:Client:Updated", function(key)
	if key == "States" then
		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			DisplayRadar(
				LocalPlayer.state.phoneOpen or hasValue(LocalPlayer.state.Character:GetData("States"), "GPS")
			)
			Hud:ShiftLocation(
				LocalPlayer.state.phoneOpen or hasValue(LocalPlayer.state.Character:GetData("States"), "GPS")
			)
		end
	end
end)

function GetLocation()
	local pos = GetEntityCoords(LocalPlayer.state.ped)

	if LocalPlayer.state?.tpLocation then
		pos = vector3(
			LocalPlayer.state?.tpLocation.x,
			LocalPlayer.state?.tpLocation.y,
			LocalPlayer.state?.tpLocation.z
		)
	end

	local direction = GetDirection(GetEntityHeading(LocalPlayer.state.ped))
	local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local area = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

	return {
		main = GetStreetNameFromHashKey(var1),
		cross = GetStreetNameFromHashKey(var2),
		area = area,
		direction = direction,
	}
end

function GetDirection(heading)
	if (heading >= 0 and heading < 45) or (heading >= 315 and heading < 360) then
		return "N"
	elseif heading >= 45 and heading < 135 then
		return "W"
	elseif heading >= 135 and heading < 225 then
		return "S"
	elseif heading >= 225 and heading < 315 then
		return "E"
	end
end

function DrawText3D(position, text, r, g, b)
	local onScreen, _x, _y = World3dToScreen2d(position.x, position.y, position.z + 1)
	local dist = #(GetGameplayCamCoords() - position)

	local scale = (1 / dist) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		if not useCustomScale then
			SetTextScale(0.0 * scale, 0.55 * scale)
		else
			SetTextScale(0.0 * scale, customScale)
		end
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(r, g, b, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x, _y)
	end
end

_showingIds = false
function ShowIds()
	_showingIds = true
	local nearPlayers = {}

	local showInvisible = LocalPlayer.state.isDev

	Citizen.CreateThread(function()
		while _showingIds do
			for _, data in ipairs(nearPlayers) do
				local targetPed = GetPlayerPed(data.id)
				if data.SID ~= nil and (IsEntityVisible(targetPed) or showInvisible) then
					DrawText3D(GetPedBoneCoords(targetPed, 0), data.SID, 255, 255, 255)
				end
			end
			Citizen.Wait(0)
		end
	end)

	Citizen.CreateThread(function()
		while _showingIds do
			nearPlayers = {}
			local playerCoords = GetEntityCoords(LocalPlayer.state.ped)

			if Admin.NoClip:IsActive() then
				playerCoords = Admin.NoClip:GetPos()
			end

			for _, id in ipairs(GetActivePlayers()) do
				local targetPed = GetPlayerPed(id)
				if DoesEntityExist(targetPed) then
					local source = GetPlayerServerId(id)
					local distance = #(
							vector3(playerCoords.x, playerCoords.y, playerCoords.z)
							- GetEntityCoords(targetPed)
						)
					if distance <= 25 and GlobalState[string.format("SID:%s", source)] ~= nil then
						table.insert(nearPlayers, {
							id = id,
							SID = GlobalState[string.format("SID:%s", source)],
							source = source,
							distance = distance,
						})
					end
				end
			end
			Wait(2000)
		end
	end)
end

function StartThreads()
	Citizen.CreateThread(function()
		while _toggled do
			if IsPauseMenuActive() and not _paused then
				_paused = true

				SendNUIMessage({
					type = "TOGGLE_HUD",
				})

				if _vehToggled then
					SendNUIMessage({
						type = "TOGGLE_VEHICLE",
					})
				end
			end

			if not _paused then
				SendNUIMessage({
					type = "UPDATE_LOCATION",
					data = { location = GetLocation() },
				})
				Citizen.Wait(200)
				SendNUIMessage({
					type = "UPDATE_HP",
					data = {
						hp = (GetEntityHealth(LocalPlayer.state.ped) - 100),
						maxHp = (GetEntityMaxHealth(LocalPlayer.state.ped) - 100),
						armor = GetPedArmour(LocalPlayer.state.ped),
					},
				})
				Citizen.Wait(200)
			else
				if not IsPauseMenuActive() then
					SendNUIMessage({
						type = "TOGGLE_HUD",
					})

					if _vehToggled then
						SendNUIMessage({
							type = "TOGGLE_VEHICLE",
						})
					end
					_paused = false
				end
				Citizen.Wait(400)
			end
		end
	end)
end

function StartVehicleThreads()
	if not _toggled then
		return
	end

	local class = GetVehicleClass(GLOBAL_VEH)

	if class == 8 or class == 13 or class == 14 or class == 15 or class == 16 then
		SendNUIMessage({
			type = "HIDE_SEATBELT",
		})
	else
		SendNUIMessage({
			type = "SHOW_SEATBELT",
		})
	end

	Citizen.CreateThread(function()
		DisplayRadar(true)
		while _vehToggled do
			local speed = math.ceil(GetEntitySpeed(GLOBAL_VEH) * 2.237)
			SendNUIMessage({
				type = "UPDATE_SPEED",
				data = { speed = speed },
			})
			Citizen.Wait(100)
		end

		if LocalPlayer.state.Character ~= nil then
			DisplayRadar(hasValue(LocalPlayer.state.Character:GetData("States"), "GPS"))
		end
	end)

	Citizen.CreateThread(function()
		while _vehToggled do
			if GLOBAL_VEH then
				SendNUIMessage({
					type = "UPDATE_RPM",
					data = { rpm = GetVehicleCurrentRpm(GLOBAL_VEH) },
				})
				Citizen.Wait(10)
			end
		end
	end)

	if GetPedInVehicleSeat(GLOBAL_VEH, -1) ~= LocalPlayer.state.ped then
		Citizen.CreateThread(function()
			local lastIgnition = Entity(GLOBAL_VEH).state?.VEH_IGNITION
			while _vehToggled do
				Citizen.Wait(1000)

				if GLOBAL_VEH then
					local ignitionState = Entity(GLOBAL_VEH).state?.VEH_IGNITION
					if lastIgnition ~= ignitionState then
						lastIgnition = ignitionState

						SendNUIMessage({
							type = "UPDATE_IGNITION",
							data = { ignition = ignitionState },
						})
					end
				end
			end
		end)
	end

	if class ~= 13 then
		Citizen.CreateThread(function()
			while _vehToggled do
				local checkEngine = false

				if GLOBAL_VEH then
					local ent = Entity(GLOBAL_VEH)

					if class ~= 14 and class ~= 15 and class ~= 16 then
						local damageStuff = ent.state.DamagedParts or {}

						for k, v in pairs(damageStuff) do
							if type(v) == "number" and v < 25.0 then
								checkEngine = true
							end
						end
					end

					if GetVehicleEngineHealth(GLOBAL_VEH) <= 400.0 then
						checkEngine = true
					end
				end

				SendNUIMessage({
					type = "UPDATE_ENGINELIGHT",
					data = { checkEngine = checkEngine },
				})

				Citizen.Wait(10000)
			end
		end)
	else
		SendNUIMessage({
			type = "UPDATE_ENGINELIGHT",
			data = { checkEngine = false },
		})
	end

end

-- Citizen.CreateThread(function()
-- 	SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
-- 	SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
-- 	SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
-- 	SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
-- 	SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
-- end)

Citizen.CreateThread(function()
	SetRadarZoom(1200)
end)

-- function DoRadarFix()
-- 	Citizen.CreateThread(function()
-- 		Citizen.Wait(300)
-- 		SetRadarZoom(_zoomLevels[6])
-- 		Citizen.Wait(300)
-- 		SetRadarZoom(_zoomLevels[4])
-- 		Citizen.Wait(300)
-- 		SetRadarZoom(_zoomLevels[1])
-- 		Citizen.Wait(300)
-- 		SetRadarZoom(_zoomLevels[_zoomLevel])
-- 	end)
-- end

AddEventHandler("Keybinds:Client:KeyUp:cancel_action", function()
	if _overlayToggled then
		Hud.Overlay.Hide()
	end
end)
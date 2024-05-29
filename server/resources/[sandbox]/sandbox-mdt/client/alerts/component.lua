local _jobs = {
	police = true,
	prison = true,
	ems = true,
	tow = true,
}

AddEventHandler("EmergencyAlerts:Shared:DependencyUpdate", RetrievePDAComponents)
function RetrievePDAComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	UISounds = exports["sandbox-base"]:FetchComponent("UISounds")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	CCTV = exports["sandbox-base"]:FetchComponent("CCTV")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("MDT", {
		"Callbacks",
		"Logger",
		"Sounds",
		"UISounds",
		"EmergencyAlerts",
		"Notification",
		"Keybinds",
		"Blips",
		"CCTV",
		"Progress",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrievePDAComponents()
		RegisterCallbacks()
		Keybinds:Add("emergency_alerts_toggle", "GRAVE", "keyboard", "Police - Toggle Alerts Panel", function()
			local duty = LocalPlayer.state.onDuty
			if _jobs[duty] and not LocalPlayer.state.isDead then
				EmergencyAlerts:Open()
			end
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("EmergencyAlerts", _pdAlerts)
end)

local _pTs = {
	[6] = true,
	[27] = true,
	[29] = true,
	[28] = true,
}

function isEligiblePed(p, gs, spd)
	if math.random(100) > 15 then
		return false
	end

	if LocalPlayer.state.inCayo then
		return false
	end

	if p == nil or not DoesEntityExist(p) then
		return false
	end

	if IsPedAPlayer(p) then
		return false
	end

	if spd == nil then
		spd = false
	elseif not IsPedInAnyVehicle(p, false) then
		return false
	end

	if p == LocalPlayer.state.ped then
		return false
	end

	if LocalPlayer.state.oxyBuyer ~= nil and LocalPlayer.state.oxyBuyer.ped == p then
		return false
	end

	if GetEntityHealth(p) < GetEntityMaxHealth(p) then
		return false
	end

	local startcoords = GetEntityCoords(p)

	if #(LocalPlayer.state.myPos - startcoords) < 10.0 then
		return false
	end

	if not HasEntityClearLosToEntity(LocalPlayer.state.ped, p, 17) and not gs then
		return false
	end

	if IsPedFatallyInjured(p) then
		return false
	end

	if IsPedArmed(p, 7) then
		return false
	end

	if IsPedInMeleeCombat(p) then
		return false
	end

	if IsPedShooting(p) then
		return false
	end

	if IsPedDucking(p) then
		return false
	end

	if IsPedBeingJacked(p) then
		return false
	end

	if IsPedSwimming(p) then
		return false
	end

	if IsPedJumpingOutOfVehicle(p) or IsPedBeingJacked(p) then
		return false
	end

	local entState = Entity(p).state
	if entState.boughtDrugs then
		return false
	end

	if entState.isDrugBuyer then
		return false
	end

	if entState.crimePed then
		return false
	end

	if _pTs[GetPedType(p)] then
		return false
	end
	return true
end

function nearNpc(dist, isGunshot)
	local handle, ped = FindFirstPed()
	local success
	local retval = nil
	repeat
		local loc = GetEntityCoords(ped)
		local d1 = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - loc)
		if isEligiblePed(ped, isGunshot) and d1 <= dist and (retval == nil or d1 < retval.dist) then
			retval = {
				ped = ped,
				dist = d1,
			}
		end
		success, ped = FindNextPed(handle)
	until not success
	EndFindPed(handle)

	return retval
end

function RegisterCallbacks()
	Callbacks:RegisterClientCallback("EmergencyAlerts:GetStreetName", function(data, cb)
		local x, y, z = table.unpack(data)
		local main, cross = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

		main = GetStreetNameFromHashKey(main)
		cross = GetStreetNameFromHashKey(cross)
		cb({
			street1 = main,
			street2 = intersect,
			area = GetLabelText(GetNameOfZone(x, y, z)),
			x = x,
			y = y,
			z = z,
		})
	end)
end

local ids = 0
_pdAlerts = {
	Open = function(self)
		SendNUIMessage({
			type = "SET_SHOWING",
			data = {
				state = true,
			},
		})
		SetNuiFocus(true, true)
	end,
	Close = function(self)
		SendNUIMessage({
			type = "SET_SHOWING",
			data = {
				state = false,
			},
		})
		SetNuiFocus(false, false)
	end,
	CreateIfReported = function(self, distance, type, isNpcTriggered, description)
		if isNpcTriggered then
			local ped = nearNpc(distance, type == "shotsfired" or type == "shotsfiredvehicle")
			if ped ~= nil then
				TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", type, description)
				return true
			end
			return false
		else
			TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", type, description)
		end
	end,
	CreateClientAlert = function(self, code, title, eType, location, description, isPanic, blip, styleOverride, isArea, camera)
		local alert = {
			id = string.format("local-%s-%s", GetGameTimer(), math.random(1000, 9999)),
			code = code,
			title = title,
			type = eType,
			location = location,
			description = description,
			panic = isPanic,
			blip = blip,
			style = styleOverride or eType,
			camera = camera or false,
			client = true,
			attached = {},
		}

		SendNUIMessage({
			type = "ADD_ALERT",
			data = {
				alert = alert,
			},
		})
	end,
}

RegisterNetEvent("EmergencyAlerts:Client:Open", function()
	EmergencyAlerts:Open()
end)

RegisterNetEvent("EmergencyAlerts:Client:Close", function()
	EmergencyAlerts:Close()
end)

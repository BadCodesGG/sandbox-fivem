_curBed = nil
_done = false

_healEnd = nil
_leavingBed = false

AddEventHandler("Hospital:Shared:DependencyUpdate", HospitalComponents)
function HospitalComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Escort = exports["sandbox-base"]:FetchComponent("Escort")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hospital", {
		"Callbacks",
		"Notification",
		"Damage",
		"Targeting",
		"Hospital",
		"Progress",
		"PedInteraction",
		"Escort",
		"Polyzone",
		"Action",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		HospitalComponents()
		Init()

		while GlobalState["HiddenHospital"] == nil do
			Citizen.Wait(5)
		end

		PedInteraction:Add("HiddenHospital", `s_m_m_doctor_01`, GlobalState["HiddenHospital"].coords, GlobalState["HiddenHospital"].heading, 25.0, {
			{
				icon = "heart-pulse",
				text = "Revive Escort (20 $MALD)",
				event = "Hospital:Client:HiddenRevive",
				data = LocalPlayer.state.isEscorting or {},
				isEnabled = function()
					if LocalPlayer.state.isEscorting ~= nil and not LocalPlayer.state.isDead then
						local ps = Player(LocalPlayer.state.isEscorting).state
						return ps.isDead and not ps.deadData?.isMinor
					else
						return false
					end
				end,
			},
		}, 'suitcase-medical', false, true, {
			animDict = "mp_prison_break",
			anim = "hack_loop",
		})

		Polyzone.Create:Box('hospital-check-in-zone-1', vector3(1146.37, -1538.66, 35.03), 2.8, 1.2, {
			heading = 0,
			--debugPoly=true,
			minZ = 32.63,
  			maxZ = 36.63
		}, {})

		Polyzone.Create:Box('hospital-check-in-zone-2', vector3(1129.59, -1534.96, 35.03), 2.8, 1.2, {
			heading = 3,
			--debugPoly=true,
			minZ = 32.63,
			maxZ = 36.63
		}, {})

		Polyzone.Create:Box('hospital-check-in-zone-3', vector3(1142.82, -1537.74, 39.5), 2.8, 1.2, {
			heading = 88,
			--debugPoly=true,
			minZ = 37.1,
			maxZ = 41.1
		}, {})

		Targeting.Zones:AddBox("icu-checkout", "bell-concierge", vector3(1147.83, -1542.54, 39.5), 2.8, 0.8, {
			name = "hospital",
			heading = 0,
			--debugPoly=true,
			minZ = 38.5,
			maxZ = 41.1
		}, {
			{
				icon = "bell-concierge",
				text = "Request Personnel",
				event = "Hospital:Client:RequestEMS",
				isEnabled = function()
					return (LocalPlayer.state.Character:GetData("ICU") ~= nil and not LocalPlayer.state.Character:GetData("ICU").Released) and (not _done or _done < GetCloudTimeAsInt())
				end,
			}
		})

		Polyzone.Create:Poly("hospital-icu-area", {
			vector2(1144.3436279297, -1541.1220703125),
			vector2(1144.3024902344, -1560.3250732422),
			vector2(1148.193359375, -1560.3918457031),
			vector2(1154.2583007812, -1560.4184570312),
			vector2(1154.3413085938, -1555.5563964844),
			vector2(1154.4481201172, -1548.7468261719),
			vector2(1154.1629638672, -1540.7801513672)
		}, {
			--debugPoly=true,
			minZ = 38.50,
			maxZ = 40.53
		})
	end)
end)

AddEventHandler("Hospital:Client:RequestEMS", function()
	if not _done or _done < GetCloudTimeAsInt() then
		TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", "icurequest")
		_done = GetCloudTimeAsInt() + (60 * 10)
	end
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['sandbox-base']:RegisterComponent('Hospital', HOSPITAL)
end)

local _bedId = nil
HOSPITAL = {
	CheckIn = function(self)
		Callbacks:ServerCallback('Hospital:Treat', {}, function(bed)
			if bed ~= nil then
				_countdown = Config.HealTimer
				LocalPlayer.state:set("isHospitalized", true, true)
				Hospital:SendToBed(Config.Beds[bed], false, bed)
			else
				Notification:Error('No Beds Available')
			end
		end)
	end,
	SendToBed = function(self, bed, isRp, bedId)
		local fuck = false

		if bedId then
			local p = promise.new()
			Callbacks:ServerCallback('Hospital:OccupyBed', bedId, function(s)
				p:resolve(s)
			end)

			fuck = Citizen.Await(p)
		else
			fuck = true
		end

		_bedId = bedId

		if bed ~= nil and fuck then
			TriggerEvent("PAC:IgnoreNextNoclipFlag")
			SetBedCam(bed)
			if isRp then
				_healEnd = GetCloudTimeAsInt()
				Hud.DeathTexts:Show("hospital_rp", GetCloudTimeAsInt(), _healEnd, "primary_action")
			else
				_healEnd = GetCloudTimeAsInt() + (60 * 1)
				Hud.DeathTexts:Show("hospital", GetCloudTimeAsInt(), _healEnd, "primary_action")
				Citizen.SetTimeout(((_healEnd - GetCloudTimeAsInt()) - 10) * 1000, function()
					if LocalPlayer.state.loggedIn and LocalPlayer.state.isHospitalized then
						LocalPlayer.state.deadData = {}
						Damage.Reductions:Reset()
						Damage:Revive()
					end
				end)
			end
		else
			Notification:Error('Invalid Bed or Bed Occupied')
		end
	end,
	FindBed = function(self, object)
		local coords = GetEntityCoords(object)
		Callbacks:ServerCallback('Hospital:FindBed', coords, function(bed)
			if bed ~= nil then
				Hospital:SendToBed(Config.Beds[bed], true, bed)
			else
				Hospital:SendToBed({
					x = coords.x,
					y = coords.y,
					z = coords.z,
					h = GetEntityHeading(object),
					freeBed = true,
				}, true)
			end
		end)
	end,
	LeaveBed = function(self)
		Callbacks:ServerCallback('Hospital:LeaveBed', _bedId, function()
			_bedId = nil
		end)
	end,
}

local _inCheckInZone = false

AddEventHandler('Polyzone:Enter', function(id, point, insideZone, data)
    if id == 'hospital-check-in-zone-1' or id == 'hospital-check-in-zone-2' or id == 'hospital-check-in-zone-3' then
        _inCheckInZone = true

		if not LocalPlayer.state.isEscorted and (GlobalState["ems:pmc:doctor"] == nil or GlobalState["ems:pmc:doctor"] == 0) then
			if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
				Action:Show("medical", '{keybind}primary_action{/keybind} Check In {key}$1500{/key}')
			else
				Action:Show("medical", '{keybind}primary_action{/keybind} Check In {key}$1500{/key}')
			end
		end
    end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZone, data)
    if id == 'hospital-check-in-zone-1' or id == 'hospital-check-in-zone-2' or id == 'hospital-check-in-zone-3' then
        _inCheckInZone = false
		Action:Hide("medical")
	elseif id == "hospital-icu-area" and LocalPlayer.state.loggedIn then
		if LocalPlayer.state.Character:GetData("ICU") and not LocalPlayer.state.Character:GetData("ICU").Released then
			TriggerEvent("Hospital:Client:ICU:Enter")
		end
    end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
    if _inCheckInZone then
		if not LocalPlayer.state.doingAction and not LocalPlayer.state.isEscorted and (GlobalState["ems:pmc:doctor"] == nil or GlobalState["ems:pmc:doctor"] == 0) then
			TriggerEvent('Hospital:Client:CheckIn')
		end
	else
		if _curBed ~= nil and LocalPlayer.state.isHospitalized and GetCloudTimeAsInt() > _healEnd and not _leavingBed then
			_leavingBed = true
			Hud.DeathTexts:Release()
			LeaveBed()
		end
	end
end)
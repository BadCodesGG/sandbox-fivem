function PrisonVisitation()
	Polyzone.Create:Box("prison_visitation", vector3(1831.24, 2585.78, 46.01), 12.4, 8.2, {
		heading = 0,
		--debugPoly=true,
		minZ = 44.21,
		maxZ = 49.01,
	}, {
		disableEscorting = true,
		disableInventory = true,
		allowJobs = { "ems", "prison", "police" },
	})
end

function PrisonHospitalInit()
	PedInteraction:Add(
		"PrisonHospital",
		`s_m_m_doctor_01`,
		vector3(1769.832, 2571.891, 44.730),
		138.556,
		Config.PrisonCheckIn.Radius,
		{
			{
				icon = "heart-pulse",
				text = "Medical Attention - $150",
				event = "Hospital:Client:PrisonHospitalRevive",
				data = {},
				isEnabled = function()
					-- if not LocalPlayer.state.isEscorted then
					-- 	return true
					-- end
					-- return false
					return false
				end,
			},
		},
		"suitcase-medical",
		"WORLD_HUMAN_CLIPBOARD"
	)

	Polyzone.Create:Box(
		"prison-hospital-check-in-zone",
		Config.PrisonCheckIn.Coords,
		Config.PrisonCheckIn.Width,
		Config.PrisonCheckIn.Length,
		{
			heading = Config.PrisonCheckIn.Heading,
			--debugPoly=true,
			minZ = Config.PrisonCheckIn.Coords.z - 1.0,
			maxZ = Config.PrisonCheckIn.Coords.z + 1.0,
		},
		{}
	)
end

local _inCheckInZone = false

AddEventHandler("Polyzone:Enter", function(id, point, insideZone, data)
	if id == "prison-hospital-check-in-zone" then
		_inCheckInZone = true
		if not LocalPlayer.state.isEscorted then
			Action:Show(
				"medical",
				"{keybind}primary_action{/keybind} Check In {key}$" .. Config.PrisonCheckIn.Cost .. "{/key}"
			)
		end
	end

	if id == "prison_visitation" and not hasValue(data.allowJobs, LocalPlayer.state.onDuty) then
		if data.disableEscorting then
			LocalPlayer.state:set("AllowEscorting", false, true)
		end
		if data.disableInventory then
			Inventory:Disable()
		end
	end
end)

AddEventHandler("Polyzone:Exit", function(id, point, insideZone, data)
	if id == "prison-hospital-check-in-zone" then
		_inCheckInZone = false
		Action:Hide("medical")
	end
	if id == "prison_visitation" then
		if data.disableEscorting then
			LocalPlayer.state:set("AllowEscorting", true, true)
		end
		if data.disableInventory then
			Inventory:Enable()
		end
	end
end)

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
	if _inCheckInZone then
		if not LocalPlayer.state.doingAction and not LocalPlayer.state.isEscorted then
			TriggerEvent("Hospital:Client:PrisonHospitalRevive")
		end
	end
end)

AddEventHandler("Hospital:Client:PrisonHospitalRevive", function(entity, data)
	local _animDict = "move_m@_idles@shake_off"
	local _anim = "shakeoff_1"
	local _animFlag = 49
	local _animTask = ""
	local _animObj = {}

	_animObj = {
		animDict = _animDict,
		anim = _anim,
		flags = _animFlag,
	}

	if LocalPlayer.state.isDead then
		_animObj = {
			animDict = "dead",
			anim = "dead_d",
			flags = 1,
		}
	end

	Progress:Progress({
		name = "prison_hospital_revive_action",
		duration = (math.random(10) + 45) * 1000,
		label = "Healing",
		useWhileDead = true,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = _animObj.animDict,
			anim = _animObj.anim,
			flags = _animObj.flag,
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Hospital:PrisonHospitalRevive", {}, function(s)
				if s then
					Escort:StopEscort()
				end
			end)
		end
	end)
end)

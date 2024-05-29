_inPursuitVehicle = false
_inPursuitVehicleSettings = nil
_inPursuitVehicleMode = 1
_inPursuitVehicleMegaphone = false

AddEventHandler("Characters:Client:Spawn", function()
    Citizen.Wait(500)
    Buffs:RegisterBuff("pursuit-modes", "gauge-circle-bolt", "#892020", -1, "permanent")
end)

local _timeout = false

AddEventHandler('Vehicles:Client:StartUp', function()

	Interaction:RegisterMenu("vehicle-megaphone", false, "megaphone", function(data)
		Interaction:Hide()
		_inPursuitVehicleMegaphone = not _inPursuitVehicleMegaphone
		Entity(_inPursuitVehicle).state:set('VehicleMegaphone', _inPursuitVehicleMegaphone, true)
		Callbacks:ServerCallback("Vehicles:Server:VehicleMegaphone", {}, function(data, cb)
		end)
	end, function()
        return _inPursuitVehicle
    end)

    Interaction:RegisterMenu("pursuit-modes", false, "car-on", function(data)
        if _inPursuitVehicleSettings then
            local menu = {}
            for k,v in pairs(_inPursuitVehicleSettings) do
                table.insert(menu, {
                    icon = "gauge-high",
                    label = string.format("%s Class", v.name),
                    action = function()
                        Interaction:Hide()
                        
                        _inPursuitVehicleMode = k
                        UISounds.Play:FrontEnd(-1, "Business_Restart", "DLC_Biker_Computer_Sounds")
                        Notification:Standard("Switched to Pursuit Mode " .. v.name)
                        ApplyPursuitStuffToVehicle(_inPursuitVehicleMode)

                        Entity(_inPursuitVehicle).state:set('PursuitMode', _inPursuitVehicleMode, true)

                        --TriggerServerEvent("EmergencyAlerts:Server:PursuitModeChange", v.name or _inPursuitVehicleMode)
                        TriggerEvent("EmergencyAlerts:Client:PursuitModeChange", v.name or _inPursuitVehicleMode)
                    end,
                })
            end

            Interaction:ShowMenu(menu)
        end
    end, function()
        return _inPursuitVehicleSettings
    end)

    Keybinds:Add('vehicle_pursuit_modes', '', 'keyboard', 'Vehicle - Pursuit Modes', function()
		if _inPursuitVehicle and _timeout then
			Notification:Error("Cannot switch modes that quickly.")
			return
		end
        if _inPursuitVehicle and not _timeout then
            if (_inPursuitVehicleMode + 1) <= #_inPursuitVehicleSettings then
                _inPursuitVehicleMode += 1
            else
                _inPursuitVehicleMode = 1
            end

            UISounds.Play:FrontEnd(-1, "Business_Restart", "DLC_Biker_Computer_Sounds")
            Notification:Standard("Switched to Pursuit Mode " .. _inPursuitVehicleSettings[_inPursuitVehicleMode].name or _inPursuitVehicleMode)
            ApplyPursuitStuffToVehicle(_inPursuitVehicleMode)

            Entity(_inPursuitVehicle).state:set('PursuitMode', _inPursuitVehicleMode, true)

            --TriggerServerEvent("EmergencyAlerts:Server:PursuitModeChange", _inPursuitVehicleSettings[_inPursuitVehicleMode].name or _inPursuitVehicleMode)
            TriggerEvent("EmergencyAlerts:Client:PursuitModeChange", _inPursuitVehicleSettings[_inPursuitVehicleMode].name or _inPursuitVehicleMode)

            _timeout = true
            Citizen.SetTimeout(2000, function()
                _timeout = false
            end)
        end
    end)

    AddTaskBeforeVehicleThread('pursuit-modes', function(veh, class)
        local pVeh = _pursuitModeConfig[GetEntityModel(veh)]
        if pVeh then
            _inPursuitVehicle = veh
            _inPursuitVehicleMode = 1
            _inPursuitVehicleSettings = pVeh

            local lastPursuitMode = Entity(veh)?.state?.PursuitMode
            if lastPursuitMode ~= nil and lastPursuitMode <= #_inPursuitVehicleSettings then
                _inPursuitVehicleMode = lastPursuitMode

                UISounds.Play:FrontEnd(-1, "Business_Restart", "DLC_Biker_Computer_Sounds")
                Notification:Standard("Switched to Pursuit Mode " .. _inPursuitVehicleSettings[_inPursuitVehicleMode].name or _inPursuitVehicleMode)

                ApplyPursuitStuffToVehicle(lastPursuitMode)

                --TriggerServerEvent("EmergencyAlerts:Server:PursuitModeChange", _inPursuitVehicleSettings[_inPursuitVehicleMode].name or _inPursuitVehicleMode)
                TriggerEvent("EmergencyAlerts:Client:PursuitModeChange", _inPursuitVehicleSettings[_inPursuitVehicleMode].name or _inPursuitVehicleMode)
            else
                -- Apply Lowest Pursuit Mode
                print("Applying Lowest Pursuit Mode")
                ApplyPursuitStuffToVehicle(1)
            end
        end
    end)

    AddTaskToVehicleThread('pursuit-modes', 100, true, function(veh, class, running, inside, onExit)
        if _inPursuitVehicle then
            if onExit then
				_inPursuitVehicleMegaphone = false
				local lastVehicleMegaphone = Entity(veh)?.state?.VehicleMegaphone
				if lastVehicleMegaphone == true then
					Callbacks:ServerCallback("Vehicles:Server:VehicleMegaphone", function(data, cb)
					end)
				end

                _inPursuitVehicle = false
                _inPursuitVehicleMode = 1
                _inPursuitVehicleSettings = nil

                RemovePursuitStuffFromVehicle(veh)
                SetVehicleLights(veh, 0)
            else

            end
        end
    end, true)
end)

function ApplyPursuitStuffToVehicle(mode)
    if mode <= #_inPursuitVehicleSettings then

        local modeSettings = _inPursuitVehicleSettings[mode]

        ResetVehicleHandlingOverrides(_inPursuitVehicle)

        if modeSettings?.handling then
            for k, v in ipairs(modeSettings.handling) do
                if v.multiplier then
                    SetVehicleHandlingOverrideMultiplier(_inPursuitVehicle, v.field, v.fieldType, v.value)
                else
                    SetVehicleHandlingOverride(_inPursuitVehicle, v.field, v.fieldType, v.value)
                end
            end
        end

        if modeSettings?.topSpeed then
            VEHICLE_TOP_SPEED = modeSettings.topSpeed / 2.237
        else
            VEHICLE_TOP_SPEED = 250.0
        end

        SetVehicleModKit(_inPursuitVehicle, 0)
        for k, v in pairs(_performanceUpgrades) do
            if k == "turbo" then
                ToggleVehicleMod(_inPursuitVehicle, v, modeSettings?.performance?.turbo or false)
            else
                SetVehicleMod(_inPursuitVehicle, v, modeSettings?.performance?[k] or -1, false)
            end
        end

        if mode > 1 then
            SetVehicleLights(_inPursuitVehicle, 2)
            ToggleVehicleMod(_inPursuitVehicle, 22, true)

			-- mode 1 = D
			-- mode 2 = C
			-- mode 3 = B
			-- mode 4 = A
			-- mode 5 = S

            if mode == 2 then
				SetVehicleDashboardColour(_inPursuitVehicle, 4)
			elseif mode == 3 then
				SetVehicleDashboardColour(_inPursuitVehicle, 99)
			elseif mode == 4 then
				SetVehicleDashboardColour(_inPursuitVehicle, 83)
			elseif mode == 5 then
				SetVehicleDashboardColour(_inPursuitVehicle, 27)
			end

            if mode >= 4 then
                SetVehicleXenonLightsColor(_inPursuitVehicle, 0)
            else
                SetVehicleXenonLightsColor(_inPursuitVehicle, -1)
            end
        else
            SetVehicleLights(_inPursuitVehicle, 0)
            ToggleVehicleMod(_inPursuitVehicle, 22, false)
			SetVehicleDashboardColour(_inPursuitVehicle, 0)
        end

        -- if _inPursuitVehicleSettings[_inPursuitVehicleMode] and _inPursuitVehicleSettings[_inPursuitVehicleMode].name then
        --     local name = _inPursuitVehicleSettings[_inPursuitVehicleMode].name

        --     SetVehsicleNeonLightEnabled(_inPursuitVehicle, 0, true)
		-- 	SetVehicleNeonLightEnabled(_inPursuitVehicle, 1, true)
		-- 	SetVehicleNeonLightEnabled(_inPursuitVehicle, 2, true)
		-- 	SetVehicleNeonLightEnabled(_inPursuitVehicle, 3, true)

        --     if name == "D" then
        --         SetVehicleNeonLightsColour(_inPursuitVehicle, 235, 113, 218)
        --     elseif name == "C" then
        --         SetVehicleNeonLightsColour(_inPursuitVehicle, 255, 255, 255)
        --     elseif name == "B" then
        --         SetVehicleNeonLightsColour(_inPursuitVehicle, 255, 255, 255)
        --     elseif name == "A" then
        --         SetVehicleNeonLightsColour(_inPursuitVehicle, 0, 0, 255)
        --     elseif name == "S" then
        --         SetVehicleNeonLightsColour(_inPursuitVehicle, 255, 0, 0)
        --     end
        -- end

        if mode > 1 then
            local percentage = (100 / (#_inPursuitVehicleSettings - 1)) * (mode - 1)

            print(_inPursuitVehicleSettings[_inPursuitVehicleMode].name)
            Buffs:ApplyUniqueBuff("pursuit-modes", -1, _inPursuitVehicleSettings[_inPursuitVehicleMode].name)
            --TriggerEvent("Status:Client:Update", "pursuit-modes", percentage)
        else
            Buffs:RemoveBuffType("pursuit-modes")
            --TriggerEvent("Status:Client:Update", "pursuit-modes", 0)
        end
    end
end

function RemovePursuitStuffFromVehicle(veh)
    SetVehicleModKit(veh, 0)
    for k, v in pairs(_performanceUpgrades) do
        if k == "turbo" then
            ToggleVehicleMod(veh, v, false)
        else
            SetVehicleMod(veh, v, -1, false)
        end
    end

    SetVehicleLights(veh, 0)
    ToggleVehicleMod(veh, 22, false)

    Buffs:RemoveBuffType("pursuit-modes")
    --TriggerEvent("Status:Client:Update", "pursuit-modes", 0)
end
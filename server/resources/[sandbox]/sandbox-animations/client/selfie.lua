local _selfie = false
local _frontie = true

RegisterNetEvent("Animations:Client:Selfie", function(toggle)
	if toggle ~= nil then
		if toggle then
			StartSelfieMode()
		else
			StopSelfieMode()
		end
	else
		if _selfie then
			StopSelfieMode()
		else
			StartSelfieMode()
		end
	end
end)

function StartSelfieMode()
	if not _selfie and not LocalPlayer.state.doingAction then
		_selfie = true
		Notification.Persistent:Info(
			"camera-info-notif",
			string.format("Camera - Press %s to take a Selfie", Keybinds:GetKey("primary_action"))
				.. "<br/>"
				.. string.format("Camera - Press %s to flip the camera", Keybinds:GetKey("secondary_action"))
				.. "<br/>"
				.. string.format("Camera - Press %s to cancel", Keybinds:GetKey("emote_cancel")),
			"camera"
		)
		Inventory:Disable()
		Hud:Hide()
		DestroyMobilePhone()
		Citizen.Wait(10)
		CreateMobilePhone(0)
		CellCamActivate(true, true)
		CellCamDisableThisFrame(true)
	end
end

function StopSelfieMode()
	if _selfie then
		Notification.Persistent:Remove("camera-info-notif")
		DestroyMobilePhone()
		Citizen.Wait(10)
		CellCamDisableThisFrame(false)
		CellCamActivate(false, false)
		Inventory:Enable()
		Hud:Show()
		_selfie = false
		_frontie = true
	end
end

RegisterNetEvent("Selfie:DoCloseSelfie", function()
	DestroyMobilePhone()
	CellCamActivate(false, false)
	StopSelfieMode()
end)

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
	if _selfie then
		TriggerServerEvent("Selfie:CaptureSelfie")
	end
end)

AddEventHandler("Keybinds:Client:KeyUp:secondary_action", function()
	if _selfie then
		_frontie = not _frontie
		CellFrontCamActivate(_frontie)
		-- if _frontie == false then
		-- 	Animations.Emotes:Play("filmshocking", false, false, false)
		-- else
		-- 	Animations.Emotes:ForceCancel()
		-- end
	end
end)

AddEventHandler("Keybinds:Client:KeyUp:cancel_action", function()
	if _selfie then
		StopSelfieMode()
	end
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

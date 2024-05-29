local _maxDist = 5.0
local _gizmoCam = false

function RotationToDirection(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z,
	}
	local direction = {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x),
	}
	return direction
end

function PlaceCast()
	local distance = 100.0
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = {
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance,
	}

	local a, hit, hitcoords, _, material, entity = GetShapeTestResultIncludingMaterial(
		StartExpensiveSynchronousShapeTestLosProbe(
			cameraCoord.x,
			cameraCoord.y,
			cameraCoord.z,
			destination.x,
			destination.y,
			destination.z,
			-1,
			LocalPlayer.state.ped,
			0
		)
	)
	return hit, hitcoords, material, entity
end

function InstructionButton(ControlButton)
	N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

function InstructionScaleform(scaleform, showFurnitureButtons, showGizmoButtons)
	if createdCamera ~= 0 then
		local scaleform = RequestScaleformMovie(scaleform)
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
		PopScaleformMovieFunctionVoid()

		if showFurnitureButtons then
			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(9)
			InstructionButton(GetControlInstructionalButton(0, GetHashKey("+furniture_prev") | 0x80000000, 1))
			InstructionButtonMessage("Prev. Item")
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(8)
			InstructionButton(GetControlInstructionalButton(0, GetHashKey("+furniture_next") | 0x80000000, 1))
			InstructionButtonMessage("Next Item")
			PopScaleformMovieFunctionVoid()
		end

		if showGizmoButtons then
			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(7)
			InstructionButton(GetControlInstructionalButton(0, 21, 1))
			InstructionButtonMessage("Ground Align")
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(6)
			InstructionButton(GetControlInstructionalButton(0, GetHashKey("+gizmoCameraToggle") | 0x80000000, 1))
			InstructionButtonMessage("Toggle Camera")
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(5)
			InstructionButton(GetControlInstructionalButton(0, 36, 1))
			InstructionButtonMessage("Rotate Reset")
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(4)
			InstructionButton(GetControlInstructionalButton(0, GetHashKey("+gizmoRotation") | 0x80000000, 1))
			InstructionButtonMessage("Rotate Mode")
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(3)
			InstructionButton(GetControlInstructionalButton(0, GetHashKey("+gizmoTranslation") | 0x80000000, 1))
			InstructionButtonMessage("Translate Mode")
			PopScaleformMovieFunctionVoid()
		end

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(2)
		InstructionButton(GetControlInstructionalButton(0, GetHashKey("+cancel_action") | 0x80000000, 1))
		InstructionButtonMessage(showFurnitureButtons and "Cancel" or "Cancel Placement")
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(1)
		InstructionButton(GetControlInstructionalButton(0, GetHashKey("+primary_action") | 0x80000000, 1))
		InstructionButtonMessage(showFurnitureButtons and "Place" or "Place Object")
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(80)
		PopScaleformMovieFunctionVoid()

		return scaleform
	else
		return false
	end
end

function RunPlacementThread(
	model,
	canPlaceInside,
	useGizmo,
	showFurnitureButtons,
	startCoords,
	startHeading,
	startRotation,
	maxDistOverride
)
	loadModel(model)
	_maxDist = 5.0
	_gizmoCam = false
	local myPed = PlayerPedId()
	local myPos = GetOffsetFromEntityInWorldCoords(myPed, 0.0, 2.5, 0.0)

	if maxDistOverride then
		_maxDist = maxDistOverride
	end

	local obj = CreateObject(model, myPos.x, myPos.y, myPos.z, false, true, false)
	DisableCamCollisionForEntity(obj)
	SetEntityCompletelyDisableCollision(obj, false, true)

	FreezeEntityPosition(obj, true)
	SetEntityAlpha(obj, 185, true)
	SetEntityDrawOutlineColor(255, 255, 255, 175)
	SetEntityDrawOutline(obj, true)

	if startCoords then
		SetEntityCoords(obj, startCoords.x, startCoords.y, startCoords.z)
	end

	local rotate = GetEntityHeading(myPed)
	if startRotation then
		SetEntityRotation(obj, startRotation.x, startRotation.y, startRotation.z)
	elseif startHeading then
		rotate = startHeading
		SetEntityHeading(obj, startHeading)
	end

	if not useGizmo then
		Citizen.CreateThread(function()
			while _placeData ~= nil and _placing do
				if IsPedInAnyVehicle(myPed) then
					ObjectPlacer:Cancel()
				end

				local instructions = InstructionScaleform("instructional_buttons", showFurnitureButtons)
				DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)

				if IsControlPressed(1, 181) then
					local amount = IsControlPressed(1, 21) and 1.0 or 5.0
					if rotate >= 360.0 then
						rotate = 0.0
					else
						rotate += amount
					end
				elseif IsControlPressed(1, 180) then
					local amount = IsControlPressed(1, 21) and 1.0 or 5.0
					if rotate <= 0.0 then
						rotate = 360.0
					else
						rotate -= amount
					end
				end

				myPos = GetEntityCoords(myPed)
				local hit, coords, material, entity = PlaceCast()

				if hit then
					SetEntityCoords(obj, coords.x, coords.y, coords.z, 0, 0, 0, false)

					if stupidFlag then
						PlaceObjectOnGroundProperly(obj)
					end

					SetEntityHeading(obj, rotate)
				end

				isValid = hit
					and (not IsEntityAVehicle(entity) and not IsEntityAPed(entity))
					and #(coords - myPos) <= _maxDist
					and (
						canPlaceInside == true
						or (canPlaceInside == 2 and not LocalPlayer.state.tpLocation)
						or (GetInteriorFromEntity(myPed) == 0 and GetInteriorFromEntity(obj) == 0)
					)

				StopEntityFire(obj)

				if isValid then
					SetEntityDrawOutlineColor(0, 255, 0, 175)
					placementCoords = {
						coords = coords,
						rotation = rotate,
					}
				else
					SetEntityDrawOutlineColor(255, 0, 0, 175)
					placementCoords = nil
				end

				Citizen.Wait(1)
			end

			DeleteObject(obj)
		end)
	else
		EnterCursorMode()
		exports["sandbox-objects"]:prepareGizmo(obj)

		Citizen.CreateThread(function()
			while _placeData ~= nil and _placing do
				if IsPedInAnyVehicle(myPed) then
					ObjectPlacer:Cancel()
				end

				local instructions = InstructionScaleform("instructional_buttons", showFurnitureButtons, true)
				DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
				DisableControls()

				if IsDisabledControlJustReleased(0, 36) then -- INPUT_DUCK
					SetEntityRotation(obj, 0.0, 0.0, 0.0)
					exports["sandbox-objects"]:prepareGizmo(obj)
				elseif IsDisabledControlJustReleased(0, 21) then -- INPUT_SPRINT
					PlaceObjectOnGroundProperly(obj)
					exports["sandbox-objects"]:prepareGizmo(obj)
				end

				myPos = GetEntityCoords(myPed)
				if not _gizmoCam then
					exports["sandbox-objects"]:drawGizmo(obj)
				end

				isValid = #(GetEntityCoords(obj) - myPos) <= _maxDist
					and (
						canPlaceInside == true
						or (canPlaceInside == 2 and not LocalPlayer.state.tpLocation)
						or (GetInteriorFromEntity(myPed) == 0 and GetInteriorFromEntity(obj) == 0)
					)

				StopEntityFire(obj)

				if isValid then
					SetEntityDrawOutlineColor(0, 255, 0, 175)
					placementCoords = {
						coords = GetEntityCoords(obj),
						rotation = GetEntityRotation(obj),
					}
				else
					SetEntityDrawOutlineColor(255, 0, 0, 175)
					placementCoords = nil
				end

				Citizen.Wait(1)
			end

			if _gizmoCam then
				EnterCursorMode()
				Citizen.Wait(100)
			end
			LeaveCursorMode()
			DeleteObject(obj)
		end)
	end
end

RegisterCommand("+gizmoCameraToggle", function()
	if _placeData ~= nil and _placing then
		if _gizmoCam then
			_gizmoCam = false
			EnterCursorMode()
		else
			_gizmoCam = true
			LeaveCursorMode()
		end
	end
end)

RegisterCommand("-gizmoCameraToggle", function() end)

function DisableControls()
	DisableControlAction(0, 30, true) -- disable left/right
	DisableControlAction(0, 31, true) -- disable forward/back
	DisableControlAction(0, 36, true) -- INPUT_DUCK
	DisableControlAction(0, 21, true) -- disable sprint
	DisableControlAction(0, 26, true) -- look behind
	DisableControlAction(0, 44, true) -- disable cover
	DisableControlAction(0, 63, true) -- veh turn left
	DisableControlAction(0, 64, true) -- veh turn right
	DisableControlAction(0, 71, true) -- veh forward
	DisableControlAction(0, 72, true) -- veh backwards
	DisableControlAction(0, 75, true) -- disable exit vehicle
	DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
	DisableControlAction(0, 24, true) -- disable attack
	DisableControlAction(0, 25, true) -- disable aim
	DisableControlAction(1, 37, true) -- disable weapon select
	DisableControlAction(0, 47, true) -- disable weapon
	DisableControlAction(0, 58, true) -- disable weapon
	DisableControlAction(0, 140, true) -- disable melee
	DisableControlAction(0, 141, true) -- disable melee
	DisableControlAction(0, 142, true) -- disable melee
	DisableControlAction(0, 143, true) -- disable melee
	DisableControlAction(0, 263, true) -- disable melee
	DisableControlAction(0, 264, true) -- disable melee
	DisableControlAction(0, 257, true) -- disable melee
end

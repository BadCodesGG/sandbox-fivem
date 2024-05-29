function GetVehicleProperties(vehicle, initSetup)
	if DoesEntityExist(vehicle) then
		local paintType1, _, _ = GetVehicleModColor_1(vehicle)
		local paintType2, _, _ = GetVehicleModColor_2(vehicle)
		local chameleonColor = GetVehicleColours(vehicle)

		local color1, color2 = {}, {}
		color1["r"], color1["g"], color1["b"] = GetVehicleCustomPrimaryColour(vehicle)
		color2["r"], color2["g"], color2["b"] = GetVehicleCustomSecondaryColour(vehicle)

		local neonColor = {}
		neonColor["r"], neonColor["g"], neonColor["b"] = GetVehicleNeonLightsColour(vehicle)

		local tireSmoke = {}
		tireSmoke["r"], tireSmoke["g"], tireSmoke["b"] = GetVehicleTyreSmokeColor(vehicle)

		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

		local extras = {}
		for id = 0, 12 do
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end

		if initSetup then
			SetVehicleModKit(vehicle, 0)
			ToggleVehicleMod(vehicle, 18, false)
			SetVehicleMod(vehicle, 11, -1, false) -- Engine
			SetVehicleMod(vehicle, 12, -1, false) -- Brakes
			SetVehicleMod(vehicle, 13, -1, false) -- Transmission
			SetVehicleMod(vehicle, 15, -1, false) -- Suspension
			SetVehicleMod(vehicle, 16, -1, false) -- Armour

			Citizen.Wait(100)
		end

		return {
			plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

			color1 = color1,
			color2 = color2,
			paintType = {
				paintType1,
				paintType2,
			},
			chameleonColor = chameleonColor,
			pearlescentColor = pearlescentColor,
			wheelColor = wheelColor,
			interiorColor = GetVehicleInteriorColor(vehicle),

			wheels = GetVehicleWheelType(vehicle),
			windowTint = GetVehicleWindowTint(vehicle),

			neonEnabled = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3),
			},

			neonColor = neonColor,
			tyreSmoke = IsToggleModOn(vehicle, 20),
			tyreSmokeColor = tireSmoke,

			extras = extras,
			livery = GetVehicleLivery(vehicle),

			mods = {
				spoilers = GetVehicleMod(vehicle, 0),
				frontBumper = GetVehicleMod(vehicle, 1),
				rearBumper = GetVehicleMod(vehicle, 2),
				sideSkirt = GetVehicleMod(vehicle, 3),
				exhaust = GetVehicleMod(vehicle, 4),
				frame = GetVehicleMod(vehicle, 5),
				grille = GetVehicleMod(vehicle, 6),
				hood = GetVehicleMod(vehicle, 7),
				fender = GetVehicleMod(vehicle, 8),
				rightFender = GetVehicleMod(vehicle, 9),
				roof = GetVehicleMod(vehicle, 10),

				engine = GetVehicleMod(vehicle, 11),
				brakes = GetVehicleMod(vehicle, 12),
				transmission = GetVehicleMod(vehicle, 13),
				horns = GetVehicleMod(vehicle, 14),
				suspension = GetVehicleMod(vehicle, 15),
				armor = GetVehicleMod(vehicle, 16),

				turbo = IsToggleModOn(vehicle, 18),
				xenon = IsToggleModOn(vehicle, 22),
				xenonColor = GetVehicleXenonLightsColour(vehicle) or -1,

				frontWheels = GetVehicleMod(vehicle, 23),
				backWheels = GetVehicleMod(vehicle, 24),
				customTiresF = GetVehicleModVariation(vehicle, 23),
				customTiresR = GetVehicleModVariation(vehicle, 24),

				plateHolder = GetVehicleMod(vehicle, 25),
				vanityPlate = GetVehicleMod(vehicle, 26),
				trimA = GetVehicleMod(vehicle, 27),
				ornaments = GetVehicleMod(vehicle, 28),
				dashboard = GetVehicleMod(vehicle, 29),
				dial = GetVehicleMod(vehicle, 30),
				doorSpeaker = GetVehicleMod(vehicle, 31),
				seats = GetVehicleMod(vehicle, 32),
				steeringWheel = GetVehicleMod(vehicle, 33),
				shifterLeavers = GetVehicleMod(vehicle, 34),
				aPlate = GetVehicleMod(vehicle, 35),
				speakers = GetVehicleMod(vehicle, 36),
				trunk = GetVehicleMod(vehicle, 37),
				hydrolic = GetVehicleMod(vehicle, 38),
				engineBlock = GetVehicleMod(vehicle, 39),
				airFilter = GetVehicleMod(vehicle, 40),
				struts = GetVehicleMod(vehicle, 41),
				archCover = GetVehicleMod(vehicle, 42),
				aerials = GetVehicleMod(vehicle, 43),
				trimB = GetVehicleMod(vehicle, 44),
				tank = GetVehicleMod(vehicle, 45),
				windows = GetVehicleMod(vehicle, 46),
			},
		}
	else
		return {}
	end
end

local function getCallsignDigit(callsign, digit)
	local n = 10 ^ digit
	local n1 = 10 ^ (digit - 1)

	return math.floor((callsign % n) / n1)
end

function SetVehicleProperties(vehicle, props, data)
	if DoesEntityExist(vehicle) and type(props) == "table" then
		if Police:IsPdCar(vehicle) then
			props.chameleonColor = 0
			props.pearlescentColor = 0
			props.plateIndex = 4
			props.tyreSmoke = false
			props.paintType = { 0, 0 }
			props.mods.xenon = false
			props.dashboardColor = 0
		end

		if Police:IsPdCar(vehicle) or Police:IsEMSCar(vehicle) and data?.callsign and (type(data.callsign) == "string" or type(data.callsign) == "number") then
			local callsignData = tostring(data?.callsign)
			if callsignData and #callsignData == 3 then
				local callsign = tonumber(callsignData)
				if callsign ~= nil then
					local one, two, three = getCallsignDigit(callsign, 3), getCallsignDigit(callsign, 2), getCallsignDigit(callsign, 1)
	
					props.mods.fender = one
					props.mods.rightFender = two
					props.mods.roof = three
				end
			end
		end

		SetVehicleModKit(vehicle, 0)

		if props.paintType ~= nil then
			SetVehicleModColor_1(vehicle, props.paintType[1], 0, 0)
			SetVehicleModColor_2(vehicle, props.paintType[2], 0, 0)
		end

		if props.plateIndex then
			SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
		end

		if props.color1 then
			ClearVehicleCustomPrimaryColour(vehicle)
			SetVehicleCustomPrimaryColour(vehicle, props.color1.r, props.color1.g, props.color1.b)
		end

		if props.color2 then
			ClearVehicleCustomSecondaryColour(vehicle)
			SetVehicleCustomSecondaryColour(vehicle, props.color2.r, props.color2.g, props.color2.b)
		end

		if props.chameleonColor and type(props.chameleonColor) == "number" and props.chameleonColor >= 223 then
			ClearVehicleCustomSecondaryColour(vehicle)
			ClearVehicleCustomPrimaryColour(vehicle)
			SetVehicleColours(vehicle, props.chameleonColor, props.chameleonColor)
		end

		if props.wheelColor or props.pearlescentColor then
			local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
			SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor or wheelColor)
		end

		if props.interiorColor then
			SetVehicleInteriorColor(vehicle, props.interiorColor)
		end

		if props.dashboardColor ~= nil then
			SetVehicleDashboardColour(vehicle, props.dashboardColor)
		end

		if props.wheels then
			SetVehicleWheelType(vehicle, props.wheels)
		end
		if props.windowTint then
			SetVehicleWindowTint(vehicle, props.windowTint)
		end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for id, enabled in pairs(props.extras) do
				if enabled ~= nil then
					if enabled then
						SetVehicleExtra(vehicle, tonumber(id), 0)
					else
						SetVehicleExtra(vehicle, tonumber(id), 1)
					end
				end
			end
		end

		if props.neonColor then
			SetVehicleNeonLightsColour(vehicle, props.neonColor.r, props.neonColor.g, props.neonColor.b)
		end

		if props.tyreSmoke ~= nil then
			ToggleVehicleMod(vehicle, 20, props.tyreSmoke)
		end

		if props.tyreSmokeColor then
			SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor.r, props.tyreSmokeColor.g, props.tyreSmokeColor.b)
		end

		-- Liveries
		if props.livery then
			SetVehicleMod(vehicle, 48, props.livery, false)
			SetVehicleLivery(vehicle, props.livery)
		end

		if type(props.mods) == "table" then
			if props.mods.spoilers then
				SetVehicleMod(vehicle, 0, props.mods.spoilers, false)
			end
			if props.mods.frontBumper then
				SetVehicleMod(vehicle, 1, props.mods.frontBumper, false)
			end
			if props.mods.rearBumper then
				SetVehicleMod(vehicle, 2, props.mods.rearBumper, false)
			end
			if props.mods.sideSkirt then
				SetVehicleMod(vehicle, 3, props.mods.sideSkirt, false)
			end
			if props.mods.exhaust then
				SetVehicleMod(vehicle, 4, props.mods.exhaust, false)
			end
			if props.mods.frame then
				SetVehicleMod(vehicle, 5, props.mods.frame, false)
			end
			if props.mods.grille then
				SetVehicleMod(vehicle, 6, props.mods.grille, false)
			end
			if props.mods.hood then
				SetVehicleMod(vehicle, 7, props.mods.hood, false)
			end
			if props.mods.fender then
				SetVehicleMod(vehicle, 8, props.mods.fender, false)
			end
			if props.mods.rightFender then
				SetVehicleMod(vehicle, 9, props.mods.rightFender, false)
			end
			if props.mods.roof then
				SetVehicleMod(vehicle, 10, props.mods.roof, false)
			end
			if props.mods.engine then
				SetVehicleMod(vehicle, 11, props.mods.engine, false)
			else
				SetVehicleMod(vehicle, 11, -1, false)
			end
			if props.mods.brakes then
				SetVehicleMod(vehicle, 12, props.mods.brakes, false)
			else
				SetVehicleMod(vehicle, 12, -1, false)
			end
			if props.mods.transmission then
				SetVehicleMod(vehicle, 13, props.mods.transmission, false)
			else
				SetVehicleMod(vehicle, 13, -1, false)
			end
			if props.mods.horns then
				SetVehicleMod(vehicle, 14, props.mods.horns, false)
			end
			if props.mods.suspension then
				SetVehicleMod(vehicle, 15, props.mods.suspension, false)
			else
				SetVehicleMod(vehicle, 15, -1, false)
			end
			if props.mods.armor then
				SetVehicleMod(vehicle, 16, props.mods.armor, false)
			end
			if props.mods.turbo ~= nil and props.mods.turbo then
				SetVehicleModKit(vehicle, 0)
				ToggleVehicleMod(vehicle, 18, true)
			else
				ToggleVehicleMod(vehicle, 18, false)
			end
			if props.mods.xenon ~= nil then
				ToggleVehicleMod(vehicle, 22, props.mods.xenon)
			end
			if props.mods.xenonColor ~= nil then
				SetVehicleXenonLightsColour(vehicle, props.mods.xenonColor)
			end
			if props.mods.frontWheels then
				SetVehicleMod(vehicle, 23, props.mods.frontWheels, false)
			end
			if props.mods.backWheels then
				SetVehicleMod(vehicle, 24, props.mods.backWheels, false)
			end
			if props.mods.customTiresF ~= nil then
				SetVehicleMod(vehicle, 23, props.mods.frontWheels, props.mods.customTiresF)
			end
			if props.mods.customTiresR ~= nil then
				SetVehicleMod(vehicle, 24, props.mods.backWheels, props.mods.customTiresR)
			end
			if props.mods.plateHolder then
				SetVehicleMod(vehicle, 25, props.mods.plateHolder, false)
			end
			if props.mods.vanityPlate then
				SetVehicleMod(vehicle, 26, props.mods.vanityPlate, false)
			end
			if props.mods.trimA then
				SetVehicleMod(vehicle, 27, props.mods.trimA, false)
			end
			if props.mods.ornaments then
				SetVehicleMod(vehicle, 28, props.mods.ornaments, false)
			end
			if props.mods.dashboard then
				SetVehicleMod(vehicle, 29, props.mods.dashboard, false)
			end
			if props.mods.dial then
				SetVehicleMod(vehicle, 30, props.mods.dial, false)
			end
			if props.mods.doorSpeaker then
				SetVehicleMod(vehicle, 31, props.mods.doorSpeaker, false)
			end
			if props.mods.seats then
				SetVehicleMod(vehicle, 32, props.mods.seats, false)
			end
			if props.mods.steeringWheel then
				SetVehicleMod(vehicle, 33, props.mods.steeringWheel, false)
			end
			if props.mods.shifterLeavers then
				SetVehicleMod(vehicle, 34, props.mods.shifterLeavers, false)
			end
			if props.mods.aPlate then
				SetVehicleMod(vehicle, 35, props.mods.aPlate, false)
			end
			if props.mods.speakers then
				SetVehicleMod(vehicle, 36, props.mods.speakers, false)
			end
			if props.mods.trunk then
				SetVehicleMod(vehicle, 37, props.mods.trunk, false)
			end
			if props.mods.hydrolic then
				SetVehicleMod(vehicle, 38, props.mods.hydrolic, false)
			end
			if props.mods.engineBlock then
				SetVehicleMod(vehicle, 39, props.mods.engineBlock, false)
			end
			if props.mods.airFilter then
				SetVehicleMod(vehicle, 40, props.mods.airFilter, false)
			end
			if props.mods.struts then
				SetVehicleMod(vehicle, 41, props.mods.struts, false)
			end
			if props.mods.archCover then
				SetVehicleMod(vehicle, 42, props.mods.archCover, false)
			end
			if props.mods.aerials then
				SetVehicleMod(vehicle, 43, props.mods.aerials, false)
			end
			if props.mods.trimB then
				SetVehicleMod(vehicle, 44, props.mods.trimB, false)
			end
			if props.mods.tank then
				SetVehicleMod(vehicle, 45, props.mods.tank, false)
			end
			if props.mods.windows then
				SetVehicleMod(vehicle, 46, props.mods.windows, false)
			end
		end

		if Entity(vehicle) and Entity(vehicle).state.Plate then
			SetVehicleNumberPlateText(vehicle, Entity(vehicle).state.Plate)
		end

		-- Hopefully stop ghost drivers stealing your car
		local driverPed = GetPedInVehicleSeat(vehicle, -1)
		if driverPed and driverPed > 0 and DoesEntityExist(driverPed) and not IsPedAPlayer(driverPed) then
			print("Removing NPC Driver From Spawned Vehicle")
			NetSync:DeletePed(driverPed)
		end
	end
end

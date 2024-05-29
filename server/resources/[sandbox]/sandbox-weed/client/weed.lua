AddEventHandler("Weed:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	Weed = exports["sandbox-base"]:FetchComponent("Weed")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Weed", {
		"Logger",
		"Callbacks",
		"Game",
		"Weed",
		"Targeting",
		"Animations",
		"Progress",
		"Notification",
		"ListMenu",
		"Inventory",
		"PedInteraction",
		"Polyzone",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterTargets()
		RegisterCallbacks()

		LoadWeedModels()

		Polyzone.Create:Poly("casino_roof_weed_blocker", {
			vector2(909.12774658203, 68.336456298828),
			vector2(892.63311767578, 34.766555786133),
			vector2(904.96075439453, 22.200096130371),
			vector2(894.90655517578, 1.1801514625549),
			vector2(922.87658691406, -17.753396987915),
			vector2(932.50738525391, -8.3494606018066),
			vector2(958.59307861328, -23.690893173218),
			vector2(1018.4107055664, 62.70947265625),
			vector2(984.884765625, 89.045021057129),
			vector2(970.19580078125, 90.825546264648),
			vector2(948.73913574219, 85.602745056152)
		}, {
			minZ = 105.0,
			maxZ = 145.0	
		}, {})
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Weed", WEED)
end)

function getStageByPct(pct)
	local stagePct = 100 / (#Plants - 1)
	return math.floor((pct / stagePct) + 1.5)
end

local _plants = {}
function RegisterCallbacks()
	Callbacks:RegisterClientCallback("Weed:PlantingAnim", function(data, cb)
		local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.3, 0))
		local foundGround, zPos = GetGroundZFor_3dCoord(x, y, z - 0.5, 0)
		if foundGround then
			z = zPos
		end

		local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(x, y, z + 4, x, y, z - 2, 1, 0, 4)
		local retval, hit, endCoords, _, materialHash, _ = GetShapeTestResultIncludingMaterial(rayHandle)

		local fuck = false
		for k,v in pairs(_activePlants) do
			if v and v.plant and #(vector3(x, y, z) - vector3(v.plant.location.x, v.plant.location.y, v.plant.location.z)) <= 0.8 then
				fuck = true
			end
		end

		if hit then
			if Materials[materialHash] ~= nil and not Polyzone:IsCoordsInZone(vector3(x, y, z), "cayo_perico") and not Polyzone:IsCoordsInZone(vector3(x, y, z), "casino_roof_weed_blocker") then
				if not fuck then
					Progress:Progress({
						name = "plant_weed",
						duration = 15000,
						label = "Planting",
						canCancel = true,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							task = "WORLD_HUMAN_GARDENER_PLANT",
						},
					}, function(cancelled)
						if not cancelled then
							cb({
								coords = { x = x, y = y, z = z },
								material = materialHash,
							})
						else
							cb({ error = 3 })
						end
					end)
				else
					cb({ error = 3 })
				end
			else
				cb({ error = 2 })
			end
		else
			cb({ error = 1 })
		end
	end)

	Callbacks:RegisterClientCallback("Weed:RollingAnim", function(data, cb)
		Progress:Progress({
			name = "rolling_weed",
			duration = 3000,
			label = "Rolling Joints",
			canCancel = true,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@world_human_clipboard@male@idle_a",
				anim = "idle_c",
				flags = 49,
			},
		}, function(cancelled)
			cb(not cancelled)
		end)
	end)

	Callbacks:RegisterClientCallback("Weed:MakingBrick", function(data, cb)
		Progress:Progress({
			name = "making_brick",
			duration = data.time * 1000,
			label = data.label,
			canCancel = true,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@world_human_clipboard@male@idle_a",
				anim = "idle_c",
				flags = 49,
			},
		}, function(cancelled)
			cb(not cancelled)
		end)
	end)

	Callbacks:RegisterClientCallback("Weed:SmokingAnim", function(data, cb)
		local ticks = 1
		Progress:ProgressWithTickEvent({
			name = "smoking_weed",
			duration = 8000,
			tickrate = 1000,
			label = "Smoking",
			canCancel = true,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				anim = "smoke_weed"
			}
    }, function()
			local armor = GetPedArmour(LocalPlayer.state.ped)
			if armor < 50 then
				SetPedArmour(LocalPlayer.state.ped, armor + 3)
			end
			ticks = ticks + 1
		end, function(cancelled)
			cb(not cancelled, ticks)
		end)
	end)
end

WEED = {}

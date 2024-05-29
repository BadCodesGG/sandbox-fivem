_cuffPromise = nil

local MAX_CUFF_ATTEMPTS = 2

AddEventHandler("Handcuffs:Shared:DependencyUpdate", HandcuffComponents)
function HandcuffComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Handcuffs", {
		"Callbacks",
		"Inventory",
		"PedInteraction",
		"Minigame",
		"Notification",
		"Weapons",
	}, function(error)
		if #error > 0 then
			return
		end
		HandcuffComponents()

		Callbacks:RegisterClientCallback("Handcuffs:VehCheck", function(data, cb)
			cb(IsPedInAnyVehicle(LocalPlayer.state.ped))
		end)

		Callbacks:RegisterClientCallback("Handcuffs:DoCuff", function(data, cb)
			if not IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
				if _cuffPromise == nil then
					if not LocalPlayer.state.isCuffed then
						beingCuffedAnim(data.cuffer)
					end

					if data.isHardCuffed then
						_cuffFlags = 17
					else
						_cuffFlags = 49
					end

					if not data.forced and not LocalPlayer.state.isCuffed and not LocalPlayer.state.isDead then
						CuffAttempt()
						_cuffPromise = promise.new()
						Minigame.Play:RoundSkillbar(
							1.35 * math.ceil(((_attempts / 2) or 1)),
							(4 - (_attempts / 2) > 1 and 4 - (_attempts / 2) or 1),
							{
								onSuccess = "Handcuffs:Client:DoCuffBreak",
								onFail = "Handcuffs:Client:FailCuffBreak",
							},
							{
								animation = false,
							}
						)
						cb(Citizen.Await(_cuffPromise))
					else
						ResetTimer()
						cb(false)
						cuffAnim()
					end
				else
					cb(-1)
				end

				_cuffPromise = nil
			else
				cb(-1)
			end
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Handcuffs", _HANDCUFFS)
end)

_HANDCUFFS = {}

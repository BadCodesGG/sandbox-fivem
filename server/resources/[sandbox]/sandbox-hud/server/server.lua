local _uircd = {}

AddEventHandler("Hud:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hud", {
		"Fetch",
		"Logger",
		"Chat",
		"Callbacks",
		"Inventory",
		"Execute",
		"Middleware",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Middleware:Add("Characters:Creating", function(source, cData)
			return {
				{
					HUDConfig = {
						layout = "default",
						statusType = "numbers",
						buffsAnchor = "compass",
						vehicle = "default",
						buffsAnchor2 = true,
						showRPM = true,
						hideCrossStreet = false,
						hideCompassBg = false,
						minimapAnchor = true,
						transparentBg = true,
					},
				},
			}
		end)
		Middleware:Add("Characters:Spawning", function(source)
			local char = Fetch:CharacterSource(source)
			local config = char:GetData("HUDConfig")
			if not config then
				char:SetData("HUDConfig", {
					layout = "default",
					statusType = "numbers",
					buffsAnchor = "compass",
					vehicle = "default",
					buffsAnchor2 = true,
					showRPM = true,
					hideCrossStreet = false,
					hideCompassBg = false,
					minimapAnchor = true,
					transparentBg = true,
				})
			end
		end, 1)

		Callbacks:RegisterServerCallback("HUD:SaveConfig", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				char:SetData("HUDConfig", data)
				cb(true)
			else
				cb(false)
			end
		end)

		Callbacks:RegisterServerCallback("HUD:RemoveBlindfold", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local tarState = Player(data).state
				if tarState.isBlindfolded then
					Callbacks:ClientCallback(source, "HUD:PutOnBlindfold", "Removing Blindfold", function(isSuccess)
						if isSuccess then
							if Inventory:AddItem(char:GetData("SID"), "blindfold", 1, {}, 1) then
								tarState.isBlindfolded = false
								TriggerClientEvent("VOIP:Client:Gag:Use", data)
							else
								Execute:Client(source, "Notification", "Error", "Failed Adding Item")
								cb(false)
							end
						end
					end)
				else
					Execute:Client(source, "Notification", "Error", "Target Not Blindfolded")
					cb(false)
				end
			else
				cb(false)
			end
		end)

		Inventory.Items:RegisterUse("blindfold", "HUD", function(source, item, itemData)
			Callbacks:ClientCallback(source, "HUD:GetTargetInfront", {}, function(target)
				if target ~= nil then
					local tarState = Player(target).state
					if not tarState.isBlindfolded then
						Callbacks:ClientCallback(source, "HUD:PutOnBlindfold", "Blindfolding", function(isSuccess)
							if isSuccess then
								if tarState.isCuffed then
									if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
										tarState.isBlindfolded = true
										TriggerClientEvent("VOIP:Client:Gag:Use", target)
									else
										Execute:Client(source, "Notification", "Error", "Failed Removing Item")
									end
								else
									Execute:Client(source, "Notification", "Error", "Target Not Cuffed")
								end
							end
						end)
					else
						Execute:Client(source, "Notification", "Error", "Target Already Blindfolded")
					end
				else
					Execute:Client(source, "Notification", "Error", "Nobody Near To Blindfold")
				end
			end)
		end)
	end)
end)

function RegisterChatCommands()
	Chat:RegisterCommand("uir", function(source, args, rawCommand)
		if not _uircd[source] or os.time() > _uircd[source] then
			TriggerClientEvent("UI:Client:Reset", source, true)
			_uircd[source] = os.time() + (60 * 5)
		else
			Chat.Send.System:Single(source, "You're Trying To Do This Too Much, Stop.")
		end
	end, {
		help = "Resets UI",
	})

	Chat:RegisterCommand("hud", function(source, args, rawCommand)
		TriggerClientEvent("UI:Client:Configure", source, true)
	end, {
		help = "Open HUD Config Menu",
	})

	Chat:RegisterAdminCommand("testblindfold", function(source, args, rawCommand)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			Player(source).state.isBlindfolded = not Player(source).state.isBlindfolded
		end
	end, {
		help = "Test Blindfold",
	})

	-- Chat:RegisterAdminCommand("notif", function(source, args, rawCommand)
	-- 	exports["sandbox-base"]:FetchComponent("Execute"):Client(source, "Notification", "Success", "This is a test, lul")
	-- end, {
	-- 	help = "Test Notification",
	-- })

	-- Chat:RegisterAdminCommand("list", function(source, args, rawCommand)
	-- 	TriggerClientEvent("ListMenu:Client:Test", source)
	-- end, {
	-- 	help = "Test List Menu",
	-- })

	-- Chat:RegisterAdminCommand("input", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Input:Client:Test", source)
	-- end, {
	-- 	help = "Test Input",
	-- })

	-- Chat:RegisterAdminCommand("confirm", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Confirm:Client:Test", source)
	-- end, {
	-- 	help = "Test Confirm Dialog",
	-- })

	-- Chat:RegisterAdminCommand("skill", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Skillbar", source)
	-- end, {
	-- 	help = "Test Skill Bar",
	-- })

	-- Chat:RegisterAdminCommand("scan", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Scanner", source)
	-- end, {
	-- 	help = "Test Scanner",
	-- })

	-- Chat:RegisterAdminCommand("sequencer", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Sequencer", source)
	-- end, {
	-- 	help = "Test Sequencer",
	-- })

	-- Chat:RegisterAdminCommand("keypad", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Keypad", source)
	-- end, {
	-- 	help = "Test Keypad",
	-- })

	-- Chat:RegisterAdminCommand("scrambler", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Scrambler", source)
	-- end, {
	-- 	help = "Test Scrambler",
	-- })

	-- Chat:RegisterAdminCommand("memory", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Memory", source)
	-- end, {
	-- 	help = "Test Memory",
	-- })
end

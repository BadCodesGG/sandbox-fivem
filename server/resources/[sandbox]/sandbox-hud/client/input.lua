AddEventHandler("Input:Shared:DependencyUpdate", RetrieveInputComponents)
function RetrieveInputComponents()
	UISounds = exports["sandbox-base"]:FetchComponent("UISounds")
	Input = exports["sandbox-base"]:FetchComponent("Input")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Input", {
		"UISounds",
		"Input",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveInputComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Input", INPUT)
end)

RegisterNetEvent("Hud:Client:GiveCash", function(hitting, data)
	local tSid = Player(hitting.serverId).state?.SID

	Input:Show(
		"Give Cash",
		"Amount To Give",
		{
			{
				id = "target",
				label = "Target",
				type = "number",
				options = {
					disabled = true,
					value = tSid,
				},
			},
			{
				id = "amount",
				type = "number",
				options = {
					inputProps = {
						min = 1,
						max = 9999999,
					},
				},
			},
		},
		"Hud:Client:DoGiveCash",
		{
			target = tSid,
		}
	)
end)

AddEventHandler("Hud:Client:DoGiveCash", function(values, data)
	Callbacks:ServerCallback("Wallet:GiveCash", {
		target = data.target,
		amount = values.amount,
	})
end)

-- RegisterNetEvent("Input:Client:Test", function()
-- 	Input:Show(
-- 		"Test Input",
-- 		"Input Label",
-- 		{
-- 			{
-- 				id = "test",
-- 				type = "text",
-- 				options = {
-- 					inputProps = {
-- 						maxLength = 2,
-- 					},
-- 				},
-- 			},
-- 			{
-- 				id = "test2",
-- 				type = "number",
-- 				options = {
-- 					inputProps = {
-- 						maxLength = 2,
-- 					},
-- 				},
-- 			},
-- 			{
-- 				id = "test3",
-- 				type = "multiline",
-- 				options = {},
-- 			},
-- 		},
-- 		"Input:Client:InputTest",
-- 		{
-- 			test = "penis",
-- 		}
-- 	)
-- end)

-- AddEventHandler("Input:Client:InputTest", function(values, data)
-- 	print(json.encode(values))
-- 	print(json.encode(data))
-- end)

RegisterNUICallback("Input:Submit", function(data, cb)
	UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	TriggerEvent(data.event, data.values, data.data)
	Input:Close()
	cb("ok")
end)

RegisterNUICallback("Input:Close", function(data, cb)
	UISounds.Play:FrontEnd(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	Input:Close()
	TriggerEvent("Input:Closed", data.event, data.data)
	cb("ok")
end)

INPUT = {
	Show = function(self, title, label, inputs, event, data)
		SetNuiFocus(true, true)
		SendNUIMessage({
			type = "SHOW_INPUT",
			data = {
				title = title,
				label = label,
				inputs = inputs,
				event = event,
				data = data,
			},
		})
	end,
	Close = function(self)
		SetNuiFocus(false, false)
		SendNUIMessage({
			type = "CLOSE_INPUT",
		})
	end,
}

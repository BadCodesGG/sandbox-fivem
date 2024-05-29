ACTION = {
	Show = function(self, id, message, duration)
		local formattedMessage = string.gsub(
			message,
			"{keybind}([A-Za-z!\"#$%&'()*+,-./[\\%]^_`|~]+){/keybind}",
			function(key)
				local keyName = Keybinds:GetKey(key) or "Unknown"
				return "{key}" .. keyName .. "{/key}"
			end
		)

		SendNUIMessage({
			type = "ADD_ACTION",
			data = {
				id = id,
				message = formattedMessage,
			},
		})
	end,
	Hide = function(self, id)
		SendNUIMessage({
			type = "REMOVE_ACTION",
			data = {
				id = id,
			}
		})
	end,
	HideAll = function(self)
		SendNUIMessage({
			type = "REMOVE_ALL_ACTIONS",
		})
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Action", ACTION)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	ACTION:HideAll()
end)

-- i recommend to NOT change the command name. it will make easier for people to use this command
-- when ever is this library.. so please keep this command name on "streamermode" command
-- RegisterCommand("streamermode", function(source, args, rawCommand)
--     disableMusic = not disableMusic
--     TriggerEvent("xsound:streamerMode", disableMusic)
--     if disableMusic then
--         TriggerEvent('chat:addMessage', { args = { "^1[xSound]", config.Messages["streamer_on"] } })

--         for k, v in pairs(soundInfo) do
--             Destroy(v.id)
--         end

--     else
--         TriggerEvent('chat:addMessage', { args = { "^1[xSound]", config.Messages["streamer_off"] } })
--     end
-- end, false)

RegisterNetEvent("Commands:Client:StreamerMode", function()
	disableMusic = not disableMusic

	SetResourceKvpInt("streamermode", disableMusic and 1 or 0)

	TriggerEvent("xsound:streamerMode", disableMusic)
	if disableMusic then
		TriggerEvent("chat:addMessage", {
			time = GetCloudTimeAsInt(),
			type = "system",
			message = config.Messages["streamer_on"],
		})

		for k, v in pairs(soundInfo) do
			Destroy(v.id)
		end
	else
		TriggerEvent("chat:addMessage", {
			time = GetCloudTimeAsInt(),
			type = "system",
			message = config.Messages["streamer_off"],
		})
	end
end)

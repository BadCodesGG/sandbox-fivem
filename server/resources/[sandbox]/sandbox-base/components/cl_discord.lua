COMPONENTS.Discord = {
	_name = "base",
	RichPresence = function(self)
		SetDiscordAppId(COMPONENTS.Convar.DISCORD_APP.value)
		SetDiscordRichPresenceAsset("sandboxrp_large_icon")
		SetDiscordRichPresenceAssetText("Join Today: SandboxRP.gg")
		--SetDiscordRichPresenceAssetSmall("info")
		SetDiscordRichPresenceAction(0, "Apply Now", "https://sandboxrp.gg")
		SetDiscordRichPresenceAction(1, "Join Our Discord", "https://discord.gg/sandboxgg")

		Citizen.CreateThread(function()
			while true do
				local char = LocalPlayer.state.Character
				local playerCount = GlobalState["PlayerCount"] or 0
				local queueCount = GlobalState["QueueCount"] or 0
				if char ~= nil then
					SetRichPresence(
						string.format(
							"[%d/%d]%s - Playing %s %s",
							playerCount,
							GlobalState.MaxPlayers,
							queueCount > 0 and string.format(" (Queue: %d)", queueCount) or "",
							char:GetData("First"),
							char:GetData("Last")
						)
					)
				else
					SetRichPresence(
						string.format(
							"[%d/%d]%s - Selecting a Character", 
							playerCount, 
							GlobalState.MaxPlayers,
							queueCount > 0 and string.format(" (Queue: %d)", queueCount) or ""
						)
					)
				end

				-- SetDiscordRichPresenceAssetSmallText(
				-- 	string.format("%s/%s [Queue: %s]", playerCount, GlobalState.MaxPlayers, queueCount)
				-- )
				Citizen.Wait(30000)
			end
		end)
	end,
}

Citizen.CreateThread(function()
	COMPONENTS.Discord:RichPresence()
end)

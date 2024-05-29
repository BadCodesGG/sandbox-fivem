Config = {
	MaxPrio = 1000,
	ExcludeDrop = {
		"Disconnected",
		"cup-leopard-triple",
		"Kicked",
		"Banned",
		"Exiting",
	},
	Settings = {
		QueueDelay = 0.25,
		MaxTimeBoost = 30,
		Grace = 5,
		AllowedPerTick = 150,
		SavePosition = 5, -- How Many Minutes to Save Queue Pos For
	},
	Strings = {
		Init = "Waiting For Queue",
		ACWaiting = "Waiting For Anti-Cheat Checks",
		Add = "Added %s (Account: %s, Identifier: %s) To Queue %s/%s (Current Players: %s, Prio: %s)",
		Banned = "You're Banned, Appeal in Discord\n\nReason: %s\nExpires: %s\nID: %s",
		PermaBanned = "Permanently Banned, Appeal in Discord\n\nReason: %s\nID: %s",
		SiteBanned = "You're Banned From the Website. View Reason in Discord",
		Checking = "Checking Whitelist Status",
		Disconnected = "%s (Account: %s, Identifier: %s) Disconnected From Queue",
		Crash = "%s (Account: %s, Identifier: %s) Crashed - Adding Crash Priority for 5 Minutes",
		Dropped = "Dropped From Server.",
		Joined = "%s (Account: %s, Identifier: %s) Joined The Server",
		Joining = "Joining Server...",
		NoIdentifier = "Could Not Find A License Identifier, Relaunch FiveM and try again.",
		NotReady = "The server has not yet finished loading, please try again in a few minutes.",
		NotWhitelisted = "You Are Not Whitelisted For This Server - Apply Today At https://sandboxrp.gg/",
		Queued = "✈️ Position %s of %s - 🕑 Time In Queue: %s%s",
		Retrieving = "Retrieving Queue Information",
		Waiting = "Waiting For Queue To Open - %s %s %s %s",
		WaitingSeconds = "Waiting For Queue To Open - %s %s",
		PendingRestart = "🚫 Queue Closed 🚫 Due To A Pending Restart We've Closed The Queue. Please Reconnect In A Few Minutes",

		WebLinkComplete = "Successfully Linked FiveM Account to Site. Joining the Queue",
		WebLinkError = "Failed to Link FiveM to Site. Make Sure That the Code Hasn't Expired.",
	},
}

Config.Cards = {}
Config.Cards.NotWhitelisted = {
	body = {
		{
			size = "ExtraLarge",
			type = "TextBlock",
			weight = "Bolder",
			text = "You Are Not Whitelisted For This Server",
			style = "heading",
		},
		{
			size = "Medium",
			type = "TextBlock",
			wrap = true,
			text = "You are not whitelisted for this server or a connected account could not be found. Please visit the website to apply for whitelist or to link your account at https://sandboxrp.gg/",
		},
		{
			actions = {
				{
					title = "Visit Site",
					type = "Action.OpenUrl",
					url = "https://sandboxrp.gg/",
				},
				{
					title = "Start Account Linking",
					type = "Action.Submit",
					data = {
						linking = true,
					},
				},
			},
			type = "ActionSet",
		},
	},
	type = "AdaptiveCard",
	version = "1.0",
	["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
}

Config.Cards.AccountLinking = {
	body = {
		{
			size = "ExtraLarge",
			type = "TextBlock",
			weight = "Bolder",
			text = "Link FiveM With Site",
			style = "heading",
		},
		{
			size = "Medium",
			type = "TextBlock",
			wrap = true,
			text = "Please enter the code generated on the site (in your user settings) below. Please note that you have to be whitelisted in order to link your FiveM to the site.",
		},
		{
			placeholder = "One Time Code",
			type = "Input.Text",
			id = "code",
			title = "Test",
			style = "Password",
			maxLength = 16,
		},
		{
			actions = {
				{
					title = "Submit",
					type = "Action.Submit",
				},
				{
					title = "Cancel",
					type = "Action.Submit",
					data = {
						cancel = true,
					},
				},
			},
			type = "ActionSet",
		},
	},
	type = "AdaptiveCard",
	version = "1.0",
	["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
}

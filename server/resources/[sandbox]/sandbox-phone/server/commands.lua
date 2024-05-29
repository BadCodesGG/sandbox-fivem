function RegisterChatCommands()
	Chat:RegisterCommand("resetphonepos", function(source, args, rawCommand)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			char:SetData("PhonePosition", {
				x = 25,
				y = 25,
			})
			TriggerClientEvent("Phone:Client:RestorePosition", source, char:GetData("PhonePosition"))
			Chat.Send.System:Single(source, "Phone Position Reset")
		else
			Chat.Send.System:Single(source, "Unable To Reset Phone Position")
		end
	end, {
		help = "Resets your phones position",
	}, 0)

	Chat:RegisterAdminCommand("clearalias", function(source, args, rawCommand)
		if tonumber(args[1]) then
			local char = Fetch:SID(tonumber(args[1]))

			if char ~= nil then
				local aliases = char:GetData("Alias")
				aliases[args[2]] = nil
				char:SetData("Alias", aliases)
				Chat.Send.System:Single(
					source,
					string.format(
						"Alias Cleared For %s %s (%s) For %s",
						char:GetData("First"),
						char:GetData("Last"),
						char:GetData("SID"),
						args[2]
					)
				)
			else
				Chat.Send.System:Single(source, "Invalid Target")
			end
		else
			Chat.Send.System:Single(source, "Invalid Target")
		end
	end, {
		help = "[Admin] Clear Player App Alias",
		params = {
			{
				name = "SID",
				help = "Target State ID",
			},
			{
				name = "App ID",
				help = "App ID to reset the players alias for",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("clearprofile", function(source, args, rawCommand)
		if tonumber(args[1]) then
			local char = Fetch:SID(tonumber(args[1]))
			if char ~= nil then
				local profiles = char:GetData("Profiles") or {}

				if profiles[args[2]] ~= nil then
					local queries = {}
					table.insert(queries, {
						query = "INSERT INTO app_profile_history (sid, app, name, picture, meta) VALUES(?, ?, ?, ?, ?)",
						values = {
							char:GetData("SID"),
							args[2],
							profiles[args[2]].name,
							profiles[args[2]].picture,
							json.encode(profiles[args[2]].meta or {}),
						},
					})
					table.insert(queries, {
						query = "DELETE FROM character_app_profiles WHERE sid = ? AND app = ?",
						values = {
							char:GetData("SID"),
							args[2],
						},
					})
					MySQL.transaction(queries)

					profiles[args[2]] = nil
					char:SetData("Profiles", profiles)
					Chat.Send.System:Single(
						source,
						string.format(
							"Profile Cleared For %s %s (%s) For %s",
							char:GetData("First"),
							char:GetData("Last"),
							char:GetData("SID"),
							args[2]
						)
					)
				else
				end
			else
				Chat.Send.System:Single(source, "Invalid Target")
			end
		else
			Chat.Send.System:Single(source, "Invalid Target")
		end
	end, {
		help = "[Admin] Clear Player App Alias",
		params = {
			{
				name = "SID",
				help = "Target State ID",
			},
			{
				name = "App ID",
				help = "App ID to reset the players alias for",
			},
		},
	}, 2)

	Chat:RegisterStaffCommand("ctwitter", function(source, args, rawCommand)
		ClearAllTweets(args[1])
		Chat.Send.System:Single(source, "All Tweets Removed")
	end, {
		help = "[Admin] Clear All Tweets",
		params = {
			{
				name = "SID",
				help = "(Optional) Target State ID",
			},
		},
	}, -1)

	Chat:RegisterStaffCommand("twitteraccount", function(source, args, rawCommand)
		local twitterName = args[1]

		local sid = MySQL.scalar.await("SELECT sid FROM character_app_profiles WHERE name = ? AND app = ?", {
			twitterName,
			"twitter",
		})

		local char = Fetch:SID(sid)
		if char ~= nil then
			Chat.Send.System:Single(
				source,
				string.format(
					"Twitter Account Found With Name: %s. %s %s (SID: %s) [User: %s]",
					twitterName,
					char:GetData("First"),
					char:GetData("Last"),
					sid,
					char:GetData("User")
				)
			)
		else
			Database.Game:findOne({
				collection = "characters",
				query = {
					SID = sid,
				},
			}, function(success, results)
				if success and #results > 0 then
					local char = results[1]
					Chat.Send.System:Single(
						source,
						string.format(
							"Twitter Account Found With Name: %s. %s %s (SID: %s) [User: %s]",
							twitterName,
							char.First,
							char.Last,
							char.SID,
							char.User
						)
					)
				else
					Chat.Send.System:Single(source, "No Twitter Account Found")
				end
			end)
		end
	end, {
		help = "[Admin] Get Twitter Account Owner",
		params = {
			{
				name = "Account Name",
				help = "Account Name of User You Want to Find",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("govtweet", function(source, args, rawCommand)
		local accountName, accountAvatar, content, image = args[1], args[2], args[3], args[4]

		if accountName and accountAvatar and content then
			if image then
				image = {
					using = true,
					link = image,
				}
			else
				image = {
					using = false,
				}
			end

			Phone.Twitter:Post(-1, -1, {
				name = accountName,
				picture = accountAvatar,
			}, content, image, false, "government")
			Chat.Send.System:Single(source, "Tweet Sent")
		end
	end, {
		help = "[Admin] Send GOVERNMENT ACCOUNT Tweet",
		params = {
			{
				name = "Account Name",
				help = "",
			},
			{
				name = "Account Avatar",
				help = "",
			},
			{
				name = "Tweet Content",
				help = "",
			},
			{
				name = "Tweet Image",
				help = "",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("reloadtracks", function(source, args, rawCommand)
		ReloadRaceTracks()
		Chat.Send.System:Single(source, "Reloaded Vroom Vrooms")
	end, {
		help = "[Admin] Reload Race Tracks",
	}, 0)

	Chat:RegisterAdminCommand("reloadpdtracks", function(source, args, rawCommand)
		ReloadRaceTracksPD()
		Chat.Send.System:Single(source, "Reloaded PD Vroom Vrooms")
	end, {
		help = "[Admin] Reload PD Race Tracks",
	}, 0)

	Chat:RegisterAdminCommand("raceinvite", function(source, args, rawCommand)
		local char = Fetch:CharacterSource(source)

		if char then
			local id, count = args[1], tonumber(args[2])
	
			if IsRedlineRace(id) then
				Inventory:AddItem(char:GetData("SID"), "event_invite", count, {
					Event = id,
				}, 1)
			else
				Execute:Client(source, "Notification", "Error", "Invalid Race Event")
			end
		end
	end, {
		help = "[Admin] Create Race Invite Items",
		params = {
			{
				name = "Event ID",
				help = "ID of the race that using the invite will add you to",
			},
			{
				name = "Quantity",
				help = "How many invites to create",
			},
		},
	}, 2)
end

local _tweets = {}

PHONE.Twitter = {
	Get = function(self)
		return _tweets
	end,
	Post = function(self, source, SID, author, content, image, isRetweet, verified)
		local data = {
			id = #_tweets + 1,
			time = os.time(),
			source = source,
			SID = SID,
			author = author,
			content = content,
			image = image,
			likes = {},
			retweet = isRetweet,
			verified = verified,
		}

		table.insert(_tweets, data)
		
		TriggerClientEvent("Phone:Client:Twitter:Notify", -1, data)
		return true
	end,
}

-- AddEventHandler("Phone:Server:AliasUpdated", function(src)
-- 	local char = Fetch:CharacterSource(src)
-- 	local sid = char:GetData("SID")
-- 	for k, v in ipairs(_tweets) do
-- 		if v.SID == sid then
-- 			v.author = char:GetData("Alias").twitter
-- 		end
-- 	end

-- 	TriggerLatentClientEvent("Phone:Client:SetData", -1, 50000, "tweets", _tweets)
-- end)

function ClearAllTweets(account)
	if account then
		local newTweets = {}

		for k, v in ipairs(_tweets) do
			if v.SID ~= tonumber(account) and v.author.name ~= account then
				table.insert(newTweets, v)
			end
		end

		_tweets = newTweets
		TriggerClientEvent("Phone:Client:Twitter:RemoveAccount", -1, {
			account = tonumber(account),
			count = #_tweets,
		})
	else
		_tweets = {}
		TriggerClientEvent("Phone:Client:Twitter:ClearTweets", -1)
	end
end

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Phone:CreateProfiles", function(source, cData)
		local name = string.format("%s%s%s", cData.First, cData.Last, cData.SID)

		local id = MySQL.insert.await("INSERT INTO character_app_profiles (sid, app, name, picture, meta) VALUES(?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), picture = VALUES(picture), meta = VALUES(meta)", {
			cData.SID,
			"twitter",
			name,
			nil,
			'{}',
		})

		return {
			{
				app = "twitter",
				profile = {
					sid = cData.SID,
					app = "twitter",
					name = name,
					picture = nil,
					meta = {},
				},
			},
		}
	end)

	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:CharacterSource(source)
		local alias = char:GetData("Alias")
		local profiles = char:GetData("Profiles") or {}
	
		if alias.twitter ~= nil then

			local avatar = nil
			if alias?.twitter?.avatar ~= nil then
				avatar = alias.twitter.avatar:sub(1, 512)
			end

			local rid = MySQL.insert.await("INSERT INTO character_app_profiles (sid, app, name, picture, meta) VALUES(?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), picture = VALUES(picture), meta = VALUES(meta)", {
				char:GetData("SID"),
				"twitter",
				alias.twitter.name,
				avatar,
				'{}',
			})
	
			profiles.twitter = {
				sid = char:GetData("SID"),
				app = "twitter",
				name = alias.twitter.name,
				picture = avatar,
				meta = {},
			}
	
			alias.twitter = nil
			char:SetData("Alias", alias)
			char:SetData("Profiles", profiles)
		end
	end, 2)
end)

AddEventHandler("Phone:Server:UpdateProfile", function(source, data)
	if data.app == "twitter" then
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			local count = MySQL.scalar.await('SELECT COUNT(*) FROM character_app_profiles WHERE app = ? AND name = ? and sid != ?', {
				"twitter",
				data.name,
				sid,
			})

			if count == 0 then
				MySQL.prepare.await(
					"INSERT INTO character_app_profiles (sid, app, name, picture, meta) VALUES(?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), picture = VALUES(picture), meta = VALUES(meta)",
					{
						sid,
						"twitter",
						data.name,
						data.picture,
						json.encode(data.meta or {}),
					}
				)
	
				local profiles = char:GetData("Profiles") or {}
				profiles["twitter"] = {
					sid = sid,
					app = "twitter",
					name = data.name,
					picture = data.picture,
					meta = data.meta or {},
				}
				char:SetData("Profiles", profiles)
			else
				Execute:Client(source, "Notification", "Error", "Username already in use")
			end
		end
	end
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Twitter:GetCount", function(source, data, cb)
		cb(#_tweets)
	end)

	Callbacks:RegisterServerCallback("Phone:Twitter:GetTweets", function(source, offset, cb)
		local t = {}
		for i = (#_tweets - offset), (#_tweets - offset) - 20, -1 do
			if i > 0 and _tweets[i] ~= nil then
				table.insert(t, _tweets[i])
			end
		end
		cb(t)
	end, 1)

	Callbacks:RegisterServerCallback("Phone:Twitter:CreateTweet", function(source, data, cb)
		local src = source
		local char = Fetch:CharacterSource(src)

		cb(
			Phone.Twitter:Post(
				src,
				char:GetData("SID"),
				char:GetData("Profiles").twitter,
				data.content,
				data.image,
				data.retweet,
				false
			)
		)
	end, 1)
end)

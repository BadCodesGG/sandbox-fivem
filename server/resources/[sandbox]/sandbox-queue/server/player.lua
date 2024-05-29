function PlayerClass(identifier, player, deferrals)
	local member = WebAPI.GetMember:Identifier(identifier)
	if not member or member == "" or member == -1 or not member?.name then
		return nil
	end

	local prio = 0
	local msg = ""

	if member.priority then
		local prioBoosts = tonumber(member.priority)
		if prioBoosts and prioBoosts > 0 then
			msg = "\n🎉 Extra Priority Boosts | +" .. prioBoosts
			prio = prio + prioBoosts
		end
	end

	if Queue:HasCrashPriority(identifier) then
		msg = msg .. "\n💥 Crash Priority | +50"
		prio = prio + 50
	end

	local tempPrio = Queue:HasTempPriority(identifier)
	if tempPrio then
		msg = msg .. string.format("\n🦖 Temporary Priority | +%s", tempPrio.Priority)
		prio = prio + tempPrio.Priority
	end

	local groups = {}
	table.insert(groups, member.siteRole)

	-- Everyone is management when this convar is 1
	if GetConvar("danger_everyone_is_admin", "") == "1" then
		table.insert(groups, "management")
	end

	for _, group in ipairs(groups) do
		if Config.Groups[group] and Config.Groups[group].Queue and Config.Groups[group].Queue.Priority > 0 then
			prio = prio + tonumber(Config.Groups[group].Queue.Priority)

			msg = msg
				.. "\n"
				.. string.format(
					"%s | +%s",
					Config.Groups[group].Queue.Message or Config.Groups[group].Name,
					Config.Groups[group].Queue.Priority
				)
		end
	end

	while prio == nil do
		Citizen.Wait(10)
	end

	--local tokens = GetPlayerTokens(member._id)
	local mPrio = math.min(Config.MaxPrio, prio)

	local _data = {
		Source = player,
		Groups = groups,
		Name = member.name,
		Discord = member.discord_id,
		Mention = member.mention,
		AccountID = member._id,
		Avatar = member.image,
		--Tokens = tokens,
		Identifier = identifier,
		Priority = mPrio,
		Message = msg,
		TimeBoost = 0,
		Deferrals = deferrals,
		Grace = nil,

		Timer = {
			Hour = 0,
			Minute = 0,
			Second = 0,

			Tick = function(self, plyr)
				if self.Second >= 59 then
					if self.Minute >= 59 then
						self.Second = 0
						self.Minute = 0
						self.Hour = self.Hour + 1
					else
						self.Second = 0
						self.Minute = self.Minute + 1
					end
				else
					self.Second = self.Second + 5
				end
			end,
			Output = function(self)
				if self.Hour >= 1 then
					return string.format("%d %s %d %s", self.Hour, self.Hour > 1 and "Hours" or "Hour", self.Minute, self.Minute == 1 and "Minute" or "Minutes")
				else
					return string.format("%d %s", self.Minute > 1 and self.Minute or 1, self.Minute <= 1 and "Minute" or "Minutes")
				end
			end,
		},

		IsWhitelisted = function(self)
			if Config.Groups[member.siteRole] then
				return true
			end

			return false
		end,

		IsInGracePeriod = function(self)
			if self.Grace == nil then
				return false
			else
				return os.time() <= self.Grace + (60 * Config.Settings.Grace)
			end
		end,

		GetPriority = function(self)
			return self.Priority
		end
	}

	return _data
end

function GetPlayerTokens(account)
	local p = promise.new()

	Database.Auth:findOne({
		collection = "tokens",
		query = {
			account = account,
		}
	}, function(success, results)
		if success and #results > 0 and results[1].tokens then
			p:resolve(results[1].tokens)
		else
			p:resolve(nil)
		end
	end)

	return Citizen.Await(p)
end
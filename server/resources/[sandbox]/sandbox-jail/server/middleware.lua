function RegisterMiddleware()
	Middleware:Add("Characters:Creating", function(source, cData)
		return {
			{
				Jailed = false,
			},
		}
	end)

	Middleware:Add("Characters:Spawning", function(source)
		local _src = source
		local currentTime = os.time() * 1000

		local char = Fetch:CharacterSource(_src)
		if char ~= nil then
			local jailed = char:GetData("Jailed")
			if
				(jailed and jailed.Jailed and jailed.Jailed.Time ~= nil and jailed.Jailed.Duration ~= nil)
				and (os.time() >= jailed.Time + (jailed.Duration * 60))
			then
				char:SetData("Jailed", false)
			end
		end
	end, 2)

    local function CheckJailed(source)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local jailed = char:GetData("Jailed") or false
			if
				(jailed and jailed.Jailed and jailed.Jailed.Time ~= nil and jailed.Jailed.Duration ~= nil)
				and (os.time() >= jailed.Time + (jailed.Duration * 60))
			then
				char:SetData("Jailed", false)
			end
		end
    end

	Middleware:Add("Characters:Logout", CheckJailed, 1)
	Middleware:Add("playerDropped", CheckJailed, 1)
end

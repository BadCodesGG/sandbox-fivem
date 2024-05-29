function RegisterChatCommands()
	Chat:RegisterStaffCommand("heal", function(source, args, rawCommand)
        if args[1] ~= nil then
            local admin = Fetch:Source(source)
            local char = Fetch:SID(tonumber(args[1]))
            if char ~= nil and ((char:GetData("Source") ~= admin:GetData("Source")) or admin.Permissions:IsAdmin()) then
                Callbacks:ClientCallback(char:GetData("Source"), "Damage:Heal", true)
                Status:Set(source, "PLAYER_STRESS", 0)
            else
                Chat.Send.System:Single(source, "Invalid State ID")
            end
        else
            local char = Fetch:CharacterSource(source)
            if char ~= nil then
                Callbacks:ClientCallback(source, "Damage:Heal", true)
                Status:Set(source, "PLAYER_STRESS", 0)
            end
        end
	end, {
		help = "Heals Player",
		params = {
			{
				name = "Target (Optional)",
				help = "State ID of Who You Want To Heal",
			},
		},
	}, -1)

	Chat:RegisterStaffCommand("healrange", function(source, args, rawCommand)
        local radius = args[1] and tonumber(args[1]) or 25.0

        local myPed = GetPlayerPed(source)
        for k, v in pairs(Fetch:AllCharacters()) do
            if v ~= nil then
                local src = v:GetData("Source")
                if Player(src).state.isDead then
                    local ped = GetPlayerPed(src)
                    if #(GetEntityCoords(ped) - GetEntityCoords(myPed)) <= radius then
                        Callbacks:ClientCallback(src, "Damage:Heal", true)
                    end
                end
            end
        end

        Callbacks:ClientCallback(source, "Damage:Heal", true)
        Status:Set(source, "PLAYER_STRESS", 0)
	end, {
		help = "Heals Player",
		params = {
			{
				name = "Radius (Optional)",
				help = "Radius To Heal Players (If Empty, Default Is 25 Meters)",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("god", function(source, args, rawCommand)
        if Player(source).state.isGodmode then
            SetPlayerInvincible(source, false)
            Player(source).state.isGodmode = false
            Execute:Client(source, "Notification", "Info", "God Mode Disabled")
            Callbacks:ClientCallback(source, "Damage:Admin:Godmode", false)
        else
            SetPlayerInvincible(source, true)
            Player(source).state.isGodmode = true
            Execute:Client(source, "Notification", "Info", "God Mode Enabled")
            Callbacks:ClientCallback(source, "Damage:Admin:Godmode", true)
        end
	end, {
		help = "Toggle God Mode",
	}, -1)

	Chat:RegisterAdminCommand("die", function(source, args, rawCommand)
        if not Player(source).state.isDead then
            Callbacks:ClientCallback(source, "Damage:Kill")
        end
	end, {
		help = "Kill Yourself",
	})
end
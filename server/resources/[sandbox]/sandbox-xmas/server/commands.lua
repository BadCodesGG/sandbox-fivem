function RegisterCommands()
	Chat:RegisterAdminCommand("xmastree", function(source, args, rawCommand)
		GenerateNewTree()
	end, {
		help = "Force Spawns A New Christmas Tree",
		params = {},
	}, 0)
end

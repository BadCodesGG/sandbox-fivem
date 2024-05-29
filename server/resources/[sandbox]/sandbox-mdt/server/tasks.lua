function RegisterTasks()
    Tasks:Register('mdt_warrants', 30, function()
		Logger:Trace('MDT', 'Expiring Warrants')

		-- Set Expired Active Warrants to Expired
		local r = MySQL.query.await("UPDATE mdt_warrants SET state = ? WHERE state = ? AND expires < NOW()", {
			"expired",
			"active"
		})
    end)
end
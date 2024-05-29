_MDT.Warrants = {
	Search = function(self, term, page, perPage)
		local qry = "SELECT id, state, title, creatorSID, creatorName, creatorCallsign, expires FROM mdt_warrants "
		local params = {}

		if #term > 0 then
			qry = qry .. "WHERE id = ? OR title LIKE ? "
			table.insert(params, term)
			table.insert(params, "%" .. term .. "%")
		end

		qry = qry .. "ORDER BY state, expires LIMIT ? OFFSET ?" 
        table.insert(params, perPage + 1) -- Limit
        if page > 1 then
            table.insert(params, perPage * (page - 1)) -- Offset
        else
            table.insert(params, 0) -- Offset
        end

		local results = MySQL.query.await(qry, params)

		if #results > perPage then -- There is more results for the next pages
            table.remove(results)
            pageCount = page + 1
        end

        return {
            data = results,
            pages = pageCount,
        }
	end,
	View = function(self, id)
		local warrant = MySQL.single.await("SELECT id, state, title, report, suspect, notes, creatorSID, creatorName, creatorCallsign, expires, issued FROM mdt_warrants WHERE id = ?", {
			id
		})

		if warrant and warrant.suspect then
			warrant.suspectData = MySQL.single.await("SELECT SID, First, Last, charges FROM mdt_reports_people WHERE report = ? AND type = ? AND warrant = ?", {
				warrant.report,
				"suspect",
				warrant.id
			})
		end
		
		return warrant
	end,
	Create = function(self, report, suspect, notes, author)
		local id = MySQL.insert.await("INSERT INTO mdt_warrants (title, report, suspect, notes, creatorSID, creatorName, creatorCallsign, expires) VALUES (?, ?, ?, ?, ?, ?, ?, FROM_UNIXTIME(?))", {
			string.format("Warrant For %s %s (%s)", suspect.First, suspect.Last, suspect.SID),
			report,
			suspect.id,
			notes,
			author.SID,
			string.format("%s %s", author.First, author.Last),
			author.Callsign,
			os.time() + (60 * 60 * 24 * 7)
		})

		if id then
			for user, _ in pairs(_onDutyUsers) do
				TriggerClientEvent("MDT:Client:SetData", user, "homeLastFetch", 0)
			end
			for user, _ in pairs(_onDutyLawyers) do
				TriggerClientEvent("MDT:Client:SetData", user, "homeLastFetch", 0)
			end
		end

		return id
	end,
	Update = function(self, id, state)
		local u = MySQL.query.await("UPDATE mdt_warrants SET state = ? WHERE id = ?", {
			state,
			id
		})

		if u and u.affectedRows > 0 then
			if state ~= "active" then
				MySQL.query.await("UPDATE mdt_reports_people SET warrant = NULL WHERE type = ? AND warrant = ?", {
					"suspect",
					id,
				})
			end

			for user, _ in pairs(_onDutyUsers) do
				TriggerClientEvent("MDT:Client:SetData", user, "homeLastFetch", 0)
			end
			for user, _ in pairs(_onDutyLawyers) do
				TriggerClientEvent("MDT:Client:SetData", user, "homeLastFetch", 0)
			end

			return true
		end

		return false
	end,
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Search:warrant", function(source, data, cb)
		cb(MDT.Warrants:Search(data.term, data.page, data.perPage))
	end)

	Callbacks:RegisterServerCallback("MDT:View:warrant", function(source, data, cb)
		cb(MDT.Warrants:View(data))
	end)

	Callbacks:RegisterServerCallback("MDT:Update:warrant", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if char and CheckMDTPermissions(source, false) then
			cb(MDT.Warrants:Update(data.id, data.state))
		else
			cb(false)
		end
	end)
end)

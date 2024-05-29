local PER_PAGE = 6
_MDT.Reports = {
	Search = function(self, term, rType, page, perPage, isAttorney, evidence)
        local qry = "SELECT id, type, title, created, creatorSID, creatorName, creatorCallsign FROM mdt_reports WHERE type = ? "
        local params = {
            rType,
        }

        if isAttorney then
            qry = qry .. "AND allowAttorney = 1 "
        end

        if evidence then
            if #term < 4 then
                return {
                    data = {},
                    pages = 1,
                }
            end

            local eRes = MySQL.query.await("SELECT report FROM mdt_reports_evidence WHERE value = ?", {
                term
            })

            local reports = {}
            for k, v in ipairs(eRes) do
                table.insert(reports, v.report)
            end

            qry = qry .. "AND id IN (?)"
            table.insert(params, table.concat(reports, ","))
        else
            -- suspect: 
            if rType == 0 and term and term:sub(1, 9) == "suspect: " then
                local reports = {}
                local reportsWithSuspect = MySQL.query.await("SELECT report FROM mdt_reports_people WHERE type = ? AND SID = ?", {
                    "suspect",
                    term:sub(10, #term)
                })
    
                for k, v in ipairs(reportsWithSuspect) do
                    table.insert(reports, v.report)
                end
    
                qry = qry .. string.format("AND id IN (%s) ", table.concat(reports, ","))
            elseif #term > 0 then
                qry = qry .. "AND (id = ? OR creatorSID = ? OR creatorCallsign = ?"
                table.insert(params, term)
                table.insert(params, term)
                table.insert(params, term)
    
                
                if #term >= 3 then
                    qry = qry .. " OR title LIKE ? OR creatorName LIKE ?"
                    local ffs = "%" .. term .. "%"
                    table.insert(params, ffs)
                    table.insert(params, ffs)
                end
    
                qry = qry .. ")"
            end
        end

        qry = qry .. " ORDER BY created DESC LIMIT ? OFFSET ?"
        
        table.insert(params, perPage + 1) -- Limit
        if page > 1 then
            table.insert(params, perPage * (page - 1)) -- Offset
        else
            table.insert(params, 0) -- Offset
        end

        local results = MySQL.query.await(qry, params)

        local pageCount = page
        if #results > perPage then -- There is more results for the next pages
            table.remove(results)
            pageCount = page + 1
        end

        return {
            data = results,
            pages = pageCount,
        }
	end,
    SearchEvidence = function(self, term)
        
	end,
	View = function(self, id)
        local report = MySQL.single.await("SELECT * FROM mdt_reports WHERE id = ?", {
            id
        })

        if report and report.id then
            local people = MySQL.query.await("SELECT * FROM mdt_reports_people WHERE report = ?", {
                report.id
            })

            report.allowAttorney = report.allowAttorney == 1

            local suspectList = {}

            report.suspects = {}
            report.primaries = {}
            report.people = {} 
            report.suspectsOverturned = {}

            for k, v in ipairs(people) do
                if v.type == "suspect" then
                    v.charges = json.decode(v.charges)
                    v.Licenses = json.decode(v.Licenses)
                    v.reduction = v.reduction and json.decode(v.reduction)
                    v.revoked = v.revoked and json.decode(v.revoked)

                    v.sentenced = v.sentenced == 1
                    v.expunged = v.expunged == 1
                    v.doc = v.doc == 1

                    table.insert(report.suspects, v)
                    if not v.sentenced then
                        table.insert(suspectList, v.SID)
                    end

                elseif v.type == "suspectOverturned" then
                    v.charges = json.decode(v.charges)
                    v.Licenses = json.decode(v.Licenses)
                    v.reduction = v.reduction and json.decode(v.reduction)
                    v.revoked = v.revoked and json.decode(v.revoked)

                    v.sentenced = v.sentenced == 1
                    v.expunged = v.expunged == 1
                    v.doc = v.doc == 1

                    table.insert(report.suspectsOverturned, v)
                elseif v.type == "primary" then
                    table.insert(report.primaries, v)
                elseif v.type == "person" then
                    table.insert(report.people, v)
                end
            end

            report.evidence = MySQL.query.await("SELECT id, report, value, type, label FROM mdt_reports_evidence WHERE report = ?", {
                report.id,
            })

            if #suspectList > 0 then
                report.paroleData = MySQL.query.await("SELECT SID, end, total, parole, sentence, fine FROM character_parole WHERE SID IN(?)", {
                    table.concat(suspectList, ",")
                })
            end
            return report
        end
        return false
	end,
	Create = function(self, data)
        local reportId = MySQL.insert.await("INSERT INTO mdt_reports (type, title, notes, allowAttorney, creatorSID, creatorName, creatorCallsign) VALUES (?, ?, ?, ?, ?, ?, ?)", {
            data.type,
            data.title,
            data.notes,
            data.allowAttorney and 1 or 0,
            data.author.SID,
            string.format("%s %s", data.author.First, data.author.Last),
            data.author.Callsign or "",
        })

        local queries = {}

        local peopleQry = "INSERT INTO mdt_reports_people (report, type, SID, First, Last, Callsign) VALUES"
        local peopleParams = {}
        -- Primaries
        for k, v in ipairs(data.primaries) do
            peopleQry = peopleQry .. " (?, ?, ?, ?, ?, ?)"

            table.insert(peopleParams, reportId)
            table.insert(peopleParams, "primary")
            table.insert(peopleParams, v.SID)
            table.insert(peopleParams, v.First)
            table.insert(peopleParams, v.Last)
            table.insert(peopleParams, v.Callsign)

            if k < #data.primaries or #data.people > 0 then
                peopleQry = peopleQry .. ","
            end
        end
        -- People
        for k, v in ipairs(data.people) do
            peopleQry = peopleQry .. " (?, ?, ?, ?, ?, ?)"

            table.insert(peopleParams, reportId)
            table.insert(peopleParams, "person")
            table.insert(peopleParams, v.SID)
            table.insert(peopleParams, v.First)
            table.insert(peopleParams, v.Last)
            table.insert(peopleParams, "")

            if k < #data.people then
                peopleQry = peopleQry .. ","
            end
        end
        peopleQry = peopleQry .. ";"

        if #peopleParams > 0 then
            table.insert(queries, {
                query = peopleQry,
                values = peopleParams
            })
        end

        if data.type == 0 and #data.suspects > 0 then
            local susQry = "INSERT INTO mdt_reports_people (report, type, SID, First, Last, charges, plea, Licenses) VALUES"
            local susParams = {}
            for k,v in ipairs(data.suspects) do
                susQry = susQry .. " (?, ?, ?, ?, ?, ?, ?, ?)"
                table.insert(susParams, reportId)
                table.insert(susParams, "suspect")
                table.insert(susParams, v.SID)
                table.insert(susParams, v.First)
                table.insert(susParams, v.Last)
                table.insert(susParams, json.encode(v.charges))
                table.insert(susParams, v.plea)
                table.insert(susParams, json.encode(v.Licenses))

                if k < #data.suspects then
                    susQry = susQry .. ","
                end
            end
            susQry = susQry .. ";"

            table.insert(queries, {
                query = susQry,
                values = susParams
            })
        end

        if #data.evidence > 0 then
            local evQry = "INSERT INTO mdt_reports_evidence (report, type, label, value) VALUES"
            local evParams = {}

            for k,v in ipairs(data.evidence) do
                evQry = evQry .. " (?, ?, ?, ?)"
                table.insert(evParams, reportId)
                table.insert(evParams, v.type)
                table.insert(evParams, v.label)
                table.insert(evParams, v.value)

                if k < #data.evidence then
                    evQry = evQry .. ","
                end
            end

            evQry = evQry .. ";"

            table.insert(queries, {
                query = evQry,
                values = evParams
            })
        end

        MySQL.transaction.await(queries)
        return reportId
	end,
	Update = function(self, id, char, report)
        local transaction = {
            {
                query = "UPDATE mdt_reports SET title = ?, notes = ?, allowAttorney = ? WHERE id = ?",
                values = {
                    report.title,
                    report.notes,
                    report.allowAttorney and 1 or 0,
                    id,
                }
            }
        }

        for k,v in ipairs(report.changes) do
            if v.type == "evidence" then
                if v.mode == "add" then
                    table.insert(transaction, {
                        query = "INSERT INTO mdt_reports_evidence (report, type, label, value) VALUES (?, ?, ?, ?)",
                        values = { id, v.data.type, v.data.label, v.data.value }
                    })
                elseif v.mode == "delete" then
                    table.insert(transaction, {
                        query = "DELETE FROM mdt_reports_evidence WHERE report = ? AND id = ?",
                        values = { id, v.data.id }
                    })
                end
            elseif v.type == "suspect" then
                if v.mode == "add" then
                    table.insert(transaction, {
                        query = "INSERT INTO mdt_reports_people (report, type, SID, First, Last, charges, plea) VALUES (?, ?, ?, ?, ?, ?, ?)",
                        values = { id, "suspect", v.data.SID, v.data.First, v.data.Last, json.encode(v.data.charges), v.data.plea }
                    })
                elseif v.mode == "update" then
                    table.insert(transaction, {
                        query = "UPDATE mdt_reports_people SET charges = ?, plea = ? WHERE report = ? AND type = ? AND SID = ?",
                        values = { json.encode(v.data.charges), v.data.plea, id, "suspect", v.data.SID }
                    })
                elseif v.mode == "delete" then
                    table.insert(transaction, {
                        query = "DELETE from mdt_reports_people WHERE report = ? AND type = ? AND SID = ?",
                        values = { id, "suspect", v.data.SID }
                    })
                end
            elseif v.type == "person" or v.type == "primary" then
                if v.mode == "add" then
                    table.insert(transaction, {
                        query = "INSERT INTO mdt_reports_people (report, type, SID, First, Last, Callsign) VALUES (?, ?, ?, ?, ?, ?)",
                        values = { id, v.type, v.data.SID, v.data.First, v.data.Last, v.data.Callsign or "" }
                    })
                elseif v.mode == "delete" then
                    table.insert(transaction, {
                        query = "DELETE FROM mdt_reports_people WHERE report = ? AND SID = ? AND type = ?",
                        values = { id, v.data.SID, v.type }
                    })
                end
            end
        end

        MySQL.transaction.await(transaction)

        return true
	end,
    Delete = function(self, id)
        MySQL.query.await("DELETE FROM mdt_reports WHERE id = ?", { id })
        return true
    end,
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
    Callbacks:RegisterServerCallback("MDT:Search:report", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
		if CheckMDTPermissions(source, false) or (char:GetData("Attorney") and data.isAttorney) then
			cb(MDT.Reports:Search(data.term, data.reportType, data.page, data.perPage, data.isAttorney, data.evidence))
		else
			cb(false)
		end
    end)

    Callbacks:RegisterServerCallback("MDT:Search:report-evidence", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Reports:SearchEvidence(data.term))
		else
			cb(false)
		end
    end)

    Callbacks:RegisterServerCallback("MDT:Create:report", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
		if CheckMDTPermissions(source, false) then
			data.doc.author = {
				SID = char:GetData("SID"),
				First = char:GetData("First"),
				Last = char:GetData("Last"),
				Callsign = char:GetData("Callsign"),
			}
			cb(MDT.Reports:Create(data.doc))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("MDT:Update:report", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
		if char and CheckMDTPermissions(source, false) then
			cb(MDT.Reports:Update(data.id, char, data.report))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("MDT:Delete:report", function(source, data, cb)
		if CheckMDTPermissions(source, true) then
			cb(MDT.Reports:Delete(data.id))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("MDT:View:report", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
		if CheckMDTPermissions(source, false) or char:GetData("Attorney") then
			cb(MDT.Reports:View(data))
        else
			cb(false)
		end
    end)
end)

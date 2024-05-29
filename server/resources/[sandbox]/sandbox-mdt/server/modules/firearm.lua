_MDT.Firearm = {
	Search = function(self, term)
		return MySQL.query.await("SELECT serial, model, owner_sid, owner_name FROM firearms WHERE scratched = ? AND (serial = ? OR owner_sid = ? OR owner_name LIKE ?)", {
			0,
			term,
			term,
			"%".. term .. "%"
		})
	end,
	View = function(self, id)
		local firearm = MySQL.single.await("SELECT serial, model, owner_sid, owner_name, purchased FROM firearms WHERE scratched = ? AND serial = ?", {
			0,
			id,
		})

		if firearm and firearm.serial then
			firearm.flags = MySQL.query.await("SELECT title, description, date, author_sid, author_first, author_last, author_callsign FROM firearms_flags WHERE serial = ?", {
				firearm.serial
			})
		end

		return firearm
	end,
	Flags = {
		Add = function(self, firearmSerial, data, author)
			local flag = {
				title = data.title,
				description = data.description,
				author_sid = author.SID,
				author_first = author.First,
				author_last = author.Last,
				author_callsign = author.Callsign,
			}

			local id = MySQL.insert.await("INSERT INTO firearms_flags (serial, title, description, author_sid, author_first, author_last, author_callsign) VALUES (?, ?, ?, ?, ?, ?, ?)", {
				firearmSerial,
				flag.title,
				flag.description,
				flag.author_sid,
				flag.author_first,
				flag.author_last,
				flag.author_callsign
			})

			flag.id = id

			return flag
		end,
		Remove = function(self, firearmSerial, flagId)
			MySQL.query.await("DELETE FROM firearms_flags WHERE id = ? AND serial = ?", {
				flagId,
				firearmSerial
			})
			return true
		end,
	},
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Search:firearm", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Firearm:Search(data.term or ""))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:View:firearm", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Firearm:View(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Create:firearm-flag", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and CheckMDTPermissions(source, false) then
			cb(MDT.Firearm.Flags:Add(data.parentId, data.doc, {
				SID = char:GetData("SID"),
				First = char:GetData("First"),
				Last = char:GetData("Last"),
				Callsign = char:GetData("Callsign"),
			}))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Delete:firearm-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Firearm.Flags:Remove(data.parentId, data.id))
		else
			cb(false)
		end
	end)
end)

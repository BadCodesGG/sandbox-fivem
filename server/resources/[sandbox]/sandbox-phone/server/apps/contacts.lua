local _playersContacts = {}

PHONE.Contacts = {
	IsContact = function(self, myId, targetNumber)
		if _playersContacts[myId] ~= nil then
			for k, v in ipairs(_playersContacts[myId]) do
				if v.number == targetNumber then
					return v
				end
			end

			return false
		else
			return false
		end
	end,
}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Phone:Spawning", function(source, char)
		local contacts = MySQL.query.await(
			"SELECT id, sid, number, name, avatar, color, favorite FROM character_contacts WHERE sid = ?",
			{
				char:GetData("SID"),
			}
		)

		_playersContacts[char:GetData("SID")] = contacts

		return {
			{
				type = "contacts",
				data = contacts,
			},
		}
	end)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Contacts:Create", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			local id = MySQL.insert.await(
				"INSERT INTO character_contacts (sid, number, name, avatar, color, favorite) VALUES(?, ?, ?, ?, ?, ?)",
				{
					sid,
					data.number,
					data.name,
					data.avatar,
					data.color,
					data.favorite or false,
				}
			)

			local rec = {
				id = id,
				sid = sid,
				number = data.number,
				name = data.name,
				avatar = data.avatar,
				color = data.color,
				favorite = data.favorite or false,
			}

			_playersContacts[sid] = _playersContacts[sid] or {}
			table.insert(_playersContacts[sid], rec)
			cb(id)
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Contacts:Update", function(source, data, cb)
		if data.id == nil then
			return cb(nil)
		end

		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")

			MySQL.query(
				"UPDATE character_contacts SET name = ?, number = ?, color = ?, avatar = ?, favorite = ? WHERE sid = ? AND id = ?",
				{
					data.name,
					data.number,
					data.color,
					data.avatar,
					data.favorite,
					sid,
					data.id,
				}
			)

			for k, v in ipairs(_playersContacts[sid]) do
				if v.id == data.id then
					_playersContacts[sid][k] = {
						id = data.id,
						sid = sid,
						name = data.name,
						number = data.number,
						color = data.color,
						avatar = data.avatar,
						favorite = data.favorite,
					}
				end
			end
			cb(true)
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Contacts:Delete", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")

			MySQL.query("DELETE FROM character_contacts WHERE SID = ? AND ID = ?", {
				sid,
				data,
			})

			for k, v in ipairs(_playersContacts[sid]) do
				if v.id == data then
					_playersContacts[sid][k] = nil
				end
			end
			cb(true)
		else
			cb(nil)
		end
	end)
end)

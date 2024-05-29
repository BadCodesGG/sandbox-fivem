PHONE.Messages = {
	Read = function(self, owner, number)
		MySQL.query("UPDATE character_messages SET unread = ? WHERE owner = ? AND number = ?", {
			0,
			owner,
			number,
		})
	end,
	Delete = function(self, owner, number)
		MySQL.query("DELETE FROM character_messages WHERE owner = ? AND number = ?", {
			owner,
			number,
		})
	end,
}

AddEventHandler("Phone:Server:RegisterMiddleware", function()

end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Message:InitLoad", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local messages = MySQL.rawExecute.await(
				"SELECT MAX(t1.id) AS id, t1.owner, t1.number, t1.method, UNIX_TIMESTAMP(MAX(t1.time)) AS time, COUNT(*) AS count, t1.message, t1.unread FROM character_messages t1 WHERE t1.owner = ? GROUP BY t1.owner, t1.number",
				{
					char:GetData("Phone"),
				}
			)
			TriggerLatentClientEvent("Phone:Client:Messages:SetThreads", source, 50000, messages)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Messages:LoadTexts", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local messages = MySQL.rawExecute.await(
				"SELECT id, owner, number, method, unread, UNIX_TIMESTAMP(time) as time, message FROM character_messages WHERE owner = ? AND number = ? ORDER BY TIME DESC LIMIT 20 OFFSET ?",
				{
					char:GetData("Phone"),
					data.number,
					data.offset,
				}
			)
			cb(messages)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Messages:SendMessage", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local data2 = {
			owner = data.number,
			number = data.owner,
			message = data.message,
			time = data.time,
			-- I Wanna Die Omegalul
			method = 0,
			unread = true,
		}

		local params = {}
		local qry =
			"INSERT INTO character_messages (owner, number, method, unread, time, message) VALUES (?, ?, ?, ?, FROM_UNIXTIME(?), ?), (?, ?, ?, ?, FROM_UNIXTIME(?), ?);"
		table.insert(params, data.owner)
		table.insert(params, data.number)
		table.insert(params, 1)
		table.insert(params, false)
		table.insert(params, data.time)
		table.insert(params, data.message)

		table.insert(params, data.number)
		table.insert(params, data.owner)
		table.insert(params, 0)
		table.insert(params, true)
		table.insert(params, data.time)
		table.insert(params, data.message)

		local id = MySQL.query.await(qry, params)

		if id then
			local targetChar = Fetch:CharacterData("Phone", data.number)
			if targetChar ~= nil then
				data2.id = id.insertId + 1
				data2.contact = Phone.Contacts:IsContact(targetChar:GetData("SID"), data2.number)
				TriggerClientEvent("Phone:Client:Messages:Notify", targetChar:GetData("Source"), data2, false)
			end
			cb(id.insertId)
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Messages:ReadConvo", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			Phone.Messages:Read(char:GetData("Phone"), data)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Messages:DeleteConvo", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			Phone.Messages:Delete(char:GetData("Phone"), data)
			cb(true)
		else
			cb(false)
		end
	end)
end)

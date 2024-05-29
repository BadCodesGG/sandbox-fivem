PHONE.Documents = {
	Create = function(self, source, doc)
		local char = Fetch:CharacterSource(source)
		if char ~= nil and type(doc) == "table" then
			local p = promise.new()

			doc.sid = char:GetData("SID")
			doc.time = os.time()
			doc.id = MySQL.insert.await("INSERT INTO character_documents (sid, title, content) VALUES(?, ?, ?)", {
				char:GetData("SID"),
				doc.title,
				doc.content,
			})

			return doc
		end
		return false
	end,
	Edit = function(self, source, id, doc)
		local char = Fetch:CharacterSource(source)
		if char ~= nil and type(doc) == "table" then
			local ts = os.time()
			MySQL.update.await("UPDATE character_documents SET title = ?, content = ?, time = NOW() WHERE id = ?", {
				doc.title,
				doc.content,
				id,
			})

			local doc =
				MySQL.prepare.await("SELECT id, sid, time, title, content FROM character_documents WHERE id = ?", {
					id,
				})

			local shared = MySQL.rawExecute.await(
				"SELECT sid, signature_required, signed, signed_name FROM character_documents_shared WHERE doc_id = ?",
				{
					id,
				}
			)

			for k, v in ipairs(shared) do
				local char = Fetch:SID(v.sid)
				if char then
					TriggerClientEvent("Phone:Client:UpdateData", char:GetData("Source"), "myDocuments", id, {
						id = doc.id,
						time = ts,
						title = doc.title,
						content = doc.content,
						-- signature_required = v.signature_required,
						-- signed = v.signed,
						-- signed_name = v.signed_name,
					})
				end
			end

			TriggerClientEvent("Phone:Client:UpdateData", source, "myDocuments", id, {
				id = doc.id,
				time = ts,
				title = doc.title,
				content = doc.content,
				-- signature_required = v.signature_required,
				-- signed = v.signed,
				-- signed_name = v.signed_name,
			})

			return true
		end
		return false
	end,
	Delete = function(self, source, id)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local ownerId = MySQL.scalar.await("SELECT sid FROM character_documents WHERE id = ?", {
				id,
			})

			if ownerId == char:GetData("SID") then
				local shared = MySQL.rawExecute.await("SELECT sid FROM character_documents_shared WHERE doc_id = ?", {
					id,
				})

				local queries = {}
				table.insert(queries, {
					query = "DELETE FROM character_documents_shared WHERE doc_id = ?",
					values = {
						id,
					},
				})
				table.insert(queries, {
					query = "DELETE FROM character_documents WHERE id = ?",
					values = {
						id,
					},
				})

				MySQL.transaction(queries)

				for k, v in ipairs(shared) do
					local char = Fetch:SID(v.sid)
					if char ~= nil then
						TriggerClientEvent("Phone:Client:Documents:Deleted", char:GetData("Source"), id)
						--TriggerClientEvent("Phone:Client:RemoveData", char:GetData("Source"), "myDocuments", id)
					end
				end

				return true
			else
				MySQL.query("DELETE FROM character_documents_shared WHERE doc_id = ? AND sid = ?", {
					id,
					char:GetData("SID"),
				})
				TriggerClientEvent("Phone:Client:RemoveData", char:GetData("Source"), "myDocuments", id)

				return true
			end
		end
		return false
	end,
}

local function GetDocuments(sid)
	return MySQL.rawExecute.await(
		"SELECT d.id, d.sid, UNIX_TIMESTAMP(d.time) as time, d.title, d.content, ds.sharer, ds.sharer_name, UNIX_TIMESTAMP(ds.shared_date) as shared_date, ds.signature_required, ds.signed, ds.signed_name FROM character_documents d LEFT JOIN character_documents_shared ds ON d.id = ds.doc_id AND ds.sid = ? WHERE d.sid = ? OR d.id IN (SELECT ds2.doc_id FROM character_documents_shared ds2 WHERE ds2.doc_id = d.id AND ds2.sid = ?)",
		{
			sid,
			sid,
			sid,
		}
	)
end

local function GetDocument(id, sid)
	return MySQL.prepare.await(
		"SELECT d.id, d.sid, UNIX_TIMESTAMP(d.time) as time, d.title, d.content, ds.sharer, ds.sharer_name, UNIX_TIMESTAMP(ds.shared_date) as shared_date, ds.signature_required, ds.signed, ds.signed_name FROM character_documents d LEFT JOIN character_documents_shared ds ON d.id = ds.doc_id AND ds.sid = ? WHERE d.id = ? AND (d.sid = ? OR d.id IN (SELECT ds2.doc_id FROM character_documents_shared ds2 WHERE ds2.doc_id = d.id AND ds2.sid = ?))",
		{
			sid,
			id,
			sid,
			sid,
		}
	)
end

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Phone:Spawning", function(source, char)
		local sid = char:GetData("SID")
		return {
			{
				type = "myDocuments",
				data = GetDocuments(sid),
			},
		}
	end)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Documents:Create", function(source, data, cb)
		cb(Phone.Documents:Create(source, data))
	end)

	Callbacks:RegisterServerCallback("Phone:Documents:Edit", function(source, data, cb)
		cb(Phone.Documents:Edit(source, data.id, data.data))
	end)

	Callbacks:RegisterServerCallback("Phone:Documents:Delete", function(source, data, cb)
		cb(Phone.Documents:Delete(source, data))
	end)

	Callbacks:RegisterServerCallback("Phone:Documents:Refresh", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			cb("myDocuments", GetDocuments(char:GetData("SID")))
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Documents:Share", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and data and data.type and data.document then
			local target = nil
			if not data.nearby then
				if not data.target then
					return cb(false)
				end

				target = Fetch:SID(data.target)

				if not target then
					return cb(false)
				end

				if target:GetData("SID") == char:GetData("SID") then
					return cb(false)
				end
			end

			local shareData = nil

			if data.type == 1 then
				data.document.id = nil
				data.document.sharedBy = {
					ID = char:GetData("ID"),
					First = char:GetData("First"),
					Last = char:GetData("Last"),
					SID = char:GetData("SID"),
				}
				data.document.shared = true
				data.document.sharedWith = {}

				sharedData = {
					isCopy = true,
					document = data.document,
				}
			elseif data.type == 2 or data.type == 3 then
				sharedData = {
					isCopy = false,
					document = {
						id = data.document.id,
						title = data.document.title,
						sharedBy = {
							ID = char:GetData("ID"),
							First = char:GetData("First"),
							Last = char:GetData("Last"),
							SID = char:GetData("SID"),
						},
					},
					requireSignature = data.type == 3,
				}
			end

			if sharedData then
				if target then
					TriggerClientEvent("Phone:Client:ReceiveShare", target:GetData("Source"), {
						type = "documents",
						data = sharedData,
					}, os.time())

					return cb(true)
				else
					local myPed = GetPlayerPed(source)
					local myCoords = GetEntityCoords(myPed)
					local myBucket = GetPlayerRoutingBucket(source)
					for k, v in ipairs(GetPlayers()) do
						local tsrc = tonumber(v)
						local tped = GetPlayerPed(tsrc)
						local coords = GetEntityCoords(tped)
						if
							tsrc ~= source
							and #(myCoords - coords) <= 5.0
							and GetPlayerRoutingBucket(tsrc) == myBucket
						then
							TriggerClientEvent("Phone:Client:ReceiveShare", tsrc, {
								type = "documents",
								data = sharedData,
							}, os.time())
						end
					end

					return cb(true)
				end
			end
		end

		cb(false)
	end)

	Callbacks:RegisterServerCallback("Phone:Documents:RecieveShare", function(source, data, cb)
		if data then
			if data.isCopy then
				cb(Phone.Documents:Create(source, data.document))
			else
				local char = Fetch:CharacterSource(source)
				if char then
					local sid = char:GetData("SID")
					local signName = string.format("%s %s", char:GetData("First"):sub(1, 1), char:GetData("Last"))

					local existing = MySQL.prepare.await(
						"SELECT sid, signature_required FROM character_documents_shared WHERE doc_id = ? AND sid = ?",
						{
							data.document.id,
							sid,
						}
					)

					if not existing then
						MySQL.insert.await(
							"INSERT INTO character_documents_shared (doc_id, sid, sharer, sharer_name, signature_required, signed_name) VALUES(?, ?, ?, ?, ?, ?)",
							{
								data.document.id,
								sid,
								data.document.sharedBy.SID,
								string.format("%s %s", data.document.sharedBy.First, data.document.sharedBy.Last),
								data.requireSignature,
								signName,
							}
						)

						if data.requireSignature then
							local sender = Fetch:SID(data.document.sharedBy.SID)
							if sender ~= nil then
								TriggerClientEvent(
									"Phone:Client:Documents:SigReqReceived",
									sender:GetData("Source"),
									data.document.id,
									{
										sid = sid,
										signed_name = signName,
										signed = nil,
									}
								)
							end
						end

						local rDoc = GetDocument(data.document.id, sid)
						cb(rDoc)
					elseif existing.signature_required == 0 and data.requireSignature then
						MySQL.query.await(
							"UPDATE character_documents_shared SET signature_required = ?, signed_name = ? WHERE doc_id = ? AND sid = ?",
							{
								true,
								signName,
								data.document.id,
								sid,
							}
						)

						local sender = Fetch:SID(data.document.sharedBy.SID)
						if sender ~= nil then
							TriggerClientEvent(
								"Phone:Client:Documents:SigReqReceived",
								sender:GetData("Source"),
								data.document.id,
								{
									sid = sid,
									signed_name = signName,
									signed = nil,
								}
							)
						end

						local rDoc = GetDocument(data.document.id, sid)
						rDoc.update = true
						cb(rDoc)
					else
						cb(false)
					end
				else
					cb(false)
				end
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Documents:Sign", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char then
			local signName = string.format("%s %s", char:GetData("First"):sub(1, 1), char:GetData("Last"))
			local ts = os.time()
			local sid = char:GetData("SID")

			MySQL.update.await(
				"UPDATE character_documents_shared SET signed = NOW(), signed_name = ? WHERE doc_id = ? AND sid = ?",
				{
					signName,
					tonumber(data),
					sid,
				}
			)

			TriggerClientEvent("Phone:Client:UpdateData", char:GetData("Source"), "myDocuments", tonumber(data), {
				signed = ts,
				signed_name = signName,
			})

			local ownerId = MySQL.scalar.await("SELECT sid FROM character_documents WHERE id = ?", {
				tonumber(data),
			})

			local owner = Fetch:SID(ownerId)
			if owner ~= nil then
				TriggerClientEvent(
					"Phone:Client:Documents:SigReqReceived",
					owner:GetData("Source"),
					tonumber(data),
					{
						sid = sid,
						signed = ts,
						signed_name = signName,
					}
				)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Documents:GetSignatures", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local signers = MySQL.rawExecute.await(
				"SELECT sid, UNIX_TIMESTAMP(signed) as signed, signed_name FROM character_documents_shared WHERE doc_id = ? AND signature_required = ?",
				{
					data,
					true,
				}
			)
			cb(signers)
		else
			cb({})
		end
	end)
end)

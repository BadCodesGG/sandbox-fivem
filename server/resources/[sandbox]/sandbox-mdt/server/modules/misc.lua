local _runningBoloId = 0

_MDT.Misc = {
	Create = {
		BOLO = function (self, data)
			data.id = _runningBoloId
			table.insert(_bolos, data)
			for user, _ in pairs(_onDutyUsers) do
				TriggerClientEvent("MDT:Client:AddData", user, "bolos", data)
			end

			_runningBoloId = _runningBoloId + 1
		end,
		Charge = function(self, data)
			local id = MySQL.insert.await("INSERT INTO mdt_charges (type, title, description, fine, jail, points) VALUES (?, ?, ?, ?, ?, ?)", {
				data.type,
				data.title,
				data.description,
				data.fine,
				data.jail,
				data.points
			})

			data.id = id

			table.insert(_charges, data)
			for user, _ in pairs(_onDutyUsers) do
				TriggerClientEvent("MDT:Client:AddData", user, "charges", data)
			end
			for user, _ in pairs(_onDutyLawyers) do
				TriggerClientEvent("MDT:Client:AddData", user, "charges", data)
			end

			return true
		end,
		Notice = function(self, data)
			if not data.restricted then
				data.restricted = "public"
			end

			local id = MySQL.insert.await("INSERT INTO mdt_notices (title, description, creator, restricted) VALUES (?, ?, ?, ?)", {
				data.title,
				data.description,
				data.author,
				data.restricted
			})

			for user, _ in pairs(_onDutyUsers) do
				TriggerClientEvent("MDT:Client:SetData", user, "homeLastFetch", 0)
			end
			for user, _ in pairs(_onDutyLawyers) do
				TriggerClientEvent("MDT:Client:SetData", user, "homeLastFetch", 0)
			end

			return id
		end,
	},
	View = {
		Notice = function(self, id)
			return MySQL.single.await("SELECT id, title, description, creator, created, restricted FROM mdt_notices WHERE id = ?", {
				id
			})
		end,
	},
	Update = {
		Charge = function(self, id, data)
			local u = MySQL.query.await("UPDATE mdt_charges SET type = ?, title = ?, description = ?, fine = ?, jail = ?, points = ? WHERE id = ?", {
				data.type,
				data.title,
				data.description,
				data.fine,
				data.jail,
				data.points,
				id
			})

			if u and u.affectedRows > 0 then
				for k, v in ipairs(_charges) do
					if (v.id == id) then
						_charges[k] = data
						break
					end
				end

				for user, _ in pairs(_onDutyUsers) do
					TriggerClientEvent("MDT:Client:UpdateData", user, "charges", id, data)
				end
				for user, _ in pairs(_onDutyLawyers) do
					TriggerClientEvent("MDT:Client:UpdateData", user, "charges", id, data)
				end

				return true
			end
			return false
		end,
	},
	Delete = {
		BOLO = function(self, id)
			for k, v in ipairs(_bolos) do
				if v.id == id then
					table.remove(_bolos, k)
					for user, _ in pairs(_onDutyUsers) do
						TriggerClientEvent("MDT:Client:RemoveData", user, "bolos", k)
					end
					return true
				end
			end

			return false
		end,
		Notice = function(self, id)
			MySQL.query.await("DELETE FROM mdt_notices WHERE id = ?", {
				id
			})

			for user, _ in pairs(_onDutyUsers) do
				TriggerClientEvent("MDT:Client:SetData", user, "homeLastFetch", 0)
			end
			for user, _ in pairs(_onDutyLawyers) do
				TriggerClientEvent("MDT:Client:SetData", user, "homeLastFetch", 0)
			end

			return true
		end,
		Charge = function(self, id)
			MySQL.query.await("DELETE FROM mdt_charges WHERE id = ?", {
				id
			})

			for k, v in ipairs(_charges) do
				if (v.id == id) then
					table.remove(_charges, k)
					break
				end
			end

			for user, _ in pairs(_onDutyUsers) do
				TriggerClientEvent("MDT:Client:RemoveData", user, "charges", id)
			end
			for user, _ in pairs(_onDutyLawyers) do
				TriggerClientEvent("MDT:Client:RemoveData", user, "charges", id)
			end

			return true
		end,
	}
}


AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Create:BOLO", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if CheckMDTPermissions(source, false, 'police') then
			data.doc.author = {
				SID = char:GetData("SID"),
				First = char:GetData("First"),
				Last = char:GetData("Last"),
				Callsign = char:GetData("Callsign"),
			}
			MDT.Misc.Create:BOLO(data.doc)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Delete:BOLO", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(MDT.Misc.Delete:BOLO(data.id))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Create:charge", function(source, data, cb)
		if CheckMDTPermissions(source, true) then
			data.doc.active = true
			cb(MDT.Misc.Create:Charge(data.doc))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Update:charge", function(source, data, cb)
		if CheckMDTPermissions(source, true) then
			cb(MDT.Misc.Update:Charge(data.doc.id, data.doc))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Delete:charge", function(source, data, cb)
		if CheckMDTPermissions(source, true) then
			cb(MDT.Misc.Delete:Charge(data.doc.id))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Create:notice", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and CheckMDTPermissions(source, {
			'PD_HIGH_COMMAND',
			'SAFD_HIGH_COMMAND',
			'DOJ_JUDGE',
			'GOV_MAYOR',
			'GOV_DA',
			'GOV_CPUB',
			'DOC_HIGH_COMMAND',
		}) then
			data.doc.author = char:GetData("SID")
			cb(MDT.Misc.Create:Notice(data.doc))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:View:notice", function(source, data, cb)
		cb(MDT.Misc.View:Notice(data))
	end)

	Callbacks:RegisterServerCallback("MDT:Delete:notice", function(source, data, cb)
		if CheckMDTPermissions(source, {
			'PD_HIGH_COMMAND',
			'SAFD_HIGH_COMMAND',
			'DOC_HIGH_COMMAND',
		}) then
			cb(MDT.Misc.Delete:Notice(data.id))
		else
			cb(false)
		end
	end)
end)

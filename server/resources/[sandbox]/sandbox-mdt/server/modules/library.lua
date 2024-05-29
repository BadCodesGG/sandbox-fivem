_MDT.Library = {
	Create = function(self, label, link, job, workplace)
        local inserted = MySQL.insert.await("INSERT INTO mdt_library (label, link, job, workplace) VALUES (?, ?, ?, ?)", {
            label,
            link,
            job,
            workplace and workplace or nil,
        })

        return inserted
    end,
	Delete = function(self, id)
        MySQL.query.await("DELETE FROM mdt_library WHERE id = ?", {
            id
        })

        return true
    end
}


AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:AddLibraryDocument", function(source, data, cb)
		if CheckMDTPermissions(source, true) then
			cb(MDT.Library:Create(data.label, data.link, data.job, data.workplace))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:RemoveLibraryDocument", function(source, data, cb)
		if CheckMDTPermissions(source, true) then
			cb(MDT.Library:Delete(data.id))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:GetLibraryDocuments", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
        if char then
            local dutyData = Jobs.Duty:Get(source)

            if CheckMDTPermissions(source, true) then
                local res = MySQL.query.await("SELECT id, label, link FROM mdt_library ORDER BY label", {})

                cb(res)
            elseif dutyData then
                local res = MySQL.query.await("SELECT id, label, link FROM mdt_library WHERE (job = ? AND workplace IS NULL) OR (job = ? AND workplace = ?) ORDER BY label", {
                    dutyData.Id,
                    dutyData.Id,
                    dutyData.WorkplaceId,
                })
                cb(res)
            else
                cb({})
            end
        else
            cb({})
        end
	end)
end)

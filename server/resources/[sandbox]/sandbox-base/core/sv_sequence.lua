local _cachedSeq = {}
local _loading = {}

COMPONENTS.Sequence = {
	Get = function(self, key)
		if _cachedSeq[key] ~= nil then
			_cachedSeq[key].sequence += 1
			_cachedSeq[key].dirty = true
			return _cachedSeq[key].sequence
		else
			_cachedSeq[key] = {
				id = key,
				sequence = 1,
				dirty = true,
			}
			return 1
		end
	end,

	Save = function(self)
		local queries = {}
		for k, v in pairs(_cachedSeq) do
			if v.dirty then
				table.insert(queries, {
					query = "INSERT INTO sequence (id, sequence) VALUES(?, ?) ON DUPLICATE KEY UPDATE sequence = VALUES(sequence)",
					values = {
						k,
						v.sequence,
					},
				})

				v.dirty = false
			end
		end

		MySQL.transaction(queries)
	end,
}

AddEventHandler("Core:Server:StartupReady", function()
	local t = MySQL.rawExecute.await("SELECT id, sequence FROM sequence")
	for k, v in ipairs(t) do
		_cachedSeq[v.id] = {
			id = v.id,
			sequence = v.sequence,
			dirty = false,
		}
	end
end)

AddEventHandler("Core:Shared:Ready", function()
	COMPONENTS.Tasks:Register("sequence_save", 10, function()
		COMPONENTS.Sequence:Save()
	end)
end)

AddEventHandler("Core:Server:ForceSave", function()
	COMPONENTS.Sequence:Save()
end)

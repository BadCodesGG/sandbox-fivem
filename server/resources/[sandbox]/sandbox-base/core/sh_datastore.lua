local _stores = {}

local _blacklistedCharEvents = {
	HP = true,
	Armor = true,
}

COMPONENTS.DataStore = {
	_name = "base",
	CreateStore = function(self, owner, key, data)
		data = data or {}
		_stores[owner] = _stores[owner] or {}

		_stores[owner][key] = data

		return {
			Owner = owner,
			Key = key,
			SetData = function(self, var, data)
				_stores[self.Owner][self.Key][var] = data

				if self.Key == "Character" and IsDuplicityVersion() and not _blacklistedCharEvents[var] then
					TriggerClientEvent("Characters:Client:SetData", _stores[self.Owner][self.Key]["Source"], var, data)
				end
			end,
			GetData = function(self, var)
				if var ~= nil and var ~= "" then
					if
						_stores[self.Owner]
						and _stores[self.Owner][self.Key]
						and _stores[self.Owner][self.Key][var] ~= nil
					then
						return _stores[self.Owner][self.Key][var]
					else
						return nil
					end
				else
					return _stores[self.Owner][self.Key]
				end
			end,
			DeleteStore = function(self)
				COMPONENTS.DataStore:DeleteStore(self.Owner, self.Key)
			end,
		}
	end,
	DeleteStore = function(self, owner, key)
		if _stores[owner] then
			_stores[owner][key] = nil
		end
	end,
}

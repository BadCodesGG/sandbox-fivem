AddEventHandler("Reputation:Shared:DependencyUpdate", RepComponents)
function RepComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Reputation", {
		"Fetch",
		"Callbacks",
		"Database",
		"Middleware",
		"Logger",
		"Database",
		"Reputation",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RepComponents()
		RepItems()
	end)
end)

function RepItems()
	Inventory.Items:RegisterUse("rep_voucher", "RandomItems", function(source, item)
		local char = Fetch:CharacterSource(source)
		if item.MetaData.Reputation and ((item.MetaData.Amount and tonumber(item.MetaData.Amount) or 0) > 0) then
			Reputation.Modify:Add(source, item.MetaData.Reputation, item.MetaData.Amount)
			Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
		else
			Execute:Client(source, "Notification", "Error", "Invalid Voucher")
		end
	end)
end

_REP = {
	Create = function(self, id, label, levels, hidden)
		GlobalState[string.format("Rep:%s", id)] = {
			id = id,
			label = label,
			levels = levels,
			hidden = hidden,
		}
	end,
	GetLevel = function(self, source, id)
		if GlobalState[string.format("Rep:%s", id)] ~= nil then
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local reps = char:GetData("Reputations") or {}
                local level = 0
				if reps[id] ~= nil then
                    for k, v in ipairs(GlobalState[string.format("Rep:%s", id)].levels) do
                        if v.value <= reps[id] then
                            level = k
                        end
                    end
                    return level
				else
					return 0
				end
			else
				return nil
			end
		else
			return nil
		end
	end,
	HasLevel = function(self, source, id, level)
		if GlobalState[string.format("Rep:%s", id)] ~= nil then
			return _REP:GetLevel(source, id) >= level
		else
			return false
		end
	end,
	View = function(self, source)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local reps = char:GetData("Reputations") or {}
			local viewingData = {}

			for id, val in pairs(reps) do
				local repData = GlobalState[string.format("Rep:%s", id)]
				if id and val and repData and not repData.hidden then
					local repCurrent = {
						level = 0,
						value = 0
					}

					for k, v in ipairs(repData.levels) do
                        if v.value <= val then
							repCurrent = {
								level = k,
								label = v.label,
								value = v.value,
							}
                        end
                    end

					local repNext = {
						level = repCurrent.level += 1
					}

					local nextRepLevel = repCurrent.level += 1
					local nextRepLevelLabel = nil
					if repData.levels[nextRepLevel] then
						repNext.value = repData.levels[nextRepLevel].value
						repNext.label = repData.levels[nextRepLevel].label
					else
						repNext = {
							level = repCurrent.level,
							value = repCurrent.value,
							label = 'Done!',
						}
					end

					table.insert(viewingData, {
						id = repData.id,
						label = repData.label,
						value = val,
						current = repCurrent,
						next = repNext,
					})
				end
			end

			return viewingData
		else
			return nil
		end
	end,
	ViewList = function(self, source, list)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local reps = char:GetData("Reputations") or {}
			local viewingData = {}

			for id, val in pairs(reps) do
				local repData = GlobalState[string.format("Rep:%s", id)]
				if id and val and repData and list[id] then
					local repCurrent = {
						level = 0,
						value = 0
					}

					for k, v in ipairs(repData.levels) do
                        if v.value <= val then
							repCurrent = {
								level = k,
								label = v.label,
								value = v.value,
							}
                        end
                    end

					local repNext = {
						level = repCurrent.level += 1
					}

					local nextRepLevel = repCurrent.level += 1
					local nextRepLevelLabel = nil
					if repData.levels[nextRepLevel] then
						repNext.value = repData.levels[nextRepLevel].value
						repNext.label = repData.levels[nextRepLevel].label
					else
						repNext = {
							level = repCurrent.level,
							value = repCurrent.value,
							label = 'Done!',
						}
					end

					table.insert(viewingData, {
						id = repData.id,
						label = repData.label,
						value = val,
						current = repCurrent,
						next = repNext,
					})
				end
			end

			return viewingData
		else
			return nil
		end
	end,
	Modify = {
		Add = function(self, source, id, amount)
			if GlobalState[string.format("Rep:%s", id)] ~= nil then
                local rep = GlobalState[string.format("Rep:%s", id)]
				local char = Fetch:CharacterSource(source)
				if char ~= nil then
					local reps = char:GetData("Reputations") or {}
					if reps[id] ~= nil then
						if reps[id] + math.abs(amount) <= rep.levels[#rep.levels].value then
							reps[id] = reps[id] + math.abs(amount)
						else
							reps[id] = rep.levels[#rep.levels].value
						end
					else
						if math.abs(amount) <= rep.levels[#rep.levels].value then
							reps[id] = math.abs(amount)
						else
							reps[id] = rep.levels[#rep.levels].value
						end
					end
					char:SetData("Reputations", reps)
				end
			end
		end,
		Remove = function(self, source, id, amount)
			if GlobalState[string.format("Rep:%s", id)] ~= nil then
                local rep = GlobalState[string.format("Rep:%s", id)]

				local char = Fetch:CharacterSource(source)
				if char ~= nil then
					local reps = char:GetData("Reputations") or {}
					if reps[id] ~= nil and (reps[id] - math.abs(amount) > 0) then
						reps[id] = reps[id] - math.abs(amount)
					else
						reps[id] = 0
					end
					char:SetData("Reputations", reps)
				end
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Reputation", _REP)
end)

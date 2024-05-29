AddEventHandler("Loot:Shared:DependencyUpdate", LootComponents)
function LootComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Loot", {
		"Callbacks",
		"Fetch",
		"Logger",
		"Utils",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end
		LootComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Loot", _LOOT)
end)

_LOOT = {
	ItemClass = function(self, owner, invType, class, count)
		return INVENTORY:AddItem(owner, itemClasses[class][math.random(#itemClasses[class])], count, {}, invType)
	end,
	CustomSet = function(self, set, owner, invType, count)
		return INVENTORY:AddItem(owner, set[math.random(#set)], count, {}, invType)
	end,
	CustomSetWithCount = function(self, set, owner, invType)
		local i = set[math.random(#set)]
		return INVENTORY:AddItem(owner, i.name, math.random(i.min or 0, i.max), {}, invType)
	end,
	-- Pass a set array with the following layout
	-- set = {
	-- 	{chance_num, item_name },
	-- }
	CustomWeightedSet = function(self, set, owner, invType)
		local randomItem = Utils:WeightedRandom(set)
		if randomItem then
			return INVENTORY:AddItem(owner, randomItem, 1, {}, invType)
		end
	end,
	-- Pass a set array with the following layout
	-- set = {
	-- 	{chance_num, { name = item, max = max } },
	-- }
	CustomWeightedSetWithCount = function(self, set, owner, invType, dontAdd)
		local randomItem = Utils:WeightedRandom(set)
		if randomItem?.name and randomItem?.max then
			if dontAdd then
				return {
					name = randomItem.name,
					count = math.random(randomItem.min or 1, randomItem.max)
				}
			else
				return INVENTORY:AddItem(owner, randomItem.name, math.random(randomItem.min or 1, randomItem.max), randomItem.metadata or {}, invType)
			end
		end
	end,
	-- Pass a set array with the following layout
	-- set = {
	-- 	{chance_num, { name = item, max = max } },
	-- }
	CustomWeightedSetWithCountAndModifier = function(self, set, owner, invType, modifier, dontAdd)
		local randomItem = Utils:WeightedRandom(set)
		if randomItem?.name and randomItem?.max then
			if dontAdd then
				return {
					name = randomItem.name,
					count = math.random(randomItem.min or 1, randomItem.max) * modifier
				}
			else
				return INVENTORY:AddItem(owner, randomItem.name, math.random(randomItem.min or 1, randomItem.max) * modifier, randomItem.metadata or {}, invType)
			end
		end
	end,
	Sets = {
		Gem = function(self, owner, invType)
			local randomGem = Utils:WeightedRandom({
				{5, "diamond"},
				{5, "emerald"},
				{5, "sapphire"},
				{5, "ruby"},
				{25, "amethyst"},
				{25, "citrine"},
				{75, "opal"},
			})
			return INVENTORY:AddItem(owner, randomGem, 1, {}, invType)
		end,
		GemRandom = function(self, owner, invType, day)
			local randomGem = nil
			if day == 1 then
				randomGem = Utils:WeightedRandom({
					{15, "diamond"},
					{15, "emerald"},
					{20, "sapphire"},
					{20, "ruby"},
					{25, "amethyst"},
					{25, "citrine"},
					{50, "opal"},
				})
			else
				randomGem = Utils:WeightedRandom({
					{5, "diamond"},
					{5, "emerald"},
					{5, "sapphire"},
					{5, "ruby"},
					{25, "amethyst"},
					{25, "citrine"},
					{75, "opal"},
				})
			end
			
			return INVENTORY:AddItem(owner, randomGem, 1, {}, invType)
		end,
		Ore = function(self, owner, invType, count)
			local randomOre = Utils:WeightedRandom({
				{12, "goldore"},
				{18, "silverore"},
				{50, "ironore"},
			})
			return INVENTORY:AddItem(owner, randomOre, count, {}, invType)
		end,
	},
}

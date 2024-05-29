function GenerateNewTree()
	if _currentDate.month == XMAS_MONTH then
		_currentTree = {
			model = `prop_xmas_tree_int`,
			location = _xmasConfig.Locations[math.random(#_xmasConfig.Locations)],
		}

		_treeLooted = {}

		TriggerClientEvent("Xmas:Client:NewTree", -1, _currentTree)
		Logger:Trace("Xmas", "Generated New Tree Location")
	end
end

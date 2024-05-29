AddEventHandler("Core:Shared:Ready", function()
	-- COMPONENTS.Database.Auth:find({
	-- 	collection = "roles",
	-- 	query = {},
	-- }, function(success, results)
	-- 	if not success or #results <= 0 then
	-- 		COMPONENTS.Logger:Critical("Core", "Failed to Load User Groups", {
	-- 			console = true,
	-- 			file = true,
	-- 		})

	-- 		return
	-- 	end

	-- 	COMPONENTS.Config.Groups = {}

	-- 	for k, v in ipairs(results) do
	-- 		COMPONENTS.Config.Groups[v.Abv] = v
	-- 	end

	-- 	COMPONENTS.Logger:Info("Core", string.format("Loaded %s User Groups", #results), {
	-- 		console = true,
	-- 	})
	-- end)
end)

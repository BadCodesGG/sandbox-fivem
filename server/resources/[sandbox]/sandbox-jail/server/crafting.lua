function RegisterPrisonCraftingStartup()
	for k, v in pairs(_prisonCrafting.peds) do
		Crafting:RegisterBench(k, v.target, {
			ped = {
				model = v.model,
				task = v.anim,
			},
			icon = v.icon,
		}, {
			x = v.coords.x,
			y = v.coords.y,
			z = v.coords.z,
			h = v.coords.w,
		}, {
			rep = {
				id = "PrisonSearch",
				level = v.level,
			},
		}, _prisonCrafting.recipes[v.recipeType])
	end
end

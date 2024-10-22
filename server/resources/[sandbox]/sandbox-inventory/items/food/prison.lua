_itemsSource["food_prison"] = {
	{
		name = "prison_food",
		label = "Prison Food",
		price = 5,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 1,
		isDestroyed = true,
		durability = (60 * 60 * 24),
		statusChange = {
			Add = {
				PLAYER_HUNGER = 100,
			},
		},
		animConfig = {
			anim = "sandwich",
			time = 8000,
			pbConfig = {
				label = "Eating",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		metalic = false,
	},
	{
		name = "prison_drink",
		label = "Prison Drink",
		price = 5,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 0.5,
		isDestroyed = true,
		durability = (60 * 60 * 24),
		statusChange = {
			Add = {
				PLAYER_THIRST = 100,
			},
		},
		animConfig = {
			anim = "soda",
			time = 8000,
			pbConfig = {
				label = "Drinking",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		metalic = false,
	},
	{
		name = "fruitpunchslushie",
		label = "Prison Slushi",
		price = 5,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 0.5,
		isDestroyed = true,
		durability = (60 * 60 * 3),
		statusChange = {
			Add = {
				PLAYER_THIRST = 100,
			},
		},
		animConfig = {
			anim = "soda",
			time = 8000,
			pbConfig = {
				label = "Drinking",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		metalic = false,
	},
	{
		name = "beatdownberryrazz",
		label = "Beatdown BerryRazz",
		price = 5,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 0.5,
		isDestroyed = true,
		durability = (60 * 60 * 3),
		statusChange = {
			Add = {
				PLAYER_THIRST = 50,
			},
		},
		animConfig = {
			anim = "soda",
			time = 8000,
			pbConfig = {
				label = "Drinking",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		metalic = false,
		healthModifier = 25,
	},
}

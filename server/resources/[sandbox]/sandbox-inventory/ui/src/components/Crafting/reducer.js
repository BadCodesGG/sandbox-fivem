const initialState = {
	bench: 'none',
	crafting: null,
	schematics: Object(),
	cooldowns:
		process.env.NODE_ENV == 'production'
			? Object()
			: Object({
					3: Date.now() + 1000 * 60 * 60 * 25,
			  }),
	recipes:
		process.env.NODE_ENV == 'production'
			? Array()
			: [
					{
						result: { name: 'bread', count: 5 },
						items: [{ name: 'water', count: 3 }],
					},
					{
						result: { name: 'water', count: 5 },
						items: [{ name: 'bread', count: 3 }],
					},
			  ],
};

const reducer = (state = initialState, action) => {
	switch (action.type) {
		case 'SET_BENCH': {
			return {
				...state,
				bench: action.payload.bench,
				cooldowns: action.payload.cooldowns,
				recipes: action.payload.recipes,
			};
		}
		case 'UPDATE_COOLDOWNS':
			return {
				...state,
				cooldowns: action.payload.cooldowns,
			};
		case 'SET_CRAFTING': {
			return {
				...state,
				crafting: {
					...action.payload,
					progress: 0,
				},
			};
		}
		case 'SET_SCHEMS':
			return {
				...state,
				schematics: action.payload,
			};
		case 'END_CRAFTING':
			return {
				...state,
				crafting: null,
			};
		case 'CRAFT_PROGRESS':
			return {
				...state,
				crafting: {
					...state.crafting,
					progress: action.payload.progress,
				},
			};
		case 'APP_HIDE':
			return {
				...state,
				recipes: Array(),
			};
		default: {
			return state;
		}
	}
};

export default reducer;

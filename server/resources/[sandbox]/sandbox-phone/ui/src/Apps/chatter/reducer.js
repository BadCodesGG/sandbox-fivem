export const initialState = {
	groups:
		process.env.NODE_ENV == 'production'
			? []
			: [
					{
						id: 1,
						label: 'Test Channel',
						icon: 'https://i.imgur.com/rKqJ6H1.jpeg',
						owner: 1,
						joined_date: 1687109208,
						last_message: 1687109210,
					},
					{
						id: 2,
						label: 'pls be last lol',
						icon: 'https://i.imgur.com/rKqJ6H1.jpeg',
						owner: 1,
						joined_date: 1687109208,
						last_message: null,
					},
			  ],
	invites:
		process.env.NODE_ENV == 'production'
			? {}
			: {
					1: {
						group: 1,
						label: 'Test Channel',
						icon: 'https://i.imgur.com/rKqJ6H1.jpeg',
						timestamp: 1687735062,
						sender: 2,
					},
			  },
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'CHATTER_SET_GROUPS':
			return {
				...state,
				groups: action.payload.groups,
			};
		case 'CHATTER_SET_INVITES':
			return {
				...state,
				invites: action.payload.invites,
			};
		case 'CHATTER_ADD_GROUP':
			return {
				...state,
				groups: [...state.groups, action.payload.group],
			};
		case 'CHATTER_REMOVE_GROUP':
			return {
				...state,
				groups: [
					...state.groups.filter((g) => g.id != action.payload.group),
				],
			};
		case 'CHATTER_UPDATE_GROUP':
			return {
				...state,
				groups: [
					...state.groups.map((t) => {
						if (t.id == action.payload.group.id)
							return { ...t, ...action.payload.group };
						else return t;
					}),
				],
			};
		case 'CHATTER_UPDATE_GROUP_IF_EXISTS':
			return {
				...state,
				groups:
					state.groups.filter((t) => t.id == action.payload.group.id)
						.length > 0
						? [
								...state.groups.map((t) => {
									if (t.id == action.payload.group.id)
										return {
											...t,
											...action.payload.group,
											count: t.count + 1,
										};
									else return t;
								}),
						  ]
						: [
								...state.groups,
								{
									...action.payload.group,
									count: 1,
								},
						  ],
			};
		case 'CHATTER_RECEIVE_INVITE':
			return {
				...state,
				invites: {
					...state.invites,
					[action.payload.invite.group]: action.payload.invite,
				},
			};
		case 'CHATTER_REMOVE_INVITE':
			return {
				...state,
				invites: {
					...Object.keys(state.invites)
						.filter((i) => i != action.payload.group)
						.reduce((obj, key) => {
							obj[key] = state.invites[key];
							return obj;
						}, {}),
				},
			};
		default:
			return state;
	}
};

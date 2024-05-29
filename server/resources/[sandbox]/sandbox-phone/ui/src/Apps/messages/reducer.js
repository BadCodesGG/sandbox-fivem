export const initialState = {
	loaded: false,
	threads:
		process.env.NODE_ENV == 'production'
			? null
			: [
					{
						owner: '555-555-5555',
						number: '111-111-1111',
						type: 1,
						time: Date.now() / 1000,
						message: 'This is a test',
						unread: 3,
						count: 180,
					},
					{
						owner: '555-555-5555',
						number: '222-222-2222',
						type: 0,
						time: Date.now() / 1000,
						message: 'just another test lol',
						unread: 0,
						count: 14,
					},
			  ],
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'MESSAGES_LOADED':
			return {
				...state,
				loaded: true,
			};
		case 'SET_MESSAGE_THREADS':
			return {
				...state,
				threads: [
					...action.payload.threads.map((t) => {
						return {
							...t,
							unread: 0,
						};
					}),
				],
			};
		case 'ADD_THREAD':
			if (!state.loaded) return;
			return {
				...state,
				threads: [...state.threads, action.payload.thread],
			};
		case 'REMOVE_THREAD':
			if (!state.loaded) return;
			return {
				...state,
				threads: [
					...state.threads.filter(
						(t) => t.number != action.payload.number,
					),
				],
			};
		case 'UPDATE_THREAD':
			if (!state.loaded) return;
			return {
				...state,
				threads: [
					...state.threads.map((t) => {
						if (t.number == action.payload.thread.number)
							return { ...t, ...action.payload.thread };
						else return t;
					}),
				],
			};
		case 'UPDATE_THREAD_IF_EXISTS':
			if (!state.loaded) return;
			return {
				...state,
				threads:
					state.threads.filter(
						(t) => t.number == action.payload.thread.number,
					).length > 0
						? [
								...state.threads.map((t) => {
									if (
										t.number == action.payload.thread.number
									)
										return {
											...t,
											...action.payload.thread,
											count: t.count + 1,
											unread: t.unread + 1,
										};
									else return t;
								}),
						  ]
						: [
								...state.threads,
								{
									...action.payload.thread,
									count: 1,
									unread: 1,
								},
						  ],
			};
		case 'MESSAGES_CLEAR_UNREAD':
			if (!state.loaded) return;
			return {
				...state,
				threads: [
					...state.threads.map((t) => {
						if (t.number == action.payload.number)
							return { ...t, unread: 0 };
						else return t;
					}),
				],
			};
		case 'UI_RESET':
			return {
				...state,
				loaded: false,
				threads: null,
			};
		default:
			return state;
	}
};

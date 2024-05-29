export const initialState = {
	open: null,
	new: [],
	notifications:
		process.env.NODE_ENV == 'production'
			? []
			: [
					{
						id: 1,
						title: 'Test Title',
						description:
							'This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description.',
						time: Date.now() / 1000,
						show: true,
						duration: 1000,
						app: 'messages',
						action: {
							accept: 'EventName',
							cancel: 'EventName',
							view: 'convo/111-111-1111',
						},
					},
					{
						id: 2,
						title: 'Test Title',
						description:
							'This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description.',
						time: Date.now() / 1000,
						show: true,
						duration: -1,
						app: 'messages',
						action: {
							accept: 'EventName',
							cancel: 'EventName',
						},
					},
					{
						id: 3,
						title: 'Test Title',
						description:
							'This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description.',
						time: Date.now() / 1000,
						show: true,
						manual: true,
						app: 'messages',
						action: {
							view: 'convo/111-111-1111',
						},
					},
			  ],
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'NOTIF_RESET_APP':
			return {
				...state,
				open: null,
			};
		case 'NOTIF_HIDE':
			return {
				...state,
				notifications: [
					...state.notifications.map((n, k) => {
						if (n.id == action.payload?.id)
							return { ...n, show: false };
						else return n;
					}),
				],
			};
		case 'NOTIF_COLLAPSE':
			return {
				...state,
				notifications: [
					...state.notifications.map((n, k) => {
						if (n.id == action.payload.id)
							return { ...n, collapsed: true };
						else return n;
					}),
				],
			};
		case 'APP_OPEN':
			return {
				...state,
				open: action.payload,
			};
		case 'NOTIF_ADD':
			return {
				...state,
				notifications:
					Boolean(action.payload.notification.id) &&
					state.notifications.filter(
						(n) => n.id == action.payload.notification.id,
					).length > 0
						? [
								...state.notifications.map((n) => {
									if (n.id == action.payload.notification.id)
										return {
											...action.payload.notification,
											collapsed: false,
										};
									else return n;
								}),
						  ]
						: [
								{
									id: state.notifications.length,
									...action.payload.notification,
									collapsed: false,
								},
								...state.notifications,
						  ],
			};
		case 'NOTIF_UPDATE':
			return {
				...state,
				notifications: state.notifications.map((notif) => {
					if (notif.id == action.payload.id)
						return {
							...notif,
							title: action.payload.title,
							description: action.payload.description,
							collapsed: false,
						};
					else return notif;
				}),
			};
		case 'REMOVE_NEW_NOTIF':
			return {
				...state,
				new: state.new.filter((a, i) => i > 0),
			};
		case 'NOTIF_DISMISS':
			return {
				...state,
				notifications: state.notifications.filter(
					(n, i) => i != action.payload.index,
				),
			};
		case 'NOTIF_DISMISS_APP':
			return {
				...state,
				notifications: state.notifications.filter(
					(n) => n.app != action.payload.app,
				),
			};
		case 'NOTIF_DISMISS_ALL':
			return {
				...state,
				notifications: [],
			};
		default:
			return state;
	}
};

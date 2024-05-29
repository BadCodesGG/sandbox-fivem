export const initialState = {
	hidden: process.env.NODE_ENV == 'production',
	brand: process.env.NODE_ENV == 'production' ? null : 'fleeca',
	app: process.env.NODE_ENV == 'production' ? null : 'BANK',
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'APP_SHOW':
			return {
				...state,
				hidden: false,
			};
		case 'APP_HIDE':
			return {
				...state,
				hidden: true,
			};
		case 'SET_APP':
			return {
				...state,
				hidden: false,
				brand: action.payload.brand ?? 'fleeca',
				app: action.payload.app,
			};
		default:
			return state;
	}
};

export default appReducer;

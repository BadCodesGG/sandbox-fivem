export const initialState = {
    hidden: process.env.NODE_ENV == 'production',
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
        default:
            return state;
    }
};

export default appReducer;

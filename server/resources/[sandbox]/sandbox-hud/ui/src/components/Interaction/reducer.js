export const initialState = {
    show:  process.env.NODE_ENV != 'production',
    menuItems:  process.env.NODE_ENV == 'production' ? Array() : [
        {
            id: 1,
			label: 'Test',
			icon: 'x',
			shouldShow: true,
			action: 'd',
			labelFunc: null,
        }
    ],
    layer: 0,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_INTERACTION_MENU':
            return {
                ...state,
                show: action.payload.toggle,
            };
        case 'SET_INTERACTION_LAYER':
            return {
                ...state,
                layer: action.payload.layer,
            };
        case 'SET_INTERACTION_MENU_ITEMS':
            return {
                ...state,
                menuItems: action.payload.items.sort((a, b) => a.id - b.id),
            };
        default:
            return state;
    }
};

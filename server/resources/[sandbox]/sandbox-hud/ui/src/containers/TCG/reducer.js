export const initialState = {
    open: process.env.NODE_ENV != 'production',
    cards: [
        {
            id: 1,
            label: 'Zach Wilson',
            description: 'STABBY STAB',
            image: 'https://i.imgur.com/85Qu2nJ.png',
        },
    ],
    collected: [
        {
            id: 1,
            sid: 1,
            card: 1,
            quality: 88,
            variant: 0,
            case_type: 0,
        },
    ],
};

export default (state = initialState, action) => {
    switch (action.type) {
        default:
            return state;
    }
};

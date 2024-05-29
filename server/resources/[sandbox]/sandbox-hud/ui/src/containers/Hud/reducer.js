export const initialState = {
    showing: process.env.NODE_ENV != 'production',
    voip: 2,
    voipIcon: 'microphone',
    talking: 0,
    settings: process.env.NODE_ENV != 'production',
    config: {
        layout: 'default',
        statusType: 'numbers',
        buffsAnchor: 'compass',
        buffsAnchor2: true,
        showRPM: true,
        hideCrossStreet: false,
        hideCompassBg: true,
        largeBars: false,
        minimapAnchor: true,
        transparentBg: false,
        vehicle: 'minimal',
        maskRadio: false,
        condenseAlignment: 'left',
        circleNumbers: false,
    },
    position:
        process.env.NODE_ENV == 'production'
            ? {}
            : {
                  Y: 0.88595553199968,
                  width: 0.14062499895226,
                  topY: 0.79783427715301,
                  X: 0.08104687504237,
                  height: 0.17624250969333,
                  leftX: 0.01073437556624,
                  bottomY: 0.97407678684635,
                  rightX: 0.1513593745185,
              },
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_HUD':
            return {
                ...state,
                showing: true,
            };
        case 'HIDE_HUD':
            return {
                ...state,
                showing: false,
            };
        case 'SET_CONFIG':
            return {
                ...state,
                config: action.payload.config,
            };
        case 'UPDATE_MM_POS':
        case 'SHIFT_LOCATION':
            return {
                ...state,
                position: action.payload.position,
            };
        case 'TOGGLE_HUD':
            return {
                ...state,
                showing: !state.showing,
            };
        case 'SET_VOIP_LEVEL':
            return {
                ...state,
                voip: action.payload.level,
                talking: action.payload.talking,
                voipIcon: action.payload.icon,
            };
        case 'TOGGLE_SETTINGS':
            return {
                ...state,
                settings: action.payload.state,
            };
        default:
            return state;
    }
};

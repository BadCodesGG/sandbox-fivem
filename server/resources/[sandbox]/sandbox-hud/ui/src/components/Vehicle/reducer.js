export const initialState = {
    showing: process.env.NODE_ENV != 'production',
    ignition: process.env.NODE_ENV != 'production',
    nos: process.env.NODE_ENV == 'production' ? 0 : 75,
    speed: 0,
    rpm: 0.4,
    speedMeasure: 'MPH',
    seatbelt: process.env.NODE_ENV == 'production',
    seatbeltHide: false,
    cruise: process.env.NODE_ENV != 'production',
    checkEngine: process.env.NODE_ENV != 'production',
    fuel: 8,
    fuelHide: false,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_VEHICLE':
            return {
                ...state,
                showing: true,
            };
        case 'HIDE_VEHICLE':
            return {
                ...state,
                showing: false,
            };
        case 'UPDATE_IGNITION':
            return {
                ...state,
                ignition: action.payload.ignition,
            };
        case 'UPDATE_RPM':
            return {
                ...state,
                rpm: action.payload.rpm,
            };
        case 'UPDATE_SPEED':
            return {
                ...state,
                speed: action.payload.speed,
            };
        case 'UPDATE_SPEED_MEASURE':
            return {
                ...state,
                speedMeasure: action.payload.measurement,
            };
        case 'UPDATE_SEATBELT':
            return {
                ...state,
                seatbelt: action.payload.seatbelt,
            };
        case 'SHOW_SEATBELT':
            return {
                ...state,
                seatbeltHide: false,
            };
        case 'HIDE_SEATBELT':
            return {
                ...state,
                seatbeltHide: true,
            };
        case 'UPDATE_CRUISE':
            return {
                ...state,
                cruise: action.payload.cruise,
            };
        case 'UPDATE_ENGINELIGHT':
            return {
                ...state,
                checkEngine: action.payload.checkEngine,
            };
        case 'SHOW_HUD':
        case 'UPDATE_FUEL':
            return {
                ...state,
                fuel: Boolean(action.payload.fuel)
                    ? action.payload.fuel
                    : state.fuel,
                fuelHide:
                    typeof action.payload.fuelHide == 'boolean'
                        ? action.payload.fuelHide
                        : state.fuelHide,
            };
        case 'SHOW_FUEL':
            return {
                ...state,
                fuelHide: false,
            };
        case 'HIDE_FUEL':
            return {
                ...state,
                fuelHide: true,
            };
        case 'UPDATE_NOS':
            return {
                ...state,
                nos: action.payload.nos,
            };
        default:
            return state;
    }
};

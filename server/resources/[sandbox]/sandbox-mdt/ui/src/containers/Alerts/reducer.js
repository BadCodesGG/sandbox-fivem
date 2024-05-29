import Nui from '../../util/Nui';

export const initialState = {
	showing: process.env.NODE_ENV != 'production',
	alerts: Array(),

	units: Array(),
	myUnit: null,
	dispatchExpanded: true,
	dispatchLog: Array(),
	radioNames: Array(),
	attached: Array(),
	showing: false,
	// alerts: [
	// 	{
	// 		id: 1,
	// 		title: 'Breaking & Entering',
	// 		code: '10-31A',
	// 		type: 1,
	// 		time: Date.now(),
	// 		location: {
	// 			street1: 'Buccaneer Way',
	// 			street2: null,
	// 			area: 'Terminal',
	// 			x: 0,
	// 			y: 0,
	// 			z: 0,
	// 		},
	// 		description: {
	// 			icon: 'car',
	// 			details: 'White Gauntlet',
	// 			vehicleColor: { r: 0, g: 0, b: 0 },
	// 			vehiclePlate: "AAAAAA",
	// 			vehicleClass: "D",
	// 		},
	// 		onScreen: true,
	// 	},
	// 	{
	// 		id: 2,
	// 		title: 'Breaking & Entering',
	// 		code: '10-31A',
	// 		type: 2,
	// 		time: Date.now(),
	// 		location: {
	// 			street1: 'Buccaneer Way',
	// 			street2: null,
	// 			area: 'Terminal',
	// 			x: 0,
	// 			y: 0,
	// 			z: 0,
	// 		},
	// 		description: {
	// 			icon: 'car',
	// 			details: 'White Gauntlet',
	// 		},
	// 		onScreen: true,
	// 		panic: true,
	// 	},
	// 	{
	// 		id: 3,
	// 		title: 'Breaking & Entering',
	// 		code: '10-31A',
	// 		type: 3,
	// 		time: Date.now(),
	// 		location: {
	// 			street1: 'Buccaneer Way',
	// 			street2: null,
	// 			area: 'Terminal',
	// 			x: 0,
	// 			y: 0,
	// 			z: 0,
	// 		},
	// 		description: {
	// 			icon: 'car',
	// 			details: 'White Gauntlet',
	// 		},
	// 		onScreen: true,
	// 		panic: true,
	// 	},
	// ],
	socketConnected: false,
	socketInitialised: false,
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'RESET_ALERTS':
			return {
				...state,
				alerts: Array(),
			};
		case 'SET_SHOWING':
			return {
				...state,
				showing: action.payload.state,
			};
		case 'TOGGLE_DISPATCH_LOG':
			return {
				...state,
				dispatchExpanded: !state.dispatchExpanded,
			};
		case 'TOGGLE_ROSTER_SECTION':
			return {
				...state,
				rosterSections: {
					...state.rosterSections,
					[action.payload.type]: !state.rosterSections[action.payload.type],
				},
			};
		case 'ADD_ALERT':
			Nui.send('ReceiveAlert', action.payload.alert);
			return {
				...state,
				alerts: [
					...state.alerts.filter(
						(alert) => alert.time >= Date.now() - 60000 * 30 || alert.attached.length > 0,
					),
					{
						...action.payload.alert,
						onScreen: true,
						time: Date.now(),
					},
				],
			};
		case 'REMOVE_ALERT':
			Nui.send('RemoveAlert', { id: action.payload.id });
			return {
				...state,
				alerts: state.alerts.filter((alert) => alert.id !== action.payload.id),
			};
		case 'UPDATE_ALERT_UNITS':
			if (action.payload.id && state.alerts) {
				const myUnitData = state.units?.[state.myUnit.job]?.find((u) => u?.primary === state.myUnit?.primary);
				const meAttached = action.payload.units.includes(
					myUnitData?.operatingUnder != null ? myUnitData?.operatingUnder : myUnitData?.primary,
				);

				if (state.attached.includes(action.payload.id) || !meAttached) {
					return {
						...state,
						alerts: state.alerts.map((a) => {
							if (a.id === action.payload.id) {
								a.attached = action.payload.units;
								return a;
							} else {
								return a;
							}
						}),
					};
				} else if (meAttached) {
					Nui.send('AssignedToAlert', action.payload.id);
					return {
						...state,
						alerts: state.alerts.map((a) => {
							if (a.id === action.payload.id) {
								a.attached = action.payload.units;
								return a;
							} else {
								return a;
							}
						}),
						attached: [...state.attached, action.payload.id],
					};
				}
			} else return state;
		case 'ADD_UNIT':
			return {
				...state,
				units: {
					...state.units,
					[action.payload.unit.job]: [...state.units[action.payload.unit.job], action.payload.unit],
				},
			};
		case 'REMOVE_UNIT':
			if (state.units[action.payload.job]) {
				return {
					...state,
					units: {
						...state.units,
						[action.payload.job]: state.units[action.payload.job].filter(
							(unit) => unit.source !== action.payload.source,
						),
					},
				};
			} else {
				return state;
			}
		case 'UPDATE_UNIT_DATA':
			if (action.payload.job) {
				return {
					...state,
					units: {
						...state.units,
						[action.payload.job]: state.units[action.payload.job].map((u) => {
							if (u.primary == action.payload.primary) {
								return {
									...u,
									[action.payload.key]: action.payload.value,
								};
							} else {
								return u;
							}
						}),
					},
				};
			} else {
				return state;
			}
		case 'OPERATE_UNDER_UNIT':
			// action.payload.job
			// action.payload.callsign - the unit that is attaching
			// action.payload.primary - the unit that is attaching to
			return {
				...state,
				units: {
					...state.units,
					[action.payload.job]: state.units[action.payload.job].map((u) => {
						if (u.primary == action.payload.callsign) {
							return {
								...u,
								operatingUnder: action.payload.primary,
							};
						} else {
							return u;
						}
					}),
				},
			};
		case 'BREAK_OFF_UNIT':
			// action.payload.job
			// action.payload.callsign - the unit that is breaking off

			return {
				...state,
				units: {
					...state.units,
					[action.payload.job]: state.units[action.payload.job].map((u) => {
						if (u.primary == action.payload.callsign) {
							return {
								...u,
								operatingUnder: null,
							};
						} else {
							return u;
						}
					}),
				},
			};
		case 'UPDATE_RADIO_INFO':
			return {
				...state,
				radioNames: action.payload.data,
			};
		case 'ADD_DISPATCH_LOG':
			const data = [...state.dispatchLog];

			if (data.length > 200) data.shift();

			return {
				...state,
				dispatchLog: [...data, action.payload.data],
			};
		case 'ALERTS_WS_STATE':
			if (action.payload.connected) {
				return {
					...state,
					socketConnected: true,
					socketInitialised: state.socketInitialised,
				};
			} else {
				return {
					...state,
					socketConnected: false,
				};
			}
		case 'ALERTS_WS_INIT':
			return {
				...state,
				socketInitialised: true,
				units: action.payload.units,
				alerts: action.payload.alerts,
				myUnit: action.payload.myUnit,
				radioNames: action.payload.radioNames,
				dispatchLog: action.payload.dispatchLog,
				socket: action.payload.socket,
				rosterSections: {
					police: false,
					ems: false,
					prison: false,
					tow: false,
					[action.payload.myUnit.job]: true,
				},
			};
		case 'ALERTS_WS_DISCONNECT':
			return {
				...initialState,
			};
		default:
			return state;
	}
};

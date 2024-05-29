export const initialState = {
	inRace: false,
	creator: null,
	invites:
		process.env.NODE_ENV == 'production'
			? Array()
			: [
					{
						id: 1,
						sender: 'Full_send',
						expires: Date.now() + 1000 * 60 * 5,
					},
			  ],
	races:
		process.env.NODE_ENV == 'production'
			? {}
			: {
					1: {
						id: 1,
						class: 'S',
						name: 'Test Race Test Race Test Race Test Race Test Race Test Race Test Race',
						state: 0,
						racers: {
							MeFast: {
								source: 1,
								sid: 1,
							},
							Full_send: {
								source: 2,
								sid: 2,
							},
						},
						track: 1,
						laps: 3,
						host: 'MeFast',
						host_src: 2,
						host_id: 2,
						buyin: 500,
						access: 'invite',
					},
					2: {
						id: 2,
						class: 'S',
						name: 'Test Race Test Race Test Race Test Race Test Race Test Race Test Race',
						state: 2,
						racers: {
							MeFast: {
								source: 1,
								sid: 1,
							},
						},
						track: 1,
						laps: 3,
						host: 'MeFast',
						host_src: 1,
						host_id: 1,
						buyin: 500,
					},
					3: {
						id: 3,
						class: 'A',
						name: 'Test Race Test Race Test Race Test Race Test Race Test Race Test Race',
						state: 2,
						racers: {
							MeFast: {
								place: 1,
								isOwned: false,
								car: 'drafter',
								reward: {
									cash: 1000,
									coin: 'VRM',
									crypto: 10,
								},
								fastest: {
									lap_start: 1687294263,
									lap_end: 1687294266,
								},
								finished: true,
							},
							MeSlow: {
								place: 2,
								isOwned: false,
								car: 'drafter',
								reward: {
									cash: 1000,
									coin: 'VRM',
									crypto: 10,
								},
								fastest: {
									lap_start: 1687294263,
									lap_end: 1687294266,
								},
								finished: true,
							},
							MeSlow2: {
								place: 3,
								isOwned: false,
								car: 'drafter',
								reward: {
									cash: 1000,
									coin: 'VRM',
									crypto: 10,
								},
								fastest: {
									lap_start: 1687294263,
									lap_end: 1687294266,
								},
								finished: true,
							},
							MeSlow3: {
								place: 4,
								isOwned: false,
								car: 'drafter',
								reward: {
									cash: 1000,
									coin: 'VRM',
									crypto: 10,
								},
								fastest: {
									lap_start: 1687294263,
									lap_end: 1687294266,
								},
								finished: true,
							},
							MeSlow4: {
								place: 5,
								isOwned: false,
								car: 'drafter',
								reward: {
									cash: 1000,
									coin: 'VRM',
									crypto: 10,
								},
								fastest: {
									lap_start: 1687294263,
									lap_end: 1687294266,
								},
								finished: true,
							},
							MeSlow5: {
								place: 6,
								isOwned: false,
								car: 'drafter',
								reward: {
									cash: 1000,
									coin: 'VRM',
									crypto: 10,
								},
								fastest: {
									lap_start: 1687294263,
									lap_end: 1687294266,
								},
								finished: true,
							},
							MeSlow6: {
								place: 7,
								isOwned: false,
								car: 'drafter',
								reward: {
									cash: 1000,
									coin: 'VRM',
									crypto: 10,
								},
								fastest: {
									lap_start: 1687294263,
									lap_end: 1687294266,
								},
								finished: true,
							},
							MeSlow7: {
								place: false,
								isOwned: false,
								car: 'drafter',
								reward: {
									cash: 1000,
									coin: 'VRM',
									crypto: 10,
								},
								fastest: {
									lap_start: 1687294263,
									lap_end: 1687294266,
								},
								finished: false,
							},
						},
						track: 1,
						laps: 3,
						host: 'MeFast',
						host_id: 1,
						host_src: 1,
						buyin: 500,
					},
			  },
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'RACE_STATE_CHANGE':
			return {
				...state,
				creator: action.payload.state,
			};
		case 'EVENT_SPAWN':
			return {
				...state,
				races: { ...action.payload.races },
				inRace: false,
			};
		case 'I_RACE':
			return {
				...state,
				inRace: action.payload.state,
			};
		case 'ADD_PENDING_RACE':
			return {
				...state,
				races: {
					...state.races,
					[action.payload.race.id]: action.payload.race,
				},
			};
		case 'CANCEL_RACE':
			return {
				...state,
				races: {
					...state.races,
					[action.payload.race]: {
						...state.races[action.payload.race],
						state: -1,
					},
				},
				inRace: action.payload.myRace ? false : state.inRace,
			};
		case 'STATE_UPDATE':
			return {
				...state,
				races: {
					...state.races,
					[action.payload.race]: {
						...state.races[action.payload.race],
						state: action.payload.state,
					},
				},
			};
		case 'JOIN_RACE':
			return {
				...state,
				races: {
					...state.races,
					[action.payload.race]: {
						...state.races[action.payload.race],
						racers: {
							...state.races[action.payload.race].racers,
							[action.payload.racer]: action.payload.racerData,
						},
					},
				},
			};
		case 'LEAVE_RACE':
			return {
				...state,
				races: {
					...state.races,
					[action.payload.race]: {
						...state.races[action.payload.race],
						racers: Object.keys(
							state.races[action.payload.race].racers,
						).reduce((result, key) => {
							if (key != action.payload.racer) {
								result[key] =
									state.races[action.payload.race].racers[
										key
									];
							}
							return result;
						}, {}),
					},
				},
			};
		case 'RACER_FINISHED':
			return {
				...state,
				races: {
					...state.races,
					[action.payload.race]: {
						...state.races[action.payload.race],
						racers: {
							...r.racers,
							[action.payload.racer]: action.payload.finish,
						},
					},
				},
			};
		case 'FINISH_RACE':
			return {
				...state,
				races: {
					...state.races,
					[action.payload.id]: action.payload.race,
				},
			};
		case 'NEW_INVITE':
			return {
				...state,
				invites: [...state.invites, action.payload.invite],
			};
		case 'REMOVE_INVITE':
			return {
				...state,
				invites: [
					...state.invites.filter((i) => i.id != action.payload.id),
				],
			};
		case 'UI_RESET':
			return {
				...initialState,
				invites: [...state.invites],
				inRace: state.inRace,
			};
		default:
			return state;
	}
};

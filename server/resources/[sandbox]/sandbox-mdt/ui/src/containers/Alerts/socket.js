import io from 'socket.io-client';

const alertsSocketMiddleware = (store) => (next) => (action) => {
	let socket;
	let state;
	switch (action.type) {
		case 'ALERTS_WS_CONNECT':
			if (store.getState().alerts?.socket) store.getState().alerts.socket.disconnect();
			socket = io(action.payload.url, {
				query: {
					token: action.payload.token, // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lc3BhY2UiOiJtZHQtYWxlcnRzIiwic291cmNlIjoxLCJqb2IiOiJwb2xpY2UiLCJjYWxsc2lnbiI6IjEwMSIsImlhdCI6MTY5MzI0NDUzNX0.ghc7QkYutM3-921__0uFxwscmMmvCG06P9L0BZGLSN8',
				},
			});

			socket.on('connect', () => {
				console.log('Connected to WSS');
				store.dispatch({
					type: 'ALERTS_WS_STATE',
					payload: {
						connected: true,
					},
				});
			});

			socket.on('disconnect', (reason) => {
				console.log('Disconnected From Dispatch WebSocket:', reason);
				store.dispatch({
					type: 'ALERTS_WS_STATE',
					payload: {
						connected: false,
					},
				});
			});

			socket.on('init', (data, alerts, units, myUnit, radioNames, dispatchLog) => {
				console.log('Successfully Connected to Dispatch WebSocket - Running Init');
				store.dispatch({
					type: 'ALERTS_WS_INIT',
					payload: {
						alerts,
						units,
						myUnit,
						radioNames,
						dispatchLog,
						socket,
					},
				});
			});

			socket.on('alert', (alert) => {
				console.log('RECEIVE Dispatch ALERT');
				const state = store.getState();
				if (!state.alerts.socketInitialised) return;

				store.dispatch({
					type: 'ADD_ALERT',
					payload: {
						alert,
					},
				});
			});

			socket.on('unitUpdateData', (data) => {
				store.dispatch({
					type: 'UPDATE_UNIT_DATA',
					payload: data,
				});
			});

			socket.on('unitAdd', (unit) => {
				store.dispatch({
					type: 'ADD_UNIT',
					payload: {
						unit,
					},
				});
			});

			socket.on('unitRemove', (job, source) => {
				store.dispatch({
					type: 'REMOVE_UNIT',
					payload: {
						job,
						source,
					},
				});
			});

			socket.on('unitOperateUnder', (job, callsign, primary) => {
				store.dispatch({
					type: 'OPERATE_UNDER_UNIT',
					payload: {
						job,
						callsign,
						primary,
					},
				});
			});

			socket.on('unitBreakOff', (job, callsign) => {
				store.dispatch({
					type: 'BREAK_OFF_UNIT',
					payload: {
						job,
						callsign,
					},
				});
			});

			socket.on('alertUpdateUnits', (id, units) => {
				store.dispatch({
					type: 'UPDATE_ALERT_UNITS',
					payload: {
						id,
						units,
					},
				});
			});

			socket.on('radioInfoUpdate', (data) => {
				store.dispatch({
					type: 'UPDATE_RADIO_INFO',
					payload: {
						data,
					},
				});
			});

			socket.on('dispatchLog', (log) => {
				store.dispatch({
					type: 'ADD_DISPATCH_LOG',
					payload: {
						data: log,
					},
				});
			});

			socket.on('alertRemove', (id) => {
				store.dispatch({
					type: 'REMOVE_ALERT',
					payload: {
						id,
					},
				});
			});

			return;
		case 'ALERTS_WS_DISCONNECT':
			state = store.getState().alerts;
			if (state.socketConnected) state.socket.disconnect();
			return;
		case 'ALERTS_CHANGE_UNIT_TYPE':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('changeUnit', action.payload.job, action.payload.primary, action.payload.type);
			}
			return;
		case 'ALERTS_CHANGE_UNIT_AVAILABILITY':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('changeAvailability', action.payload.job, action.payload.primary);
			}
			return;
		case 'ALERTS_OPERATE_UNDER_UNIT':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('operateUnderUnit', action.payload.job, action.payload.primary, action.payload.unit);
			}
			return;
		case 'ALERTS_BREAK_OFF_UNIT':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('breakOffUnit', action.payload.job, action.payload.primary, action.payload.unit);
			}
			return;
		case 'ALERTS_UPDATE_ALERT_UNITS':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('updateAlertUnits', action.payload.id, action.payload.units);
			}
			return;
		case 'ALERTS_RADIO_INFO_ADD':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('addRadioInfo', action.payload.data);
			}
			return;
		case 'ALERTS_RADIO_INFO_UPDATE':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('updateRadioInfo', action.payload.id, action.payload.data);
			}
			return;
		case 'ALERTS_RADIO_INFO_REMOVE':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('removeRadioInfo', action.payload.id, action.payload.data);
			}
			return;
		case 'ALERTS_UPDATE_PURSUIT_MODE':
			state = store.getState().alerts;
			if (state.socketConnected && state.myUnit && state.units && state.units[state.myUnit.job]) {
				const myUnitData = state.units[state.myUnit.job].find((u) => u.primary === state.myUnit.primary);

				if (myUnitData) {
					state.socket.emit(
						'changePursuitMode',
						myUnitData.job,
						myUnitData.operatingUnder !== null ? myUnitData.operatingUnder : myUnitData.primary,
						action.payload.mode,
					);
				}
			}
			return;
		case 'ALERTS_UPDATE_RADIO_CHANNEL':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('changeRadioChannel', action.payload.channel);
			}
			return;
		case 'ALERTS_REMOVE_ALERT':
			state = store.getState().alerts;
			if (state.socketConnected) {
				const alert = state.alerts.find((alert) => alert.id === action.payload.id);

				if (alert.client) {
					store.dispatch({
						type: 'REMOVE_ALERT',
						payload: {
							id: alert.id,
						},
					});
				} else {
					state.socket.emit('removeAlert', alert.id);
				}
			}
			return;
		case 'EMIT_LOG_MESSAGE':
			state = store.getState().alerts;
			if (state.socketConnected) {
				state.socket.emit('logMessage', action.payload.message);
			}
			return;
	}

	next(action);
};

export default alertsSocketMiddleware;

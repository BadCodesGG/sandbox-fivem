import {
	APP_RESET,
	SET_SPAWNS,
	SELECT_SPAWN,
	DESELECT_SPAWN,
} from '../../actions/types';

export const initialState = {
	spawns:
		process.env.NODE_ENV == 'production'
			? []
			: [
					{
						id: 0,
						icon: 'location-smile',
						label: 'Last Location',
						location: { x: 0, y: 0, z: 0, h: 0 },
					},
					{
						id: 1,
						icon: 'building',
						label: 'Test Location 1',
						location: { x: 0, y: 0, z: 0, h: 0 },
					},
					{
						id: 2,
						icon: 'house-tree',
						label: 'Test Location 2',
						location: { x: 0, y: 0, z: 0, h: 0 },
					},
					{
						id: 2,
						icon: 'cars',
						label: 'Test Location 2',
						location: { x: 0, y: 0, z: 0, h: 0 },
					},
			  ],
	selected: null,
};

const spawnReducer = (state = initialState, action) => {
	switch (action.type) {
		case SET_SPAWNS:
			return { ...state, spawns: action.payload.spawns };
		case SELECT_SPAWN:
			return { ...state, selected: action.payload };
		case DESELECT_SPAWN:
			return { ...state, selected: null };
		case APP_RESET:
			return { ...initialState };
		default:
			return state;
	}
};

export default spawnReducer;

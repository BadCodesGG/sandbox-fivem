export const initialState = {
	show: false,
	showPopup: false,
	currentSong: Array()
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'MUSIC_APP_OPEN':
			return {
				...state,
				show: true,
			};
		case 'MUSIC_APP_CLOSED':
			return {
				...state,
				show: false,
				showPopup: action.payload.musicPlayerActive
			};
		case 'MUSIC_PROGRESS':
			return {
				...state,
				showPopup: action.payload.music.isPlaying,
				currentSong: {
					id: action.payload.music.id,
					label_name: action.payload.music.label_name,
					title: action.payload.music.title,
					isPlaying: action.payload.music.isPlaying,
					duration: action.payload.music.duration,
				}
			};
		case 'UI_RESET':
			return {
				...initialState,
			};
		default:
			return state;
	}
};

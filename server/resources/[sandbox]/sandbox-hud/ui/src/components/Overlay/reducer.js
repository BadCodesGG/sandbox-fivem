export const initialState = {
	showing: false,
	data: {},
    // showing: true,
	// data: [
	// 	{
	// 		Name: "vanityitem",
	// 		MetaData: {
	// 			CustomItemImage: `https://wallpapercave.com/wp/wp4765544.jpg`
	// 		}
	// 	}
	// ],
};

export default (state = initialState, action) => {
    switch (action.type) {
		case 'SHOW_OVERLAY':
			return {
				...state,
				showing: true,
				data: action.payload,
			};		
		case 'CLOSE_UI':
		case 'RESET_UI':
		case 'HIDE_OVERLAY':
			return {
				...state,
				showing: false,
			}
		default:
			return state;
	}
};
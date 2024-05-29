import { useDispatch, useSelector } from 'react-redux';
import Nui from '../util/Nui';

export default () => {
	const dispatch = useDispatch();
	const player = useSelector((state) => state.data.data.player);

	return async (action, type, app) => {
		await Nui.send(type, {
			action,
			app,
		});

		if (action == 'add') {
			dispatch({
				type: 'SET_DATA',
				payload: {
					type: 'player',
					data: {
						...player,
						Apps: {
							...player.Apps,
							[type.toLowerCase()]: [
								...player.Apps[type.toLowerCase()],
								app,
							],
						},
					},
				},
			});
		} else {
			dispatch({
				type: 'SET_DATA',
				payload: {
					type: 'player',
					data: {
						...player,
						Apps: {
							...player.Apps,
							[type.toLowerCase()]: [
								...player.Apps[type.toLowerCase()].filter(
									(a) => a != app,
								),
							],
						},
					},
				},
			});
		}
	};
};

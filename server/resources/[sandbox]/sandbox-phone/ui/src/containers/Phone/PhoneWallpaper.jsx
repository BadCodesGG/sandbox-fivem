import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Wallpapers } from '../../util/Wallpapers';

export default (props) => {
	const wallpaper = useSelector(
		(state) => state.data.data.player?.PhoneSettings?.wallpaper,
	);

	const useStyles = makeStyles((theme) => ({
		phoneWallpaper: {
			height: '99%',
			width: '100%',
			position: 'absolute',
			background: `transparent no-repeat fixed center cover`,
			zIndex: -1,
			borderRadius: 40,
			userSelect: 'none',
		},
	}));
	const classes = useStyles();

	return (
		<img
			className={classes.phoneWallpaper}
			src={
				Wallpapers[Boolean(wallpaper) ? wallpaper : 0] != null
					? Wallpapers[Boolean(wallpaper) ? wallpaper : 0]?.file
					: wallpaper
			}
		/>
	);
};

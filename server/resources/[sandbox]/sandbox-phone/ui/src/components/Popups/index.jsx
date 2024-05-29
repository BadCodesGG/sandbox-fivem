import React, { useRef } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import Popup from './Popup';
import { useMyApps } from '../../hooks';
import Race from '../../containers/Race';
import Music from '../../containers/Music/music';
import { useLocation } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		position: 'absolute',
		width: '90%',
		top: '5%',
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 1000,
	},
}));

export default () => {
	const classes = useStyles();
	const myApps = useMyApps();
	const ref = useRef();
	const location = useLocation();
	const phoneOpen = useSelector((state) => state.phone.visible);
	const newNotifs = useSelector((state) => state.notifications.notifications);
	const showTrack = useSelector((state) => state.track.show);
	const musicData = useSelector((state) => state.music.showPopup);

	return (
		<div className={classes.wrapper} ref={ref}>
			{showTrack && location.pathname == '/' && <Race />}
			{musicData && location.pathname == '/' && <Music />}
			{newNotifs
				.sort((a, b) => b.time - a.time)
				.filter(
					(n) =>
						n.show &&
						(typeof n.app == 'object' || Boolean(myApps[n.app])),
				)
				.slice(0, 5)
				.map((n, k) => {
					return <Popup key={n.id} notification={n} />;
				})}
		</div>
	);
};

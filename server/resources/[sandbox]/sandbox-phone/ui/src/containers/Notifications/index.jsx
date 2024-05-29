import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';

import PhoneCase from '../Phone/PhoneCase';
import { useMyApps } from '../../hooks';
import { Home } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		position: 'absolute',
		right: '1%',
		bottom: (zoom) => `calc(-800px * ${zoom / 100})`,
		height: (zoom) => `calc(1000px * ${zoom / 100})`,
		width: (zoom) => `calc(500px * ${zoom / 100})`,
		marginBottom: -200,
		transition: 'margin 0.15s linear',
		borderRadius: 40,
	},
}));

export default (props) => {
	const myApps = useMyApps();
	const zoom = useSelector(
		(state) => state.data.data.player.PhoneSettings?.zoom,
	);
	const classes = useStyles(zoom);

	const phoneOpen = useSelector((state) => state.phone.visible);
	const newNotifs = useSelector((state) => state.notifications.notifications);
	const showTrack = useSelector((state) => state.track.show);
	const trackDetails = useSelector((state) => state.track);

	const [hasNotifs, setHasNotifs] = useState(0);

	useEffect(() => {
		let t = newNotifs
			.sort((a, b) => b.time - a.time)
			.filter(
				(n) =>
					n.show &&
					(typeof n.app == 'object' || Boolean(myApps[n.app])),
			)
			.slice(0, 2);

		setHasNotifs(t?.length ?? 0);
	}, [newNotifs]);

	if (phoneOpen) return null;

	return (
		<div
			className={classes.wrapper}
			style={
				Boolean(showTrack)
					? {
							marginBlock: trackDetails.dnf
								? -15
								: trackDetails.isLaps
								? 100
								: 15,
					  }
					: hasNotifs > 0
					? { marginBottom: hasNotifs > 1 ? 110 : 35 }
					: {}
			}
		>
			<PhoneCase>
				<Home />
			</PhoneCase>
		</div>
	);
};

import React, { Fragment, memo, useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import {
	Header,
	Footer,
	Alerts,
	QuickShare,
	ErrorBoundary,
} from '../../components';

import defaultCase from '../../Frames/default.png';
import blueCase from '../../Frames/blue.png';
import goldCase from '../../Frames/gold.png';
import pinkCase from '../../Frames/pink.png';
import whiteCase from '../../Frames/white.png';

import Popups from '../../components/Popups';
import PhoneWallpaper from './PhoneWallpaper';

const useStyles = makeStyles((theme) => ({
	phoneImg: {
		zIndex: 999000000,
		// minHeight: (zoom) => `calc((1000px * ${zoom / 100}) + 10px)`,
		// minWidth: (zoom) => `calc((510px * ${zoom / 100}) + 25px)`,
		height: '100%',
		width: '100%',
		position: 'absolute',
		pointerEvents: 'none',
		userSelect: 'none',
		left: 0,
		right: 0,
		objectFit: 'cover',
	},
	phone: {
		// height: (zoom) => `calc(975px * ${zoom / 100})`,
		// width: (zoom) => `calc(520px * ${zoom / 100})`,
		height: '96%',
		width: '96%',
		overflow: 'hidden',
		margin: 'auto',
		position: 'absolute',
		bottom: 10,
		right: 0,
		left: 0,
	},
	screen: {
		height: '86.5%',
		overflow: 'hidden',
		margin: 'auto',
		width: '100%',
	},
}));

export default memo(({ children }) => {
	const visible = useSelector((state) => state.phone.visible);
	const phonecase = useSelector((state) => state.data.data.player?.PhoneCase);
	const zoom = useSelector(
		(state) => state.data.data.player.PhoneSettings?.zoom,
	);
	const classes = useStyles(zoom);

	const [current, setCurrent] = useState(defaultCase);

	useEffect(() => {
		setCurrent(GetPhoneCase());
	}, [phonecase]);

	const GetPhoneCase = () => {
		switch (phonecase) {
			case 'blue':
				return blueCase;
			case 'gold':
				return goldCase;
			case 'pink':
				return pinkCase;
			case 'white':
				return whiteCase;
			default:
				return defaultCase;
		}
	};

	return (
		<Fragment>
			<img className={classes.phoneImg} src={current} />
			<ErrorBoundary>
				<div className={classes.phone}>
					<PhoneWallpaper />
					<Header />
					{visible && <Alerts />}
					<Popups />
					{visible && <QuickShare />}
					<div className={classes.screen}>{children}</div>
					<Footer />
				</div>
			</ErrorBoundary>
		</Fragment>
	);
});

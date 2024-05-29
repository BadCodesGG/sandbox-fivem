import React, { useEffect, useState } from 'react';
import { useDispatch } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../util/Nui';
import { GetData } from '../../util/NuiEvents';

import logo from '../../assets/imgs/logo_banner.png';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: 'fit-content',
		width: 800,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		textAlign: 'center',
		fontSize: 30,
		color: theme.palette.text.main,
		zIndex: 1000,
		padding: 36,
		background: theme.palette.secondary.dark,
		borderLeft: `6px solid ${theme.palette.primary.main}`,
	},
	img: {
		maxWidth: 450,
		width: '100%',
		borderBottom: `2px solid ${theme.palette.border.divider}`,
		margin: 'auto',
	},
	innerBody: {
		paddingTop: 50,
	},
	splashHeader: {
		fontSize: '1.5vw',
		display: 'block',
	},
	splashBranding: {
		color: theme.palette.primary.main,
	},
	splashTip: {
		fontSize: '0.75vw',
		animation: '$blinker 1s linear infinite',
	},
	splashTipHighlight: {
		fontWeight: 500,
		color: theme.palette.primary.main,
		opacity: 1,
	},
	'@keyframes blinker': {
		'50%': {
			opacity: 0.3,
		},
	},
}));

export default (props) => {
	const dispatch = useDispatch();
	const classes = useStyles();

	const [show, setShow] = useState(true);

	const onAnimEnd = () => {
		Nui.send(GetData);
		dispatch({
			type: 'LOADING_SHOW',
			payload: { message: 'Loading Server Data' },
		});
	};

	const Bleh = (e) => {
		if (e.which == 1 || e.which == 13 || e.which == 32) {
			setShow(false);
		}
	};

	useEffect(() => {
		['click', 'keydown', 'keyup'].forEach(function (e) {
			window.addEventListener(e, Bleh);
		});

		// returned function will be called on component unmount
		return () => {
			['click', 'keydown', 'keyup'].forEach(function (e) {
				window.removeEventListener(e, Bleh);
			});
		};
	}, []);

	return (
		<Fade in={show} onExited={onAnimEnd}>
			<div className={classes.wrapper}>
				<img className={classes.img} src={logo} />
				<div className={classes.innerBody}>
					<span className={classes.splashHeader}>
						Welcome To{' '}
						<span className={classes.splashBranding}>
							SandboxRP
						</span>
					</span>
					<span className={classes.splashTip}>
						<span className={classes.splashTipHighlight}>
							ENTER
						</span>
						{' / '}
						<span className={classes.splashTipHighlight}>
							SPACE
						</span>
						{' / '}
						<span className={classes.splashTipHighlight}>
							LEFT MOUSE
						</span>{' '}
					</span>
				</div>
			</div>
		</Fade>
	);
};

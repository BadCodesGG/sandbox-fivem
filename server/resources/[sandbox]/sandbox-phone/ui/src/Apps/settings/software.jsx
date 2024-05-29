import React, { useEffect, useRef } from 'react';
import { Fade, Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Fireworks } from '@fireworks-js/react';

import vers from '../../vers/3.gif';
import { AppContainer } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '98%',
		background: theme.palette.secondary.main,
		textAlign: 'center',
		position: 'relative',
	},
	heading: {
		display: 'block',
		fontFamily: 'Aclonica',
		fontSize: 40,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	subheading: {
		display: 'block',
		fontFamily: 'Aclonica',
		fontSize: 30,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	versimg: {
		width: '95%',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		borderRadius: 300,
		border: '8px solid #00ff9280',
	},
	footer: {
		display: 'block',
		width: '100%',
		textAlign: 'center',
		position: 'absolute',
		bottom: 0,
		padding: 10,
		fontFamily: 'Aclonica',
		fontSize: 16,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	fireworks: {
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		// width: '82%',
		// height: '81%',
		width: '100%',
		height: '100%',
		position: 'absolute',
		margin: 'auto',
		zIndex: 998000000,
	},
}));

export default (props) => {
	const classes = useStyles();
	const ref = useRef(null);

	const [open, setOpen] = React.useState(false);
	const [open2, setOpen2] = React.useState(false);
	const [open3, setOpen3] = React.useState(false);

	useEffect(() => {}, []);

	useEffect(() => {
		setOpen(true);

		let o2 = setTimeout(() => {
			setOpen2(true);
		}, 500);

		let o3 = setTimeout(() => {
			setOpen3(true);
		}, 1000);

		return () => {
			setOpen(false);
			clearTimeout(o2);
			clearTimeout(o3);
		};
	}, []);

	return (
		<AppContainer appId="settings">
			<div className={classes.wrapper}>
				<div>
					<Slide in={open} direction="up" timeout={500}>
						<div>
							<span className={classes.heading}>
								Angry Boi OS
							</span>
							<span className={classes.subheading}>
								v{__APPVERSION__}
							</span>
						</div>
					</Slide>

					<Fade in={open2} timeout={500}>
						<img
							src={vers}
							className={`fa ${classes.versimg}`}
						></img>
					</Fade>

					<Slide in={open3} direction="down" timeout={500}>
						<span className={classes.footer}>💙 From Alzar 😁</span>
					</Slide>
				</div>
				<Fireworks
					ref={ref}
					className={classes.fireworks}
					options={{ opacity: 0.5 }}
				/>
			</div>
		</AppContainer>
	);
};

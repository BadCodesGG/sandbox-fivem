import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { ToastContainer, Flip, toast } from 'react-toastify';
import { Fade } from '@mui/material';

import { Bank } from '../../components';
import ATM from '../../components/ATM';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		width: '100%',
		fontWeight: 'bold',
		fontSize: 32,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		left: 0,
		margin: 'auto',
	},
}));

export default () => {
	const classes = useStyles();
	const user = useSelector((state) => state.data.data.character);
	const isHidden = useSelector((state) => state.app.hidden);
	const app = useSelector((state) => state.app.app);

	const [rendering, setRendering] = useState(false);

	const getAppScreen = () => {
		if (!rendering) return null;
		switch (app) {
			case 'BANK':
				return <Bank />;
			case 'ATM':
				return <ATM />;
			default:
				return null;
		}
	};

	if (!Boolean(user)) {
		return null;
	} else {
		return (
			<>
				<Fade
					in={!isHidden}
					onEnter={() => setRendering(true)}
					onExiting={() => toast.dismiss()}
					onExited={() => setRendering(false)}
				>
					<div className={classes.wrapper}>{getAppScreen()}</div>
				</Fade>
				<ToastContainer
					theme="dark"
					position="bottom-right"
					newestOnTop={false}
					closeOnClick
					rtl={false}
					draggable
					transition={Flip}
					pauseOnFocusLoss={false}
					pauseOnHover={false}
				/>
			</>
		);
	}
};

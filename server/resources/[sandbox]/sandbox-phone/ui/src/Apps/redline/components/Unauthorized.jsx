import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Fade, TextField, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Typist from 'react-typist';

import Nui from '../../../util/Nui';
import { useAlert, useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		textAlign: 'center',
	},
	header: {
		fontSize: 28,
		fontWeight: 'bold',
		color: (app) => app.color,
		margin: 'auto',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		height: 'fit-content',
		width: 'fit-content',
	},
	body: {
		margin: 'auto',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		paddingTop: 75,
		height: 'fit-content',
		width: 'fit-content',
	},
}));

export default (props) => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const showAlert = useAlert();
	const dispatch = useDispatch();
	const myState = useSelector((state) => state.data.data.myState);
	const alias = useSelector(
		(state) => state.data.data.player?.Profiles?.redline,
	);

	const [show, setShow] = useState(false);
	const onAnimEnd = () => {
		setShow(true);
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.header}>
				<Typist onTypingDone={onAnimEnd}>
					<span>You Are Not Authorized</span>
				</Typist>
			</div>
			{show && (
				<Fade in={true}>
					<div className={classes.body}>
						<Typist onTypingDone={onAnimEnd}>
							<span>Immediately Stop What You Are Doing</span>
						</Typist>
					</div>
				</Fade>
			)}
		</div>
	);
};

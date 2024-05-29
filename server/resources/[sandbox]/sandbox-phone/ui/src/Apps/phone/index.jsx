import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles } from '@mui/styles';

import Keypad from './keypad';

import { readCalls } from './action';
import { useAppData } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	limitedWrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
}));

export default connect(null, { readCalls })((props) => {
	const appData = useAppData('phone');
	const classes = useStyles(appData);
	const history = useNavigate();
	const limited = useSelector((state) => state.phone.limited);
	const callData = useSelector((state) => state.call.call);
	const callHistory = useSelector((state) => state.data.data.calls);

	useEffect(() => {
		if (callHistory.filter((c) => Boolean(c) && c.unread).length > 0) {
			props.readCalls();
		}
	}, [callHistory]);

	useEffect(() => {
		if (callData != null && callData.state != 1) {
			history(`/apps/phone/call/${callData.number}`);
		}
	}, []);

	return (
		<>
			{limited ? (
				<div className={classes.limitedWrapper}>
					<Keypad />
				</div>
			) : (
				<Keypad />
			)}
		</>
	);
});

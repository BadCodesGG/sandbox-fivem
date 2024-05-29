import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useLocation, useNavigate } from 'react-router-dom';
import { Grid, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert, useMyStates } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	header: {
		background: (state) =>
			state.pathname != '/' && state.pathname != '/apps' && state.visible
				? theme.palette.secondary.main
				: 'transparent',
		height: '5%',
		margin: 'auto',
		borderTopLeftRadius: 30,
		borderTopRightRadius: 30,
		fontSize: '16px',
		lineHeight: '55px',
		padding: '0 6% 0px 6%',
		userSelect: 'none',
	},
	hLeft: {
		color: theme.palette.text.light,
	},
	hRight: {
		textAlign: 'right',
	},
	headerIcon: {
		marginLeft: 10,
		'&.clickable': {
			transition: 'color ease-in 0.15s',
			'&:hover': {
				color: theme.palette.primary.main,
			},
		},
		'&:first-of-type': {
			marginLeft: 0,
		},
		'&.wifi': {
			color: (state) =>
				state.limited
					? theme.palette.warning.main
					: theme.palette.text.main,
		},
	},
	headerRightIcon: {
		marginRight: 10,
		'&.clickable': {
			transition: 'color ease-in 0.15s',
			'&:hover': {
				color: theme.palette.primary.main,
			},
		},
	},
	callActive: {
		marginLeft: 10,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	timer: {
		fontSize: 12,
		color: theme.palette.text.alt,
	},
}));

export default (props) => {
	const hasState = useMyStates();
	const location = useLocation();
	const history = useNavigate();
	const dispatch = useDispatch();
	const showAlert = useAlert();

	const locked = useSelector((state) => state.phone.locked);
	const visible = useSelector((state) => state.phone.visible);
	const limited = useSelector((state) => state.phone.limited);
	const callData = useSelector((state) => state.call.call);
	const time = useSelector((state) => state.phone.time);
	const sharing = useSelector((state) => state.share.sharing);

	const classes = useStyles({
		limited,
		pathname: location.pathname,
		visible,
	});

	const onClickCall = () => {
		if (callData != null) {
			history(`/apps/phone/call/${callData.number}`);
		}
	};

	const ToggleLock = () => {
		dispatch({
			type: 'TOGGLE_LOCKED',
		});
		showAlert(
			locked
				? 'Phone Position Unlocked - Drag To Move'
				: 'Phone Position Locked',
		);
	};

	const sharePrompt = (e) => {
		e.preventDefault();
		if (!sharing) return;
		dispatch({
			type: 'USE_SHARE',
			payload: true,
		});
	};

	return (
		<Grid container className={classes.header}>
			<Grid item xs={9} className={classes.hLeft}>
				<FontAwesomeIcon
					className={classes.headerIcon}
					icon={['fad', 'signal-strong']}
				/>
				<FontAwesomeIcon
					className={classes.headerIcon}
					onClick={ToggleLock}
					icon={['far', locked ? 'unlock' : 'floppy-disk']}
				/>
				{limited && (
					<FontAwesomeIcon
						className={`${classes.headerIcon} wifi`}
						icon={['fad', 'wifi-slashed']}
					/>
				)}
				{!limited && hasState('PHONE_VPN') && (
					<FontAwesomeIcon
						className={`${classes.headerIcon} vpn`}
						icon={['far', 'route-interstate']}
					/>
				)}
				{!limited && hasState('RACE_DONGLE') && (
					<FontAwesomeIcon
						className={`${classes.headerIcon} race`}
						icon={['fad', 'flag-checkered']}
					/>
				)}
				{sharing != null && (
					<FontAwesomeIcon
						className={`${classes.headerIcon} clickable`}
						onClick={sharePrompt}
						icon="share-nodes"
					/>
				)}
				{Boolean(callData) &&
					!location.pathname.startsWith('/apps/phone/call') &&
					(callData.state == 0 ? (
						<small
							className={classes.callActive}
							onClick={onClickCall}
						>
							Calling
						</small>
					) : callData.state == 1 ? (
						<small
							className={classes.callActive}
							onClick={onClickCall}
						>
							Call Incoming
						</small>
					) : (
						<small
							className={classes.callActive}
							onClick={onClickCall}
						>
							Call Active{' '}
							<Moment
								durationFromNow
								interval={1000}
								className={classes.timer}
								format="hh:mm:ss"
								date={callData.start * 1000}
							/>
						</small>
					))}
			</Grid>
			<Grid item xs={3} className={classes.hRight}>
				<span className={classes.headerRightIcon}>
					{(time?.hour ?? 0).toString().padStart(2, '0')}:
					{(time?.minute ?? 0).toString().padStart(2, '0')}
				</span>
				<FontAwesomeIcon icon={['fad', 'battery-half']} />
			</Grid>
		</Grid>
	);
};

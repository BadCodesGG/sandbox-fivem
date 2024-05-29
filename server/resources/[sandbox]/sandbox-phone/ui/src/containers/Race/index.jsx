import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useStopwatch } from 'react-use-stopwatch';
import { Slide, Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import useCountDown from 'react-countdown-hook';
import parseMilliseconds from 'parse-ms';
import PhoneCase from '../Phone/PhoneCase';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		borderRadius: 4,
		marginBottom: 10,
	},
	appInfo: {
		paddingBottom: 5,
		marginBottom: 5,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'filter ease-in 0.15s',
		'&.clickable:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	appName: {
		height: 'fit-content',
		color: theme.palette.text.alt,
		textTransform: 'uppercase',
		top: 0,
		bottom: 0,
		margin: 'auto',
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		fontSize: 12,
	},
	label: {
		fontSize: 18,
		color: theme.palette.text.alt,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	value: {
		fontSize: 18,
		color: theme.palette.text.main,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		fontWeight: 'bold',
		textAlign: 'right',
	},
}));

Number.prototype.pad = function (size) {
	var s = String(this);
	while (s.length < (size || 2)) {
		s = '0' + s;
	}
	return s;
};

export default () => {
	const dispatch = useDispatch();
	const alias = useSelector(
		(state) => state.data.data.player?.Profiles?.redline,
	);
	const trackDetails = useSelector((state) => state.track);
	const zoom = useSelector(
		(state) => state.data.data.player.PhoneSettings?.zoom,
	);
	const classes = useStyles(zoom);

	const [lapTime, lapStart, lapStop, lapReset] = useStopwatch();
	const [total, start, stop, reset] = useStopwatch();
	const [dnfTimer, dnfFuncs] = useCountDown(300 * 1000, 10);
	const dnf = parseMilliseconds(dnfTimer);
	const [fastest, setFastest] = useState(null);

	useEffect(() => {
		start();
		return () => {
			stop();
		};
	}, []);

	useEffect(() => {
		return () => {
			finishLap();
			dispatch({
				type: 'RACE_HUD_END',
			});
		};
	}, []);

	useEffect(() => {
		if (trackDetails.dnf) {
			setTimeout(() => {
				dispatch({
					type: 'RACE_END',
				});
			}, 3000);
		}
	}, [trackDetails.dnf]);

	useEffect(() => {
		if (trackDetails.dnfTime != null) {
			dnfFuncs.start(trackDetails.dnfTime * 1000);
		} else {
			dnfFuncs.pause();
		}
	}, [trackDetails.dnfTime]);

	const finishLap = () => {
		dispatch({
			type: 'ADD_LAP_TIME',
			payload: {
				...{
					...lapTime,
					lapStart: trackDetails.lapStart,
					lapEnd: Date.now(),
				},
				alias,
			},
		});
		if (lapTime.time > 0 && (!fastest || lapTime.time < fastest.time)) {
			setFastest(lapTime);
		}
	};

	useEffect(() => {
		if (lapTime.time > 0) {
			finishLap();
		}
		lapReset();
		lapStart();
	}, [trackDetails.lap]);

	return (
		<Fragment>
			{trackDetails.dnf ? (
				<Grid container className={classes.wrapper}>
					<Grid item xs={12} className={classes.appInfo}>
						<span className={classes.appName}>Active Race</span>
					</Grid>
					<Grid item xs={12} className={classes.label}>
						You DNF'd, Better Luck Next Time
					</Grid>
				</Grid>
			) : (
				<Grid container className={classes.wrapper}>
					<Grid item xs={12} className={classes.appInfo}>
						<span className={classes.appName}>Active Race</span>
					</Grid>
					{Boolean(trackDetails.dnfTime) && (
						<Grid item xs={12}>
							<Grid container>
								<Grid item xs={6} className={classes.label}>
									DNF
								</Grid>
								<Grid item xs={6} className={classes.value}>
									{`${dnf.hours.pad(2)}:${dnf.minutes.pad(
										2,
									)}:${dnf.seconds.pad(2)}.${(
										dnf.milliseconds / 10
									).pad(2)}`}
								</Grid>
							</Grid>
						</Grid>
					)}
					{trackDetails.isLaps && (
						<Grid item xs={12}>
							<Grid container>
								<Grid item xs={6} className={classes.label}>
									Lap
								</Grid>
								<Grid item xs={6} className={classes.value}>
									{trackDetails.lap} /{' '}
									{trackDetails.totalLaps}
								</Grid>
							</Grid>
						</Grid>
					)}
					<Grid item xs={6} className={classes.label}>
						Checkpoint
					</Grid>
					<Grid item xs={6} className={classes.value}>
						{trackDetails.checkpoint} /{' '}
						{trackDetails.totalCheckpoints}
					</Grid>
					{trackDetails.isLaps && (
						<Grid item xs={12}>
							<Grid container>
								<Grid item xs={6} className={classes.label}>
									Current Lap
								</Grid>
								<Grid item xs={6} className={classes.value}>
									{lapTime.format}
								</Grid>
								<Grid item xs={6} className={classes.label}>
									Fastest Lap
								</Grid>
								<Grid item xs={6} className={classes.value}>
									{fastest ? (
										fastest.format
									) : (
										<span>--:--:--.--</span>
									)}
								</Grid>
							</Grid>
						</Grid>
					)}
					<Grid item xs={6} className={classes.label}>
						Total Time
					</Grid>
					<Grid item xs={6} className={classes.value}>
						{total.format}
					</Grid>
				</Grid>
			)}
		</Fragment>
	);
};

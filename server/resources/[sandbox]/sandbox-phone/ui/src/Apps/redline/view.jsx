import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	IconButton,
	List,
	ListItem,
	ListItemText,
	TextField,
	Tooltip,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate, useParams } from 'react-router';

import { useAlert, useAppData } from '../../hooks';
import {
	AppContainer,
	AppInput,
	Confirm,
	Loader,
	Modal,
} from '../../components';
import { CurrencyFormat } from '../../util/Parser';
import Racer from './components/Racer';
import Nui from '../../util/Nui';
import { AccessTypes, GhostTypes } from '.';

const useStyles = makeStyles((theme) => ({
	header: {
		display: 'inline-block',
		fontSize: 16,
		marginLeft: 8,
		'& svg': {
			marginRight: 4,
		},
	},
	content: {
		height: '87%',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	links: {
		width: '100%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	link: {
		textAlign: 'center',
		fontSize: 28,
		padding: 10,
		transition: 'color ease-in 0.15s',

		'&:hover': {
			cursor: 'pointer',
			color: (app) => app.color,
		},
	},
	header: {
		textAlign: 'center',
		fontSize: 20,
		color: theme.palette.text.main,
		position: 'relative',

		'& span': {
			background: theme.palette.secondary.main,
			padding: 4,
			zIndex: 1,
			position: 'relative',
		},

		'&::before': {
			content: '" "',
			display: 'block',
			height: 2,
			background: (app) => app.color,
			width: '100%',
			position: 'absolute',
			top: 0,
			bottom: 0,
			margin: 'auto',
			zIndex: 0,
		},
	},
	content: {
		padding: 8,
	},
	contentInner: {
		padding: '0 16px',
	},
	label: {
		fontSize: 12,
		color: theme.palette.text.alt,
	},
	value: {
		fontSize: 16,
		color: theme.palette.text.main,
		transition: 'color ease-in 0.15s',

		'&.clickable:hover': {
			cursor: 'pointer',
			color: (app) => app.color,
		},
	},
	racers: {
		padding: 8,
		maxHeight: '51%',
		overflow: 'auto',
		height: '100%',
	},
	racersInner: {
		padding: '0 16px',
		maxHeight: '90%',
		overflow: 'auto',
		height: '100%',
		listStyle: 'none !important',
	},
}));

export default () => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const navigate = useNavigate();
	const showAlert = useAlert();
	const dispatch = useDispatch();
	const { race } = useParams();

	const onDuty = useSelector((state) => state.data.data.onDuty);
	const sid = useSelector((state) => state.data.data.player.SID);
	const alias = useSelector(
		(state) => state.data.data.player?.Profiles?.redline?.name,
	);
	const inRace = useSelector((state) => state.race.inRace);
	const tracks = useSelector((state) => state.data.data.tracks);
	const raceData = useSelector((state) => state.race.races)[race];

	const activePhaseType = GhostTypes.filter(
		(g) => g.value == raceData.phasing,
	)[0];

	const [loaded, setLoaded] = useState(false);
	const [track, setTrack] = useState(null);
	const [removing, setRemoving] = useState(null);
	const [winnings, setWinnings] = useState(null);
	const [inviting, setInviting] = useState(false);

	useEffect(() => {
		setLoaded(false);
	}, [race]);

	useEffect(() => {
		if (!Boolean(raceData)) return;
		setTrack(tracks.filter((t) => t.id == raceData.track)[0]);
		setLoaded(true);
	}, [raceData]);

	const onRacerClick = (racer) => {
		navigate(`/apps/redline/profile/${racer}`);
	};

	const onTrackClick = (track) => {
		navigate(`/apps/redline/tracks/${track}`);
	};

	const joinRace = async () => {
		try {
			let res = await (await Nui.send('JoinRace', raceData.id)).json();
			showAlert(res ? 'Joined Race' : 'Unable to Join Race');
			if (res) {
				dispatch({
					type: 'I_RACE',
					payload: {
						state: true,
					},
				});
			}
		} catch (err) {
			console.error(err);
			showAlert('Unable to Join Race');
		}
	};

	const leaveRace = async () => {
		try {
			let res = await (await Nui.send('LeaveRace', raceData.id)).json();
			showAlert(res ? 'Left Race' : 'Unable to Leave Race');
			if (res) {
				dispatch({
					type: 'I_RACE',
					payload: {
						state: false,
					},
				});
				navigate('/apps/redline', { replace: true });
			}
		} catch (err) {
			console.error(err);
			showAlert('Unable to Leave Race');
		}
	};

	const cancelRace = async () => {
		try {
			let res = await (await Nui.send('CancelRace', raceData.id)).json();
			showAlert(res ? 'Cancelled Race' : 'Unable to Cancel Race');
			if (res) {
				dispatch({
					type: 'I_RACE',
					payload: {
						state: false,
					},
				});
				navigate('/apps/redline', { replace: true });
			}
		} catch (err) {
			console.error(err);
			showAlert('Unable to Cancel Race');
		}
	};

	const startRace = async () => {
		try {
			let res = await (await Nui.send('StartRace', raceData.id)).json();
			showAlert(!res?.failed ? 'Starting Race' : res.message);
		} catch (err) {
			console.error(err);
			showAlert('Unable to Start Race');
		}
	};

	const endRace = async () => {
		try {
			let res = await (await Nui.send('EndRace', raceData.id)).json();
			showAlert(res ? 'Event Ended' : 'Unable to End Event');
			if (res) {
				dispatch({
					type: 'I_RACE',
					payload: {
						state: false,
					},
				});
				navigate('/apps/redline', { replace: true });
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Ending Event');
		}
	};

	const onStartRemove = (alias) => {
		setRemoving(alias);
	};

	const onConfirmRemove = async () => {
		try {
			let res = await (
				await Nui.send('RemoveFromRace', {
					id: raceData.id,
					alias: removing,
				})
			).json();
			showAlert(
				res
					? `${removing} Removed From Event`
					: 'Unable to Remove From Event',
			);
		} catch (err) {
			console.error(err);
			showAlert('Error Removing From Event');
		}
		setRemoving(null);
	};

	const onInvite = async (e) => {
		e.preventDefault();
		try {
			let res = await (
				await Nui.send('SendInvite', {
					id: raceData.id,
					alias: e.target.alias.value,
				})
			).json();
			showAlert(res ? `Event Invite Sent` : 'Unable to Send Invite');
		} catch (err) {
			console.error(err);
			showAlert('Error Sending Invite');
		}
		setInviting(false);
	};

	return (
		<AppContainer
			appId="redline"
			titleOverride={Boolean(raceData) ? raceData.name : false}
			actionShow={Boolean(alias) && onDuty != 'police'}
			actions={
				<Fragment>
					<IconButton onClick={() => navigate(-1)}>
						<FontAwesomeIcon icon={['far', 'arrow-left']} />
					</IconButton>
					{raceData?.host_id == sid &&
						raceData.state == 0 &&
						raceData.access == 'invite' && (
							<Tooltip title="Invite Racer To Event">
								<IconButton onClick={() => setInviting(true)}>
									<FontAwesomeIcon
										icon={['far', 'envelope']}
									/>
								</IconButton>
							</Tooltip>
						)}
					{raceData?.host_id == sid ? (
						raceData?.state == 0 ? (
							<Fragment>
								<Tooltip title="Cancel Race">
									<IconButton onClick={cancelRace}>
										<FontAwesomeIcon
											icon={['far', 'xmark']}
										/>
									</IconButton>
								</Tooltip>
								<Tooltip title="Start Race">
									<IconButton onClick={startRace}>
										<FontAwesomeIcon
											icon={['far', 'play']}
										/>
									</IconButton>
								</Tooltip>
							</Fragment>
						) : raceData?.state != 2 ? (
							<Tooltip title="End Race">
								<IconButton onClick={endRace}>
									<FontAwesomeIcon icon={['far', 'ban']} />
								</IconButton>
							</Tooltip>
						) : null
					) : (
						<Fragment>
							{!inRace &&
							Boolean(raceData) &&
							raceData?.state == 0 &&
							!Boolean(raceData.racers[alias]) &&
							raceData.access == 'public' ? (
								<Tooltip title="Join Race">
									<IconButton onClick={joinRace}>
										<FontAwesomeIcon
											icon={['far', 'right-to-bracket']}
										/>
									</IconButton>
								</Tooltip>
							) : (raceData?.state == 0 ||
									raceData?.state == 1) &&
							  Boolean(raceData.racers[alias]) ? (
								<Tooltip title="Leave Race">
									<IconButton onClick={leaveRace}>
										<FontAwesomeIcon
											icon={['far', 'right-from-bracket']}
										/>
									</IconButton>
								</Tooltip>
							) : null}
						</Fragment>
					)}
				</Fragment>
			}
		>
			{!loaded || !Boolean(raceData) || !Boolean(track) ? (
				<Loader static text="Loading Race Data" />
			) : Boolean(raceData) && Boolean(track) ? (
				<Fragment>
					<div className={classes.content}>
						<div className={classes.header}>
							<span>Event #{raceData.id} Details</span>
						</div>
						<div className={classes.contentInner}>
							<div className={classes.item}>
								<div className={classes.label}>Host</div>
								<div
									className={`${classes.value} clickable`}
									onClick={() => onRacerClick(raceData.host)}
								>
									{raceData.host}
								</div>
							</div>
							<div className={classes.item}>
								<div className={classes.label}>State</div>
								<div className={classes.value}>
									{raceData?.state == -1 ? (
										<span>Cancelled</span>
									) : raceData?.state == 0 ? (
										<span>Setting Up</span>
									) : raceData?.state == 1 ? (
										<span>In Progress</span>
									) : raceData?.state == 2 ? (
										<span>Finished</span>
									) : null}
								</div>
							</div>
							<div className={classes.item}>
								<div className={classes.label}>Buy In</div>
								<div className={classes.value}>
									{raceData.buyin > 0
										? CurrencyFormat.format(raceData.buyin)
										: 'None'}
								</div>
							</div>
							<div className={classes.item}>
								<div className={classes.label}>Track</div>
								<div
									className={`${classes.value} clickable`}
									onClick={() => onTrackClick(raceData.id)}
								>
									{track?.Name} ({track?.Distance})
								</div>
							</div>
							<div className={classes.item}>
								<div className={classes.label}># of Laps</div>
								<div className={classes.value}>
									{raceData.laps}
								</div>
							</div>
							<div className={classes.item}>
								<div className={classes.label}>
									Race Phasing
								</div>
								<div className={classes.value}>
									{Boolean(activePhaseType)
										? activePhaseType.label
										: 'Disabled'}
								</div>
							</div>
						</div>
					</div>
					<div className={classes.racers}>
						<div className={classes.header}>
							<span>Racers</span>
						</div>
						<div className={classes.racersInner}>
							{Object.keys(raceData.racers).length > 0 ? (
								raceData?.state == 2 ? (
									<List style={{ listStyle: 'none' }}>
										{Object.keys(raceData.racers).filter(
											(r) => raceData.racers[r].finished,
										).length > 0 && (
											<Fragment>
												<ListItem>
													<div
														className={
															classes.label
														}
													>
														Podium
													</div>
												</ListItem>
												{Object.keys(raceData.racers)
													.filter(
														(r) =>
															raceData.racers[r]
																.finished,
													)
													.sort(
														(a, b) =>
															raceData.racers[a]
																.place -
															raceData.racers[b]
																.place,
													)
													.slice(0, 3)
													.map((racer) => {
														return (
															<Racer
																key={racer}
																name={racer}
																race={raceData}
																track={track}
																racer={
																	raceData
																		.racers[
																		racer
																	]
																}
																onWinnings={
																	setWinnings
																}
															/>
														);
													})}
											</Fragment>
										)}
										{Object.keys(raceData.racers).filter(
											(r) =>
												raceData.racers[r].finished &&
												raceData.racers[r].place > 3,
										).length > 0 && (
											<Fragment>
												<ListItem>
													<div
														className={
															classes.label
														}
													>
														Other Racers
													</div>
												</ListItem>
												{Object.keys(raceData.racers)
													.filter(
														(r) =>
															raceData.racers[r]
																.finished &&
															raceData.racers[r]
																.place > 3,
													)
													.sort(
														(a, b) =>
															raceData.racers[a]
																.place -
															raceData.racers[b]
																.place,
													)
													.map((racer) => {
														return (
															<Racer
																key={racer}
																name={racer}
																race={raceData}
																track={track}
																racer={
																	raceData
																		.racers[
																		racer
																	]
																}
																onWinnings={
																	setWinnings
																}
															/>
														);
													})}
											</Fragment>
										)}
										{Object.keys(raceData.racers).filter(
											(r) => !raceData.racers[r].finished,
										).length > 0 && (
											<Fragment>
												<ListItem>
													<div
														className={
															classes.label
														}
													>
														DNF'd
													</div>
												</ListItem>
												{Object.keys(raceData.racers)
													.filter(
														(r) =>
															!raceData.racers[r]
																.finished,
													)
													.map((racer) => {
														return (
															<Racer
																key={racer}
																name={racer}
																race={raceData}
																track={track}
																racer={
																	raceData
																		.racers[
																		racer
																	]
																}
																onWinnings={
																	setWinnings
																}
															/>
														);
													})}
											</Fragment>
										)}
									</List>
								) : (
									Object.keys(raceData.racers).map(
										(racer) => {
											return (
												<Racer
													key={racer}
													name={racer}
													race={raceData}
													track={track}
													racer={
														raceData.racers[racer]
													}
													onRemove={onStartRemove}
												/>
											);
										},
									)
								)
							) : (
								<div className={classes.noracers}>
									No Racers Signed Up
								</div>
							)}
						</div>
					</div>
					{Boolean(removing) && (
						<Confirm
							title={`Remove ${removing} From Event?`}
							open={Boolean(removing)}
							confirm="Yes"
							decline="No"
							onConfirm={onConfirmRemove}
							onDecline={() => setRemoving(null)}
						/>
					)}
					{Boolean(winnings) && (
						<Modal
							open={Boolean(winnings)}
							title={`${winnings.name} Winnings`}
							onClose={() => setWinnings(null)}
						>
							<List className={classes.winningsBody}>
								{Boolean(winnings?.reward?.cash) && (
									<ListItem>
										<ListItemText
											primary="Cash"
											secondary={`$${winnings?.reward?.cash}`}
										/>
									</ListItem>
								)}
								{Boolean(winnings?.reward?.crypto) && (
									<ListItem>
										<ListItemText
											primary="Crypto"
											secondary={`${winnings?.reward?.crypto} $${winnings?.reward?.coin}`}
										/>
									</ListItem>
								)}
							</List>
						</Modal>
					)}

					<Modal
						form
						open={inviting}
						title="Invite Racer To Event"
						submitLang="Send Invite"
						onAccept={onInvite}
						onClose={() => setInviting(false)}
					>
						<AppInput
							app={appData}
							fullWidth
							autoFocus
							required
							label="Alias"
							name="alias"
							color="secondary"
							inputProps={{
								maxLength: 32,
							}}
						/>
					</Modal>
				</Fragment>
			) : (
				<div>Viewing Legacy Races Not Yet Supported</div>
			)}
		</AppContainer>
	);
};

import React, { Fragment, useState } from 'react';
import { AppContainer } from '../../components';
import {
	IconButton,
	TextField,
	FormGroup,
	FormControlLabel,
	Switch,
	MenuItem,
	Grid,
	Alert,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { makeStyles } from '@mui/styles';
import { useDispatch, useSelector } from 'react-redux';

import { CurrencyInput, AppInput } from '../../components';
import { useAlert, useAppData } from '../../hooks';
import { useNavigate } from 'react-router';
import Nui from '../../util/Nui';
import { AccessTypes, GhostTypes } from '.';

const useStyles = makeStyles((theme) => ({
	form: {
		height: '100%',
	},
	formBody: {
		padding: 16,
	},
}));

export default () => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const showAlert = useAlert();
	const navigate = useNavigate();
	const dispatch = useDispatch();

	const alias = useSelector(
		(state) => state.data.data.player?.Profiles?.redline,
	);
	const inRace = useSelector((state) => state.race.inRace);
	const tracks = useSelector((state) => state.data.data.tracks);
	const onDuty = useSelector((state) => state.data.data.onDuty);

	const [createState, setCreateState] = useState({
		name: '',
		host: alias?.name,
		buyin: '0',
		laps: 1,
		dnf_start: '3',
		dnf_time: '120',
		countdown: '8',
		phasing: false,
		class: 'All',
		track: tracks.length > 0 ? tracks[0].id : null,
		access: 'public',
		phasing: 'none',
		phasingAdv: 0,
	});

	const onCreateChange = (e) => {
		setCreateState({
			...createState,
			[e.target.name]: e.target.value,
		});
	};

	const onSubmit = async (e) => {
		e.preventDefault();
		if (inRace) return;

		try {
			let res = await (await Nui.send('CreateRace', createState)).json();
			showAlert(!Boolean(res?.failed) ? 'Race Created' : res.message);
			if (!Boolean(res?.failed)) {
				dispatch({
					type: 'I_RACE',
					payload: {
						state: true,
					},
				});

				navigate(`/apps/redline/view/${res.id}`);
			}
		} catch (err) {
			console.error(err);
			showAlert('Unable To Create Race');
		}
	};

	if (!Boolean(alias)) navigate('/apps/redline');
	return (
		<form className={classes.form} onSubmit={onSubmit}>
			<AppContainer
				appId="redline"
				actionShow={Boolean(alias) && onDuty != 'police'}
				actions={
					<Fragment>
						<IconButton onClick={() => navigate(-1)}>
							<FontAwesomeIcon icon={['far', 'xmark']} />
						</IconButton>
						<IconButton type="submit">
							<FontAwesomeIcon icon={['far', 'floppy-disk']} />
						</IconButton>
					</Fragment>
				}
			>
				{Boolean(alias) && onDuty != 'police' && (
					<Grid className={classes.formBody} container spacing={2}>
						<Grid item xs={12}>
							<AppInput
								app={appData}
								fullWidth
								autoFocus
								required
								label="Event Name"
								name="name"
								color="secondary"
								value={createState.name}
								onChange={onCreateChange}
								inputProps={{
									maxLength: 32,
								}}
							/>
						</Grid>
						<Grid item xs={12}>
							<AppInput
								app={appData}
								select
								required
								className={classes.creatorInput}
								fullWidth
								label="Access"
								name="access"
								variant="outlined"
								color="secondary"
								value={createState.access}
								onChange={onCreateChange}
							>
								{AccessTypes.map((access) => {
									return (
										<MenuItem
											key={access.value}
											value={access.value}
											disabled={access.disabled}
										>
											{access.label}
										</MenuItem>
									);
								})}
							</AppInput>
						</Grid>
						<Grid item xs={12}>
							<AppInput
								app={appData}
								className={classes.creatorInput}
								fullWidth
								label="Host"
								name="host"
								variant="outlined"
								color="secondary"
								disabled
								value={alias?.name}
								required
							/>
						</Grid>
						<Grid item xs={12}>
							<AppInput
								app={appData}
								select
								required
								className={classes.creatorInput}
								fullWidth
								label="Track"
								name="track"
								variant="outlined"
								color="secondary"
								value={createState.track}
								onChange={onCreateChange}
							>
								{tracks.map((track) => {
									return (
										<MenuItem
											key={track.id}
											value={track.id}
										>
											{track.id} - {track.Name}
										</MenuItem>
									);
								})}
							</AppInput>
						</Grid>
						<Grid item xs={12}>
							<AppInput
								app={appData}
								className={classes.creatorInput}
								fullWidth
								label="# of Laps"
								name="laps"
								variant="outlined"
								type="number"
								disabled={
									tracks.filter(
										(t) => t.id == createState.track,
									)[0]?.Type == 'p2p'
								}
								value={createState.laps}
								onChange={onCreateChange}
								required
								inputProps={{
									min: 1,
								}}
							/>
						</Grid>
						<Grid item xs={4}>
							<AppInput
								app={appData}
								required
								fullWidth
								className={classes.creatorInput}
								label="Countdown"
								name="countdown"
								variant="outlined"
								type="tel"
								value={createState.countdown}
								onChange={onCreateChange}
							/>
						</Grid>
						<Grid item xs={8}>
							<AppInput
								required
								fullWidth
								className={classes.creatorInput}
								label="Buy In"
								name="buyin"
								variant="outlined"
								color="secondary"
								value={createState.buyin}
								onChange={onCreateChange}
								InputProps={{
									inputComponent: CurrencyInput,
								}}
							/>
						</Grid>
						{createState.buyin > 0 && (
							<Grid item xs={12}>
								<Alert variant="filled" severity="warning">
									Cash is not automatically gathered, as the
									race host you must manage getting the buy
									ins from all racers and handle paying out
									winners
								</Alert>
							</Grid>
						)}
						<Grid item xs={6}>
							<AppInput
								app={appData}
								className={classes.creatorInput}
								fullWidth
								label="DNF Start"
								name="dnf_start"
								variant="outlined"
								type="number"
								value={createState.dnf_start}
								onChange={onCreateChange}
								required
							/>
						</Grid>
						<Grid item xs={6}>
							<AppInput
								app={appData}
								className={classes.creatorInput}
								fullWidth
								label="DNF Time"
								name="dnf_time"
								variant="outlined"
								type="number"
								value={createState.dnf_time}
								onChange={onCreateChange}
								required
							/>
						</Grid>
						<Grid item xs={createState.phasing == 'none' ? 12 : 7}>
							<AppInput
								app={appData}
								select
								required
								className={classes.creatorInput}
								fullWidth
								label="Phasing"
								name="phasing"
								variant="outlined"
								color="secondary"
								value={createState.phasing}
								onChange={onCreateChange}
							>
								{GhostTypes.map((access) => {
									return (
										<MenuItem
											key={access.value}
											value={access.value}
										>
											{access.label}
										</MenuItem>
									);
								})}
							</AppInput>
						</Grid>
						{createState.phasing != 'none' && (
							<Grid item xs={5}>
								{createState.phasing == 'timed' ? (
									<AppInput
										app={appData}
										className={classes.creatorInput}
										fullWidth
										label="Time (in Seconds)"
										name="phasingAdv"
										variant="outlined"
										type="number"
										value={createState.phasingAdv}
										onChange={onCreateChange}
										required
										inputProps={{
											min: 3,
											max: 60,
										}}
									/>
								) : createState.phasing == 'checkpoints' ? (
									<AppInput
										app={appData}
										className={classes.creatorInput}
										fullWidth
										label="# of Checkpoints"
										name="phasingAdv"
										variant="outlined"
										type="number"
										value={createState.phasingAdv}
										onChange={onCreateChange}
										required
										inputProps={{
											min: 1,
											max: 10,
										}}
									/>
								) : null}
							</Grid>
						)}
						<Grid item xs={12}>
							<AppInput
								app={appData}
								select
								className={classes.creatorInput}
								fullWidth
								label="Vehicle Class"
								name="class"
								variant="outlined"
								type="number"
								value={createState.class}
								onChange={onCreateChange}
								required
							>
								<MenuItem value={'D'}>D Class</MenuItem>
								<MenuItem value={'C'}>C Class</MenuItem>
								<MenuItem value={'B'}>B Class</MenuItem>
								<MenuItem value={'A'}>A Class</MenuItem>
								<MenuItem value={'S'}>S Class</MenuItem>
								<MenuItem value={'All'}>All Classes</MenuItem>
							</AppInput>
						</Grid>
					</Grid>
				)}
			</AppContainer>
		</form>
	);
};

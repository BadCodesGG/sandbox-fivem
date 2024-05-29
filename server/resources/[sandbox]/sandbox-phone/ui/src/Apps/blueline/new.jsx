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
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { makeStyles } from '@mui/styles';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router';

import { AppInput } from '../../components';
import { useAlert, useAppData, useJobPermissions } from '../../hooks';
import Unauthorized from './components/Unauthorized';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	content: {
		position: 'relative',
		height: '100%',
	},
	formBody: {
		padding: 16,
	},
}));

export default () => {
	const appData = useAppData('blueline');
	const classes = useStyles(appData);
	const showAlert = useAlert();
	const navigate = useNavigate();
	const dispatch = useDispatch();
	const hasPerm = useJobPermissions();

	const onDuty = useSelector((state) => state.data.data.onDuty);
	const alias = useSelector((state) => state.data.data.player?.Callsign);
	const tracks = useSelector((state) => state.data.data.tracks_pd);
	const canCreate = hasPerm('PD_MANAGE_TRIALS', 'police');

	const [createState, setCreateState] = useState({
		name: '',
		host: alias,
		buyin: '',
		laps: 1,
		dnf_start: '',
		dnf_time: '',
		countdown: '20',
		phasing: false,
		class: 'All',
		track: tracks.length > 0 ? tracks[0].id : null,
	});

	const onCreateChange = (e) => {
		switch (e.target.name) {
			case 'phasing':
				setCreateState({
					...createState,
					[e.target.name]: e.target.checked,
				});
				break;
			default:
				setCreateState({
					...createState,
					[e.target.name]: e.target.value,
				});
				break;
		}
	};

	const onSubmit = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('CreateRacePD', createState)
			).json();
			showAlert(!Boolean(res?.failed) ? 'Race Created' : res.message);
			if (!Boolean(res?.failed)) {
				dispatch({
					type: 'PD_I_RACE',
					payload: {
						state: true,
					},
				});

				navigate(`/apps/blueline/view/${res.id}`);
			}
		} catch (err) {
			console.error(err);
			showAlert('Unable To Create Race');
		}
	};

	return (
		<form className={classes.content} onSubmit={onSubmit}>
			<AppContainer
				appId="blueline"
				actionShow={Boolean(alias) && onDuty == 'police' && canCreate}
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
				{!alias || onDuty != 'police' ? (
					<Unauthorized />
				) : (
					<Grid className={classes.formBody} container spacing={2}>
						<Grid item xs={12}>
							<AppInput
								app={appData}
								className={classes.creatorInput}
								fullWidth
								label="Host"
								name="host"
								variant="outlined"
								disabled
								value={alias}
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
								value={createState.track}
								onChange={onCreateChange}
							>
								{tracks.map((track) => {
									return (
										<MenuItem
											key={track.id}
											value={track.id}
										>
											{track.Name}
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
								label="Event Name"
								name="name"
								variant="outlined"
								value={createState.name}
								onChange={onCreateChange}
								required
								inputProps={{
									maxLength: 32,
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
							/>
						</Grid>
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
						{/* <Grid item xs={12}>
						<FormGroup className={classes.creatorInput}>
							<FormControlLabel
								control={
									<Switch
										className={classes.creatorInput}
										checked={createState.phasing}
										onChange={onCreateChange}
										value={false}
										name="phasing"
										color="warning"
									/>
								}
								label="Vehicle Phasing"
							/>
						</FormGroup>
					</Grid> */}
					</Grid>
				)}
			</AppContainer>
		</form>
	);
};

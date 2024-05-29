import React, { Fragment, useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
	IconButton,
	List,
	ListItem,
	ListItemText,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate, useParams } from 'react-router';

import { useAppData, usePermissions } from '../../hooks';
import Welcome from './components/Welcome';
import Unauthorized from './components/Unauthorized';
import { AppContainer, AppInput } from '../../components';
import FastestRacer from './components/FastestRacer';

export const TrackTypes = {
	laps: 'Laps',
	p2p: 'Point to Point',
};

const useStyles = makeStyles((theme) => ({
	user: {
		height: '6%',
		width: '100%',
		padding: 10,
		borderBottom: `1px solid ${theme.palette.border.divider}`,

		'& span': {
			color: (app) => app.color,
		},
	},
	content: {
		padding: 16,
		height: '94%',
	},
	noTracks: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	selector: {
		height: '12%',
	},
	records: {
		marginTop: 10,
		height: '87%',
		overflow: 'auto',
	},
}));

export default (props) => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const hasPerm = usePermissions();
	const navigate = useNavigate();
	const { track } = useParams();
	const onDuty = useSelector((state) => state.data.data.onDuty);
	const alias = useSelector(
		(state) => state.data.data.player?.Profiles?.redline,
	);
	const tracks = useSelector((state) => state.data.data.tracks);

	const [selected, setSelected] = useState('');
	const [history, setHistory] = useState(Array());

	useEffect(() => {
		if (Boolean(track)) setSelected(+track);
		else setSelected(tracks[0]?.id ?? '');
	}, [track]);

	useEffect(() => {
		setHistory(
			tracks.filter((t) => t.id == selected)[0]?.Fastest ?? Array(),
		);
	}, [selected]);

	const onChange = (e) => {
		navigate(`/apps/redline/tracks/${e.target.value}`, { replace: true });
	};

	return (
		<AppContainer
			appId="redline"
			titleOverride="Redline - Fastest Laps"
			actionShow={Boolean(alias) && onDuty != 'police'}
			actions={
				<Fragment>
					<IconButton onClick={() => navigate('/apps/redline')}>
						<FontAwesomeIcon icon={['far', 'home']} />
					</IconButton>
				</Fragment>
			}
		>
			{!alias ? (
				<Welcome />
			) : onDuty == 'police' ? (
				<Unauthorized />
			) : (
				<Fragment>
					<div className={classes.user}>
						Welcome Back <span>{alias?.name}</span>
					</div>
					{Boolean(tracks) && tracks.length > 0 ? (
						<div className={classes.content}>
							<div className={classes.selector}>
								<AppInput
									app={appData}
									select
									className={classes.creatorInput}
									fullWidth
									label="Track"
									name="track"
									variant="outlined"
									color="secondary"
									value={selected}
									onChange={onChange}
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
							</div>
							<div className={classes.records}>
								{Boolean(history) && history.length > 0 ? (
									history.map((lap, k) => {
										return (
											<FastestRacer
												key={k}
												rank={k + 1}
												racer={lap}
											/>
										);
									})
								) : (
									<div className={classes.noTracks}>
										Track Has No Lap Records
									</div>
								)}
							</div>
						</div>
					) : (
						<div className={classes.noTracks}>No Tracks Exist</div>
					)}
				</Fragment>
			)}
		</AppContainer>
	);
};

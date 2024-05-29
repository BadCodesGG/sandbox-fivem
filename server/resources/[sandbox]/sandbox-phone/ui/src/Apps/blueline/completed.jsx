import React, { Fragment } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router';

import { useAppData, useJobPermissions } from '../../hooks';
import Unauthorized from './components/Unauthorized';
import { AppContainer } from '../../components';
import Race from './components/Race';

export const TrackTypes = {
	laps: 'Laps',
	p2p: 'Point to Point',
};

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
	user: {
		width: '100%',
		padding: 10,
		borderBottom: `1px solid ${theme.palette.border.divider}`,

		'& span': {
			color: (app) => app.color,
		},
	},
	noRaces: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const appData = useAppData('blueline');
	const classes = useStyles(appData);
	const hasPerm = useJobPermissions();
	const navigate = useNavigate();
	const onDuty = useSelector((state) => state.data.data.onDuty);
	const alias = useSelector((state) => state.data.data.player?.Callsign);
	const canCreate = hasPerm('PD_MANAGE_TRIALS', 'police');

	const tracks = useSelector((state) => state.data.data.tracks_pd);
	const rawRaces = useSelector((state) => state.pdRace.races)
	const races = Object.keys(rawRaces)
		.reduce((result, key) => {
			if (
				Boolean(tracks.filter((t) => t.id == rawRaces[key].track)[0]) &&
				(rawRaces[key].state == -1 || rawRaces[key].state == 2)
			)
				result.push(rawRaces[key]);
			return result;
		}, Array())
		.sort((a, b) => b.time - a.time);

	return (
		<AppContainer
			appId="blueline"
			titleOverride="Trials - Recent Races"
			actionShow={Boolean(alias) && onDuty == 'police'}
			actions={
				<Fragment>
					<IconButton
						onClick={() =>
							navigate('/apps/blueline', {
								replace: true,
							})
						}
					>
						<FontAwesomeIcon icon={['far', 'calendar-days']} />
					</IconButton>
					<IconButton onClick={() => navigate('/apps/blueline/new')}>
						<FontAwesomeIcon icon={['far', 'plus']} />
					</IconButton>
					{Boolean(canCreate) && (
						<IconButton
							onClick={() => navigate('/apps/blueline/admin')}
						>
							<FontAwesomeIcon icon={['fad', 'shield-halved']} />
						</IconButton>
					)}
				</Fragment>
			}
		>
			{!alias || onDuty != 'police' ? (
				<Unauthorized />
			) : (
				<Fragment>
					<div className={classes.user}>
						Welcome Back <span>{alias}</span>
					</div>
					<div className={classes.content}>
						{Boolean(races) && races.length > 0 ? (
							races.map((race, k) => {
								let track = tracks.filter(
									(t) => t.id == race.track,
								)[0];

								return (
									<Race
										key={`pending-${k}`}
										track={track}
										race={race}
									/>
								);
							})
						) : (
							<div className={classes.noRaces}>
								No Pending Races
							</div>
						)}
					</div>
				</Fragment>
			)}
		</AppContainer>
	);
};

import React, { Fragment } from 'react';
import { useSelector } from 'react-redux';
import { IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router';

import { useAppData, usePermissions } from '../../hooks';
import Welcome from './components/Welcome';
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
	invCount: {
		position: 'absolute',
		fontSize: 12,
		bottom: 0,
		right: 0,
		zIndex: 10,
		background: theme.palette.error.main,
		padding: '2px 6px',
		borderRadius: 20,
	},
}));

export default (props) => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const hasPerm = usePermissions();
	const navigate = useNavigate();
	const onDuty = useSelector((state) => state.data.data.onDuty);
	const sid = useSelector((state) => state.data.data.player.SID);
	const alias = useSelector(
		(state) => state.data.data.player?.Profiles?.redline,
	);
	const canCreate = hasPerm('redline', 'create');

	const tracks = useSelector((state) => state.data.data.tracks);
	const rawRaces = useSelector((state) => state.race.races);
	const invites = useSelector((state) => state.race.invites).filter((i) =>
		Boolean(rawRaces[i.id]),
	);
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
			appId="redline"
			titleOverride="Redline - Recent Races"
			actionShow={Boolean(alias) && onDuty != 'police'}
			actions={
				<Fragment>
					{invites.length > 0 && (
						<IconButton
							onClick={() => navigate('/apps/redline/invites')}
						>
							<span className={classes.invCount}>
								{invites.length}
							</span>
							<FontAwesomeIcon icon={['far', 'envelope']} />
						</IconButton>
					)}
					<IconButton
						onClick={() =>
							navigate('/apps/redline', {
								replace: true,
							})
						}
					>
						<FontAwesomeIcon icon={['far', 'calendar-days']} />
					</IconButton>
					<IconButton
						onClick={() => navigate('/apps/redline/tracks')}
					>
						<FontAwesomeIcon icon={['far', 'trophy']} />
					</IconButton>
					{Object.keys(rawRaces).filter(
						(k) =>
							rawRaces[k].host_id == sid &&
							rawRaces[k].state != -1 &&
							rawRaces[k].state != 2,
					).length == 0 && (
						<IconButton
							onClick={() => navigate('/apps/redline/new')}
						>
							<FontAwesomeIcon icon={['far', 'plus']} />
						</IconButton>
					)}
					{Boolean(canCreate) && (
						<IconButton
							onClick={() => navigate('/apps/redline/admin')}
						>
							<FontAwesomeIcon icon={['fad', 'shield-halved']} />
						</IconButton>
					)}
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
					<div className={classes.content}>
						{Boolean(races) && races.length > 0 ? (
							races.map((race, k) => {
								let track = tracks.filter(
									(t) => t.id == race.track,
								)[0];

								return (
									<Race
										key={`recent-${k}`}
										track={track}
										race={race}
									/>
								);
							})
						) : (
							<div className={classes.noRaces}>
								No Recent Races
							</div>
						)}
					</div>
				</Fragment>
			)}
		</AppContainer>
	);
};

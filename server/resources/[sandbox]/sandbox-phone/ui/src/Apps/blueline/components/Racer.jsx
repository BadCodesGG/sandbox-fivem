import React from 'react';
import { makeStyles } from '@mui/styles';
import moment from 'moment';

import { useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	race: {
		display: 'flex',
		fontFamily: 'Aclonica',
		transition: 'background ease-in 0.15s',
	},
	placing: {
		width: 50,
		textAlign: 'center',
		lineHeight: '50px',
		'& span': {
			fontFamily: 'Lexend Peta',
			color: (app) => app.color,
			fontSize: 34,
		},
	},
	label: {
		flexGrow: 1,
		maxWidth: 'calc(100% - 50px)',
		width: '100%',
	},
	raceNameBasic: {
		fontSize: 14,
		overflow: 'hidden',
		whiteSpace: 'nowrap',
		textOverflow: 'ellipsis',
		lineHeight: '50px',
	},
	raceName: {
		fontSize: 14,
		overflow: 'hidden',
		whiteSpace: 'nowrap',
		textOverflow: 'ellipsis',
		lineHeight: '24px',
		marginTop: 6,
	},
	trackName: {
		fontSize: 12,
		lineHeight: '14px',

		'& small': {
			fontSize: 10,
		},
	},
	arrow: {
		width: 50,
		textAlign: 'center',
		lineHeight: '50px',
	},
}));

export default ({ name, racer }) => {
	const appData = useAppData('blueline');
	const classes = useStyles(appData);
	if (racer.finished) {
		let duration = moment.duration(
			racer.fastest.lap_end - racer.fastest.lap_start,
		);

		return (
			<div className={classes.race}>
				<div className={classes.placing}>
					{Boolean(racer.place) ? `#${racer.place}` : 'DNF'}
				</div>
				<div className={classes.label}>
					<div className={classes.raceName}>{name}</div>
					<div className={classes.trackName}>
						Fastest Lap:{' '}
						{`${String(duration.hours()).padStart(2, '0')}:${String(
							duration.minutes(),
						).padStart(2, '0')}:${String(
							duration.seconds(),
						).padStart(2, '0')}:${String(
							duration.milliseconds(),
						).padStart(3, '0')}`}
					</div>
				</div>
			</div>
		);
	} else {
		return (
			<div className={classes.race}>
				<div className={classes.placing}>-</div>
				<div className={classes.label}>
					<div className={classes.raceNameBasic}>{name}</div>
				</div>
			</div>
		);
	}
};

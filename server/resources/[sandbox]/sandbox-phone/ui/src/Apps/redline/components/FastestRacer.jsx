import React from 'react';
import { makeStyles } from '@mui/styles';
import { useAppData } from '../../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router';
import moment from 'moment';

const useStyles = makeStyles((theme) => ({
	race: {
		display: 'flex',
		fontFamily: 'Aclonica',
		transition: 'background ease-in 0.15s',
		'&:hover': {
			background: theme.palette.secondary.dark,
			cursor: 'pointer',
		},
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
		maxWidth: 'calc(100% - 100px)',
		width: '100%',
	},
	raceName: {
		fontSize: 14,
		overflow: 'hidden',
		whiteSpace: 'nowrap',
		textOverflow: 'ellipsis',
		lineHeight: '20px',
		marginTop: 6,
	},
	trackName: {
		fontSize: 10,
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

export default ({ rank, racer }) => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const navigate = useNavigate();

	const onClick = () => {
		navigate(`/apps/redline/profile/${racer.alias}`);
	};

	let duration = moment.duration(racer.lap_end - racer.lap_start);

	return (
		<div className={classes.race} onClick={onClick}>
			<div className={classes.placing}>#{rank}</div>
			<div className={classes.label}>
				<div className={classes.raceName}>
					{racer.alias} - {racer.car}
				</div>
				<div className={classes.trackName}>
					Laptime:{' '}
					{`${String(duration.hours()).padStart(2, '0')}:${String(
						duration.minutes(),
					).padStart(2, '0')}:${String(duration.seconds()).padStart(
						2,
						'0',
					)}:${String(duration.milliseconds()).padStart(3, '0')}`}
				</div>
			</div>
			<div className={classes.arrow}>
				<FontAwesomeIcon icon={['far', 'chevron-right']} />
			</div>
		</div>
	);
};

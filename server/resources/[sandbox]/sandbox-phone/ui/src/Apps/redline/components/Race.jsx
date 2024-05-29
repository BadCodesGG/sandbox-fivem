import React from 'react';
import { makeStyles } from '@mui/styles';
import { useAppData } from '../../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router';

const useStyles = makeStyles((theme) => ({
	race: {
		display: 'flex',
		fontFamily: 'Aclonica',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		padding: '8px 0',
		background: theme.palette.secondary.dark,
		transition: 'background ease-in 0.15s',
		'&:hover': {
			background: theme.palette.secondary.light,
			cursor: 'pointer',
		},
	},
	classIcon: {
		width: 50,
		textAlign: 'center',
		lineHeight: '50px',
		'& span': {
            fontFamily: 'Lexend Peta',
			color: (app) => app.color,
			fontSize: 26,
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
		lineHeight: '27px',
        marginTop: 4,
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

export default ({ track, race }) => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const navigate = useNavigate();

	const onClick = () => {
		navigate(`/apps/redline/view/${race.id}`);
	};

	return (
		<div className={classes.race} onClick={onClick}>
			<div className={classes.classIcon}>
				{race.class != 'All' ? (
					<span>{race.class}</span>
				) : (
					<span>-</span>
				)}
			</div>
			<div className={classes.label}>
				<div className={classes.raceName}>{race.name}</div>
				<div className={classes.trackName}>
					{track.Name}{' '}
					<small>({Object.keys(race.racers).length} Racers)</small>
				</div>
			</div>
			<div className={classes.arrow}>
				<FontAwesomeIcon icon={['far', 'chevron-right']} />
			</div>
		</div>
	);
};

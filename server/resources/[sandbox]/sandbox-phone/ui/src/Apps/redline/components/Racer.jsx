import React from 'react';
import { makeStyles } from '@mui/styles';
import { useAppData } from '../../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router';
import moment from 'moment';
import {
	IconButton,
	ListItem,
	ListItemAvatar,
	ListItemSecondaryAction,
	ListItemText,
} from '@mui/material';
import { useSelector } from 'react-redux';

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
	action: {
		fontSize: 18,

		'&:not(:last-of-type)': {
			marginRight: 4,
		},
	},
}));

export default ({ race, name, racer, onRemove = null, onWinnings = null }) => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const navigate = useNavigate();

	const player = useSelector((state) => state.data.data.player);

	const onClick = () => {
		navigate(`/apps/redline/profile/${name}`);
	};

	if (racer.finished) {
		let duration = moment.duration(
			racer.fastest.lap_end - racer.fastest.lap_start,
		);

		return (
			<ListItem>
				<ListItemAvatar>
					{Boolean(racer.place) ? `#${racer.place}` : 'DNF'}
				</ListItemAvatar>
				<ListItemText
					primary={name}
					secondary={
						<span>
							Fastest Lap:{' '}
							{`${String(duration.hours()).padStart(
								2,
								'0',
							)}:${String(duration.minutes()).padStart(
								2,
								'0',
							)}:${String(duration.seconds()).padStart(
								2,
								'0',
							)}:${String(duration.milliseconds()).padStart(
								3,
								'0',
							)}`}
						</span>
					}
				/>
				<ListItemSecondaryAction>
					{Boolean(racer.reward) && Boolean(onWinnings) && (
						<IconButton
							className={classes.action}
							onClick={() => {
								onWinnings({
									name,
									event: race.name,
									reward: racer.reward,
								});
							}}
						>
							<FontAwesomeIcon icon={['fas', 'dollar']} />
						</IconButton>
					)}
					<IconButton className={classes.action} onClick={onClick}>
						<FontAwesomeIcon icon={['fas', 'user']} />
					</IconButton>
				</ListItemSecondaryAction>
			</ListItem>
		);
	} else {
		return (
			<ListItem>
				<ListItemAvatar>-</ListItemAvatar>
				<ListItemText primary={name} />
				<ListItemSecondaryAction>
					{Boolean(onRemove) &&
						race.host_id == player.SID &&
						racer.sid != player.SID && (
							<IconButton
								className={classes.action}
								onClick={() => onRemove(name)}
							>
								<FontAwesomeIcon icon={['fas', 'x']} />
							</IconButton>
						)}
					<IconButton className={classes.action} onClick={onClick}>
						<FontAwesomeIcon icon={['fas', 'user']} />
					</IconButton>
				</ListItemSecondaryAction>
			</ListItem>
		);
	}
};

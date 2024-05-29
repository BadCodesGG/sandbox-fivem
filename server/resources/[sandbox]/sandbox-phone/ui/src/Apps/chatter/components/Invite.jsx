import React from 'react';
import { makeStyles } from '@mui/styles';
import { Avatar } from '@mui/material';

import { useAppData } from '../../../hooks';
import Moment from 'react-moment';
import { useNavigate } from 'react-router';

const useStyles = makeStyles((theme) => ({
	invite: {
		fontFamily: 'Kanit',
		display: 'flex',
		padding: 10,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		background: theme.palette.secondary.main,
		transition: 'background ease-in 0.15s',
		'&:hover': {
			cursor: 'pointer',
			background: (app) => app.color,
		},
	},
	iconContainer: {
		marginRight: 8,
		position: 'relative',
		width: 40,
	},
	icon: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		border: (app) => `2px solid ${app.color}`,
	},
	joined: {
		fontSize: 12,
		color: theme.palette.text.alt,

		'&::before': {
			content: '"Received: "',
		},
	},
}));

export default ({ invite }) => {
	const appData = useAppData('chatter');
	const classes = useStyles(appData);
	const navigate = useNavigate();

	const onClick = () => {
		navigate(`/apps/chatter/join/${invite.group}`);
	};

	return (
		<div className={classes.invite} onClick={onClick}>
			<div className={classes.iconContainer}>
				<Avatar className={classes.icon} src={invite.icon} />
			</div>
			<div className={classes.inviteInfo}>
				<div>{invite.label}</div>
				<div className={classes.joined}>
					<Moment unix date={invite.timestamp} format="LLL" />
				</div>
			</div>
		</div>
	);
};

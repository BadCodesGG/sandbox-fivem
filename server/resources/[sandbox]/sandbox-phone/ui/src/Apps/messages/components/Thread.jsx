import React from 'react';
import { useSelector } from 'react-redux';
import { Avatar } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { useAppData } from '../../../hooks';
import Moment from 'react-moment';
import { useNavigate } from 'react-router';

const useStyles = makeStyles((theme) => ({
	thread: {
		display: 'flex',
		padding: '16px 4px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'background ease-in 0.15s',

		'&:hover': {
			cursor: 'pointer',
			background: theme.palette.secondary.dark,
		},
	},
	picContainer: {
		width: 65,
		position: 'relative',

		'& .avatar': {
			width: 50,
			height: 50,
			position: 'absolute',
			top: 0,
			bottom: 0,
			left: 0,
			right: 0,
			margin: 'auto',
		},
	},
	infoContainer: {
		flexGrow: 1,
		maxWidth: 'calc(100% - 140px)',
		position: 'relative',

		'& .inner': {
			height: 'fit-content',
			position: 'absolute',
			top: 0,
			bottom: 0,
			left: 0,
			margin: 'auto',

			'& .name': {
				fontSize: 16,
				maxWidth: '100%',
				overflow: 'hidden',
				textOverflow: 'ellipsis',
				whiteSpace: 'nowrap',
				color: (app) =>
					Boolean(app.contact) ? app.contact.color : app.color,
			},
			'& .message': {
				fontSize: 14,
				color: theme.palette.text.main,
				maxWidth: '100%',
				overflow: 'hidden',
				textOverflow: 'ellipsis',
				whiteSpace: 'nowrap',
			},
		},
	},
	timestampContainer: {
		width: 100,
		height: 64,
		textAlign: 'right',

		'& .timestamp': {
			fontSize: 10,
			color: theme.palette.text.alt,
		},
		'& .unread': {
			width: 'fit-content',
			marginLeft: 'auto',
			borderRadius: 16,
			background: (app) => app.color,
			padding: '0 8px',
			marginTop: 16,
		},
	},
}));

export default ({ thread }) => {
	const appData = useAppData('messages');
	const navigate = useNavigate();
	const contacts = useSelector((state) => state.data.data.contacts);
	const isContact = contacts.filter((c) => c.number === thread.number)[0];
	const classes = useStyles({ ...appData, contact: isContact });

	const onClick = () => {
		navigate(`/apps/messages/convo/${thread.number}`);
	};

	return (
		<div className={classes.thread} onClick={onClick}>
			<div className={classes.picContainer}>
				{isContact != null ? (
					isContact.avatar != null && isContact.avatar !== '' ? (
						<Avatar
							className={`avatar ${
								Boolean(isContact?.favorite) ? 'favorite' : ''
							}`}
							src={isContact.avatar}
							alt={isContact.name.charAt(0)}
						/>
					) : (
						<Avatar
							className={`avatar ${
								Boolean(isContact?.favorite) ? 'favorite' : ''
							}`}
							style={{ background: isContact.color }}
						>
							{isContact.name.charAt(0)}
						</Avatar>
					)
				) : (
					<Avatar className="avatar">#</Avatar>
				)}
			</div>
			<div className={classes.infoContainer}>
				<div className="inner">
					<div className="name">
						{Boolean(isContact) ? isContact.name : thread.number}
					</div>
					<div className="message">
						<Moment
							unix
							className="timestamp"
							date={thread.time}
							fromNow
						/>
					</div>
				</div>
			</div>
			<div className={classes.timestampContainer}>
				{thread.unread > 0 && (
					<div className="unread">{thread.unread}</div>
				)}
			</div>
		</div>
	);
};

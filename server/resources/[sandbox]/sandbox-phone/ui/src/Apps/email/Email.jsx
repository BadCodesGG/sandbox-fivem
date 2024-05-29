import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { Grid, Avatar, Paper, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { DeleteEmail } from './action';
import { useAppData } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	email: {
		display: 'flex',
		flexDirection: 'row',
		padding: '16px 8px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'background ease-in 0.15s',

		'&:hover': {
			background: theme.palette.secondary.dark,
			cursor: 'pointer',
		},
	},
	flags: {
		display: 'flex',
		flexDirection: 'column',
		padding: '8px 8px 8px 0px',
		gap: 8,
	},
	readIndicator: {
		fontSize: 14,
		color: theme.palette.text.alt,
		'&.unread': {
			color: (app) => app.color,
		},
	},
	expireIndicator: {
		fontSize: 12,
		color: theme.palette.error.light,
	},
	flagIndicator: {
		fontSize: 14,
		color: theme.palette.warning.main,
	},
	details: {
		maxWidth: 'calc(100% - 22px)',
		flexGrow: 1,
	},
	senderContainer: {
		display: 'flex',
	},
	sender: {
		flexGrow: 1,
		maxWidth: '70%',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		whiteSpace: 'nowrap',
		fontSize: 18,
		color: (app) => app.color,
	},
	timestamp: {
		textAlign: 'right',
		fontSize: 10,
		color: theme.palette.text.alt,
		width: '30%',
		lineHeight: '26px',
	},
	subject: {
		fontSize: 14,
		color: theme.palette.text.main,
		width: '100%',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		whiteSpace: 'nowrap',
	},
}));

export default connect(null, { DeleteEmail })(({ email, DeleteEmail }) => {
	const appData = useAppData('email');
	const classes = useStyles(appData);
	const history = useNavigate();

	const onClick = () => {
		history(`/apps/email/view/${email.id}`);
	};

	useEffect(() => {
		let intrvl = null;
		if (Boolean(email.expires)) {
			intrvl = setInterval(() => {
				if (email.expires < Date.now() / 1000) {
					DeleteEmail(email.id);
				}
			}, 2500);
		}
		return () => {
			clearInterval(intrvl);
		};
	}, []);

	return (
		<div className={classes.email} onClick={onClick}>
			<div className={classes.flags}>
				<Tooltip
					placement="right"
					title={
						Boolean(email.unread)
							? 'Email Is Unread'
							: 'Email Has Been Read'
					}
				>
					<FontAwesomeIcon
						icon={['fas', 'circle']}
						className={`${classes.readIndicator} ${
							Boolean(email.unread) ? 'unread' : ''
						}`}
					/>
				</Tooltip>
				{Boolean(email?.expires) &&
					email.expires > Date.now() / 1000 && (
						<Tooltip title="Email Expires Soon" placement="right">
							<FontAwesomeIcon
								icon={['far', 'hexagon-exclamation']}
								className={classes.expireIndicator}
							/>
						</Tooltip>
					)}
				{Boolean(email.flags) && (
					<Tooltip
						title="Email Has Additional Flags"
						placement="right"
					>
						<FontAwesomeIcon
							icon={['far', 'flag']}
							className={classes.flagIndicator}
						/>
					</Tooltip>
				)}
			</div>
			<div className={classes.details}>
				<div className={classes.senderContainer}>
					<div className={classes.sender}>{email.sender}</div>
					<div className={classes.timestamp}>
						<Moment
							unix
							interval={60000}
							fromNow
							date={email.time}
						/>
					</div>
				</div>
				<div className={classes.subject}>{email.subject}</div>
			</div>
		</div>
	);

	return (
		<Paper className={classes.convo} onClick={onClick}>
			<Grid container>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<Avatar
						className={
							props.email.unread
								? classes.avatarUnread
								: classes.avatar
						}
					>
						{props.email.sender?.charAt(0)?.toUpperCase() ?? '?'}
					</Avatar>
				</Grid>
				<Grid item xs={10} style={{ position: 'relative' }}>
					<div>
						<span
							className={
								props.email.unread
									? classes.senderUnread
									: classes.sender
							}
						>
							{props.email.sender}
						</span>
						<div className={classes.time}>
							<Moment
								unix
								interval={60000}
								fromNow
								date={props.email.time}
							/>
						</div>
					</div>
					{props.email.flags != null ? (
						<FontAwesomeIcon
							className={classes.specialIcon}
							icon={['fas', 'flag']}
						/>
					) : null}
					<div className={classes.subject}>{props.email.subject}</div>
					{/* <div className={classes.body}>{props.email.body}</div> */}
				</Grid>
			</Grid>
		</Paper>
	);
});

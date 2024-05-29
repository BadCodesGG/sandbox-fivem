import React, { Fragment } from 'react';
import { makeStyles } from '@mui/styles';
import { useNavigate, useParams } from 'react-router';
import { Avatar, IconButton } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import chroma from 'chroma-js';

import { AppContainer } from '../../components';
import { useAlert, useAppData } from '../../hooks';
import { useDispatch, useSelector } from 'react-redux';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	icon: {
		width: 175,
		height: 175,
		margin: 'auto',
		border: (app) => `2px solid ${chroma(app.color).brighten(1)}`,
		marginTop: 50,
	},
	header: {
		fontSize: 12,
		color: theme.palette.text.alt,
		textAlign: 'center',
		textTransform: 'uppercase',
		marginTop: 25,
	},
	label: {
		fontSize: 24,
		fontWeight: 'bold',
		textAlign: 'center',
		color: theme.palette.text.main,
		marginTop: 10,
	},
	actions: {
		fontSize: 40,
		display: 'flex',
		gap: 30,
		width: 'fit-content',
		position: 'absolute',
		bottom: '20%',
		left: 0,
		right: 0,
		margin: 'auto',

		'& .MuiIconButton-root': {
			width: 60,
			height: 60,
		},
		'& .negative': {
			transition: 'color ease-in 0.15s',
			'&:hover': {
				color: theme.palette.error.light,
			},
		},
		'& .positive': {
			transition: 'color ease-in 0.15s',
			'&:hover': {
				color: theme.palette.success.main,
			},
		},
	},
}));

export default () => {
	const appData = useAppData('chatter');
	const classes = useStyles(appData);
	const navigate = useNavigate();
	const showAlert = useAlert();
	const dispatch = useDispatch();
	const { channel } = useParams();

	const invite = useSelector((state) => state.chatter.invites[+channel]);

	const onDecline = async () => {
		try {
			let res = await (
				await Nui.send('Chatter:Invite:Decline', channel)
			).json();
			if (Boolean(res)) {
				showAlert('Group Invite Declined');
				dispatch({
					type: 'CHATTER_REMOVE_INVITE',
					payload: {
						group: +channel,
					},
				});
				navigate('/apps/chatter/invites', { replace: true });
			} else {
				showAlert('Failed Declining Invite');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Declining Invite');
		}
	};

	const onAccept = async () => {
		try {
			let res = await (
				await Nui.send('Chatter:Invite:Accept', channel)
			).json();
			if (Boolean(res)) {
				showAlert('Group Invite Accepted');
				dispatch({
					type: 'CHATTER_ADD_GROUP',
					payload: {
						group: res,
					},
				});
				dispatch({
					type: 'CHATTER_REMOVE_INVITE',
					payload: {
						group: res.id,
					},
				});
				navigate(`/apps/chatter/channel/${channel}`, { replace: true });
			} else {
				showAlert('Failed Accepting Invite');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Accepting Invite');
		}
	};

	return (
		<AppContainer
			appId="chatter"
			titleOverride={
				Boolean(invite)
					? `Join ${invite.label}`
					: 'Chatter - Invalid Invite'
			}
		>
			{Boolean(invite) ? (
				<div>
					<Avatar
						className={classes.icon}
						src={invite.icon}
						alt={invite.label.charAt(0)}
					/>
					<div className={classes.header}>You've Been Invited To</div>
					<div className={classes.label}>{invite.label}</div>
					<div className={classes.actions}>
						<IconButton className="negative" onClick={onDecline}>
							<FontAwesomeIcon icon={['far', 'x']} />
						</IconButton>
						<IconButton className="positive" onClick={onAccept}>
							<FontAwesomeIcon icon={['far', 'check']} />
						</IconButton>
					</div>
				</div>
			) : (
				<div>Invalid Invite</div>
			)}
		</AppContainer>
	);
};

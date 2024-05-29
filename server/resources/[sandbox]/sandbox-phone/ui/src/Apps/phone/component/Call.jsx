import React from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { Avatar, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import Nui from '../../../util/Nui';
import { useAlert, useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	call: {
		display: 'flex',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		padding: '8px 4px',
	},
	avatarContainer: {
		width: 60,
		position: 'relative',
	},
	avatar: {
		color: '#fff',
		height: 45,
		width: 45,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		'&.favorite': {
			border: '2px solid gold',
		},
	},
	infoContainer: {
		flexGrow: 1,

		'& .type': {
			fontSize: 10,
			color: theme.palette.text.alt,
		},
		'& .name': {
			fontSize: 18,
			color: (app) =>
				Boolean(app.contact) ? app.contact.color : app.color,
		},
		'& .number': {
			fontSize: 12,
			color: theme.palette.text.alt,
		},
	},
	actions: {
		display: 'flex',
		marginTop: 10,

		'& .button': {
			height: 45,
			width: 45,
		},
	},
}));

export default (props) => {
	const appData = useAppData('phone');
	const history = useNavigate();
	const showAlert = useAlert();
	const contacts = useSelector((state) => state.data.data.contacts);
	const callData = useSelector((state) => state.call.call);
	const isContact = contacts.filter((c) => c.number === props.call.number)[0];
	const classes = useStyles({ ...appData, contact: isContact });

	const callContact = async () => {
		if (
			callData == null &&
			!props?.call?.limited &&
			!props?.call?.anonymous
		) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number: props.call.number,
						isAnon: false,
					})
				).json();
				if (res) {
					history(`/apps/phone/call/${props.call.number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.error(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const textContact = () => {
		if (!props?.call?.limited && !props?.call?.anonymous) {
			history(`/apps/messages/convo/${props.call.number}`);
		}
	};

	const viewContact = () => {
		if (!props?.call?.limited && !props?.call?.anonymous) {
			if (Boolean(isContact)) {
				history(`/apps/contacts/view/${isContact.id}`);
			} else {
				history(`/apps/contacts/caller/${props.call.number}`);
			}
		}
	};

	const getCallType = (call) => {
		if (call.duration > -1) {
			if (call.method) {
				return <span>Outgoing Call</span>;
			} else {
				return <span>Incoming Call</span>;
			}
		} else {
			if (call.method) {
				return <span>Unanswered Outgoing Call</span>;
			} else {
				return <span>Missed Incoming Call</span>;
			}
		}
	};

	if (props?.call?.limited && props?.call?.method) return null;
	return (
		<div className={classes.call}>
			<div className={classes.avatarContainer}>
				{!props?.call?.limited &&
					!props?.call?.anonymous &&
					isContact != null &&
					isContact.avatar != null &&
					isContact.avatar !== '' ? (
					<Avatar
						className={`${classes.avatar} ${isContact.favorite ? 'favorite' : ''
							}`}
						src={isContact.avatar}
						alt={isContact.name.charAt(0)}
					/>
				) : (
					<Avatar
						className={`${classes.avatar} ${!props?.call?.limited &&
							!props?.call?.anonymous &&
							isContact != null &&
							isContact.favorite
							? 'favorite'
							: ''
							}`}
						style={{
							background:
								!props?.call?.limited &&
									!props?.call?.anonymous &&
									isContact != null &&
									isContact.color
									? isContact.color
									: '#333',
						}}
					>
						{!props?.call?.limited &&
							!props?.call?.anonymous &&
							isContact != null
							? isContact.name.charAt(0)
							: props?.call?.limited
								? '?'
								: '#'}
					</Avatar>
				)}
			</div>
			<div className={classes.infoContainer}>
				<div className="type">{getCallType(props?.call)}</div>
				{(!props?.call?.limited && !props?.call?.anonymous) ? (
					<div className="name">
						{isContact != null
							? isContact.name
							: props.call.number}
					</div>
				) : (
					<div className="name">
						{'Unknown Caller'}
					</div>
				)}
				<div className="number">
					<Moment date={props.call.time} unix fromNow />
				</div>
			</div>
			{!props?.call?.limited && !props?.call?.anonymous && (
				<div className={classes.actions}>
					<IconButton className="button" onClick={callContact}>
						<FontAwesomeIcon icon={['far', 'phone']} />
					</IconButton>
					<IconButton className="button" onClick={textContact}>
						<FontAwesomeIcon icon={['far', 'message-sms']} />
					</IconButton>
					<IconButton className="button" onClick={viewContact}>
						<FontAwesomeIcon icon={['far', 'eye']} />
					</IconButton>
				</div>
			)}
		</div>
	);
};

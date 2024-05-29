import React from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
	Grid,
	Avatar,
	Accordion,
	AccordionSummary,
	AccordionDetails,
	Paper,
	IconButton,
	Tooltip,
} from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';

const ExpansionPanel = withStyles({
	root: {
		border: '1px solid rgba(0, 0, 0, .25)',
		boxShadow: 'none',
		'&:not(:last-child)': {
			borderBottom: 0,
		},
		'&:before': {
			display: 'none',
		},
		'&$expanded': {
			margin: 'auto',
		},
	},
	expanded: {},
})(Accordion);

const useStyles = makeStyles((theme) => ({
	contact: {
		display: 'flex',
		padding: 8,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	avatarContainer: {
		width: 60,
		position: 'relative',
	},
	avatar: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		'&.favorite': {
			border: `2px solid gold`,
		},
	},
	info: {
		flexGrow: 1,
		maxWidth: 'calc(100% - 183px)',

		'& .name': {
			maxWidth: '100%',
			width: '100%',
			overflow: 'hidden',
			fontSize: 18,
			fontWeight: 'bold',
			textOverflow: 'ellipsis',
			whiteSpace: 'nowrap',
		},
		'& .number': {
			fontSize: 14,
			color: theme.palette.text.alt,
		},
	},
}));

export default ({ contact, onDelete }) => {
	const classes = useStyles();
	const history = useNavigate();
	const showAlert = useAlert();
	const callData = useSelector((state) => state.call.call);

	const callContact = async () => {
		if (callData == null) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number: contact.number,
						isAnon: false,
					})
				).json();
				if (res) {
					history(`/apps/phone/call/${contact.number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.error(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const textContact = () => {
		history(`/apps/messages/convo/${contact.number}`);
	};

	const viewContact = () => {
		history(`/apps/contacts/view/${contact.id}`);
	};

	return (
		<div className={classes.contact}>
			<div className={classes.avatarContainer}>
				{contact.avatar != null && contact.avatar !== '' ? (
					<Avatar
						className={`${classes.avatar} ${
							Boolean(contact?.favorite) ? 'favorite' : ''
						}`}
						src={contact.avatar}
						alt={contact.name.charAt(0)}
					/>
				) : (
					<Avatar
						className={`${classes.avatar} ${
							Boolean(contact?.favorite) ? 'favorite' : ''
						}`}
						style={{ background: contact.color }}
					>
						{contact.name.charAt(0)}
					</Avatar>
				)}
			</div>
			<Tooltip title={contact.name} placement="left">
				<div className={classes.info}>
					<div className="name">{contact.name}</div>
					<div className="number">{contact.number}</div>
				</div>
			</Tooltip>
			<div className={classes.actions}>
				<IconButton onClick={callContact}>
					<FontAwesomeIcon icon={['far', 'phone']} />
				</IconButton>
				<IconButton onClick={textContact}>
					<FontAwesomeIcon icon={['far', 'message-sms']} />
				</IconButton>
				<IconButton onClick={viewContact}>
					<FontAwesomeIcon icon={['far', 'eye']} />
				</IconButton>
			</div>
		</div>
	);

	return (
		<Paper className={classes.paper}>
			<ExpansionPanel
				className={classes.contact}
				expanded={props.expanded == props.index}
				onChange={props.onClick}
			>
				<AccordionSummary
					expandIcon={
						<FontAwesomeIcon icon={['fas', 'chevron-down']} />
					}
					style={{ padding: '0 12px' }}
				>
					<Grid container>
						<Grid item xs={2}>
							{props.contact.avatar != null &&
							props.contact.avatar !== '' ? (
								<Avatar
									className={
										props.contact.favorite
											? classes.avatarFav
											: classes.avatar
									}
									src={props.contact.avatar}
									alt={props.contact.name.charAt(0)}
								/>
							) : (
								<Avatar
									className={
										props.contact.favorite
											? classes.avatarFav
											: classes.avatar
									}
									style={{ background: props.contact.color }}
								>
									{props.contact.name.charAt(0)}
								</Avatar>
							)}
						</Grid>
						<Grid item xs={10}>
							<div className={classes.contactName}>
								{props.contact.name}
							</div>
							<div className={classes.contactNumber}>
								{props.contact.number}
							</div>
						</Grid>
					</Grid>
				</AccordionSummary>
				<AccordionDetails>
					<Grid container className={classes.expandoContainer}>
						<Grid
							item
							xs={props.onDelete != null ? 3 : 4}
							className={classes.expandoItem}
							onClick={callContact}
						>
							<FontAwesomeIcon icon="phone" />
						</Grid>
						<Grid
							item
							xs={props.onDelete != null ? 3 : 4}
							className={classes.expandoItem}
							onClick={textContact}
						>
							<FontAwesomeIcon icon="message-sms" />
						</Grid>
						<Grid
							item
							xs={props.onDelete != null ? 3 : 4}
							className={classes.expandoItem}
							onClick={editContact}
						>
							<FontAwesomeIcon icon="user-pen" />
						</Grid>
						{props.onDelete != null ? (
							<Grid
								item
								xs={3}
								className={classes.expandoItem}
								onClick={props.onDelete}
							>
								<FontAwesomeIcon icon="user-minus" />
							</Grid>
						) : null}
					</Grid>
				</AccordionDetails>
			</ExpansionPanel>
		</Paper>
	);
};

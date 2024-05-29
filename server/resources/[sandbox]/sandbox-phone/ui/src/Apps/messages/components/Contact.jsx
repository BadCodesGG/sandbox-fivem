import React from 'react';
import { Avatar, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	contact: {
		display: 'flex',
		padding: 8,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'background ease-in 0.15s',

		'&:hover': {
			cursor: 'pointer',
			background: theme.palette.secondary.dark,
		},
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
		maxWidth: 'calc(100% - 90px)',

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
    actions: {
        width: 30,
        textAlign: 'center',
        lineHeight: '45px',
    }
}));

export default ({ contact, onClick }) => {
	const classes = useStyles();

	return (
		<div className={classes.contact} onClick={onClick}>
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
				<FontAwesomeIcon icon={['far', 'chevron-right']} />
			</div>
		</div>
	);
};

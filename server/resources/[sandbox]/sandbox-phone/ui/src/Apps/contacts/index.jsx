import React, { Fragment, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { IconButton, TextField, Tooltip } from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { AppContainer, Confirm } from '../../components';
import Contact from './contact';

import { deleteContact } from './actions';
import { useAlert, useAppData } from '../../hooks';
import { FormatPhoneNumber } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
	content: {
		height: '88%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	searchField: {
		height: '10%',
		padding: '10px 20px',
		marginBottom: 10,
		display: 'flex',
	},
	add: {
		position: 'absolute',
		bottom: '12%',
		right: '10%',
		'&:hover': {
			filter: 'brightness(0.75)',
			transition: 'filter ease-in 0.15s',
		},
	},
	closer: {
		position: 'fixed',
		top: 0,
		left: 0,
		height: '100%',
		width: '100%',
		background: 'rgba(0, 0, 0, 0.75)',
		zIndex: 10000,
	},
	createInput: {
		width: '100%',
		height: '100%',
		marginBottom: 10,
	},
	nocontacts: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	input: {
		flexGrow: 1,

		'& .MuiInputBase-root': {
			borderRadius: 30,
		},
	},
}));

const CssTextField = withStyles((theme) => ({
	root: {
		'& label.Mui-focused': {
			color: ({ app }) => app.color,
		},
		'& .MuiInput-underline:after': {
			borderBottomColor: ({ app }) => app.color,
		},
		'& .MuiOutlinedInput-root': {
			'& fieldset': {
				borderColor: 'white',
			},
			'&:hover fieldset': {
				borderColor: 'white',
			},
			'&.Mui-focused fieldset': {
				borderColor: ({ app }) => app.color,
			},
		},
	},
}))(TextField);

const fitSearchFilter = (name, number, term) => {
	let r = FormatPhoneNumber(term);
	if (term && term.length > 0 && name && number) {
		term = term.toLowerCase();

		return (
			name.toLowerCase().includes(term) ||
			(Boolean(r) && number.includes(r))
		);
	} else return true;
};

export default connect(null, { deleteContact })((props) => {
	const appData = useAppData('contacts');
	const showAlert = useAlert();
	const classes = useStyles(appData);
	const history = useNavigate();
	const data = useSelector((state) => state.data.data);
	const contacts = data.contacts;
	const [expanded, setExpanded] = useState(-1);
	const [search, setSearched] = useState('');

	const create = () => {
		history('/apps/contacts/add');
	};

	const handleClick = (index) => (event, newExpanded) => {
		setExpanded(newExpanded ? index : false);
	};

	const [deleteOpen, setDeleteOpen] = useState(false);
	const handleDeleteOpen = (id) => {
		setDeleteOpen(id);
	};

	const onDecline = () => {
		setDeleteOpen(false);
	};

	const onDelete = () => {
		props.deleteContact(deleteOpen);
		setDeleteOpen(false);
		showAlert('Contact Deleted');
	};

	return (
		<AppContainer
			appId="contacts"
			actions={
				<Fragment>
					<Tooltip title="Add Contact">
						<IconButton onClick={create}>
							<FontAwesomeIcon icon={['fas', 'plus']} />
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			{Boolean(contacts) && contacts.length > 0 ? (
				<Fragment>
					<div className={classes.searchField}>
						<CssTextField
							app={appData}
							label="Search Contacts"
							color="secondary"
							className={classes.input}
							value={search}
							onChange={(e) => setSearched(e.target.value)}
						/>
					</div>
					<div className={classes.content}>
						{contacts
							.filter(
								(c) =>
									c.favorite &&
									fitSearchFilter(c.name, c.number, search),
							)
							.sort((a, b) => {
								if (a.name.toLowerCase() > b.name.toLowerCase())
									return 1;
								else if (
									b.name.toLowerCase() > a.name.toLowerCase()
								)
									return -1;
								else return 0;
							})
							.map((contact) => {
								return (
									<Contact
										key={contact.id}
										contact={contact}
										expanded={expanded}
										index={contact.id}
										onClick={handleClick(contact.id)}
										onDelete={() =>
											handleDeleteOpen(contact.id)
										}
									/>
								);
							})}
						{contacts
							.filter(
								(c) =>
									!c.favorite &&
									fitSearchFilter(c.name, c.number, search),
							)
							.sort((a, b) => {
								if (a.name > b.name) return 1;
								else if (b.name > a.name) return -1;
								else return 0;
							})
							.map((contact) => {
								return (
									<Contact
										key={contact.id}
										contact={contact}
										expanded={expanded}
										index={contact.id}
										onClick={handleClick(contact.id)}
										onDelete={() =>
											handleDeleteOpen(contact.id)
										}
									/>
								);
							})}
					</div>
					<Confirm
						title="Delete Contact"
						open={deleteOpen}
						confirm="Delete"
						decline="Cancel"
						onConfirm={onDelete}
						onDecline={onDecline}
					/>
				</Fragment>
			) : (
				<div className={classes.wrapper}>
					<div className={classes.content}>
						<div className={classes.nocontacts}>
							You Have No Contacts
						</div>
					</div>
					<Confirm
						title="Delete Contact"
						open={deleteOpen}
						confirm="Delete"
						decline="Cancel"
						onConfirm={onDelete}
						onDecline={onDecline}
					/>
				</div>
			)}
		</AppContainer>
	);
});

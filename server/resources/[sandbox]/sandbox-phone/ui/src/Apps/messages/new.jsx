import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
	TextField,
	Avatar,
	Grid,
	InputAdornment,
	IconButton,
} from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert, useAppData } from '../../hooks';
import { AppContainer } from '../../components';
import Contact from './components/Contact';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	newNumber: {
		marginTop: '1%',
		height: '9%',
		padding: '0 25px',
	},
	searchField: {
		marginTop: 8,
		width: '100%',
		'& .MuiInputBase-root': {
			borderRadius: 30,
		},
	},
	contactsList: {
		height: '90%',
		padding: '15px 0px',
		overflow: 'hidden',
	},
	contactWrapper: {
		width: '100%',
		padding: '20px 12px',
		background: theme.palette.secondary.dark,
		border: '1px solid rgba(0, 0, 0, .25)',
		'&:not(:last-child)': {
			borderBottom: 'none',
		},
		'&:hover': {
			filter: 'brightness(0.75)',
			transition: 'filter ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	avatar: {
		color: '#fff',
		height: 45,
		width: 45,
	},
	avatarFav: {
		color: '#fff',
		height: 45,
		width: 45,
		border: '2px solid gold',
	},
	noContacts: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		color: theme.palette.error.main,
	},
	contactsFilter: {
		height: '11%',
		overflow: 'hidden',
	},
	contactsBody: {
		height: '89%',
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

const FormatPhoneNumber = (phoneNumberString) => {
	var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
	var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
	if (match) {
		return `${match[1]}-${match[2]}-${match[3]}`;
	}
	return null;
};

export default (props) => {
	const appData = useAppData('messages');
	const showAlert = useAlert();
	const history = useNavigate();
	const contacts = useSelector((state) => state.data.data.contacts);
	const classes = useStyles(appData);

	const [filteredContacts, setFilteredContacts] = useState(Array());
	const [rawNumber, setRawNumber] = useState('');

	useEffect(() => {
		if (rawNumber == '') return setFilteredContacts([...contacts]);

		setFilteredContacts(
			contacts.filter(
				(c) =>
					c.name.toUpperCase().includes(rawNumber.toUpperCase()) ||
					c.number
						.replace(/\-/g, '')
						.includes(rawNumber.toUpperCase()),
			),
		);
	}, [rawNumber]);

	const onRawChange = (e) => {
		setRawNumber(e.target.value);
	};

	const onContactClick = (contact) => {
		history(`/apps/messages/convo/${contact.number}`);
	};

	const sendMessageToRaw = () => {
		let r = FormatPhoneNumber(rawNumber);
		if (r) {
			history(`/apps/messages/convo/${r}`);
		} else {
			showAlert('Not A Valid Number');
		}
	};

	return (
		<AppContainer appId="messages">
			<div className={classes.newNumber}>
				<CssTextField
					app={appData}
					className={classes.searchField}
					label="Enter Number or Contact Name"
					name="number"
					type="text"
					variant="outlined"
					value={rawNumber}
					onChange={onRawChange}
					InputProps={{
						endAdornment: (
							<InputAdornment position="end">
								<IconButton
									aria-label="toggle password visibility"
									onClick={sendMessageToRaw}
								>
									<FontAwesomeIcon
										icon={['fas', 'paper-plane-top']}
									/>
								</IconButton>
							</InputAdornment>
						),
					}}
					InputLabelProps={{
						style: { fontSize: 16 },
					}}
				/>
			</div>
			<div className={classes.contactsList}>
				{contacts.length > 0 ? (
					<div style={{ height: '100%' }}>
						<div className={classes.contactsBody}>
							{filteredContacts
								.filter((c) => c.favorite)
								.sort((a, b) => {
									if (
										a.name.toLowerCase() >
										b.name.toLowerCase()
									)
										return 1;
									else if (
										b.name.toLowerCase() >
										a.name.toLowerCase()
									)
										return -1;
									else return 0;
								})
								.map((contact) => {
									return (
										<Contact
											key={contact.id}
											contact={contact}
											onClick={() =>
												onContactClick(contact)
											}
										/>
									);
								})}
							{filteredContacts
								.filter((c) => !c.favorite)
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
											onClick={() =>
												onContactClick(contact)
											}
										/>
									);
								})}
						</div>
					</div>
				) : (
					<div className={classes.noContacts}>
						You Have No Contacts
					</div>
				)}
			</div>
		</AppContainer>
	);
};

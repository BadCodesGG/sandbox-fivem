import React, { Fragment, useState } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { Tooltip, IconButton, InputAdornment } from '@mui/material';
import { makeStyles } from '@mui/styles';
import InputMask from 'react-input-mask';
import { useAppData } from '../../hooks';
import { AppContainer, AppInput } from '../../components';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	content: {
		height: 'fit-content',
		width: '80%',
		position: 'absolute',
		left: 0,
		right: 0,
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
}));

export default () => {
	const appData = useAppData('contacts');
	const classes = useStyles(appData);
	const history = useNavigate();
	const contacts = useSelector((state) => state.data.data).contacts;

	const [number, setNumber] = useState('');

	const onChange = (e) => {
		setNumber(e.target.value);
	};

	const onSubmit = (e) => {
		e.preventDefault();
		let contact = contacts.filter((c) => c.number == number)[0];
		if (Boolean(contact)) history(`/apps/contacts/view/${contact.id}`);
		else history(`/apps/contacts/caller/${number}`);
	};

	return (
		<AppContainer
			appId="contacts"
			actions={
				<Fragment>
					<Tooltip title="Cancel">
						<IconButton onClick={() => history(-1)}>
							<FontAwesomeIcon icon={['fas', 'x']} />
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			<form className={classes.content} onSubmit={onSubmit}>
				<InputMask
					mask="999-999-9999"
					value={number}
					onChange={onChange}
				>
					{() => (
						<AppInput
							fullWidth
							label="Number"
							name="number"
							type="text"
							required
							InputLabelProps={{
								style: { fontSize: 20 },
							}}
							InputProps={{
								startAdornment: (
									<InputAdornment position="end">
										<FontAwesomeIcon
											icon={['fab', 'searchengin']}
										/>
									</InputAdornment>
								),
							}}
						/>
					)}
				</InputMask>
			</form>
		</AppContainer>
	);
};

/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { TextField, FormControl, MenuItem, Autocomplete } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { LocalizationProvider, DatePicker } from '@mui/x-date-pickers';
import { getCodeList } from 'country-list';
import { AdapterMoment } from '@mui/x-date-pickers/AdapterMoment';
import moment from 'moment';

import Nui from '../../util/Nui';

import { STATE_CHARACTERS } from '../../util/States';
import { CreateCharacter } from '../../util/NuiEvents';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		width: 650,
		height: 650,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		left: 0,
		margin: 'auto',
		background: theme.palette.secondary.dark,
		borderLeft: `4px solid ${theme.palette.primary.main}`,
	},
	createForm: {
		margin: 25,
	},
	title: {
		textAlign: 'center',
		borderBottom: `2px solid ${theme.palette.border.divider}`,
		fontSize: 26,
		paddingBottom: 15,
		marginBottom: 15,
	},
	button: {
		fontSize: 14,
		lineHeight: '20px',
		fontWeight: '500',
		display: 'inline-block',
		padding: '10px 20px',
		borderRadius: 3,
		userSelect: 'none',
		margin: 10,
		width: '40%',
		'&:disabled': {
			opacity: 0.5,
			cursor: 'not-allowed',
		},
	},
	positive: {
		border: `2px solid ${theme.palette.success.dark}`,
		background: theme.palette.success.main,
		color: theme.palette.text.dark,
		fontSize: 20,
		padding: 10,
		width: 105,
		textAlign: 'center',
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			background: theme.palette.success.main,
			filter: 'brightness(0.7)',
		},
	},
	negative: {
		border: `2px solid ${theme.palette.error.dark}`,
		background: theme.palette.error.main,
		color: theme.palette.text.main,
		fontSize: 20,
		padding: 10,
		width: 105,
		textAlign: 'center',
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			background: theme.palette.error.main,
			filter: 'brightness(0.7)',
		},
	},
	form: {
		display: 'flex',
		justifyContent: 'space-evenly',
		padding: '1% 0',
		flexWrap: 'wrap',
	},
	formControl: {
		width: '45%',
		display: 'block',
		margin: 10,
	},
	formControlFull: {
		width: '94%',
		display: 'block',
		margin: 10,
	},
	formControl2: {
		width: '94%',
		display: 'block',
		margin: 10,
	},
	input: {
		width: '100%',
	},
}));

const genders = [
	{
		value: 0,
		label: 'Male',
	},
	{
		value: 1,
		label: 'Female',
	},
];

const countriesOrigin = getCodeList();
const date = new Date();
date.setFullYear(date.getFullYear() - 18);
const date2 = new Date();
date2.setFullYear(date2.getFullYear() - 100);

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const countries = Object.keys(countriesOrigin).map((k) => {
		let c = countriesOrigin[k];
		return {
			label: c,
			value: k,
		};
	});

	const [state, setState] = useState({
		first: '',
		last: '',
		dob: moment().subtract(18, 'years'),
		gender: 0,
		bio: '',
		origin: null,
		originInput: '',
	});

	const onChange = (evt) => {
		if (evt.target.name == 'first' || evt.target.name == 'last') {
			setState({
				...state,
				[evt.target.name]: evt.target.value.replace(/\s/g, ''),
			});
		} else {
			setState({
				...state,
				[evt.target.name]: evt.target.value,
			});
		}
	};

	const onSubmit = (evt) => {
		evt.preventDefault();

		const data = {
			first: state.first,
			last: state.last,
			gender: state.gender,
			dob: state.dob,
			lastPlayed: -1,
			origin: state.origin,
		};

		Nui.send(CreateCharacter, data);
		dispatch({
			type: 'LOADING_SHOW',
			payload: { message: 'Creating Character' },
		});
	};

	return (
		<LocalizationProvider dateAdapter={AdapterMoment}>
			<div className={classes.wrapper}>
				<div className={classes.createForm}>
					<div className={classes.title}>Create Character</div>
					<form
						autoComplete="off"
						id="createForm"
						className={classes.form}
						onSubmit={onSubmit}
					>
						<FormControl className={classes.formControl}>
							<TextField
								className={classes.input}
								required
								label="First Name"
								name="first"
								variant="outlined"
								value={state.first}
								onChange={onChange}
							/>
						</FormControl>
						<FormControl className={classes.formControl}>
							<TextField
								className={classes.input}
								required
								label="Last Name"
								name="last"
								variant="outlined"
								value={state.last}
								onChange={onChange}
							/>
						</FormControl>
						<FormControl className={classes.formControlFull}>
							<Autocomplete
								value={state.origin}
								onChange={(e, v) => {
									onChange({
										target: {
											name: 'origin',
											value: v,
										},
									});
								}}
								inputValue={state.originInput}
								onInputChange={(e, v) => {
									onChange({
										target: {
											name: 'originInput',
											value: v,
										},
									});
								}}
								options={countries}
								getOptionLabel={(option) =>
									Boolean(option) ? option.label : ''
								}
								renderInput={(params) => (
									<TextField
										{...params}
										label="Country of Origin"
										variant="outlined"
									/>
								)}
							/>
						</FormControl>
						<FormControl className={classes.formControl}>
							<TextField
								className={classes.input}
								required
								select
								label="Gender"
								name="gender"
								value={state.gender}
								onChange={onChange}
								variant="outlined"
							>
								{genders.map((option) => (
									<MenuItem
										key={option.value}
										value={option.value}
									>
										{option.label}
									</MenuItem>
								))}
							</TextField>
						</FormControl>
						<FormControl className={classes.formControl}>
							<DatePicker
								className={classes.input}
								openTo="year"
								autoOk
								animateYearScrolling
								disableFuture
								required
								label="Date of Birth"
								views={['year', 'month', 'day']}
								value={state.dob}
								onChange={(newDate) =>
									onChange({
										target: { name: 'dob', value: newDate },
									})
								}
								renderInput={(params) => (
									<TextField fullWidth {...params} />
								)}
								slotProps={{
									textField: {
										helperText: 'MM/DD/YYYY',
									},
								}}
							/>
						</FormControl>
						<FormControl className={classes.formControl2}>
							<TextField
								className={classes.input}
								required
								label="Character Biography"
								name="bio"
								multiline
								rows="4"
								value={state.bio}
								onChange={onChange}
								variant="outlined"
							/>
						</FormControl>
					</form>
				</div>
				<div
					className={classes.actionData}
					style={{ textAlign: 'center' }}
				>
					<button
						type="button"
						className={`${classes.button} ${classes.negative}`}
						onClick={() => {
							dispatch({
								type: 'SET_STATE',
								payload: { state: STATE_CHARACTERS },
							});
						}}
					>
						Cancel
					</button>
					<button
						type="submit"
						className={`${classes.button} ${classes.positive}`}
						form="createForm"
					>
						Create
					</button>
				</div>
			</div>
		</LocalizationProvider>
	);
};

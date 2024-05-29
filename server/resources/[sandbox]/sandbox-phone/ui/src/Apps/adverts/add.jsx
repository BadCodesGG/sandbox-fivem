import React, { Fragment, useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Chip,
	InputAdornment,
	Autocomplete,
	Tooltip,
	IconButton,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert, useAppData } from '../../hooks';
import { Categories } from './data';
import { AppContainer, AppInput, Editor } from '../../components';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	form: {
		padding: 10,
	},
	button: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.warning.main,
		'&:hover': {
			backgroundColor: `${theme.palette.warning.main}14`,
		},
	},
	buttonNegative: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.main,
		'&:hover': {
			backgroundColor: `${theme.palette.error.main}14`,
		},
	},
	buttonPositive: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.success.main,
		'&:hover': {
			backgroundColor: `${theme.palette.success.main}14`,
		},
	},
	creatorInput: {
		marginTop: 20,
	},
}));

const initState = {
	title: '',
	full: '<p></p>',
	price: '',
	tags: Array(),
};

export default (props) => {
	const appData = useAppData('adverts');
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useNavigate();
	const player = useSelector((state) => state.data.data.player);

	const [state, setState] = useState(initState);
	const textChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	const onSave = () => {
		let t = Array();
		state.tags.map((tag) => {
			t.push(tag.label);
		});

		Nui.send('CreateAdvert', {
			...state,
			id: player.Source,
			author: `${player.First} ${player.Last}`,
			number: player.Phone,
			time: Date.now(),
			categories: t,
		})
			.then((res) => {
				showAlert('Advert Created');
				history(-1);
			})
			.catch((err) => {});
	};

	return (
		<AppContainer
			appId="adverts"
			actions={
				<Fragment>
					<Tooltip title="Cancel">
						<IconButton onClick={() => history(-1)}>
							<FontAwesomeIcon icon={['fas', 'x']} />
						</IconButton>
					</Tooltip>
					<Tooltip title="Create Ad">
						<IconButton onClick={onSave}>
							<FontAwesomeIcon icon={['fas', 'floppy-disk']} />
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			<div className={classes.form}>
				<AppInput
					app={appData}
					fullWidth
					label="Title"
					name="title"
					variant="outlined"
					required
					onChange={textChange}
					value={state.title}
					inputProps={{
						maxLength: 32,
					}}
				/>
				<Autocomplete
					app={appData}
					multiple
					fullWidth
					required
					style={{ marginTop: 10 }}
					value={state.tags}
					onChange={(event, newValue) => {
						setState({
							...state,
							tags: [...newValue],
						});
					}}
					options={Categories}
					getOptionLabel={(option) => option.label}
					renderTags={(tagValue, getTagProps) =>
						tagValue.map((option, index) => (
							<Chip
								label={option.label}
								style={{ backgroundColor: option.color }}
								{...getTagProps({ index })}
							/>
						))
					}
					renderInput={(params) => (
						<AppInput {...params} label="Tags" variant="outlined" />
					)}
				/>
				<AppInput
					app={appData}
					className={classes.creatorInput}
					fullWidth
					label="Price (Leave Empty If Negotiable)"
					name="price"
					variant="outlined"
					onChange={textChange}
					value={state.price}
					inputProps={{
						maxLength: 16,
					}}
					InputProps={{
						startAdornment: (
							<InputAdornment position="start">
								<FontAwesomeIcon
									icon={['fas', 'dollar-sign']}
								/>
							</InputAdornment>
						),
					}}
				/>
				<Editor
					appData={appData}
					value={state.full}
					onChange={textChange}
					name="full"
					placeholder="Description"
				/>
			</div>
		</AppContainer>
	);
};

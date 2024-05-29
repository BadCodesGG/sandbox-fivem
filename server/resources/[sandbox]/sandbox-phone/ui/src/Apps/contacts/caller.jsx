import React, { Fragment, useState } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { useNavigate, useParams } from 'react-router-dom';
import {
	Avatar,
	TextField,
	Switch,
	FormGroup,
	FormControlLabel,
	Tooltip,
	IconButton,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import InputMask from 'react-input-mask';

import { useAlert, useAppData } from '../../hooks';
import { Modal, ColorPicker, AppContainer } from '../../components';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	topContainer: {
		padding: '10px 25px',
		marginTop: 50,
	},
	avatarContainer: {},
	avatar: {
		height: 125,
		width: 125,
		margin: 'auto',
		border: '2px solid transparent',
		transition: 'border 0.15s ease-in',
		'&:hover': {
			filter: 'brightness(0.6)',
			transition: 'filter ease-in 0.15s',
			cursor: 'pointer',
		},
		'&.favorite': {
			border: '2px solid gold',
		},
	},
	infoContainer: {
		marginTop: 16,
		textAlign: 'center',

		'& .name': {
			maxWidth: '85%',
			margin: 'auto',
			overflow: 'hidden',
			textOverflow: 'ellipsis',
			whiteSpace: 'nowrap',
			fontSize: 22,
			color: (app) => app.color,
		},
		'& .number': {
			fontSize: 16,
			color: theme.palette.text.alt,
		},
	},
	editField: {
		marginBottom: 8,
	},
	actions: {
		width: 'fit-content',
		display: 'flex',
		gap: 16,
		position: 'absolute',
		left: 0,
		right: 0,
		bottom: '15%',
		margin: 'auto',

		'& .button': {
			width: 64,
			height: 64,
			transition: 'color ease-in 0.15s',

			'& svg': {
				fontSize: 28,
			},

			'&:hover': {
				color: (app) => app.color,
			},
		},
	},
}));

export default (props) => {
	const appData = useAppData('contacts');
	const showAlert = useAlert();
	const history = useNavigate();
	const params = useParams();
	const dispatch = useDispatch();
	const { id } = params;
	const callData = useSelector((state) => state.call.call);
	const contacts = useSelector((state) => state.data.data).contacts;
	const [contact, setContact] = useState(
		useSelector((state) => state.data.data.contacts).filter(
			(c) => c.id == id,
		)[0],
	);

	const classes = useStyles(appData);

	const [avatarSelection, setAvatarSelection] = useState(false);
	const [saving, setSaving] = useState(false);

	const [state, setState] = useState({
		number: id,
		name: '',
		favorite: false,
		avatar: '',
	});

	const onSave = async () => {
		try {
			let id = await (await Nui.send('CreateContact', state)).json();
			if (Boolean(id)) {
				dispatch({
					type: 'ADD_DATA',
					payload: {
						type: 'contacts',
						data: {
							...state,
							id: id,
						},
					},
				});
				showAlert('Contact Saved');
				history(`/apps/contacts/view/${id}`);
			} else {
				showAlert('Failed Creating Contact');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Creating Contact');
		}
	};

	const callContact = async () => {
		if (!Boolean(callData)) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number: id,
						isAnon: false,
					})
				).json();
				if (res) {
					history(`/apps/phone/call/${id}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.error(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const textContact = () => {
		history(`/apps/messages/convo/${id}`);
	};

	const onAvatarSubmit = (ov) => {
		setState({
			...state,
			avatar: Boolean(ov) ? '' : avatarSelection?.avatar,
		});
		setAvatarSelection(false);
	};

	const removeImage = () => {
		onAvatarSubmit(true);
	};

	const onChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	const onChecked = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.checked,
		});
	};

	return (
		<AppContainer
			appId="contacts"
			actions={
				<Fragment>
					<Tooltip title="Save As Contact">
						<IconButton onClick={() => setSaving(true)}>
							<FontAwesomeIcon icon={['fas', 'floppy-disk']} />
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			<div className={classes.topContainer}>
				<div className={classes.avatarContainer}>
					{state.avatar != null && state.avatar !== '' ? (
						<Avatar
							className={`${classes.avatar}${
								state.favorite ? ' favorite' : ''
							}`}
							src={state.avatar}
							alt={state.name.charAt(0)}
							onClick={() =>
								setAvatarSelection({
									avatar: state?.avatar ?? '',
								})
							}
						/>
					) : (
						<Avatar
							className={`${classes.avatar}${
								state.favorite ? ' favorite' : ''
							}`}
							style={{
								background: state.color,
							}}
							onClick={() =>
								setAvatarSelection({
									avatar: state?.avatar ?? '',
								})
							}
						>
							?
						</Avatar>
					)}
				</div>
				<div className={classes.infoContainer}>
					<div className="name">Unknown Number</div>
					<div className="number">{state.number}</div>
				</div>
				<div className={classes.actions}>
					<IconButton className="button" onClick={callContact}>
						<FontAwesomeIcon icon={['far', 'phone']} />
					</IconButton>
					<IconButton className="button" onClick={textContact}>
						<FontAwesomeIcon icon={['far', 'message-sms']} />
					</IconButton>
				</div>
			</div>
			<Modal
				form
				open={avatarSelection}
				title="Avatar"
				onAccept={onAvatarSubmit}
				onClose={() => setAvatarSelection(false)}
				onDelete={Boolean(avatarSelection?.avatar) ? removeImage : null}
				deleteLang="Remove Avatar"
				closeLang="Done"
			>
				{Boolean(avatarSelection) && (
					<TextField
						fullWidth
						className={classes.editField}
						label="Link"
						name="avatar"
						type="text"
						onChange={onChange}
						value={avatarSelection.avatar}
						InputLabelProps={{
							style: { fontSize: 20 },
						}}
					/>
				)}
			</Modal>

			<Modal
				form
				open={Boolean(saving)}
				title="Create New Contact"
				onAccept={onSave}
				onClose={() => setSaving(false)}
			>
				{Boolean(saving) && (
					<Fragment>
						<TextField
							fullWidth
							className={classes.editField}
							label="Name"
							name="name"
							type="text"
							required
							value={state.name}
							onChange={onChange}
							InputLabelProps={{
								style: { fontSize: 20 },
							}}
						/>
						<InputMask
							mask="999-999-9999"
							value={state.number}
							onChange={onChange}
						>
							{() => (
								<TextField
									fullWidth
									className={classes.editField}
									label="Number"
									name="number"
									type="text"
									required
									InputLabelProps={{
										style: { fontSize: 20 },
									}}
								/>
							)}
						</InputMask>
						<FormGroup row>
							<FormControlLabel
								style={{ width: '100%' }}
								control={
									<Switch
										checked={state.favorite}
										onChange={onChecked}
										value="favorite"
										name="favorite"
										color="primary"
									/>
								}
								label="Favorite"
							/>
						</FormGroup>
					</Fragment>
				)}
			</Modal>
		</AppContainer>
	);
};

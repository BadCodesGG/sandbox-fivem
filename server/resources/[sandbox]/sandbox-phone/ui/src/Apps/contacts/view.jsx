import React, { Fragment, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
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
import _ from 'lodash';

import { useAlert, useAppData } from '../../hooks';
import { Modal, ColorPicker, AppContainer, Confirm } from '../../components';
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
			color: (app) =>
				Boolean(app?.contact?.color) ? app.contact.color : app.color,
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
				color: (app) =>
					Boolean(app?.contact?.color)
						? app.contact.color
						: app.color,
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

	const oContact = contacts.filter((c) => c.id == id)[0];
	const [contact, setContact] = useState(
		useSelector((state) => state.data.data.contacts).filter(
			(c) => c.id == id,
		)[0],
	);

	const classes = useStyles({
		...appData,
		contact: Boolean(contact) ? contact : {},
	});

	const [colorSelection, setColorSelection] = useState(false);
	const [avatarSelection, setAvatarSelection] = useState(false);
	const [editState, setEditState] = useState(null);
	const [deleteOpen, setDeleteOpen] = useState(false);

	if (!Boolean(contact)) return history(`/apps/contacts/caller/${id}`);

	const callContact = async () => {
		if (!Boolean(callData)) {
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

	const onSendUpdate = (newData) => {
		try {
			setContact({
				...newData,
			});

			Nui.send('UpdateContact', {
				...newData,
				id: contact.id,
			}).then((res) => {
				if (res) {
					dispatch({
						type: 'UPDATE_DATA',
						payload: {
							type: 'contacts',
							id: contact.id,
							data: { ...newData },
						},
					});
					showAlert('Contact Updated');
				} else {
					showAlert('Failed Updating Contact');
				}
			});
		} catch (err) {
			console.error(err);
			showAlert('Error Updating Contact');
		}
	};

	const onColorSubmit = () => {
		setContact({ ...contact, color: colorSelection.color });
		setColorSelection(false);
	};

	const onAvatarSubmit = (ov) => {
		setContact({
			...contact,
			avatar: avatarSelection.avatar,
		});
		setAvatarSelection(false);
	};

	const removeImage = () => {
		setContact({
			...contact,
			avatar: null,
		});
		setAvatarSelection(false);
	};

	const onStartEdit = () => {
		setEditState({
			name: contact.name,
			number: contact.number,
			favorite: contact.favorite,
		});
	};

	const onChange = (e) => {
		setEditState({
			...editState,
			[e.target.name]: e.target.value,
		});
	};

	const onChangeChecked = (e) => {
		setEditState({
			...editState,
			[e.target.name]: e.target.checked,
		});
	};

	const onSubmit = (e) => {
		e.preventDefault();

		setContact({
			...contact,
			...editState,
		});
		setEditState(null);
	};

	const onSave = () => {
		if (
			contacts.filter(
				(c) => c.number === contact.number && c.id != contact.id,
			).length > 1 &&
			contacts.filter(
				(c) => c.id === contact.id && c.number !== contact.number,
			).length > 0
		) {
			showAlert('Contact Already Exists For This Number');
		} else {
			onSendUpdate(contact);
		}
	};

	const onStartDelete = () => {
		setDeleteOpen(true);
	};

	const onDecline = () => {
		setDeleteOpen(false);
	};

	const onDelete = async () => {
		try {
			Nui.send('DeleteContact', contact.id).then((res) => {
				if (res) {
					dispatch({
						type: 'REMOVE_DATA',
						payload: { type: 'contacts', id: contact.id },
					});
					showAlert('Contact Deleted');
					history(-1);
				} else {
					showAlert('Failed Deleting Contact');
				}
			});
		} catch (err) {
			console.error(err);
			showAlert('Error Deleting Contact');
		}
		setDeleteOpen(false);
	};

	return (
		<AppContainer
			appId="contacts"
			colorOverride={Boolean(contact?.color) ? contact.color : false}
			actions={
				<Fragment>
					<Tooltip title="Delete Contact">
						<IconButton onClick={onStartDelete}>
							<FontAwesomeIcon icon={['fas', 'trash']} />
						</IconButton>
					</Tooltip>
					<Tooltip title="Edit Color">
						<IconButton
							onClick={() =>
								setColorSelection({ color: contact.color })
							}
						>
							<FontAwesomeIcon icon={['fas', 'palette']} />
						</IconButton>
					</Tooltip>
					<Tooltip title="Edit Details">
						<IconButton onClick={onStartEdit}>
							<FontAwesomeIcon icon={['fas', 'pen-to-square']} />
						</IconButton>
					</Tooltip>
					{!_.isEqual(contact, oContact) && (
						<Tooltip title="Save Edits">
							<IconButton onClick={onSave}>
								<FontAwesomeIcon
									icon={['fas', 'floppy-disk']}
								/>
							</IconButton>
						</Tooltip>
					)}
				</Fragment>
			}
		>
			<div className={classes.topContainer}>
				<div className={classes.avatarContainer}>
					{contact.avatar != null && contact.avatar !== '' ? (
						<Avatar
							className={`${classes.avatar}${
								contact.favorite ? ' favorite' : ''
							}`}
							src={contact.avatar}
							alt={contact.name.charAt(0)}
							onClick={() =>
								setAvatarSelection({
									...avatarSelection,
									avatar: contact.avatar,
								})
							}
						/>
					) : (
						<Avatar
							className={`${classes.avatar}${
								contact.favorite ? ' favorite' : ''
							}`}
							style={{
								background: contact.color,
							}}
							onClick={() =>
								setAvatarSelection({
									...avatarSelection,
									avatar: contact.avatar,
								})
							}
						>
							{contact.name.charAt(0)}
						</Avatar>
					)}
				</div>
				<div className={classes.infoContainer}>
					<div className="name">{contact.name}</div>
					<div className="number">{contact.number}</div>
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
				open={Boolean(avatarSelection)}
				title="Avatar"
				onAccept={onAvatarSubmit}
				onClose={() => setAvatarSelection(false)}
				onDelete={Boolean(avatarSelection) ? removeImage : null}
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
						onClick={() =>
							setAvatarSelection({
								...avatarSelection,
								avatar: e.target.value,
							})
						}
						value={avatarSelection.avatar}
						InputLabelProps={{
							style: { fontSize: 20 },
						}}
					/>
				)}
			</Modal>

			<Modal
				hideClose
				form
				open={Boolean(colorSelection)}
				title="Contact Color"
				onClose={() => setColorSelection(false)}
				onAccept={onColorSubmit}
				acceptLang="Save"
			>
				{Boolean(colorSelection) && (
					<ColorPicker
						color={colorSelection}
						onChange={(e) =>
							setColorSelection({
								...colorSelection,
								color: e.hex,
							})
						}
					/>
				)}
			</Modal>

			<Modal
				form
				open={Boolean(editState)}
				title="Avatar"
				onAccept={onSubmit}
				onClose={() => setEditState(null)}
				deleteLang="Edit Contact"
			>
				{Boolean(editState) && (
					<Fragment>
						<TextField
							fullWidth
							className={classes.editField}
							label="Name"
							name="name"
							type="text"
							required
							value={editState.name}
							onChange={onChange}
							InputLabelProps={{
								style: { fontSize: 20 },
							}}
						/>
						<InputMask
							mask="999-999-9999"
							value={editState.number}
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
										checked={editState.favorite}
										onChange={onChangeChecked}
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
			<Confirm
				title="Delete Contact"
				open={deleteOpen}
				confirm="Delete"
				decline="Cancel"
				onConfirm={onDelete}
				onDecline={onDecline}
			/>
		</AppContainer>
	);
};

import React, { Fragment, useMemo, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { Avatar, TextField, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import _, { throttle } from 'lodash';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { AppContainer } from '../../components';

const useStyles = makeStyles((theme) => ({
	form: {
		height: '100%',
	},
	avatar: {
		height: 140,
		width: 140,
		fontSize: 55,
		color: theme.palette.text.light,
		background: '#00aced',
		display: 'block',
		textAlign: 'center',
		lineHeight: '140px',
		margin: 'auto',

		'&.pending': {
			border: `3px solid ${theme.palette.warning.main}`,
		},
	},
	fields: {
		paddingTop: 30,
	},
	contactHeader: {
		padding: 20,
		width: '100%',
		textAlign: 'center',
		position: 'relative',
	},
	contactName: {
		fontSize: 30,
		color: theme.palette.primary.main,
	},
	editField: {
		width: '100%',
		marginBottom: 20,
		fontSize: 20,
	},
	header: {
		background: '#00aced',
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
}));

export default (props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useNavigate();
	const dispatch = useDispatch();
	const player = useSelector((state) => state.data.data.player);

	const [oProfile, setOProfile] = useState({
		name: player.Profiles?.twitter?.name ?? '',
		picture: player.Profiles?.twitter?.picture ?? '',
	});

	const [profile, setProfile] = useState({
		name: player.Profiles?.twitter?.name ?? '',
		picture: player.Profiles?.twitter?.picture ?? '',
	});

	const onChange = (e) => {
		setProfile({
			...profile,
			[e.target.name]: e.target.value,
		});
	};

	const onSubmit = (e) => {
		e.preventDefault();
		if (_.isEqual(oProfile, profile)) return;
		onSubmitIntrnl(e);
	};

	const onSubmitIntrnl = throttle(async (e) => {
		if (_.isEqual(oProfile, profile)) return;

		try {
			let res = await (
				await Nui.send('UpdateProfile', {
					app: 'twitter',
					name: profile.name,
					picture: profile.picture,
				})
			).json();
			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'player',
						id: 'Profiles',
						key: 'twitter',
						data: {
							sid: player.SID,
							app: 'twitter',
							name: e.target.name.value,
							picture: e.target.picture.value,
							meta: profile.meta,
						},
					},
				});

				setOProfile({
					name: profile?.name ?? '',
					picture: profile?.picture ?? '',
				});

				showAlert('Profile Updated');
			} else {
				showAlert('Unable To Update Profile');
			}
		} catch (err) {
			console.error(err);
			setProfile({
				...profile,
				...oProfile,
			});
			showAlert('Failed Updating Profile');
		}
	}, 5000);

	return (
		<form className={classes.form} id="profile-form" onSubmit={onSubmit}>
			<AppContainer
				appId="twitter"
				actions={
					<Fragment>
						<IconButton onClick={() => history(-1)}>
							<FontAwesomeIcon icon="chevron-left" />
						</IconButton>
						{!_.isEqual(oProfile, profile) && (
							<IconButton type="submit">
								<FontAwesomeIcon
									icon={['fas', 'floppy-disks']}
								/>
							</IconButton>
						)}
					</Fragment>
				}
			>
				<div className={classes.contactHeader}>
					{Boolean(profile.picture) ? (
						<Avatar
							className={`${classes.avatar}${
								!_.isEqual(oProfile, profile) ? ' pending' : ''
							}`}
							src={profile.picture}
							alt={profile.name.charAt(0)}
						/>
					) : (
						<Avatar
							className={`${classes.avatar}${
								!_.isEqual(oProfile, profile) ? ' pending' : ''
							}`}
						>
							<FontAwesomeIcon icon={['fas', 'user']} />
						</Avatar>
					)}
					<div className={classes.fields}>
						<TextField
							required
							className={classes.editField}
							label="Username"
							name="name"
							type="text"
							onChange={onChange}
							value={profile.name}
							inputProps={{
								pattern: '[a-zA-Z0-9_-]+',
								maxLength: 64,
							}}
						/>
						<TextField
							className={classes.editField}
							label="Avatar Link"
							name="picture"
							type="text"
							onChange={onChange}
							value={profile.picture}
							inputProps={{
								maxLength: 512,
							}}
						/>
					</div>
				</div>
			</AppContainer>
		</form>
	);
};

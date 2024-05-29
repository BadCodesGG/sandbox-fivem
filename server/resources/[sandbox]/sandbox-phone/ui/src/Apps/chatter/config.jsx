import React, { Fragment, useEffect, useState } from 'react';
import { makeStyles, withStyles } from '@mui/styles';
import { useDispatch, useSelector } from 'react-redux';
import { Avatar, IconButton, TextField } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate, useParams } from 'react-router';
import chroma from 'chroma-js';
import _, { throttle } from 'lodash';

import { AppContainer } from '../../components';
import { useAlert, useAppData } from '../../hooks';
import Nui from '../../util/Nui';

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
		border: (app) => `3px solid ${chroma(app.color).brighten(1)}`,
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

const CssTextField = withStyles((theme) => ({
	root: {
		'& label.Mui-focused': {
			color: ({ app }) => chroma(app.color).brighten(1),
		},
		'& .MuiInput-underline:after': {
			borderBottomColor: ({ app }) => chroma(app.color).brighten(1),
		},
		'& .MuiOutlinedInput-root': {
			'& fieldset': {
				borderColor: 'white',
			},
			'&:hover fieldset': {
				borderColor: 'white',
			},
			'&.Mui-focused fieldset': {
				borderColor: ({ app }) => chroma(app.color).brighten(1),
			},
		},
	},
}))(TextField);

export default () => {
	const appData = useAppData('chatter');
	const classes = useStyles(appData);
	const dispatch = useDispatch();
	const navigate = useNavigate();
	const showAlert = useAlert();
	const { channel } = useParams();

	const channelData = useSelector(
		(state) => state.chatter.groups.filter((g) => g.id == +channel)[0],
	);

	const [formData, setFormData] = useState({});
	const [origData, setOrigData] = useState({});

	useEffect(() => {
		setFormData({
			label: channelData.label,
			icon: channelData.icon,
		});
		setOrigData({
			label: channelData.label,
			icon: channelData.icon,
		});
	}, [channel, channelData]);

	const onChange = (e) => {
		setFormData({
			...formData,
			[e.target.name]: e.target.value,
		});
	};

	const onSubmit = async (e) => {
		e.preventDefault();
		if (_.isEqual(formData, origData)) return;
		onSubmitIntrnl();
	};

	const onSubmitIntrnl = throttle(async (e) => {
		try {
			let res = await (
				await Nui.send('Chatter:UpdateGroup', {
					channel: +channel,
					data: formData,
				})
			).json();
			if (Boolean(res)) {
				dispatch({
					type: 'CHATTER_UPDATE_GROUP',
					payload: {
						group: {
							...formData,
							id: +channel,
						},
					},
				});
				showAlert('Group Updated');
				navigate(`/apps/chatter/channel/${channel}`, { replace: true });
			} else {
				showAlert('Failed Updating Group');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Updating Group');
		}
	}, 5000);

	return (
		<form className={classes.form} id="profile-form" onSubmit={onSubmit}>
			<AppContainer
				appId="chatter"
				titleOverride={`${channelData.label} Settings`}
				actionShow={!_.isEqual(formData, origData)}
				actions={
					<Fragment>
						<IconButton type="submit">
							<FontAwesomeIcon icon={['fas', 'floppy-disks']} />
						</IconButton>
					</Fragment>
				}
			>
				<div className={classes.contactHeader}>
					{Boolean(formData.icon) ? (
						<Avatar
							className={classes.avatar}
							src={formData.icon}
							alt={
								Boolean(formData.label)
									? formData.label.charAt(0)
									: '?'
							}
						/>
					) : (
						<Avatar className={classes.avatar}>
							<FontAwesomeIcon icon={['fas', 'users']} />
						</Avatar>
					)}
					<div className={classes.fields}>
						<CssTextField
							required
							app={appData}
							className={classes.editField}
							label="Group Label"
							name="label"
							type="text"
							value={formData.label}
							onChange={onChange}
						/>
						<CssTextField
							app={appData}
							className={classes.editField}
							label="Icon Link"
							name="icon"
							type="text"
							value={formData.icon}
							onChange={onChange}
						/>
					</div>
				</div>
			</AppContainer>
		</form>
	);
};

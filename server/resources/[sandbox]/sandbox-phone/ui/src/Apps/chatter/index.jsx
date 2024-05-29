import React, { Fragment, useState } from 'react';
import { makeStyles } from '@mui/styles';
import { IconButton, TextField } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router';

import Channel from './components/Channel';
import { Modal } from '../../components';
import { useAlert, useAppData } from '../../hooks';
import Nui from '../../util/Nui';
import { AppContainer } from '../../components';

const useStyles = makeStyles((theme) => ({
	list: {
		borderTop: `1px solid ${theme.palette.border.divider}`,
	},
	inviteCount: {
		position: 'absolute',
		fontSize: 12,
		bottom: 0,
		right: 0,
		zIndex: 10,
		background: theme.palette.error.main,
		padding: '2px 6px',
		borderRadius: 20,
	},
}));

export default () => {
	const appData = useAppData('chatter');
	const classes = useStyles(appData);
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const navigate = useNavigate();

	const mySid = useSelector((state) => state.data.data.player.SID);
	const invites = useSelector((state) => state.chatter.invites);
	const groups = useSelector((state) => state.chatter.groups);

	const [creating, setCreating] = useState(false);

	const onCreate = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('Chatter:CreateGroup', {
					label: e.target.label.value,
				})
			).json();

			if (Boolean(res)) {
				dispatch({
					type: 'CHATTER_ADD_GROUP',
					payload: {
						group: {
							id: res.id,
							label: e.target.label.value,
							create_date: res.create_date,
							owner: mySid,
							join_date: res.create_date,
							last_message: null,
							icon: null,
						},
					},
				});
				showAlert('Group Created');
			} else {
				showAlert('Unable To Create Group');
			}
		} catch (err) {
			console.error(err);
			showAlert('Failed Creating Group');
		}

		setCreating(false);
	};

	return (
		<AppContainer
			appId="chatter"
			actions={
				<Fragment>
					<IconButton
						onClick={() => navigate('/apps/chatter/invites')}
					>
						{Boolean(invites) &&
							Object.keys(invites).length > 0 && (
								<span className={classes.inviteCount}>
									{Object.keys(invites).length}
								</span>
							)}
						<FontAwesomeIcon icon={['far', 'envelope']} />
					</IconButton>
					<IconButton onClick={() => setCreating(true)}>
						<FontAwesomeIcon icon={['far', 'plus']} />
					</IconButton>
				</Fragment>
			}
		>
			<div className={classes.list}>
				{groups
					.sort((a, b) => b.last_message - a.last_message)
					.map((group) => {
						return (
							<Channel
								key={`channel-${group.id}`}
								channel={group}
							/>
						);
					})}
			</div>

			<Modal
				form
				open={creating}
				title="Create New Group"
				submitLang="Create"
				onAccept={onCreate}
				onClose={() => setCreating(false)}
			>
				<TextField
					required
					fullWidth
					className={classes.editField}
					label="Group Name"
					name="label"
					type="text"
					inputProps={{
						maxLength: 64,
					}}
				/>
			</Modal>
		</AppContainer>
	);
};

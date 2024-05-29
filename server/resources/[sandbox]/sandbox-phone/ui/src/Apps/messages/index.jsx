import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { Fab, IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { AppContainer, Loader, Modal } from '../../components';
import Message from './message';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Thread from './components/Thread';
import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
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
	add: {
		position: 'absolute',
		bottom: '12%',
		right: '10%',
		'&:hover': {
			filter: 'brightness(0.75)',
			transition: 'filter ease-in 0.15s',
		},
	},
	or: {
		fontSize: 40,
		color: theme.palette.primary.main,
		textAlign: 'center',
		fontWeight: 'bold',
	},
	contactList: {
		zIndex: '10001 !important',
		maxHeight: 400,
		'& div::-webkit-scrollbar': {
			width: 6,
		},
		'& div::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'& div::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'& div::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	contactListTrigger: {
		width: '100%',
		height: 60,
		background: 'red',
		textAlign: 'center',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useNavigate();
	const showAlert = useAlert();
	const loaded = useSelector((state) => state.messages.loaded);
	const messageThreads = useSelector((state) => state.messages.threads);

	useEffect(() => {
		const a = async () => {
			try {
				let res = await (await Nui.send('Messages:InitLoad')).json();
				if (Boolean(res)) {
					dispatch({
						type: 'MESSAGES_LOADED',
					});
				} else {
					showAlert('Failed Loading Message Threads');
				}
			} catch (err) {
				console.error(err);
				showAlert('Error Loading Message Threads');
			}
		};

		if (!loaded) {
			a();
		}
	}, []);

	return (
		<AppContainer
			appId="messages"
			actions={
				<Fragment>
					<Tooltip title="Send New Text">
						<span>
							<IconButton
								onClick={() => history('/apps/messages/new')}
							>
								<FontAwesomeIcon icon={['fas', 'plus']} />
							</IconButton>
						</span>
					</Tooltip>
				</Fragment>
			}
		>
			{!Boolean(loaded) || !Boolean(messageThreads) ? (
				<Loader static text="Loading Messages" />
			) : messageThreads.length > 0 ? (
				messageThreads
					.sort((a, b) => b.time - a.time)
					.map((thread) => {
						return <Thread key={thread.id} thread={thread} />;
					})
			) : (
				<div className={classes.emptyMsg}>You Have No Messages</div>
			)}
		</AppContainer>
	);
};

import React, { Fragment, useEffect, useMemo, useRef, useState } from 'react';
import { throttle } from 'lodash';
import { makeStyles, withStyles } from '@mui/styles';
import { useDispatch, useSelector } from 'react-redux';
import { Avatar, IconButton, Menu, MenuItem, TextField } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate, useParams } from 'react-router';
import InfiniteScroll from 'react-infinite-scroll-component';

import {
	AppContainer,
	Confirm,
	EventListener,
	Loader,
	Modal,
} from '../../components';
import { useAlert, useAppData } from '../../hooks';
import Nui from '../../util/Nui';
import chroma from 'chroma-js';
import Message from './components/Message';
import { NumericFormat } from 'react-number-format';

const useStyles = makeStyles((theme) => ({
	messages: {
		flexGrow: 1,
		overflow: 'auto',
		padding: 10,
		display: 'flex',
		flexDirection: 'column-reverse',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: (app) => chroma(app.color).brighten(1),
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	inputContainer: {
		display: 'flex',
		padding: 15,
		height: '12%',
	},
	input: {
		flexGrow: 1,

		'& .MuiInputBase-root': {
			borderRadius: 30,
		},
	},
	sendBtn: {
		height: 56,
		width: 56,
		marginLeft: 15,
		transition: 'color ease-in 0.15s',

		'&:hover': {
			color: (app) => chroma(app.color).brighten(1),
		},
	},
	noMsgs: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	title: {
		display: 'flex',
		position: 'relative',

		'& span': {
			marginLeft: 40,
		},
	},
	headerIcon: {
		width: 35,
		height: 35,
		position: 'absolute',
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	inner: {
		height: '100%',
		display: 'flex',
		flexDirection: 'column',
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

const testMsgs = [
	{
		id: 1,
		groupId: 1,
		message: 'This is a message, lol',
		character: 1,
		timestamp: 1687730059,
	},
	{
		id: 2,
		groupId: 1,
		message: 'This is a message, lol',
		character: 2,
		timestamp: 1687730063,
	},
	{
		id: 3,
		groupId: 1,
		message: 'This is a message, lol',
		character: 2,
		timestamp: 1687730063,
	},
	{
		id: 4,
		groupId: 1,
		message: 'This is a message, lol',
		character: 2,
		timestamp: 1687730063,
	},
	{
		id: 5,
		groupId: 1,
		message: 'This is a message, lol',
		character: 2,
		timestamp: 1687730063,
	},
];

export default () => {
	const appData = useAppData('chatter');
	const classes = useStyles(appData);
	const dispatch = useDispatch();
	const navigate = useNavigate();
	const showAlert = useAlert();
	const { channel } = useParams();
	const mySid = useSelector((state) => state.data.data.player.SID);
	const channelData = useSelector(
		(state) => state.chatter.groups.filter((g) => g.id == +channel)[0],
	);
	const formRef = useRef(null);

	const [loading, setLoading] = useState(false);
	const [inviting, setInviting] = useState(false);
	const [leaving, setLeaving] = useState(false);
	const [deleting, setDeleting] = useState(false);
	const [ownerMenu, setOwnerMenu] = useState(false);

	const [messageCount, setMessageCount] = useState(0);
	const [messages, setMessages] = useState([]);

	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
	});

	const fetchCount = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (
						await Nui.send('Chatter:GetMessageCount', +channel)
					).json();

					if (Boolean(res)) setMessageCount(res);
				} catch (err) {
					console.error(err);
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetchCount();
	}, [channel]);

	const onLoadMessages = async () => {
		if (loading) return;
		try {
			let res = await (
				await Nui.send('Chatter:LoadMessages', {
					channel: +channel,
					offset: messages?.length ?? 0,
				})
			).json();
			if (res) {
				setMessages([...messages, ...res]);
			} else {
				throw res;
			}
		} catch (err) {
			console.error(err);
		}
		setLoading(false);
	};

	useEffect(() => {
		if (Boolean(channel) && messageCount > 0 && messages.length == 0)
			onLoadMessages();
	}, [channel, messageCount]);

	const onSend = (e) => {
		e.preventDefault();
		sendText(e.target.text.value);
	};

	const sendText = useMemo(
		() =>
			throttle(async (message) => {
				if (message != '') {
					try {
						let res = await (
							await Nui.send('Chatter:SendMessage', {
								channel: +channel,
								message,
							})
						).json();

						if (Boolean(res)) {
							setMessages([
								...messages,
								{
									id: res,
									message,
									author: mySid,
									timestamp: Date.now() / 1000,
								},
							]);
						}
					} catch (err) {
						console.error(err);
					}
					formRef.current.reset();
				} else {
					showAlert('Message Must Have Content');
				}
			}, 3000),
		[messages],
	);

	const onInvite = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('Chatter:Invite:Send', {
					channel: +channel,
					sid: e.target.sid.value,
				})
			).json();

			if (Boolean(res)) {
				showAlert('Group Invite Sent');
			} else {
				showAlert('Failed Sending Group Invite');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Sending Group Invite');
		}

		setInviting(false);
	};

	const onLeave = async () => {
		try {
			let res = await (
				await Nui.send('Chatter:LeaveGroup', +channel)
			).json();

			if (Boolean(res)) {
				dispatch({
					type: 'CHATTER_REMOVE_GROUP',
					payload: {
						group: res,
					},
				});
				navigate(`/apps/chatter`, { replace: true });
			}
		} catch (err) {}
	};

	const onMenuClick = (e) => {
		e.preventDefault();
		setOffset({ left: e.clientX - 2, top: e.clientY - 4 });
		setOwnerMenu(true);
	};

	const onConfig = () => {
		try {
			navigate(`/apps/chatter/config/${channel}`);
		} catch (err) {
			console.error(err);
		}

		setOwnerMenu(false);
	};

	const startDeleting = () => {
		setOwnerMenu(false);
		setDeleting(true);
	};

	const onDelete = async () => {
		setDeleting(false);
		try {
			let res = await (
				await Nui.send('Chatter:DeleteGroup', +channel)
			).json();

			if (Boolean(res)) {
				dispatch({
					type: 'CHATTER_REMOVE_GROUP',
					payload: {
						group: res,
					},
				});
				showAlert('Group Deleted');
				navigate(`/apps/chatter`, { replace: true });
			}
		} catch (err) {
			console.error(err);
			showAlert('Failed Deleting Group');
		}

		setOwnerMenu(false);
	};

	const onDeleted = (data) => {
		dispatch({
			type: 'CHATTER_REMOVE_GROUP',
			payload: data,
		});
		showAlert('Group Was Deleted By The Group Owner');
		navigate('/apps/chatter', { replace: true });
	};

	const onReceivedMessage = (msg) => {
		if (msg.group != +channel) return;
		setMessages([...messages, { ...msg, timestamp: msg.timestamp }]);
	};

	return (
		<EventListener
			event="CHATTER_CHANNEL_DELETED"
			onEvent={onDeleted}
			state={{ messages, messageCount, channel }}
		>
			<EventListener
				event="CHATTER_RECEIVED_MESSAGE"
				onEvent={onReceivedMessage}
				state={{ messages, messageCount, channel }}
			>
				<AppContainer
					appId="chatter"
					titleOverride={
						Boolean(channelData) ? (
							<div className={classes.title}>
								<Avatar
									className={classes.headerIcon}
									src={channelData.icon}
									alt={channelData.label}
								/>
								<span>{channelData.label}</span>
							</div>
						) : (
							false
						)
					}
					actions={
						<Fragment>
							<IconButton onClick={() => setInviting(true)}>
								<FontAwesomeIcon icon="plus" />
							</IconButton>
							{mySid == channelData?.owner ? (
								<IconButton onClick={onMenuClick}>
									<FontAwesomeIcon icon="ellipsis-vertical" />
								</IconButton>
							) : (
								<IconButton onClick={() => setLeaving(true)}>
									<FontAwesomeIcon icon="arrow-right-from-bracket" />
								</IconButton>
							)}
						</Fragment>
					}
				>
					<Menu
						anchorReference="anchorPosition"
						anchorPosition={offset}
						keepMounted
						open={ownerMenu}
						onClose={() => setOwnerMenu(false)}
					>
						<MenuItem onClick={onConfig}>Group Settings</MenuItem>
						<MenuItem onClick={startDeleting}>
							Delete Group
						</MenuItem>
					</Menu>
					<div className={classes.inner}>
						<div className={classes.messages} id="scrollableDiv">
							<InfiniteScroll
								dataLength={messages.length}
								next={onLoadMessages}
								style={{
									display: 'flex',
									flexDirection: 'column-reverse',
								}} //To put endMessage and loader to the top.
								inverse={true} //
								hasMore={
									(messages?.length ?? 0) <
									(messageCount ?? 0)
								}
								loader={<h4>Loading...</h4>}
								scrollableTarget="scrollableDiv"
							>
								{Boolean(messages) && messages?.length > 0 ? (
									messages
										.sort(
											(a, b) => b.timestamp - a.timestamp,
										)
										.map((msg) => {
											return (
												<Message
													key={msg.id}
													message={msg}
													isMe={msg.author == mySid}
												/>
											);
										})
								) : (
									<div className={classes.noMsgs}>
										No Message Have Been Sent
									</div>
								)}
							</InfiniteScroll>
						</div>
						<form
							className={classes.inputContainer}
							onSubmit={onSend}
							ref={formRef}
						>
							<CssTextField
								app={appData}
								label="Send Message"
								color="secondary"
								name="text"
								className={classes.input}
							/>
							<IconButton
								type="submit"
								className={classes.sendBtn}
							>
								<FontAwesomeIcon icon="send" />
							</IconButton>
						</form>
					</div>

					<Confirm
						title="Leave Chatter Group?"
						open={leaving}
						confirm="Yes"
						decline="No"
						onConfirm={onLeave}
						onDecline={() => setLeaving(false)}
					/>
					<Confirm
						title="Delete Chatter Group?"
						open={deleting}
						confirm="Yes"
						decline="No"
						onConfirm={onDelete}
						onDecline={() => setDeleting(false)}
					/>
					<Modal
						form
						open={inviting}
						title="Send Group Invite"
						submitLang="Invite"
						onAccept={onInvite}
						onClose={() => setInviting(false)}
					>
						<NumericFormat
							required
							fullWidth
							app={appData}
							allowNegative={false}
							className={classes.editField}
							label="Target State ID"
							name="sid"
							type="tel"
							customInput={CssTextField}
						/>
					</Modal>
				</AppContainer>
			</EventListener>
		</EventListener>
	);
};

import React, { useState, useEffect, Fragment, useRef, useMemo } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { useNavigate, useParams } from 'react-router-dom';
import {
	Menu,
	MenuItem,
	TextField,
	Avatar,
	Paper,
	IconButton,
} from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
const processString = require('react-process-string');
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import { Link } from 'react-router-dom';
import { throttle } from 'lodash';
import InfiniteScroll from 'react-infinite-scroll-component';

import { SendMessage, DeleteConvo, ReadConvo } from './actions';
import { useAlert, useAppData } from '../../hooks';
import Nui from '../../util/Nui';
import { AppContainer, EventListener } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	header: {
		background: (app) =>
			Boolean(app.isContact) ? app.isContact.color : app.color,
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
	},
	avatar: {
		color: '#fff',
		height: 45,
		width: 45,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	avatarFav: {
		color: '#fff',
		height: 45,
		width: 45,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		border: '2px solid gold',
	},
	messageAction: {
		textAlign: 'center',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	body: {
		padding: 10,
		flexGrow: 1,
		overflow: 'auto',
		display: 'flex',
		flexDirection: 'column-reverse',
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
	inputContainer: {
		display: 'flex',
		padding: 15,
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
			color: (app) =>
				Boolean(app.contact) ? app.contact.color : app.color,
		},
	},
	submitBtnDisabled: {
		height: '100%',
		fontSize: 30,
		textAlign: 'center',
		borderBottom: '1px solid rgba(255, 255, 255, 0.7)',
		filter: 'brightness(0.25)',
	},
	submitIcon: {
		display: 'block',
		margin: 'auto',
		height: '100%',
		width: '40%',
	},
	textWrap: {
		width: '100%',
		fontSize: 16,
		margin: '20px 0px',
		padding: '0 10px',
		color: theme.palette.text.light,
		'&:first-of-type': {
			marginTop: 0,
		},
	},
	myText: {
		marginLeft: 'auto',
		width: 'fit-content',
		maxWidth: '75%',
		padding: 15,
		borderRadius: 15,
		background: theme.palette.secondary.dark,
		overflowWrap: 'break-word',
		hyphens: 'auto',
	},
	otherText: {
		marginRight: 'auto',
		width: 'fit-content',
		maxWidth: '75%',
		padding: 15,
		borderRadius: 15,
		background: (app) =>
			Boolean(app.contact) ? app.contact.color : app.color,
		overflowWrap: 'break-word',
		hyphens: 'auto',
	},
	timestamp: {
		color: theme.palette.text.main,
		fontSize: 12,
		padding: '5px 5px 0px 5px',
	},
	messageImg: {
		display: 'block',
		maxWidth: 200,
	},
	copyableText: {
		color: theme.palette.primary.main,
		textDecoration: 'underline',
		'&:hover': {
			transition: 'color ease-in 0.15s',
			color: theme.palette.text.main,
			cursor: 'pointer',
		},
	},
	avatarContainer: {
		width: 60,
		position: 'relative',
		marginRight: 8,
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
			color: ({ app, contact }) =>
				Boolean(contact) ? contact.color : app.color,
		},
		'& .MuiInput-underline:after': {
			borderBottomColor: ({ app, contact }) =>
				Boolean(contact) ? contact.color : app.color,
		},
		'& .MuiOutlinedInput-root': {
			'& fieldset': {
				borderColor: 'white',
			},
			'&:hover fieldset': {
				borderColor: 'white',
			},
			'&.Mui-focused fieldset': {
				borderColor: ({ app, contact }) =>
					Boolean(contact) ? contact.color : app.color,
			},
		},
	},
}))(TextField);

export default connect(null, {
	SendMessage,
	DeleteConvo,
	ReadConvo,
})((props) => {
	const appData = useAppData('messages');
	const showAlert = useAlert();
	const history = useNavigate();
	const params = useParams();
	const dispatch = useDispatch();
	const { number } = params;
	const thread = useSelector((state) => state.messages.threads)?.filter(
		(c) => c.number == number,
	)[0];
	const isContact = useSelector((state) => state.data.data.contacts)?.filter(
		(c) => c.number === number,
	)[0];
	const classes = useStyles({ ...appData, contact: isContact });
	const allMsgs = useSelector((state) => state.data.data.messages);
	const player = useSelector((state) => state.data.data.player);
	const callData = useSelector((state) => state.call.call);

	const formRef = useRef();

	const [messages, setMessages] = useState([]);

	const clearUnread = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					Nui.send('ReadConvo', number);
					dispatch({
						type: 'MESSAGES_CLEAR_UNREAD',
						payload: {
							number,
						},
					});
				} catch (err) {
					console.error(err);
				}
				setLoading(false);
			}, 2000),
		[],
	);

	useEffect(() => {
		clearUnread();
	}, [number]);

	const [loading, setLoading] = useState(false);
	const [open, setOpen] = useState(false);
	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
	});

	const onClick = (e) => {
		e.preventDefault();
		setOffset({ left: e.clientX - 2, top: e.clientY - 4 });
		setOpen(true);
	};

	const onClose = () => {
		setOpen(false);
	};

	const callNumber = async () => {
		if (callData == null) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number,
						isAnon: false,
					})
				).json();
				if (res) {
					history(`/apps/phone/call/${number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.error(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const deleteConvo = async () => {
		try {
			let res = await (await Nui.send('DeleteConvo', number)).json();

			if (Boolean(res)) {
				dispatch({
					type: 'REMOVE_THREAD',
					payload: {
						number,
					},
				});
				showAlert('Conversation Deleted');
				history('/apps/messages', { replace: true });
			} else {
				showAlert('Failed Deleting Conversation');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Deleting Conversation');
		}

		onClose();
	};

	const editNumber = () => {
		if (isContact != null) {
			history(`/apps/contacts/view/${isContact.id}`);
		} else {
			history(`/apps/contacts/caller/${number}`);
		}
	};

	const sendText = useMemo(
		() =>
			throttle(async (msgs, message, createThread) => {
				try {
					let res = await (
						await Nui.send('SendMessage', message)
					).json();
					if (Boolean(res)) {
						setMessages([
							...messages,
							{ ...message, time: message.time },
						]);

						if (createThread) {
							dispatch({
								type: 'ADD_THREAD',
								payload: {
									thread: {
										id: res,
										owner: player.Phone,
										number,
										type: 1,
										time: message.time,
										message: message.message,
										unread: 0,
										count: 1,
									},
								},
							});
						} else {
							dispatch({
								type: 'UPDATE_THREAD',
								payload: {
									thread: {
										...thread,
										type: 1,
										time: message.time,
										message: message.message,
									},
								},
							});
						}

						return true;
					} else {
						return false;
					}
				} catch (err) {
					console.error(err);
					return false;
				}
			}, 1000),
		[messages],
	);

	const onSubmit = (e) => {
		e.preventDefault();
		onSubmitIntrnl(e);
	};

	const onSubmitIntrnl = throttle((e) => {
		if (e.target.text.value !== '') {
			sendText(
				messages,
				{
					owner: player.Phone,
					number: number,
					method: 1,
					time: Date.now() / 1000,
					message: e.target.text.value,
				},
				!Boolean(thread),
			);
			formRef.current.reset();
		}
	}, 3000);

	const config = [
		{
			regex: /^https?:\/\/(\w+\.)?imgur.com\/(\w*\d\w*)+(\.[a-zA-Z]{3})?$/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => showAlert('Link Copied To Clipboard')}
				>
					<img
						key={key}
						className={classes.messageImg}
						src={result[0]}
					/>
				</CopyToClipboard>
			),
		},
		{
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)(mp4)/gim,
			fn: (key, result) => (
				<div>
					<ReactPlayer
						key={key}
						volume={0.25}
						width="100%"
						controls={true}
						url={`${result[0]}`}
					/>
				</div>
			),
		},
		{
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => showAlert('Link Copied To Clipboard')}
				>
					<a className={classes.copyableText}>{result.input}</a>
				</CopyToClipboard>
			),
		},
		{
			regex: /(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => showAlert('Link Copied To Clipboard')}
				>
					<a className={classes.copyableText}>{result.input}</a>
				</CopyToClipboard>
			),
		},
		{
			regex: /ircinvite=(\d)+/gim,
			fn: (key, result) => {
				return (
					<Link
						key={key}
						className={classes.copyableText}
						to={`/apps/irc/join/${result[0].split('=')[1]}`}
					>
						IRC Invite: {result[0].split('=')[1]}
					</Link>
				);
			},
		},
	];

	const onLoadMessages = async () => {
		if (loading) return;
		try {
			let res = await (
				await Nui.send('Messages:LoadTexts', {
					number,
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

	const fuckme = (m) => {
		setMessages([...messages, { ...m, time: m.time }]);
		clearUnread();
	};

	useEffect(() => {
		onLoadMessages();
	}, [number]);

	return (
		<EventListener
			event="RECEIVED_NEW_MESSAGE"
			onEvent={fuckme}
			state={messages}
		>
			<AppContainer
				appId="messages"
				colorOverride={Boolean(isContact) ? isContact.color : false}
				titleOverride={
					Boolean(isContact) ? (
						<div style={{ display: 'flex' }}>
							<div className={classes.avatarContainer}>
								{isContact.avatar != null &&
								isContact.avatar !== '' ? (
									<Avatar
										className={
											isContact.favorite
												? classes.avatarFav
												: classes.avatar
										}
										src={isContact.avatar}
										alt={isContact.name.charAt(0)}
									/>
								) : (
									<Avatar
										className={
											isContact.favorite
												? classes.avatarFav
												: classes.avatar
										}
										style={{ background: isContact.color }}
									>
										{isContact.name.charAt(0)}
									</Avatar>
								)}
							</div>
							{isContact.name}
						</div>
					) : (
						number
					)
				}
				actions={
					<Fragment>
						<IconButton onClick={callNumber}>
							<FontAwesomeIcon icon="phone" />
						</IconButton>
						<IconButton onClick={onClick}>
							<FontAwesomeIcon icon="ellipsis-vertical" />
						</IconButton>
					</Fragment>
				}
			>
				<Menu
					anchorReference="anchorPosition"
					anchorPosition={offset}
					keepMounted
					open={open}
					onClose={onClose}
				>
					<MenuItem onClick={editNumber}>
						{isContact != null ? 'View Contact' : 'Create Contact'}
					</MenuItem>
					<MenuItem onClick={deleteConvo}>
						Delete Conversation
					</MenuItem>
				</Menu>
				<div className={classes.inner}>
					<div className={classes.body} id="scrollableDiv">
						<InfiniteScroll
							dataLength={messages.length}
							next={onLoadMessages}
							style={{
								display: 'flex',
								flexDirection: 'column-reverse',
							}} //To put endMessage and loader to the top.
							inverse={true} //
							hasMore={
								(messages?.length ?? 0) < (thread?.count ?? 0)
							}
							loader={<h4>Loading...</h4>}
							scrollableTarget="scrollableDiv"
						>
							{messages
								.sort((a, b) => b.time - a.time)
								.map((message, key) => (
									<div key={key} className={classes.textWrap}>
										<Paper
											className={
												message?.method === 1
													? classes.myText
													: classes.otherText
											}
										>
											{processString(config)(
												message.message,
											)}
										</Paper>
										<div
											className={classes.timestamp}
											style={{
												textAlign:
													message?.method === 1
														? 'right'
														: 'left',
											}}
										>
											<Moment
												unix
												fromNow
												titleFormat="L LT"
												withTitle
												date={message.time}
											/>
										</div>
									</div>
								))}
						</InfiniteScroll>
					</div>
					<form
						className={classes.inputContainer}
						ref={formRef}
						onSubmit={onSubmit}
					>
						<CssTextField
							app={appData}
							contact={isContact}
							label="Send Message"
							name="text"
							color="primary"
							className={classes.input}
							inputProps={{
								maxLength: 256,
							}}
						/>
						<IconButton type="submit" className={classes.sendBtn}>
							<FontAwesomeIcon icon="send" />
						</IconButton>
					</form>
				</div>
			</AppContainer>
		</EventListener>
	);
});

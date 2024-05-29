import React from 'react';
import { Paper } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import { Link } from 'react-router-dom';
import chroma from 'chroma-js';
const processString = require('react-process-string');

import { useAlert, useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	textWrap: {
		width: '100%',
		fontSize: 16,
		margin: '20px 0px',
		padding: '0 10px',
		color: theme.palette.text.light,
		position: 'relative',
		'&:first-of-type': {
			marginTop: 0,
		},
	},
	myMsg: {
		marginLeft: 'auto',
		width: 'fit-content',
		maxWidth: '75%',
		padding: 15,
		borderRadius: 15,
		background: (app) => chroma(app.color).darken(),
		overflowWrap: 'break-word',
		hyphens: 'auto',
	},
	otherMsg: {
		marginRight: 'auto',
		width: 'fit-content',
		maxWidth: '75%',
		padding: 15,
		borderRadius: 15,
		background: (app) => app.color,
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
}));

export default ({ message, isMe = false }) => {
	const appData = useAppData('chatter');
	const classes = useStyles(appData);
	const showAlert = useAlert();

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

	return (
		<div className={classes.textWrap}>
			<Paper className={isMe ? classes.myMsg : classes.otherMsg}>
				{processString(config)(message.message)}
			</Paper>
			<div
				className={classes.timestamp}
				style={{
					textAlign: isMe ? 'right' : 'left',
				}}
			>
				<Moment
					unix
					date={message.timestamp}
					titleFormat="L LT"
					withTitle
					fromNow
				/>
			</div>
		</div>
	);
};

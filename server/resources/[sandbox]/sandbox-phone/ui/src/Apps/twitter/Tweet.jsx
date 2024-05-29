import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Avatar, IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import processString from 'react-process-string';
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';

import Nui from '../../util/Nui';
import { SanitizeStrict } from '../../util/Parser';
import { LightboxImage } from '../../components';
import { useAppData } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	tweet: {
		borderRadius: 8,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		marginBottom: 8,
		border: `1px solid ${theme.palette.border.divider}`,
	},
	header: {
		display: 'flex',
		padding: 10,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	username: {
		flexGrow: 1,
		lineHeight: '35px',
	},
	verification: {
		marginLeft: 5,
		color: '#00aced',

		'&.business': {
			color: '#eac93e',
		},

		'&.government': {
			color: '#829aab',
		},
	},
	avatar: {
		width: 35,
		height: 35,
		margin: 'auto',
		marginRight: 8,
	},
	timestamp: {
		fontSize: 10,
		lineHeight: '35px',
	},
	content: {
		marginTop: 10,
		fontSize: 14,
		color: theme.palette.text.alt,
		padding: 10,
	},
	messageImg: {
		display: 'block',
		maxWidth: 200,
	},
	copyableText: {
		color: '#1de9b6',
		textDecoration: 'underline',
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	hashtag: {
		color: theme.palette.primary.light,
	},
	image: {
		maxWidth: 400,
		maxHeight: 400,
		height: '100%',
		width: '100%',
		border: `1px solid ${theme.palette.border.divider}`,
		borderRadius: 4,
	},
	rtLink: {
		color: theme.palette.primary.light,
	},
	btnCount: {
		marginRight: 5,
		color: theme.palette.text.alt,
	},
	actionBtn: {
		fontSize: 13,
	},
	actions: {
		marginTop: 10,
		padding: '3px 0',
		borderTop: `1px solid ${theme.palette.border.divider}`,
	},
}));

export default ({ tweet, rtcount, onReply, onRetweet }) => {
	const appData = useAppData('twitter');
	const classes = useStyles(appData);
	const dispatch = useDispatch();
	const player = useSelector((state) => state.data.data.player);

	const config = [
		{
			regex: /((https?:\/\/(www\.)?(i\.)?imgur\.com\/[a-zA-Z\d]+)(\.png|\.jpg|\.jpeg|\.gif)?)/gim,
			fn: (key, result) => (
				<LightboxImage
					key={key}
					className={classes.messageImg}
					src={result[0]}
				/>
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
			regex: /#(\w)+/g,
			fn: (key, result) => {
				return (
					<span key={key} className={classes.hashtag}>
						{result[0]}
					</span>
				);
			},
		},
		{
			regex: /@(\w)+/g,
			fn: (key, result) => {
				return (
					<span key={key} className={classes.hashtag}>
						{result[0]}
					</span>
				);
			},
		},
	];

	return (
		<div className={classes.tweet}>
			<div className={classes.header}>
				<Avatar className={classes.avatar} src={tweet.author.picture} />
				<div className={classes.username}>
					<span className={classes.author}>{tweet.author.name}</span>
					{tweet.verified && (
						<Tooltip
							title={
								tweet.verified == 'business'
									? 'Verified Business Account'
									: 'Verified Government Account'
							}
						>
							<span
								className={`${classes.verification} ${tweet.verified}`}
							>
								<FontAwesomeIcon
									icon={['fas', 'badge-check']}
								/>
							</span>
						</Tooltip>
					)}
				</div>
				<div className={classes.timestamp}>
					<Moment unix date={tweet.time} interval={60000} fromNow />
				</div>
			</div>
			<div className={classes.content}>
				{processString(config)(tweet.content)}
			</div>
			{Boolean(tweet.image.using) && (
				<LightboxImage
					src={tweet.image.link}
					className={classes.image}
				/>
			)}
			<div className={classes.actions}>
				<Grid container style={{ textAlign: 'center' }}>
					<Grid item xs={6}>
						<IconButton
							className={classes.actionBtn}
							onClick={() => onReply(tweet.author.name)}
							disabled={!Boolean(player.Profiles?.twitter?.name)}
						>
							<FontAwesomeIcon icon={['fas', 'reply']} />
						</IconButton>
					</Grid>
					<Grid item xs={6}>
						<IconButton
							className={classes.actionBtn}
							onClick={() => onRetweet(tweet)}
							disabled={
								!Boolean(player?.Profiles?.twitter) ||
								tweet.retweet ||
								tweet.cid == player.ID
							}
						>
							<span className={classes.btnCount}>{rtcount}</span>
							<FontAwesomeIcon icon="arrows-rotate" />
						</IconButton>
					</Grid>
				</Grid>
			</div>
		</div>
	);
};

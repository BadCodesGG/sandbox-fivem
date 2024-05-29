import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate, useParams } from 'react-router-dom';
import { Avatar, Grid, IconButton, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import { acceptCall, endCall } from './action';

const useStyles = makeStyles((theme) => ({
	call: {
		display: 'flex',
		flexDirection: 'column',
		padding: 16,
		height: '100%',
		background: theme.palette.secondary.main,
	},
	callInfo: {
		width: '100%',
		marginTop: 32,
	},
	caller: {
		width: '100%',

		'& .inner': {
			width: '100%',
			textAlign: 'center',

			'& .details': {
				marginTop: 16,
				marginBottom: 16,
				'& span': {
					display: 'block',
					fontSize: 26,
					fontWeight: 'bold',
				},
				'& small': {
					marginTop: 4,
					display: 'block',
					fontSize: 18,
					color: theme.palette.text.alt,
				},
			},
		},
	},
	avatar: {
		height: 100,
		width: 100,
		border: '2px solid transparent',
		margin: 'auto',
		fontSize: 55,

		'&.favorite': {
			borderColor: 'gold',
		},
	},
	duration: {
		textAlign: 'center',
		fontSize: 22,
		fontWeight: 'bold',
		color: theme.palette.success.main,
	},
	keypadBtn: {
		textAlign: 'center',
		height: 75,
		fontSize: '24px',
		width: '100%',

		'&.end': {
			color: theme.palette.error.light,
			'&:hover': {
				backgroundColor: `${theme.palette.error.dark}80`,
			},
		},

		'&.accept': {
			color: theme.palette.success.light,
			'&:hover': {
				backgroundColor: `${theme.palette.success.dark}80`,
			},
		},
	},
	spacer: {
		flexGrow: 1,
	},
	actions: {
		display: 'flex',
	},
}));

export default connect(null, { acceptCall, endCall })((props) => {
	const classes = useStyles();
	const history = useNavigate();
	const params = useParams();
	const { number } = params;

	const limited = useSelector((state) => state.phone.limited);
	const callLimited = useSelector((state) => state.call.callLimited);
	const contacts = useSelector((state) => state.data.data.contacts);
	const callData = useSelector((state) => state.call.call);

	const isContact = contacts.filter((c) => c.number === number)[0];

	const [isEnding, setIsEnding] = useState(false);

	useEffect(() => {
		setIsEnding(null);
	}, []);

	useEffect(() => {
		let fml = null;
		if (callData == null) {
			setIsEnding(true);
			fml = setTimeout(() => {
				history(-1);
			}, 2500);
		}

		return () => {
			clearTimeout(fml);
		};
	}, [callData]);

	const acceptCall = () => {
		props.acceptCall(callData.number);
	};

	const endCall = (e) => {
		if (callData == null || isEnding) return;
		props.endCall();
	};

	return (
		<div className={classes.call}>
			<div className={classes.callInfo}>
				<div className={classes.caller}>
					{isContact != null && !callLimited ? (
						isContact.avatar != null && isContact.avatar !== '' ? (
							<div className="inner">
								<Avatar
									className={`${classes.avatar} ${
										isContact.favorite ? 'favorite' : ''
									}`}
									src={isContact.avatar}
									alt={isContact.name.charAt(0)}
								/>
								<div className="details">
									<span>{isContact.name}</span>
									<small>{number}</small>
								</div>
							</div>
						) : (
							<div className="inner">
								<Avatar
									className={`${classes.avatar} ${
										isContact.favorite ? 'favorite' : ''
									}`}
									style={{
										background: isContact.color,
									}}
								>
									{isContact.name.charAt(0)}
								</Avatar>
								<div className="details">
									<span>{isContact.name}</span>
									<small>{number}</small>
								</div>
							</div>
						)
					) : (
						<div className="inner">
							<Avatar className={classes.avatar}>#</Avatar>
							<div className="details">
								<span>Unknown Number</span>
								<small>{number}</small>
							</div>
						</div>
					)}
				</div>
				<div className={classes.duration}>
					{!isEnding ? (
						<small>
							{callData != null ? (
								callData.state > 0 ? (
									<Moment
										unix
										durationFromNow
										interval={1000}
										format="hh:mm:ss"
										date={callData.start}
									/>
								) : (
									<span>Calling</span>
								)
							) : (
								<span>Pending</span>
							)}
						</small>
					) : (
						<small>Call Ended</small>
					)}
				</div>
			</div>
			<div className={classes.spacer}></div>
			<div className={classes.actions}>
				<Button
					className={`${classes.keypadBtn} end`}
					onClick={endCall}
					disabled={callData == null}
				>
					<FontAwesomeIcon
						icon={['far', 'phone-hangup']}
						style={{ fontSize: 36 }}
					/>
				</Button>

				{Boolean(callData) && callData.state == 1 && (
					<Button
						className={`${classes.keypadBtn} accept`}
						onClick={acceptCall}
						disabled={callData == null}
					>
						<FontAwesomeIcon
							icon={['far', 'phone-flip']}
							style={{ fontSize: 36 }}
						/>
					</Button>
				)}
			</div>
		</div>
	);

	return (
		<div className={classes.wrapper}>
			<div className={classes.phoneTop}>
				{isContact != null && !callLimited ? (
					isContact.avatar != null && isContact.avatar !== '' ? (
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
							style={{
								background: isContact.color,
							}}
						>
							{isContact.name.charAt(0)}
						</Avatar>
					)
				) : (
					<Avatar
						className={classes.avatar}
						style={{
							background: '#333',
						}}
					>
						#
					</Avatar>
				)}
				<div className={classes.callData}>
					{callLimited
						? 'Unknown Number'
						: isContact != null && !limited
						? isContact.name
						: number}
					{!isEnding ? (
						<small>
							{callData != null ? (
								callData.state > 0 ? (
									<Moment
										durationFromNow
										interval={1000}
										format="hh:mm:ss"
										date={callData.start}
									/>
								) : (
									<span>Calling</span>
								)
							) : (
								<span>Pending</span>
							)}
						</small>
					) : (
						<small>Call Ended</small>
					)}
				</div>
			</div>
			<div className={classes.phoneBottom}>
				<Grid container>
					<Grid item xs={6}>
						{/* <Button
							color="primary"
							className={classes.keypadBtn}
							onClick={holdCall}
						>
							<FontAwesomeIcon
								icon={['fas', 'pause']}
								style={{ fontSize: 40 }}
							/>
						</Button> */}
					</Grid>
					<Grid item xs={6}>
						{/* <Button
							color="primary"
							className={classes.keypadBtn}
							onClick={putOnSpeaker}
						>
							<FontAwesomeIcon
								icon={['fas', 'volume-high']}
								style={{ fontSize: 40 }}
							/>
						</Button> */}
					</Grid>
					<Grid item xs={12} style={{ marginTop: '60%' }}>
						<div className={classes.keypadBtn}>
							{Boolean(callData) && callData.state == 1 && (
								<IconButton
									className={`${classes.keypadAction} accept`}
									onClick={acceptCall}
									disabled={callData == null}
								>
									<FontAwesomeIcon
										icon={['fas', 'phone']}
										style={{ fontSize: 40 }}
									/>
								</IconButton>
							)}
							<IconButton
								className={`${classes.keypadAction} end`}
								onClick={endCall}
								disabled={callData == null}
							>
								<FontAwesomeIcon
									icon={['fas', 'phone-xmark']}
									style={{ fontSize: 40 }}
								/>
							</IconButton>
						</div>
					</Grid>
				</Grid>
			</div>
		</div>
	);
});

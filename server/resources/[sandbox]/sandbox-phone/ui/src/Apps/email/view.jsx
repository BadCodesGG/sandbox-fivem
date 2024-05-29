import React, { Fragment, useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate, useParams } from 'react-router-dom';
import {
	Grid,
	AppBar,
	Menu,
	MenuItem,
	Paper,
	IconButton,
	Tooltip,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { Sanitize } from '../../util/Parser';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { ReadEmail, DeleteEmail, GPSRoute, Hyperlink } from './action';
import { useAlert, useAppData } from '../../hooks';
import { AppContainer } from '../../components';

const useStyles = makeStyles((theme) => ({
	email: {
		display: 'flex',
		flexDirection: 'column',
		height: '100%',
	},
	senderDetails: {
		background: theme.palette.secondary.dark,
		padding: 8,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	innerDetails: {
		display: 'flex',
	},
	sender: {
		fontSize: 22,
		color: (app) => app.color,
	},
	timestamp: {
		flexGrow: 1,
		fontSize: 14,
		color: theme.palette.text.alt,
		lineHeight: '40px',
	},
	content: {
		padding: 8,
		flexGrow: 1,
		overflow: 'auto',
	},
	expireBanner: {
		padding: 8,
		background: theme.palette.error.main,
		textAlign: 'center',
		borderBottom: `1px solid ${theme.palette.border.divider}`,

		'& span': {
			fontSize: 18,
			lineHeight: '24px',
		},

		'& .before': {
			marginRight: 8,
			fontSize: 24,
		},
		'& .after': {
			marginLeft: 8,
			fontSize: 24,
		},
	},
}));

const calendarStrings = {
	lastDay: '[Yesterday at] LT',
	sameDay: '[Today at] LT',
	nextDay: '[Tomorrow at] LT',
	lastWeek: '[last] dddd [at] LT',
	nextWeek: 'dddd [at] LT',
	sameElse: 'L',
};

export default connect(null, { ReadEmail, DeleteEmail, GPSRoute, Hyperlink })(
	(props) => {
		const appData = useAppData('email');
		const showAlert = useAlert();
		const classes = useStyles(appData);
		const history = useNavigate();
		const params = useParams();
		const { id } = params;
		const emails = useSelector((state) => state.data.data.emails);
		const email = emails.filter((e) => e.id === +id)[0];

		useEffect(() => {
			let intrvl = null;
			if (!email) {
				showAlert('Email Has Been Deleted');
				history(-1);
			}

			if (email?.unread) props.ReadEmail(email);

			if (email?.expires != null) {
				if (email.expires < Date.now() / 1000) {
					showAlert('Email Has Expired');
					props.DeleteEmail(email.id);
					history(-1);
				} else {
					intrvl = setInterval(() => {
						if (email.expires < Date.now() / 1000) {
							showAlert('Email Has Expired');
							props.DeleteEmail(email.id);
							history(-1);
						}
					}, 2500);
				}
			}
			return () => {
				clearInterval(intrvl);
			};
		}, [email]);

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

		const deleteEmail = () => {
			onClose();
			showAlert('Email Deleted');
			props.DeleteEmail(email.id);
			history(-1);
		};

		const gpsClicked = () => {
			if (email?.flags?.location != null)
				props.GPSRoute(email.id, email.flags.location);
		};

		const linkClicked = () => {
			if (email?.flags?.hyperlink != null)
				props.Hyperlink(email.id, email.flags.hyperlink);
		};

		return (
			<AppContainer
				appId="email"
				titleOverride={
					Boolean(email?.subject) ? (
						<Tooltip
							title={email?.subject}
							placement="bottom-start"
						>
							<span>{email?.subject}</span>
						</Tooltip>
					) : (
						'No Email Subject'
					)
				}
				actions={
					<Fragment>
						<IconButton onClick={onClick}>
							<FontAwesomeIcon
								icon={['fas', 'ellipsis-vertical']}
							/>
						</IconButton>
					</Fragment>
				}
			>
				<div className={classes.email}>
					<div className={classes.senderDetails}>
						<div className={classes.sender}>{email.sender}</div>
						<div className={classes.innerDetails}>
							<div className={classes.timestamp}>
								<Moment unix date={email.time} format="L LT" />
							</div>

							{Boolean(email?.flags) && (
								<div className={classes.flags}>
									{Boolean(email?.flags?.location) && (
										<IconButton onClick={gpsClicked}>
											<FontAwesomeIcon
												icon={[
													'fas',
													'location-crosshairs',
												]}
											/>
										</IconButton>
									)}
									{Boolean(email?.flags?.hyperlink) && (
										<IconButton onClick={linkClicked}>
											<FontAwesomeIcon
												icon={['fas', 'link']}
											/>
										</IconButton>
									)}
								</div>
							)}
						</div>
					</div>

					{Boolean(email?.expires) &&
						email.expires > Date.now() / 1000 && (
							<div className={classes.expireBanner}>
								<FontAwesomeIcon
									className="before"
									icon={['far', 'hexagon-exclamation']}
								/>
								<span>
									Email expires{' '}
									<Moment
										unix
										interval={10000}
										calendar={calendarStrings}
										date={email.expires}
										fromNow
									/>
								</span>
								<FontAwesomeIcon
									className="after"
									icon={['far', 'hexagon-exclamation']}
								/>
							</div>
						)}
					<div className={classes.content}>
						{Sanitize(email?.body)}
					</div>
					<Menu
						anchorReference="anchorPosition"
						anchorPosition={offset}
						keepMounted
						open={open}
						onClose={onClose}
					>
						<MenuItem onClick={deleteEmail}>Delete Email</MenuItem>
					</Menu>
				</div>
			</AppContainer>
		);

		return (
			<AppContainer
				appId="email"
				titleOverride={email?.subject}
				actions={
					<Fragment>
						<IconButton onClick={onClick}>
							<FontAwesomeIcon
								icon={['fas', 'ellipsis-vertical']}
							/>
						</IconButton>
					</Fragment>
				}
			>
				<AppBar position="static">
					<Grid container className={classes.senderBar}>
						<Grid
							item
							xs={12}
							style={{
								overflow: 'hidden',
								whiteSpace: 'nowrap',
								textOverflow: 'ellipsis',
							}}
						>
							<div className={classes.sender}>
								{email?.sender}
							</div>
							<div className={classes.recipient}>to: me</div>
						</Grid>

						<Grid
							item
							xs={8}
							style={{ textAlign: 'left', position: 'relative' }}
						>
							<p className={classes.sendTime}>
								Received{' '}
								<Moment
									unix
									interval={60000}
									fromNow
									date={email?.time}
								/>
								.
							</p>
						</Grid>
						<Grid
							item
							xs={4}
							style={{ textAlign: 'right', position: 'relative' }}
						>
							<div className={classes.actionButtons}>
								{email?.flags?.location != null ? (
									<IconButton onClick={gpsClicked}>
										<FontAwesomeIcon
											icon={[
												'fas',
												'location-crosshairs',
											]}
										/>
									</IconButton>
								) : null}
								{email?.flags?.hyperlink != null ? (
									<IconButton onClick={linkClicked}>
										<FontAwesomeIcon
											icon={['fas', 'link']}
										/>
									</IconButton>
								) : null}
							</div>
						</Grid>
					</Grid>
				</AppBar>

				<Menu
					anchorReference="anchorPosition"
					anchorPosition={offset}
					keepMounted
					open={open}
					onClose={onClose}
				>
					<MenuItem onClick={deleteEmail}>Delete Email</MenuItem>
				</Menu>
				{email?.flags?.expires != null ? (
					<AppBar className={classes.expireBar} position="static">
						<div>
							Email expires{' '}
							<Moment
								interval={10000}
								calendar={calendarStrings}
								fromNow
							>
								{+email.flags.expires}
							</Moment>
						</div>
					</AppBar>
				) : null}
				<Paper
					className={classes.emailBody}
					style={{
						height:
							email?.flags?.expires != null ? '66.6%' : '73.5%',
					}}
				>
					{Sanitize(email?.body)}
				</Paper>
			</AppContainer>
		);
	},
);

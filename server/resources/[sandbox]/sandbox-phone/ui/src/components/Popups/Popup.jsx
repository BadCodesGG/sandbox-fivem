import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate, useLocation } from 'react-router-dom';
import { Grid, IconButton, Paper, Collapse } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useDismisser, useMyApps } from '../../hooks';
import Nui from '../../util/Nui';
import DOMPurify from 'dompurify';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		borderRadius: 4,
		marginBottom: 10,
	},
	appInfo: {
		paddingBottom: 5,
		marginBottom: 5,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'filter ease-in 0.15s',
		'&.clickable:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	appName: {
		height: 'fit-content',
		color: theme.palette.text.alt,
		textTransform: 'uppercase',
		top: 0,
		bottom: 0,
		margin: 'auto',
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		fontSize: 12,
	},
	time: {
		height: 'fit-content',
		color: theme.palette.text.main,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		margin: 'auto',
		fontSize: 12,
	},
	notifTitle: {
		display: 'block',
		fontSize: 18,
		color: theme.palette.text.main,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		position: 'relative',
	},
	notifDescrip: {
		display: 'block',
		fontSize: 14,
		color: theme.palette.text.alt,
		whiteSpace: (hovering) => Boolean(hovering) ? 'wrap' : 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	actionView: {
		color: theme.palette.info.light,
		fontSize: 18,
		height: 32,
		width: 32,
	},
	actionAccept: {
		color: theme.palette.success.main,
		fontSize: 18,
		height: 32,
		width: 32,
	},
	actionCancel: {
		color: theme.palette.error.light,
		fontSize: 18,
		height: 32,
		width: 32,
	},
	actionBtns: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: -5,
		right: '2%',
		margin: 'auto',
	},
}));

export default ({ id, notification }) => {
	const dispatch = useDispatch();
	const history = useNavigate();
	const dismisser = useDismisser();
	const apps = useMyApps();
	const location = useLocation();
	const phoneOpen = useSelector((state) => state.phone.visible);
	const openApp = useSelector((state) => state.notifications.open);
	let app =
		typeof notification.app === 'object'
			? notification.app
			: apps[notification.app];

	const [hovering, setHovering] = useState(false);
	const [showIcons, setShowIcons] = useState(false);
	const [show, setShow] = useState(false);

	const classes = useStyles(hovering);

	useEffect(() => {
		setShow(true);

		if (notification.duration != -1) {
			let i = setInterval(() => {
				if (
					Date.now() / 1000 >
					notification.time + notification.duration / 1000
				) {
					setShow(false);
					clearInterval(i);
				}
			}, 1000);

			return () => {
				clearInterval(i);
			};
		}
	}, []);

	useEffect(() => {
		if (notification.collapsed) return;
		if (notification.duration == -1) {
			let t = setTimeout(() => {
				dispatch({
					type: 'NOTIF_COLLAPSE',
					payload: { id: notification.id },
				});
			}, 5000);

			return () => {
				clearTimeout(t);
			};
		}
	}, [notification]);

	const onClick = () => {
		if (notification.duration != -1) {
			setShow(false);
		} else {
			dispatch({
				type: 'NOTIF_COLLAPSE',
				payload: { id: notification.id },
			});
		}
	};

	const onView = () => {
		if (notification.duration != -1) setShow(false);

		if (notification.action?.view === 'USE_SHARE') {
			dispatch({
				type: 'USE_SHARE',
				payload: {},
			});
		} else {
			history(`/apps/${app.name}/${notification.action?.view}`);
		}
	};

	const onAccept = () => {
		setShow(false);
		Nui.send('AcceptPopup', {
			event: notification.action?.accept,
			data: notification.data,
		});
	};

	const onCancel = () => {
		setShow(false);
		Nui.send('CancelPopup', {
			event: notification.action?.cancel,
			data: notification.data,
		});
	};

	const onAnimEnd = () => {
		if (
			location.pathname != '/' &&
			phoneOpen &&
			(notification.duration == -1 || notification.manual) &&
			show
		)
			return;
		dismisser(notification.id);
	};

	if (!Boolean(app)) return null;
	return (
		<Collapse
			collapsedSize={0}
			in={
				show &&
				!(
					location.pathname != '/' &&
					phoneOpen &&
					(notification.duration == -1 || notification.manual)
				)
			}
			onEntered={() => setShowIcons(true)}
			onExiting={() => setShowIcons(false)}
			onExited={onAnimEnd}
		>
			<Paper
				elevation={20}
				className={classes.wrapper}
				onMouseEnter={() => setHovering(true)}
				onMouseLeave={() => setHovering(false)}
			>
				<Collapse in={!notification.collapsed} collapsedSize={0}>
					<Grid
						container
						className={`${classes.appInfo} clickable`}
						onClick={onClick}
					>
						<Grid item xs={6} style={{ position: 'relative' }}>
							<span className={classes.appName}>{app.label}</span>
						</Grid>
						<Grid item xs={6} style={{ position: 'relative' }}>
							<Moment
								unix
								fromNow
								className={classes.time}
								date={notification.time}
							/>
						</Grid>
					</Grid>
				</Collapse>
				<Grid container>
					<Grid item xs={12}>
						<span className={classes.notifTitle}>
							<Collapse
								in={
									!notification.collapsed ||
									!phoneOpen ||
									location.pathname == '/'
								}
								collapsedSize={0}
							>
								<span>{notification.title}</span>
							</Collapse>

							{phoneOpen && showIcons && (
								<div className={classes.actionBtns}>
									{Boolean(notification.action?.view) && (
										<IconButton
											onClick={onView}
											className={classes.actionView}
										>
											<FontAwesomeIcon
												icon={['fas', 'eye']}
											/>
										</IconButton>
									)}
									{Boolean(notification.action?.accept) && (
										<IconButton
											onClick={onAccept}
											className={classes.actionAccept}
										>
											<FontAwesomeIcon
												icon={['fas', 'circle-check']}
											/>
										</IconButton>
									)}
									{Boolean(notification.action?.cancel) && (
										<IconButton
											onClick={onCancel}
											className={classes.actionCancel}
										>
											<FontAwesomeIcon
												icon={['fas', 'circle-xmark']}
											/>
										</IconButton>
									)}
								</div>
							)}
						</span>
						<div className={classes.notifDescrip}>
							{DOMPurify.sanitize(notification.description, {
								ALLOWED_TAGS: [],
							})}
						</div>
					</Grid>
				</Grid>
			</Paper>
		</Collapse>
	);
};

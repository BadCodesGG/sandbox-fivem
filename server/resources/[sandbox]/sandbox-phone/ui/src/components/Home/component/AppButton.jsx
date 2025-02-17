import React, { useEffect, useState } from 'react';
import { Avatar, Badge } from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	appBtn: {
		width: '100%',
		height: 120,
		display: 'inline-block',
		textAlign: 'center',
		height: 'fit-content',
		padding: '10% 0px',
		borderRadius: 10,
		position: 'relative',
		userSelect: 'none',
		'&:hover': {
			transition: 'background ease-in 0.15s',
			background: `${theme.palette.primary.main}40`,
			cursor: 'pointer',
		},

		'&.edit': {
			animation: '$wiggle linear 0.5s',
			animationIterationCount: 'infinite',
		},

		'&.dragging': {
			background: 'red',
		},
	},
	appContext: {
		width: '100%',
		display: 'inline-block',
		textAlign: 'center',
		height: 'fit-content',
		padding: '10% 0px',
		borderRadius: 10,
		position: 'relative',
		transition: 'background ease-in 0.15s',
		background: `${theme.palette.primary.main}40`,
	},
	appIcon: {
		fontSize: 24,
		width: 60,
		height: 60,
		margin: 'auto',
		color: '#fff',
		borderRadius: 20,
	},
	appLabel: {
		fontSize: 12,
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		textShadow: '0px 0px 5px #000000',
		fontWeight: 800,
		marginTop: 10,
		pointerEvents: 'none',
	},
	dockBtn: {
		width: '25%',
		display: 'inline-block',
		textAlign: 'center',
		height: 'fit-content',
		padding: '2% 0px',
		borderRadius: 10,
		position: 'relative',
		'&:hover': {
			transition: 'background ease-in 0.15s',
			background: `${theme.palette.primary.main}40`,
			cursor: 'pointer',
		},
	},
	dockContext: {
		width: '25%',
		display: 'inline-block',
		textAlign: 'center',
		height: 'fit-content',
		padding: '2% 0px',
		borderRadius: 10,
		position: 'relative',
		transition: 'background ease-in 0.15s',
		background: `${theme.palette.primary.main}40`,
	},
	'@keyframes wiggle': {
		'0%': {
			transform: 'rotate(-1.5deg)',
			animationTimingFunction: 'ease-in',
		},
		'50%': {
			transform: 'rotate(2deg)',
			animationTimingFunction: 'ease-out',
		},
	},
}));

const NotiBadge = withStyles((theme) => ({
	badge: {
		right: 4,
		top: 50,
		filter: 'drop-shadow(0px 0px 6px black)',
	},
}))(Badge);

const NotifCount = withStyles((theme) => ({
	root: {
		width: 24,
		height: 24,
		fontSize: 16,
		lineHeight: '24px',
		color: '#fff',
		background: '#ff0000',
	},
}))(Avatar);

export default ({
	appId,
	app,
	isEdit,
	onClick,
	onRightClick,
	onStartEdit,
	isContext,
	onDragState = null,
	docked = false,
}) => {
	const classes = useStyles();

	let clickHoldTimer = null;
	useEffect(() => {
		return () => {
			clearTimeout(clickHoldTimer);
		};
	}, []);

	const clickHoldStart = (e) => {
		if (e.button == 0) {
			if (Boolean(onDragState)) onDragState(true);
			clickHoldTimer = setTimeout(() => {
				onStartEdit(true);
			}, 1000);
		}
	};

	const clickHoldEnd = (e) => {
		if (Boolean(onDragState)) onDragState(false);
		clearTimeout(clickHoldTimer);
	};

	return (
		<div
			className={`${
				isContext
					? docked
						? classes.dockContext
						: classes.appContext
					: docked
					? classes.dockBtn
					: classes.appBtn
			} grid-item ${isEdit ? 'edit' : ''}`}
			title={app.label}
			onClick={() => onClick(appId)}
			onContextMenu={(e) => onRightClick(e, appId, docked)}
			onMouseDown={clickHoldStart}
			onMouseUp={clickHoldEnd}
		>
			{app.unread > 0 ? (
				<NotiBadge
					badgeContent={
						<NotifCount
							style={{
								border: `2px solid ${app.color}`,
							}}
						>
							{app.unread}
						</NotifCount>
					}
				>
					<Avatar
						variant="rounded"
						className={classes.appIcon}
						style={{
							background: `${app.color}`,
						}}
					>
						<FontAwesomeIcon icon={app.icon} />
					</Avatar>
				</NotiBadge>
			) : (
				<Avatar
					variant="rounded"
					className={classes.appIcon}
					style={{
						background: `${app.color}`,
					}}
				>
					<FontAwesomeIcon icon={app.icon} />
				</Avatar>
			)}
			{!docked && <div className={classes.appLabel}>{app.label}</div>}
		</div>
	);
};

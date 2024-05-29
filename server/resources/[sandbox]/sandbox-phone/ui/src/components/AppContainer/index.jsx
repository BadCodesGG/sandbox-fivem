import React, { memo } from 'react';
import { AppBar } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useMyApps } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: theme.palette.primary.main,
		fontSize: 20,
		padding: '0 15px',
		lineHeight: '55px',
		height: 55,
		padding: '0 8px',
	},
	headerInner: {
		display: 'flex',
	},
	headerAction: {
		textAlign: 'right',
		display: 'flex',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},

		'& .MuiIconButton-root': {
			width: 40,
			height: 40,
			margin: 'auto',
			position: 'relative',
		},
	},
	body: {
		height: '92%',
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
	appTitle: {
		width: '100%',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		whiteSpace: 'nowrap',
		flexGrow: 1,
	},
}));

export default memo(
	({
		appId,
		children,
		actions = null,
		actionShow = true,
		colorOverride = false,
		titleOverride = false,
	}) => {
		const classes = useStyles();
		const apps = useMyApps();

		if (!Boolean(appId)) return null;

		const app = apps[appId];
		return (
			<>
				<div className={classes.wrapper}>
					<AppBar
						position="static"
						className={classes.header}
						elevation={0}
						style={
							Boolean(colorOverride)
								? { background: colorOverride }
								: {
										background: Boolean(app.color)
											? app.color
											: '',
								  }
						}
					>
						<div className={classes.headerInner}>
							<div className={classes.appTitle}>
								{Boolean(titleOverride)
									? titleOverride
									: app.storeLabel}
							</div>
							{actionShow && Boolean(actions) && (
								<div className={classes.headerAction}>
									{actions}
								</div>
							)}
						</div>
					</AppBar>
					<div className={classes.body}>{children}</div>
				</div>
			</>
		);
	},
);

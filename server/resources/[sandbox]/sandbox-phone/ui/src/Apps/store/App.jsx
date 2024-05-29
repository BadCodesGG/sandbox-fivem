import React from 'react';
import { connect, useSelector } from 'react-redux';
import {
	Grid,
	CircularProgress,
	Fab,
	Avatar,
	Paper,
	LinearProgress,
	IconButton,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { install, uninstall } from './action';

const useStyles = makeStyles((theme) => ({
	appContainer: {
		marginBottom: 4,
		background: theme.palette.secondary.dark,
		border: `1px solid ${theme.palette.border.divider}`,
	},
	appInfo: {
		display: 'flex',
	},
	appIcon: {
		fontSize: 18,
		width: 50,
		lineHeight: '50px',
		textAlign: 'center',
		borderRight: `1px solid ${theme.palette.border.divider}`,
	},
	appLabel: {
		lineHeight: '50px',
		paddingLeft: 10,
		fontWeight: 800,
		flexGrow: 1,
	},
	installIcon: {
		width: 50,
		lineHeight: '50px',
		textAlign: 'center',

		'& svg': {
			fontSize: 14,
		},
	},
}));

export default connect(null, { install, uninstall })((props) => {
	const classes = useStyles();

	const installing = useSelector((state) => state.store.installing).includes(
		props.app.name,
	);
	const installPending = useSelector(
		(state) => state.store.installPending,
	).includes(props.app.name);
	const installFailed = useSelector(
		(state) => state.store.installFailed,
	).includes(props.app.name);

	const uninstalling = useSelector(
		(state) => state.store.uninstalling,
	).includes(props.app.name);
	const uninstallPending = useSelector(
		(state) => state.store.uninstallPending,
	).includes(props.app.name);
	const uninstallFailed = useSelector(
		(state) => state.store.uninstallFailed,
	).includes(props.app.name);

	const installApp = (e) => {
		e.preventDefault();
		if (installing) return;
		props.install(props.app.name);
	};

	const uninstallApp = (e) => {
		e.preventDefault();
		props.uninstall(props.app.name);
	};

	return (
		<Grid item xs={12}>
			<div className={classes.appContainer}>
				<div className={classes.appInfo}>
					<div
						className={classes.appIcon}
						style={{ background: props.app.color }}
					>
						<FontAwesomeIcon icon={props.app.icon} />
					</div>
					<div className={classes.appLabel}>
						{props.app.storeLabel}
					</div>
					<div className={classes.installIcon}>
						{Boolean(props.installed) ? (
							<IconButton
								onClick={uninstallApp}
								disabled={
									uninstalling ||
									uninstallPending ||
									uninstallFailed ||
									!props.app.canUninstall
								}
							>
								<FontAwesomeIcon icon={['far', 'x']} />
							</IconButton>
						) : (
							<IconButton
								onClick={installApp}
								disabled={
									installing ||
									installPending ||
									installFailed
								}
							>
								<FontAwesomeIcon icon={['far', 'check']} />
							</IconButton>
						)}
					</div>
				</div>
				{(installing ||
					installPending ||
					uninstalling ||
					uninstallPending) && (
					<LinearProgress
						color={
							installing
								? 'success'
								: uninstalling
								? 'error'
								: 'warning'
						}
					/>
				)}
			</div>
		</Grid>
	);

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<Avatar
						variant="rounded"
						className={classes.appIcon}
						style={{ backgroundColor: props.app.color }}
					>
						<FontAwesomeIcon
							style={{ margin: 'auto', width: 'auto' }}
							icon={props.app.icon}
						/>
					</Avatar>
				</Grid>
				<Grid item xs={8} className={classes.appText}>
					<span className={classes.appTitle}>{props.app.label}</span>
				</Grid>
				<Grid item xs={2} style={{ position: 'relative' }}>
					{props.installed ? (
						<div>
							<Fab
								className={classes.uninstallBtn}
								onClick={uninstallApp}
								disabled={
									uninstalling ||
									uninstallPending ||
									uninstallFailed ||
									!props.app.canUninstall
								}
							>
								{false ? (
									<FontAwesomeIcon
										icon={['fas', 'check']}
										style={{ fontSize: 16 }}
									/>
								) : (
									<FontAwesomeIcon
										icon={['fas', 'x']}
										style={{ fontSize: 16 }}
									/>
								)}
							</Fab>
							{uninstalling || uninstallPending ? (
								<CircularProgress
									size={68}
									className={
										uninstalling
											? classes.fabInstall
											: uninstallPending
											? classes.fabPending
											: null
									}
								/>
							) : uninstallFailed ? (
								<CircularProgress
									size={68}
									variant="static"
									value={100}
									className={classes.fabFailed}
								/>
							) : null}
						</div>
					) : (
						<div>
							<Fab
								className={classes.installBtn}
								onClick={installApp}
								disabled={
									installing ||
									installPending ||
									installFailed
								}
							>
								{false ? (
									<FontAwesomeIcon
										icon={['fas', 'check']}
										style={{ fontSize: 16 }}
									/>
								) : (
									<FontAwesomeIcon
										icon={['fas', 'download']}
										style={{ fontSize: 16 }}
									/>
								)}
							</Fab>
							{installing || installPending ? (
								<CircularProgress
									size={68}
									className={
										installing
											? classes.fabInstall
											: installPending
											? classes.fabPending
											: null
									}
								/>
							) : installFailed ? (
								<CircularProgress
									size={68}
									variant="static"
									value={100}
									className={classes.fabFailed}
								/>
							) : null}
						</div>
					)}
				</Grid>
			</Grid>
		</Paper>
	);
});

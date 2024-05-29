import React, { useEffect, useMemo, useState } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { Menu, MenuItem, Avatar, Badge, Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { NestedMenuItem } from 'mui-nested-menu';
import { swap } from 'react-grid-dnd';
import { throttle } from 'lodash';

import { useAlert, useAppView, useAppButton, useMyApps } from '../../hooks';
import { uninstall } from '../../Apps/store/action';
import AppButton from './component/AppButton';
import Page from './component/Page';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		userSelect: 'none',
		display: 'flex',
		flexDirection: 'column',
	},
	grid: {
		display: 'flex',
		flexWrap: 'wrap',
		justifyContent: 'start',
		alignContent: 'flex-start',
		overflow: 'hidden',
		flexGrow: 1,
	},
	dock: {
		background: `${theme.palette.secondary.dark}b8`,
		height: 100,
		width: '100%',
		padding: 10,
		display: 'flex',
		justifyContent: 'space-evenly',
		marginLeft: 1,
	},
	menuClose: {
		position: 'fixed',
		top: 0,
		left: 0,
		height: '-webkit-fill-available',
		width: '-webkit-fill-available',
	},
	menu: {
		padding: 5,
		background: theme.palette.secondary.main,
		zIndex: 999,
		fontSize: 18,
		margin: 5,
		width: '40%',
	},
	showAll: {
		color: theme.palette.text.light,
		fontSize: 30,
		position: 'absolute',
		bottom: '19%',
		left: 0,
		right: 0,
		margin: 'auto',
		width: 'fit-content',
		padding: 5,
		zIndex: 5,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
			cursor: 'pointer',
		},
	},
	pageIndicator: {
		position: 'absolute',
		bottom: '27%',
		left: 0,
		right: 0,
		margin: 'auto',
		height: 'fit-content',
		width: 'fit-content',

		'& svg': {
			transition: 'color ease-in 0.15s',
			'&:not(:last-of-type)': {
				marginRight: 6,
			},
			'&.active': {
				color: theme.palette.primary.main,
			},
			'&:hover': {
				cursor: 'pointer',
				color: theme.palette.primary.dark,
			},

			'&.finish': {
				color: theme.palette.success.main,
				'&:hover': {
					color: theme.palette.success.dark,
				},
			},

			'&.new': {
				color: theme.palette.info.main,
				'&:hover': {
					color: theme.palette.info.dark,
				},
			},
		},
	},
	finishBtn: {
		padding: '0 4px',
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 16,
		left: 0,
		right: 0,
		margin: 'auto',
		background: theme.palette.text.main,
		color: theme.palette.secondary.dark,
		borderRadius: 8,
		fontSize: 14,
		fontFamily: 'system-ui',
		fontWeight: 'bolder',
		transition: 'background ease-in 0.15s',

		'&:hover': {
			cursor: 'pointer',
			background: theme.palette.text.alt,
		},
	},
}));

export default connect(null, {
	uninstall,
})((props) => {
	const openedApp = useAppView();
	const showAlert = useAlert();
	const appButton = useAppButton();
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useNavigate();
	const apps = useMyApps();
	const player = useSelector((state) => state.data.data.player);
	const musicData = useSelector((state) => state.music.showPopup);
	const homeApps = useSelector((state) => state.data.data.player?.Apps?.home);
	const zoom = useSelector(
		(state) => state.data.data.player.PhoneSettings?.zoom,
	);
	const dockedApps = useSelector(
		(state) => state.data.data.player?.Apps?.dock,
	);

	const pages = Math.ceil(
		Math.ceil(homeApps.length / (zoom >= 95 ? 20 : 16)),
	);
	const [page, setPage] = useState(1);
	const [editing, setEditing] = useState(false);

	const [dragging, setDragging] = useState(null);
	const [contextApp, setContextApp] = useState(null);
	const [contextDock, setContextDock] = useState(false);
	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
	});

	useEffect(() => {
		dispatch({
			type: 'NOTIF_RESET_APP',
		});
		dispatch({
			type: 'APP_OPEN',
			payload: 'home',
		});
		dispatch({
			type: 'MUSIC_APP_CLOSED',
			payload: {
				musicPlayerActive: musicData
			}
		});
	}, []);

	useEffect(() => {
		if (Math.ceil(homeApps.length / zoom >= 95 ? 20 : 16) <= 1) setPage(1);
	}, [homeApps]);

	const viewList = () => {
		history('/apps');
	};

	const onClick = (app) => {
		if (editing) return;
		openedApp(app);
		history(`/apps/${app}`);
	};

	const openApp = () => {
		openedApp(contextApp);
		history(`/apps/${contextApp}`);
	};

	const onRightClick = (e, app, isDock = false) => {
		e.preventDefault();
		setOffset({ left: e.clientX - 2, top: e.clientY - 4 });
		if (app != null) setContextApp(app);
		setContextDock(isDock);
	};

	const closeContext = (e) => {
		if (e != null) e.preventDefault();
		setContextDock(null);
		setContextApp(null);
	};

	const addToHome = async () => {
		await appButton('add', 'Home', contextApp);
		showAlert(
			`${
				Boolean(apps[contextApp])
					? apps[contextApp].label
					: 'Encrypted App'
			} Added To Home Screen`,
		);
		closeContext();
	};

	const removeFromHome = async () => {
		await appButton('remove', 'Home', contextApp);
		showAlert(
			`${
				Boolean(apps[contextApp])
					? apps[contextApp].label
					: 'Encrypted App'
			} Removed Home Screen`,
		);
		closeContext();
	};

	const dockApp = async () => {
		if (dockedApps.length < 4) {
			await appButton('add', 'Dock', contextApp);
			showAlert(
				`${
					Boolean(apps[contextApp])
						? apps[contextApp].label
						: 'Encrypted App'
				} Added To Dock`,
			);
		} else showAlert('Can Only Have 4 Apps In Dock');
		closeContext();
	};

	const undockApp = async () => {
		await appButton('remove', 'Dock', contextApp);
		showAlert(
			`${
				Boolean(apps[contextApp])
					? apps[contextApp].label
					: 'Encrypted App'
			} Removed From Dock`,
		);
		closeContext();
	};

	const uninstallApp = () => {
		props.uninstall(contextApp);
		closeContext();
	};

	const onScroll = throttle(async (e) => {
		if (dragging) return;
		if (pages > 1) {
			if (e.deltaY == 100) {
				if (page + 1 <= pages) setPage(page + 1);
			} else {
				if (page - 1 > 0) setPage(page - 1);
			}
		}
	}, 500);

	const onStopEditing = () => {
		if (!editing) return;
		setEditing(false);
	};

	const onPageClick = (id) => {
		if (!dragging) {
			setPage(id);
		}
	};

	const GeneratePageIcons = () => {
		let els = Array();

		if (pages > 1) {
			for (let i = 1; i <= pages; i++) {
				els.push(
					<FontAwesomeIcon
						key={`page-indic-${i}`}
						className={`${page == i ? 'active' : ''}`}
						icon="circle"
						onClick={() => onPageClick(i)}
					/>,
				);
			}
		}

		return els;
	};

	const onSendAppOrder = async (type, apps) => {
		await Nui.send('Reorder', {
			type,
			apps,
		});
	};

	const onAppDrag = async (sourceId, sourceIndex, targetIndex, targetId) => {
		let nApps = swap(
			homeApps,
			(page - 1) * 16 + sourceIndex,
			(page - 1) * 16 + targetIndex,
		);

		dispatch({
			type: 'SET_DATA',
			payload: {
				type: 'player',
				data: {
					...player,
					Apps: {
						...player.Apps,
						home: nApps,
					},
				},
			},
		});
		try {
			await onSendAppOrder('home', nApps);
		} catch (err) {}
	};

	const setAppPage = async (page) => {
		let lastIndex = page * (zoom >= 95 ? 20 : 16) - 1;

		let nApps = swap(homeApps, homeApps.indexOf(contextApp), lastIndex);
		onSendAppOrder('home', nApps);
		dispatch({
			type: 'SET_DATA',
			payload: {
				type: 'player',
				data: {
					...player,
					Apps: {
						...player.Apps,
						home: nApps,
					},
				},
			},
		});

		closeContext();
	};

	const GeneratePageMovers = () => {
		let els = Array();
		for (let i = 0; i < pages; i++) {
			els.push(
				<MenuItem
					key={i}
					disabled={i + 1 == page}
					onClick={() => setAppPage(i + 1)}
				>
					Page {i + 1}
				</MenuItem>,
			);
		}
		return els;
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.grid} onWheel={onScroll}>
				<Page
					page={homeApps.slice(
						(page - 1) * (zoom >= 95 ? 20 : 16),
						page * (zoom >= 95 ? 20 : 16),
					)}
					contextApp={contextApp}
					contextDock={contextDock}
					isEditing={editing}
					onClick={onClick}
					onRightClick={onRightClick}
					onStartEdit={() => setEditing(true)}
					onAppDrag={onAppDrag}
					onDragState={setDragging}
				/>
			</div>
			<Slide direction="down" in={editing}>
				<div className={classes.finishBtn} onClick={onStopEditing}>
					DONE
				</div>
			</Slide>
			<div className={classes.pageIndicator}>{GeneratePageIcons()}</div>
			<div className={classes.dock}>
				{Object.keys(apps).length > 0 && dockedApps.length > 0
					? dockedApps.slice(0, 4).map((app, i) => {
							let data = apps[app];
							if (data) {
								return (
									<AppButton
										key={i}
										docked={true}
										appId={app}
										app={data}
										onClick={onClick}
										onRightClick={onRightClick}
										onStartEdit={() => setEditing(true)}
										isContext={
											contextApp === app && contextDock
										}
									/>
								);
							} else return null;
					  })
					: null}
			</div>

			{contextApp != null ? (
				editing && !contextDock ? (
					<Menu
						keepMounted
						onClose={closeContext}
						onContextMenu={closeContext}
						open={!!contextApp}
						anchorReference="anchorPosition"
						anchorPosition={offset}
					>
						<MenuItem disabled>
							{Boolean(apps[contextApp])
								? apps[contextApp].label
								: 'Encrypted App'}
						</MenuItem>

						<NestedMenuItem
							label="Move Page"
							parentMenuOpen={!!contextApp}
						>
							{GeneratePageMovers()}
						</NestedMenuItem>

						{dockedApps.filter((app) => app == contextApp).length >
						0 ? (
							<MenuItem
								disabled={true}
								onClick={null}
							>
								Already In Dock
							</MenuItem>
						) : (
							<MenuItem
								disabled={dockedApps.length >= 4}
								onClick={dockApp}
							>
								Add To Dock
							</MenuItem>
						)}

						{homeApps.filter((app) => app == contextApp).length >
						0 ? (
							<MenuItem onClick={removeFromHome}>
								Remove From Home
							</MenuItem>
						) : (
							<MenuItem onClick={addToHome}>Add To Home</MenuItem>
						)}
					</Menu>
				) : (
					<Menu
						keepMounted
						onClose={closeContext}
						onContextMenu={closeContext}
						open={!!contextApp}
						anchorReference="anchorPosition"
						anchorPosition={offset}
					>
						<MenuItem disabled>
							{Boolean(apps[contextApp])
								? apps[contextApp].label
								: 'Encrypted App'}
						</MenuItem>
						{Boolean(apps[contextApp]) && (
							<MenuItem onClick={openApp}>
								Open {apps[contextApp].label}
							</MenuItem>
						)}
						{contextDock &&
							(dockedApps.length > 0 &&
							dockedApps.filter((app) => app == contextApp)
								.length > 0 ? (
								<MenuItem onClick={undockApp}>
									Remove From Dock
								</MenuItem>
							) : (
								<MenuItem
									disabled={dockedApps.length >= 4}
									onClick={dockApp}
								>
									Add To Dock
								</MenuItem>
							))}
						{!contextDock &&
							(homeApps.filter((app) => app == contextApp)
								.length > 0 ? (
								<MenuItem onClick={removeFromHome}>
									Remove From Home
								</MenuItem>
							) : (
								<MenuItem onClick={addToHome}>
									Add To Home
								</MenuItem>
							))}
						{Boolean(apps[contextApp]) &&
						apps[contextApp].canUninstall ? (
							<MenuItem onClick={uninstallApp}>
								Uninstall {apps[contextApp].label}
							</MenuItem>
						) : null}
					</Menu>
				)
			) : null}

			<div className={classes.showAll} onClick={viewList}>
				<FontAwesomeIcon icon="angle-up" />
			</div>
		</div>
	);
});

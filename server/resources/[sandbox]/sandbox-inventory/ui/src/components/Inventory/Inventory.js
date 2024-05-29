import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Fade,
	Menu,
	MenuItem,
	LinearProgress,
	IconButton,
	Modal,
	Box,
	Typography,
	Tooltip,
	Button,
	Dialog,
	DialogTitle,
	DialogContent,
	DialogActions,
	Grid,
	TextField,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Slot from './Slot';
import Nui from '../../util/Nui';
import { closeInventory, useItem } from './actions';
import Split from './Split';
import Crafting from '../Crafting';
import AddToStore from './AddToStore';

const useStyles = makeStyles((theme) => ({
	root: {
		display: 'flex',
		justifyContent: 'center',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		width: '100%',
		height: '100%',
		gap: 300,
	},
	gridBg: {
		padding: 25,
		background: `#080808d6`,
		border: `1px solid rgba(255, 255, 255, 0.04)`,
		height: 'fit-content',
		maxWidth: 925,
		width: '100%',
	},
	container: {
		userSelect: 'none',
		'-webkit-user-select': 'none',
		width: '100%',
		height: 'fit-content',
	},
	inventoryGrid: {
		overflowX: 'hidden',
		overflowY: 'scroll',
		maxHeight: 'calc(60vh - 90px)',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		gap: 4,
		display: 'flex',
		flexWrap: 'wrap',
		justifyContent: 'flex-start',
	},
	inventoryWeight: {
		padding: '0 0 5px 0',
		position: 'relative',
	},
	weightText: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		bottom: 10,
		right: '1%',
		margin: 'auto',
		zIndex: 1,
		fontSize: 16,
		textShadow: `0 0 10px ${theme.palette.secondary.dark}`,
	},
	inventoryWeightBar: {
		height: 6,
		borderRadius: 0,
	},
	inventoryHeader: {
		paddingLeft: 5,
		fontWeight: 'bold',
		fontSize: 18,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	slot: {
		width: '100%',
		height: '120px',
		backgroundColor: theme.palette.secondary.dark,
		border: `1px solid ${theme.palette.secondary.light}`,
		position: 'relative',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	count: {
		bottom: theme.spacing(1),
		right: theme.spacing(2),
		width: '10%',
		height: '10%',
		position: 'absolute',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	shopBtn: {
		width: 150,
		height: 175,
		lineHeight: '175px',
		textAlign: 'center',
		fontSize: 36,
		position: 'absolute',
		top: 450,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		backgroundColor: `${theme.palette.secondary.light}`,
		border: `1px solid transparent`,
		transition:
			'background ease-in 0.15s, border ease-in 0.15s, color ease-in 0.15s',
		'&:hover': {
			backgroundColor: `${theme.palette.secondary.dark}9e`,
			borderColor: theme.palette.primary.main,
			color: theme.palette.primary.main,
		},
	},
	centerBtns: {
		height: 'fit-content',
		width: 250,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		padding: 12,
		background: `#080808d6`,
		border: `1px solid rgba(255, 255, 255, 0.04)`,
		display: 'flex',
		gap: 16,
		flexDirection: 'column',
	},
	useBtn: {
		width: '100%',
		height: 65,
		lineHeight: '65px',
		textAlign: 'center',
		fontSize: 18,
		backgroundColor: `${theme.palette.secondary.light}`,
		border: `1px solid transparent`,
		userSelect: 'none',
		transition:
			'background-color ease-in 0.15s, border-color ease-in 0.15s, color ease-in 0.15s',
		'&:not(.disabled):hover': {
			backgroundColor: `${theme.palette.secondary.light}9e`,
			borderColor: theme.palette.primary.main,
			color: theme.palette.primary.main,
			cusor: 'pointer',
		},
		'&.disabled': {
			color: '#494949',
		},
	},
	closeBtn: {
		width: '100%',
		height: 65,
		lineHeight: '65px',
		textAlign: 'center',
		fontSize: 18,
		backgroundColor: `${theme.palette.secondary.light}`,
		border: `1px solid transparent`,
		userSelect: 'none',
		transition:
			'background-color ease-in 0.15s, border-color ease-in 0.15s, color ease-in 0.15s',
		'&:hover': {
			backgroundColor: `${theme.palette.secondary.light}9e`,
			borderColor: theme.palette.primary.main,
			color: theme.palette.primary.main,
			cusor: 'pointer',
		},
	},
	microActions: {
		display: 'flex',
		gap: 16,
	},
	microAction: {
		width: '100%',
		height: 35,
		lineHeight: '35px',
		textAlign: 'center',
		fontSize: 14,
		backgroundColor: `${theme.palette.secondary.light}`,
		border: `1px solid transparent`,
		userSelect: 'none',
		transition:
			'background-color ease-in 0.15s, border-color ease-in 0.15s, color ease-in 0.15s',
		'&:hover': {
			backgroundColor: `${theme.palette.secondary.light}9e`,
			borderColor: theme.palette.primary.main,
			color: theme.palette.primary.main,
			cusor: 'pointer',
		},
	},
	helpModal: {
		position: 'absolute',
		top: '50%',
		left: '50%',
		transform: 'translate(-50%, -50%)',
		width: 400,
		background: theme.palette.secondary.dark,
		boxShadow: 24,
		padding: 10,
	},
	actionBtn: {
		textAlign: 'center',
		marginTop: 15,
		padding: 10,
		color: theme.palette.text.main,
		backgroundColor: `${theme.palette.secondary.light}61`,
		border: `1px solid transparent`,
		transition: 'border ease-in 0.15s',
		'&:hover': {
			backgroundColor: `${theme.palette.secondary.light}61`,
			borderColor: theme.palette.primary.main,
			cursor: 'pointer',
		},

		'& svg': {
			marginLeft: 6,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const settings = useSelector((state) => state.app.settings);
	const mode = useSelector((state) => state.app.mode);
	const playerInventory = useSelector((state) => state.inventory.player);
	const secondaryInventory = useSelector(
		(state) => state.inventory.secondary,
	);
	const showSecondary = useSelector((state) => state.inventory.showSecondary);
	const showSplit = useSelector((state) => state.inventory.splitItem);
	const hover = useSelector((state) => state.inventory.hover);
	const hoverOrigin = useSelector((state) => state.inventory.hoverOrigin);
	const items = useSelector((state) => state.inventory.items);
	const inUse = useSelector((state) => state.inventory.inUse);

	const [showHelp, setShowHelp] = useState(false);
	const [modifyingShop, setModifyingShop] = useState(null);

	useEffect(() => {
		setModifyingShop(null);
	}, [playerInventory, secondaryInventory]);

	const onToggleSound = () => {
		Nui.send('UpdateSettings', {
			muted: !settings.muted,
		});
	};

	const calcPlayerWeight = () => {
		if (Object.keys(items) == 0 || !playerInventory.loaded) return 0;
		return playerInventory.inventory
			.filter((s) => Boolean(s))
			.reduce((a, b) => {
				return a + (items[b.Name]?.weight || 0) * b.Count;
			}, 0);
	};

	const calcSecondaryWeight = () => {
		if (Object.keys(items) == 0 || !secondaryInventory.loaded) return 0;
		return secondaryInventory.inventory
			.filter((s) => Boolean(s))
			.reduce((a, b) => {
				return a + (items[b.Name]?.weight || 0) * b.Count;
			}, 0);
	};

	const playerWeight = calcPlayerWeight();
	const secondaryWeight = calcSecondaryWeight();

	useEffect(() => {
		return () => {
			closeContext();
			closeSplitContext();
		};
	}, []);

	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
	});

	const canAddToShop = () => {
		if (Object.keys(items) == 0) return false;

		return (
			secondaryInventory.playerShop &&
			secondaryInventory.modifyShop &&
			!Boolean(inUse) &&
			Boolean(hover) &&
			Boolean(items[hover.Name]) &&
			hoverOrigin?.owner == playerInventory.owner &&
			(secondaryInventory?.inventory?.length ?? 50) < 50
		);
	};

	const canShiftClickToShop = () => {
		if (Object.keys(items) == 0) return false;

		return (
			secondaryInventory.playerShop &&
			secondaryInventory.modifyShop &&
			!Boolean(inUse) &&
			(secondaryInventory?.inventory?.length ?? 50) < 50
		);
	};

	const isUsable = () => {
		if (Object.keys(items) == 0 || mode != 'inventory') return false;

		return (
			!Boolean(inUse) &&
			Boolean(hover) &&
			Boolean(items[hover.Name]) &&
			hoverOrigin?.owner == playerInventory.owner &&
			items[hover.Name].isUsable &&
			(!Boolean(items[hover.Name].durability) ||
				hover?.CreateDate + items[hover.Name].durability >
					Date.now() / 1000)
		);
	};

	const onRightClick = (
		e,
		owner,
		invType,
		isShop,
		isFree,
		item,
		vehClass = false,
		vehModel = false,
	) => {
		e.preventDefault();
		if (Object.keys(items) == 0) return;
		if (hoverOrigin != null) return;
		if (!Boolean(items[item.Name]) || items[item.Name]?.invalid) return;

		setOffset({ left: e.clientX - 2, top: e.clientY - 4 });

		if (
			(isShop &&
				!playerInventory.isWeaponEligble &&
				items[item.Name]?.type == 2) ||
			(items[item.Name]?.type == 10 &&
				secondaryInventory.owner ==
					`container:${item?.MetaData?.Container}`)
		) {
			Nui.send('FrontEndSound', 'DISABLED');
			return;
		}

		if (item.Name != null) {
			if (e.ctrlKey || !items[item.Name]?.isStackable) {
				dispatch({
					type: 'SET_HOVER',
					payload: {
						...item,
						slot: item?.Slot,
						owner: owner,
						shop: isShop,
						free: isFree,
						invType: invType,
						Count: 1,
					},
				});
				dispatch({
					type: 'SET_HOVER_ORIGIN',
					payload: {
						...item,
						slot: item?.Slot,
						owner: owner,
						shop: isShop,
						invType: invType,
						class: vehClass,
						model: vehModel,
					},
				});

				closeContext();
				closeSplitContext();
			} else if (e.shiftKey) {
				dispatch({
					type: 'SET_SPLIT_ITEM',
					payload: {
						owner,
						item,
						invType,
						shop: isShop,
						class: vehClass,
						model: vehModel,
					},
				});
			} else {
				dispatch({
					type: 'SET_HOVER',
					payload: {
						...item,
						slot: item?.Slot,
						owner: owner,
						shop: isShop,
						free: isFree,
						invType: invType,
						Count:
							item.Count > 1
								? Math.max(
										1,
										Math.min(
											Math.floor(item.Count / 2),
											10000,
										),
								  )
								: 1,
					},
				});
				dispatch({
					type: 'SET_HOVER_ORIGIN',
					payload: {
						...item,
						slot: item?.Slot,
						owner: owner,
						shop: isShop,
						invType: invType,
					},
				});

				closeContext();
				closeSplitContext();
			}
		}
	};

	const cancelDrag = (e) => {
		if (Boolean(hoverOrigin)) {
			Nui.send('FrontEndSound', 'DISABLED');
			dispatch({
				type: 'SET_HOVER',
				payload: null,
			});
			dispatch({
				type: 'SET_HOVER_ORIGIN',
				payload: null,
			});
		}
	};

	const closeContext = (e) => {
		if (e != null) e.preventDefault();
		dispatch({
			type: 'SET_CONTEXT_ITEM',
			payload: null,
		});
	};

	const closeSplitContext = (e) => {
		if (e != null) e.preventDefault();
		dispatch({
			type: 'SET_SPLIT_ITEM',
			payload: null,
		});
	};

	const onAction = () => {
		Nui.send('FrontEndSound', 'SELECT');
		Nui.send('SubmitAction', {
			owner: secondaryInventory.owner,
			invType: secondaryInventory.invType,
		});
	};

	const onAddToShop = async (e) => {
		e.preventDefault();

		try {
			Nui.send('FrontEndSound', 'SELECT');
			let res = await (
				await Nui.send('AddToShop', {
					ownerFrom: playerInventory.owner,
					invTypeFrom: playerInventory.invType,
					slotFrom: modifyingShop.slotFrom,
					ownerTo: secondaryInventory.owner,
					invTypeTo: secondaryInventory.invType,
					slotTo: modifyingShop.slotTo,
					price: +e.target.price.value,
					quantity: +e.target.quantity.value,
				})
			).json();

			if (Boolean(res)) {
				dispatch({
					type: 'SET_INVENTORIES',
					payload: {
						player: {
							inventory: res.player,
						},
						secondary: {
							inventory: res.secondary,
						},
					},
				});
			} else {
			}
		} catch (err) {
			console.error(err);
		}

		setModifyingShop(null);
	};

	const onClose = () => {
		dispatch({
			type: 'SET_CONTEXT_ITEM',
			payload: null,
		});
		dispatch({
			type: 'SET_SPLIT_ITEM',
			payload: null,
		});
		closeInventory();
	};

	return (
		<Fragment>
			<Fade in={Boolean(playerInventory.loaded)}>
				<div className={classes.centerBtns}>
					<div
						className={`${classes.useBtn}${
							!isUsable() ? ' disabled' : ''
						}`}
						onMouseUp={() => {
							if (
								!Boolean(hover) ||
								hover?.invType != 1 ||
								!isUsable()
							)
								return;
							useItem(hover?.owner, hover?.Slot, hover?.invType);
							dispatch({
								type: 'USE_ITEM_PLAYER',
								payload: {
									originSlot: hover?.Slot,
								},
							});
							dispatch({
								type: 'SET_HOVER',
								payload: null,
							});
							dispatch({
								type: 'SET_HOVER_ORIGIN',
								payload: null,
							});
						}}
					>
						USE
					</div>
					<div className={classes.closeBtn} onClick={onClose}>
						CLOSE
					</div>
					<div className={classes.microActions}>
						<Tooltip title="Show UI Help">
							<div
								className={classes.microAction}
								onClick={() => setShowHelp(true)}
							>
								<FontAwesomeIcon icon={['fas', 'question']} />
							</div>
						</Tooltip>

						<Tooltip
							title={
								Boolean(settings.muted)
									? 'Unmute UI Sounds'
									: 'Mute UI Sounds'
							}
						>
							<div
								className={classes.microAction}
								onClick={onToggleSound}
							>
								{Boolean(settings.muted) ? (
									<FontAwesomeIcon
										color="red"
										icon={['fas', 'volume-xmark']}
									/>
								) : (
									<FontAwesomeIcon
										color="green"
										icon={['fas', 'volume-high']}
									/>
								)}
							</div>
						</Tooltip>
					</div>
				</div>
			</Fade>
			<div className={classes.root} onClick={cancelDrag}>
				<div className={classes.gridBg} onClick={cancelDrag}>
					<div className={classes.inventoryHeader}>
						{playerInventory.name}
					</div>
					<div className={classes.container}>
						<div className={classes.inventoryWeight}>
							<div className={classes.weightText}>
								{`${playerWeight.toFixed(
									2,
								)} / ${playerInventory.capacity.toFixed(2)}`}
							</div>
							<LinearProgress
								className={classes.inventoryWeightBar}
								color="primary"
								variant="determinate"
								value={Math.floor(
									(playerWeight / playerInventory.capacity) *
										100,
								)}
							/>
						</div>
						<div className={classes.inventoryGrid}>
							{playerInventory.loaded &&
								[...Array(playerInventory.size).keys()].map(
									(value) => {
										let slot =
											playerInventory.inventory.filter(
												(s) =>
													Boolean(s) &&
													s.Slot == value + 1,
											)
												? playerInventory.inventory.filter(
														(s) =>
															Boolean(s) &&
															s.Slot == value + 1,
												  )[0]
												: {};
										return (
											<Slot
												key={value + 1}
												onUse={useItem}
												canAddToShop={
													canShiftClickToShop
												}
												onAddToShop={setModifyingShop}
												slot={value + 1}
												data={slot}
												owner={playerInventory.owner}
												invType={
													playerInventory.invType
												}
												shop={false}
												free={false}
												hotkeys={true}
												playerCapacity={
													playerInventory.capacity
												}
												playerWeight={playerWeight}
												secondaryCapacity={
													Boolean(
														secondaryInventory.capacityOverride,
													)
														? secondaryInventory.capacityOverride
														: secondaryInventory.capacity
												}
												secondaryWeight={
													secondaryWeight
												}
												onContextMenu={(e) => {
													if (
														playerInventory
															.disabled[value + 1]
													)
														return;
													onRightClick(
														e,
														playerInventory.owner,
														playerInventory.invType,
														false,
														false,
														slot,
													);
												}}
												locked={
													playerInventory.disabled[
														value + 1
													]
												}
											/>
										);
									},
								)}
						</div>
					</div>
				</div>
				{mode == 'crafting' ? (
					<div className={classes.gridBg}>
						<div className={classes.inventoryHeader}>Crafting</div>
						<div className={classes.container}>
							<Crafting />
						</div>
					</div>
				) : (
					<Fade in={showSecondary}>
						<div className={classes.gridBg}>
							<div className={classes.inventoryHeader}>
								{secondaryInventory.name}
							</div>
							<div className={classes.container}>
								<div className={classes.inventoryWeight}>
									{!secondaryInventory.shop &&
										!secondaryInventory.playerShop && (
											<>
												<div
													className={
														classes.weightText
													}
												>
													{`${secondaryWeight.toFixed(
														2,
													)} / ${secondaryInventory.capacity.toFixed(
														2,
													)}`}
												</div>
												<LinearProgress
													className={
														classes.inventoryWeightBar
													}
													color="primary"
													variant="determinate"
													value={
														secondaryInventory.shop
															? 0
															: Math.floor(
																	(secondaryWeight /
																		secondaryInventory.capacity) *
																		100,
															  )
													}
												/>
											</>
										)}
								</div>
								<div className={classes.inventoryGrid}>
									{secondaryInventory.loaded &&
										[
											...Array(
												secondaryInventory.size,
											).keys(),
										].map((value) => {
											let slot =
												secondaryInventory.inventory.filter(
													(s) =>
														Boolean(s) &&
														s.Slot == value + 1,
												)
													? secondaryInventory.inventory.filter(
															(s) =>
																Boolean(s) &&
																s.Slot ==
																	value + 1,
													  )[0]
													: {};
											return (
												<Slot
													secondary
													canAddToShop={canAddToShop}
													onAddToShop={
														setModifyingShop
													}
													slot={value + 1}
													key={value + 1}
													data={slot}
													owner={
														secondaryInventory.owner
													}
													invType={
														secondaryInventory.invType
													}
													shop={
														secondaryInventory.shop
													}
													free={
														secondaryInventory.free
													}
													playerShop={
														secondaryInventory.playerShop
													}
													vehClass={
														secondaryInventory.class
													}
													vehModel={
														secondaryInventory.model
													}
													slotOverride={
														secondaryInventory.slotOverride
													}
													capacityOverride={
														secondaryInventory.capacityOverride
													}
													hotkeys={false}
													playerCapacity={
														playerInventory.capacity
													}
													playerWeight={playerWeight}
													secondaryCapacity={
														Boolean(
															secondaryInventory.capacityOverride,
														)
															? secondaryInventory.capacityOverride
															: secondaryInventory.capacity
													}
													secondaryWeight={
														secondaryWeight
													}
													onContextMenu={(e) => {
														if (
															secondaryInventory
																.disabled[
																value + 1
															]
														)
															return;
														onRightClick(
															e,
															secondaryInventory.owner,
															secondaryInventory.invType,
															secondaryInventory.shop,
															secondaryInventory.free,
															slot,
															secondaryInventory.class,
															secondaryInventory.model,
														);
													}}
													locked={
														secondaryInventory
															.disabled[value + 1]
													}
												/>
											);
										})}
								</div>
							</div>
							{Boolean(secondaryInventory.action) && (
								<Button
									fullWidth
									color="primary"
									className={classes.actionBtn}
									onClick={onAction}
								>
									{secondaryInventory.action.text}
									<FontAwesomeIcon
										icon={[
											'fas',
											secondaryInventory.action.icon ||
												'up-right-from-square',
										]}
									/>
								</Button>
							)}
						</div>
					</Fade>
				)}
			</div>

			<Modal open={showHelp} onClose={() => setShowHelp(false)}>
				<Box className={classes.helpModal}>
					<Typography
						id="modal-modal-title"
						variant="h6"
						component="h2"
					>
						Inventory Keys
					</Typography>
					<Typography id="modal-modal-description" sx={{ mt: 2 }}>
						Our inventory makes use of some hotkeys to facilitate
						quick operations. These keys can be found below;
					</Typography>
					<ul>
						<li>
							<b>Shift Left Click: </b>Quick Transfer. Move Stack
							To Other Inventory (If Possible)
						</li>
						<li>
							<b>Shift Right Click: </b>Split Stack. Brings Up
							Prompt To Split Stack (If Possible)
						</li>
						<li>
							<b>Control Left Click: </b>Half Stack. Starts
							Dragging Half Of The Selected Stack (If Possible)
						</li>
						<li>
							<b>Control Right Click: </b>Single Item. Starts
							Dragging A Single Item Of The Selected Stack
						</li>
						<li>
							<b>Middle Mouse Button: </b>Use Item. Uses Selected
							Item (If Possible)
						</li>
					</ul>
				</Box>
			</Modal>

			{showSplit != null ? (
				<Menu
					keepMounted
					onClose={closeSplitContext}
					onContextMenu={closeSplitContext}
					open={!!showSplit}
					anchorReference="anchorPosition"
					anchorPosition={offset}
					TransitionComponent={Fade}
				>
					<MenuItem disabled>Split Stack</MenuItem>
					<Split data={showSplit} />
				</Menu>
			) : null}

			{Boolean(modifyingShop) && (
				<Dialog
					fullWidth
					maxWidth="sm"
					open={Boolean(modifyingShop)}
					onClose={() => setModifyingShop(null)}
				>
					<form onSubmit={onAddToShop}>
						<DialogTitle>
							Add {items[modifyingShop.Name].label} To Shop
						</DialogTitle>
						<DialogContent>
							<Grid container spacing={2} style={{ padding: 8 }}>
								<Grid item xs={12}>
									<TextField
										fullWidth
										name="quantity"
										label="Quantity"
										type="number"
										inputProps={{
											min: 1,
											max: modifyingShop.Count,
										}}
										disabled={
											!Boolean(
												items[modifyingShop.Name]
													.isStackable,
											)
										}
										defaultValue={modifyingShop.Count}
									/>
								</Grid>
								<Grid item xs={12}>
									<TextField
										fullWidth
										name="price"
										label="Price Per Unit"
										type="number"
										inputProps={{
											min: 0,
											max: 4000000000,
										}}
										defaultValue={
											items[modifyingShop.Name].price
										}
									/>
								</Grid>
							</Grid>
						</DialogContent>
						<DialogActions>
							<Button onClick={() => setModifyingShop(null)}>
								Cancel
							</Button>
							<Button type="submit">Add</Button>
						</DialogActions>
					</form>
				</Dialog>
			)}
		</Fragment>
	);
};

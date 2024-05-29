import React, { useEffect, useState, useMemo } from 'react';
import { Button, Grid, IconButton, TextField } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch, useSelector } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { NumericFormat } from 'react-number-format';
import ReactMomentCountDown from 'react-moment-countdown';
import Moment from 'react-moment';
import { throttle } from 'lodash';

import Nui from '../../util/Nui';
import OutputSlot from './OutputSlot';
import RecipeMats from './RecipeMats';
import { fallbackItem } from '../Inventory/item';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		border: `1px solid ${theme.palette.border.divider}`,
		maxWidth: 'calc(50% - 6px)',
		width: '100%',
		position: 'relative',
	},
	recipe: {
		display: 'flex',
		width: '100%',
	},
	right: {
		width: '100%',
		borderLeft: `1px solid ${theme.palette.border.divider}`,
	},
	craftBtn: {
		width: '100%',
		borderRadius: 0,
		borderRight: `1px solid ${theme.palette.border.divider}`,
		marginTop: 4,
		width: '35%',
		'&.Mui-disabled': {
			background: '#1e1e1e',
		},
	},
	count: {
		color: theme.palette.primary.main,
		fontWeight: 'bold',
		marginRight: 2,
		fontSize: 16,
		'&::after': {
			content: '"x"',
		},
	},
	input: {
		width: 25,
		'& input': {
			textAlign: 'center',
			color: theme.palette.primary.main,
		},
		'& input::-webkit-clear-button, & input::-webkit-outer-spin-button, & input::-webkit-inner-spin-button':
			{
				display: 'none',
			},
	},
	onCooldown: {
		position: 'absolute',
		background: '#000000cf',
		width: '100%',
		height: '100%',
		zIndex: 100,

		'& .inner': {
			width: 'fit-content',
			height: 'fit-content',
			position: 'absolute',
			top: 0,
			bottom: 0,
			left: 0,
			right: 0,
			margin: 'auto',
			textAlign: 'center',

			'& .time': {
				marginLeft: 4,
				color: theme.palette.primary.main,
				fontWeight: 'bold',
			},
		},
	},
	btnContainer: {
		display: 'flex',
	},
	ph: {
		flexGrow: 1,
		height: 40,
	},
}));

const Recipe = ({ identifier, recipe, cooldown }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const items = useSelector((state) => state.inventory.items);
	const bench = useSelector((state) => state.crafting.bench);
	const myInventory = useSelector((state) => state.inventory.player);

	const outputItem = items[recipe.result.name] ?? fallbackItem;

	const max = Math.floor(outputItem.isStackable / recipe.result.count);

	const [crafting, setCrafting] = useState(false);
	const [counts, setCounts] = useState(Object());

	useEffect(() => {
		if (!Boolean(myInventory?.inventory)) return;
		setCounts(
			myInventory.inventory.reduce((obj, item) => {
				obj[item.Name] = obj[item.Name] ?? 0;
				obj[item.Name] += item.Count;
				return obj;
			}, Object()),
		);
	}, [myInventory]);

	const [qty, setQty] = useState(1);

	const calcPlayerWeight = () => {
		if (Object.keys(items) == 0 || !myInventory.loaded) return 0;
		return myInventory.inventory
			.filter((s) => Boolean(s))
			.reduce((a, b) => {
				return a + (items[b.Name]?.weight || 0) * b.Count;
			}, 0);
	};
	const playerWeight = calcPlayerWeight();

	const hasReagents = () => {
		let reagents = Object(); // Doing this so if some douche adds the same item multiple times it'll check for all
		recipe.items.map((item, k) => {
			if (!Boolean(reagents[item.name]))
				reagents[item.name] = item.count * qty;
			else reagents[item.name] += item.count * qty;
		});

		for (const item in reagents) {
			if (!Boolean(counts[item]) || reagents[item] > counts[item])
				return false;
		}

		return true;
	};

	const onCraft = useMemo(
		() =>
			throttle(async (value) => {
				if (
					playerWeight +
						outputItem.weight * recipe.result.count * qty >
					myInventory.capacity
				)
					return;

				setCrafting(true);

				try {
					let res = await (
						await Nui.send('Crafting:Craft', {
							bench,
							qty,
							result: identifier,
						})
					).json();

					if (Boolean(res)) {
						dispatch({
							type: 'SET_PLAYER_INVENTORY',
							payload: {
								disabled: false,
								inventory: res.inventory,
							},
						});
						dispatch({
							type: 'UPDATE_COOLDOWNS',
							payload: {
								cooldowns: res.cooldowns,
							},
						});
						setQty(1);
					}

					setCrafting(false);
				} catch (err) {
					console.log(err);
					setCrafting(false);
				}
			}, 3000),
		[recipe, qty, playerWeight, myInventory],
	);

	const onQtyChange = (change) => {
		if (Boolean(cooldown)) return;

		if ((change < 0 && qty <= 1) || (change > 1 && qty >= max)) return;
		setQty(qty + change);
	};

	return (
		<div className={classes.wrapper}>
			{Boolean(cooldown) && cooldown > Date.now() && (
				<div className={classes.onCooldown}>
					<div className="inner">
						On Cooldown, Available In
						<Moment
							className="time"
							date={cooldown}
							interval={1000}
							fromNow
						/>
					</div>
				</div>
			)}
			<div className={classes.recipe}>
				<OutputSlot
					qty={qty}
					recipe={recipe}
					result={recipe.result}
					item={items[recipe.result.name] ?? fallbackItem}
				/>
				<div className={classes.right}>
					<RecipeMats
						qty={qty}
						recipe={recipe}
						counts={counts}
						materials={recipe.items}
					/>
					<div className={classes.btnContainer}>
						{max > 1 ? (
							<Grid container>
								<Grid
									item
									xs={4}
									style={{ textAlign: 'center' }}
								>
									<IconButton
										disabled={Boolean(cooldown) || qty <= 1}
										onClick={() => onQtyChange(-1)}
									>
										<FontAwesomeIcon
											icon={['fas', 'minus']}
										/>
									</IconButton>
								</Grid>
								<Grid
									item
									xs={4}
									style={{ textAlign: 'center' }}
								>
									<span>
										<NumericFormat
											className={classes.input}
											value={qty}
											onChange={(e) =>
												setQty(+e.target.value)
											}
											isAllowed={({ floatValue }) => {
												return (
													floatValue >= 1 &&
													floatValue <= max
												);
											}}
											disabled={Boolean(cooldown)}
											type="tel"
											variant="standard"
											customInput={TextField}
										/>
									</span>
								</Grid>
								<Grid
									item
									xs={4}
									style={{ textAlign: 'center' }}
								>
									<IconButton
										disabled={
											Boolean(cooldown) || qty >= max
										}
										onClick={() => onQtyChange(1)}
									>
										<FontAwesomeIcon
											icon={['fas', 'plus']}
										/>
									</IconButton>
								</Grid>
							</Grid>
						) : (
							<div className={classes.ph} />
						)}
						<Button
							variant="contained"
							color="info"
							disabled={
								Boolean(crafting) ||
								!hasReagents() ||
								(Boolean(recipe.cooldown) &&
									Boolean(cooldown) &&
									cooldown > Date.now()) ||
								playerWeight +
									outputItem.weight *
										recipe.result.count *
										qty >
									myInventory.capacity
							}
							className={classes.craftBtn}
							onClick={onCraft}
						>
							{Boolean(crafting) || !hasReagents() ? (
								<FontAwesomeIcon icon={['fas', 'ban']} />
							) : playerWeight +
									outputItem.weight *
										recipe.result.count *
										qty >
							  myInventory.capacity ? (
								<FontAwesomeIcon
									icon={['fas', 'weight-hanging']}
								/>
							) : (
								<FontAwesomeIcon icon={['fas', 'hammer']} />
							)}
						</Button>
					</div>
				</div>
			</div>
		</div>
	);
};

export default Recipe;

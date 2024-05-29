import React, { useEffect, useState } from 'react';
import {
	TextField,
	InputAdornment,
	IconButton,
	Alert,
	CircularProgress,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useSelector } from 'react-redux';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Recipe from './recipe';
import { filter } from 'lodash';

const useStyles = makeStyles((styles) => ({
	craftingContainer: {
		minWidth: 678,
	},
	search: {
		marginTop: 8,
		marginBottom: 8,
	},
	recipes: {
		maxHeight: 'calc(60vh - 170px)',
		overflowX: 'hidden',
		overflowY: 'auto',
		gap: 8,
		display: 'flex',
		flexWrap: 'wrap',
		justifyContent: 'space-between',
		maxWidth: 870,
		width: '100%',
	},
}));

const Crafting = () => {
	const classes = useStyles();
	const items = useSelector((state) => state.inventory.items);
	const cooldowns =
		useSelector((state) => state.crafting.cooldowns) || Object();
	const recipes = useSelector((state) => state.crafting.recipes);
	const crafting = useSelector((state) => state.crafting.crafting);

	const [filtered, setFiltered] = useState(recipes ?? Array());
	const [search, setSearch] = useState('');

	useEffect(() => {
		if (!Boolean(recipes)) return;
		if (search == '') {
			setFiltered(recipes);
		} else {
			setFiltered(
				recipes.filter(
					(r) =>
						Boolean(items[r.result.name]) &&
						items[r.result.name].label
							.toLowerCase()
							.includes(search.toLowerCase()),
				),
			);
		}
	}, [search, recipes, items]);

	const onChange = (e) => {
		setSearch(e.target.value);
	};

	return (
		<div className={classes.craftingContainer}>
			<div className={classes.search}>
				<TextField
					fullWidth
					className={classes.search}
					label="Search"
					variant="outlined"
					value={search}
					onChange={onChange}
					disabled={Boolean(crafting)}
					InputProps={{
						startAdornment: (
							<InputAdornment position="start">
								<FontAwesomeIcon
									icon={['fas', 'magnifying-glass']}
								/>
							</InputAdornment>
						),
						endAdornment: (
							<InputAdornment position="end">
								<IconButton
									onClick={() => setSearch('')}
									edge="end"
								>
									{Boolean(search) && (
										<FontAwesomeIcon icon={['fas', 'x']} />
									)}
								</IconButton>
							</InputAdornment>
						),
					}}
				/>
			</div>

			<div className={classes.recipes}>
				{filtered.map((recipe, k) => {
					return (
						<Recipe
							key={`recipe-${k}`}
							identifier={recipe.id}
							recipe={recipe}
							cooldown={cooldowns[recipe.id]}
						/>
					);
				})}
			</div>
		</div>
	);
};

export default Crafting;

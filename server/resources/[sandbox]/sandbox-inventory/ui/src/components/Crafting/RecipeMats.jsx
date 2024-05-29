import React, { Fragment, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { fallbackItem } from '../Inventory/item';

const useStyles = makeStyles((theme) => ({
	mats: {
		width: '100%',
		height: 150,
		overflow: 'auto',
	},
	material: {
		display: 'flex',
		'&:not(:last-of-type)': {
			marginBottom: 4,
		},
	},
	img: {
		height: 20,
		width: 20,
		backgroundSize: '70%',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
	},
	label: {
		flexGrow: 1,
		maxWidth: 'calc(100% - 20px)',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		whiteSpace: 'nowrap',
		lineHeight: '20px',

		'&.missing': {
			color: theme.palette.error.light,
		},

		'& small': {
			marginLeft: 8,
		},
	},
}));

export default ({ recipe, materials, counts, qty }) => {
	const classes = useStyles();
	const items = useSelector((state) => state.inventory.items);

	const reagents = materials.reduce((obj, k) => {
		obj[k.name] = obj[k.name] ?? 0;
		obj[k.name] += k.count;
		return obj;
	}, {});

	const getIcon = (itemData) => {
		if (Boolean(itemData.iconOverride)) {
			return `../images/items/${itemData.iconOverride}.webp`;
		} else {
			return `../images/items/${itemData.name}.webp`;
		}
	};

	return (
		<div className={classes.mats}>
			{Object.keys(reagents).map((item, k) => {
				let itemData = items[item] ?? fallbackItem;
				if (Boolean(itemData)) {
					return (
						<div
							key={`recipe-${recipe.id}-${k}`}
							className={classes.material}
						>
							<div
								className={classes.img}
								style={{
									backgroundImage: `url(${getIcon(
										itemData,
									)})`,
								}}
							></div>
							<div
								className={`${classes.label} ${
									(counts[item] ?? 0) >= reagents[item] * qty
										? ''
										: 'missing'
								}`}
							>
								{itemData.label}
								<small>
									{counts[item] ?? 0} / {reagents[item] * qty}
								</small>
							</div>
						</div>
					);
				} else return null;
			})}
		</div>
	);
};

import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import { getItemLabel, itemLabels, itemRarities } from '../Inventory/item';

export default ({ item, count }) => {
	const items = useSelector((state) => state.inventory.items);
	const useStyles = makeStyles((theme) => ({
		body: {
			minWidth: 250,
			maxWidth: 400,
		},
		itemName: {
			fontSize: 24,
			color: theme.palette.text.main,
		},
		itemType: {
			fontSize: 16,
			color: theme.palette.text.main,
		},
		usable: {
			fontSize: 16,
			color: theme.palette.success.light,
			'&::before': {
				color: theme.palette.text.main,
				content: '" - "',
			},
		},
		tooltipDetails: {
			marginTop: 4,
			paddingTop: 4,
			borderTop: `1px solid ${theme.palette.border.input}`,
		},
		tooltipValue: {
			fontSize: 14,
			color: theme.palette.text.alt,
		},
		stackable: {
			fontSize: 10,
			marginLeft: 2,
		},
		description: {
			paddingLeft: 20,
			fontSize: 16,
			color: theme.palette.text.alt,
		},
	}));
	const classes = useStyles();

	const getTypeLabel = () => {
		if (Boolean(itemLabels[item.type])) return itemLabels[item.type];
		else return item.type;
	};

	const getRarityLabel = () => {
		if (Boolean(itemRarities[item.rarity])) return itemRarities[item.rarity]
		else return 'Dogshit';
	};

	if (!Boolean(item)) return null;
	return (
		<div className={classes.body}>
			<div className={classes.itemName}>{getItemLabel(null, item)}</div>
			<div className={classes.itemType}>
				{getTypeLabel()}
				{Boolean(item.isUsable) && (
					<span className={classes.usable}>Usable</span>
				)}
			</div>

			{Boolean(item.description) && (
				<div className={classes.description}>{item.description}</div>
			)}

			{Boolean(item?.component) && (
				<div className={classes.attachFitment}>
					<span className={classes.metafield}>
						<b>Attachment Fits On</b>:{' '}
						<ul className={classes.attchList}>
							{Object.keys(item.component.strings).length <=
							10 ? (
								Object.keys(item.component.strings).map(
									(weapon) => {
										let wepItem = items[weapon];
										if (!Boolean(wepItem)) return null;
										return <li>{wepItem.label}</li>;
									},
								)
							) : (
								<span>Fits On Most Weapons</span>
							)}
						</ul>
					</span>
				</div>
			)}
			{Boolean(item.schematic) &&
				Boolean(items[item.schematic.result.name]) && (
					<div className={classes.attachFitment}>
						<span className={classes.metafield}>
							<b>Teaches</b>:
							{` Crafting x${item.schematic.result.count} ${
								items[item.schematic.result.name].label
							}`}
						</span>
					</div>
				)}
			<div className={classes.tooltipDetails}>
				Weight:{' '}
				<span className={classes.tooltipValue}>
					{item?.weight || 0} lbs
					{count > 1 && (
						<span className={classes.stackable}>
							(Total: {(item?.weight || 0) * count} lbs)
						</span>
					)}
				</span>
				{' | '}Count:{' '}
				<span className={classes.tooltipValue}>
					{count}
					{Boolean(item.isStackable) && item.isStackable > 0 && (
						<span className={classes.stackable}>
							(Max Stack: {item.isStackable})
						</span>
					)}
				</span>
			</div>
		</div>
	);
};

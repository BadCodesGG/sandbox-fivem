import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { LinearProgress } from '@mui/material';
import { fallbackItem, getItemImage, getItemLabel } from '../Inventory/item';

const useStyles = makeStyles((theme) => ({
	container: {
		width: 300,
		pointerEvents: 'none',
		zIndex: 1,
		background: `${theme.palette.secondary.dark}80`,
		borderLeft: `4px solid ${theme.palette.primary.main}`,

		'&.equipped': {
			marginTop: 24,
		},

		'&.empty': {
			borderColor: theme.palette.secondary.light,
		},

		'&.broken': {
			backgroundColor: `${theme.palette.error.dark}4a`,
		},
	},
	info: {
		display: 'flex',
	},
	label: {
		color: theme.palette.text.main,
		fontSize: 18,
		lineHeight: '20px',
		textShadow: '0 0 5px #000',
		flex: 1,
		height: 'fit-content',
		paddingTop: 15,
		paddingLeft: 5,
		paddingRight: 5,
		width: 188,
		'& small': {
			fontSize: 12,
			display: 'block',
		},
	},
	image: {
		height: 60,
		width: 60,
		backgroundSize: '70%',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
		borderRight: `1px solid ${theme.palette.border.divider}`,
	},
	count: {
		height: 60,
		width: 48,
		textAlign: 'center',
		lineHeight: '60px',
		borderLeft: `1px solid ${theme.palette.border.divider}`,
	},
	durability: {
		width: '100%',
		maxWidth: '100%',
		overflow: 'hidden',
		height: 4,
		background: 'transparent',
		zIndex: 4,
	},
	progressbar: {
		transition: 'none !important',
	},
	itemName: {
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
}));

export default ({ item, slot, equipped }) => {
	const classes = useStyles();
	const items = useSelector((state) => state.inventory.items);

	const itemData = Boolean(item) ? items[item?.Name] ?? fallbackItem : null;

	const calcDurability = () => {
		if (!Boolean(item?.CreateDate) || !Boolean(itemData?.durability)) null;
		return Math.ceil(
			100 -
				((Math.floor(Date.now() / 1000) - item?.CreateDate) /
					itemData?.durability) *
					100,
		);
	};

	const durability = calcDurability();

	const broken = durability <= 0;

	return (
		<div
			className={`${classes.container} ${
				Boolean(item) ? 'occupied' : 'empty'
			} ${equipped ? 'equipped' : ''}${broken ? ' broken' : ''}`}
		>
			<div className={classes.info}>
				{Boolean(itemData) ? (
					<div
						className={classes.image}
						style={{
							backgroundImage: `url(${getItemImage(
								item,
								itemData,
							)})`,
						}}
					></div>
				) : (
					<div className={classes.image}></div>
				)}
				{Boolean(itemData) ? (
					<div className={classes.label}>
						<div className={classes.itemName}>
							{getItemLabel(item, itemData)}
						</div>
						{equipped ? (
							<small>Equipped</small>
						) : (
							<small>Quantity: {item.Count}</small>
						)}
					</div>
				) : (
					<div className={classes.label}></div>
				)}
				<div className={classes.count}>
					{Boolean(slot) ? slot : '-'}
				</div>
			</div>
			{Boolean(itemData?.durability) &&
				Boolean(item?.CreateDate) &&
				(durability > 0 ? (
					<LinearProgress
						className={classes.durability}
						color="primary"
						classes={{
							determinate: classes.progressbar,
							bar: classes.progressbar,
							bar1: classes.progressbar,
						}}
						variant="determinate"
						value={durability}
					/>
				) : null)}
		</div>
	);
};

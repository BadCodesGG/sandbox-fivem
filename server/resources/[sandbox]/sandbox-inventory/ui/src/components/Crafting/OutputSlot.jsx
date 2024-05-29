import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Popover } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Tooltip from './Tooltip';
import { closeInventory } from '../Inventory/actions';

const useStyles = makeStyles((theme) => ({
	item: {},
	img: {
		height: 190,
		width: 170,
		overflow: 'hidden',
		zIndex: 3,
		backgroundSize: '50%',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
	},
	label: {
		bottom: 0,
		left: 0,
		position: 'absolute',
		textAlign: 'center',
		padding: '0 5px',
		width: '100%',
		maxWidth: '100%',
		overflow: 'hidden',
		whiteSpace: 'nowrap',
		color: theme.palette.text.main,
		background: theme.palette.secondary.light,
		borderTop: `1px solid ${theme.palette.border.divider}`,
		zIndex: 4,
	},
	slot: {
		width: 170,
		height: 190,
		backgroundColor: `${theme.palette.secondary.light}61`,
		position: 'relative',
		zIndex: 2,
		'&.mini': {
			width: 132,
			height: 152,
		},
	},
	count: {
		top: 0,
		right: 0,
		position: 'absolute',
		textAlign: 'right',
		padding: '0 5px',
		textShadow: `0 0 5px ${theme.palette.secondary.dark}`,
		color: theme.palette.text.main,
		zIndex: 4,
	},
	price: {
		top: 0,
		left: 0,
		position: 'absolute',
		padding: '0 5px',
		textShadow: `0 0 5px ${theme.palette.secondary.dark}`,
		color: theme.palette.success.main,
		zIndex: 4,
		'&::before': {
			content: '"$"',
			marginRight: 2,
			color: theme.palette.text.main,
		},
	},
	durability: {
		bottom: 30,
		left: 0,
		position: 'absolute',
		width: '100%',
		maxWidth: '100%',
		overflow: 'hidden',
		height: 7,
		background: 'transparent',
		zIndex: 4,
	},
	broken: {
		backgroundColor: theme.palette.text.alt,
		transition: 'none !important',
	},
	progressbar: {
		transition: 'none !important',
	},
	popover: {
		pointerEvents: 'none',
	},
	paper: {
		padding: 20,
		border: `1px solid ${theme.palette.border.divider}`,
	},
}));

export default ({ recipe, result, item, qty }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hidden = useSelector((state) => state.app.hidden);

	const getIcon = () => {
		if (Boolean(item) && Boolean(item.iconOverride)) {
			return `../images/items/${item.iconOverride}.webp`;
		} else {
			return `../images/items/${item.name}.webp`;
		}
	};

	const [resultEl, setResultEl] = useState(null);
	const resultOpen = Boolean(resultEl);
	const resultTPOpen = (event) => {
		setResultEl(event.currentTarget);
	};

	const resultTPClose = (e, reason) => {
		setResultEl(null);

		if (reason == 'escapeKeyDown') {
			dispatch({
				type: 'SET_CONTEXT_ITEM',
				payload: null,
			});
			dispatch({
				type: 'SET_SPLIT_ITEM',
				payload: null,
			});
			closeInventory();
		}
	};

	return (
		<div
			className={classes.item}
			onMouseEnter={resultTPOpen}
			onMouseLeave={resultTPClose}
		>
			<div className={`${classes.slot} rarity-${item.rarity}`}>
				<div
					className={classes.img}
					style={{
						backgroundImage: `url(${getIcon()})`,
					}}
				></div>
				<div className={classes.label}>{item.label}</div>
				{result.count > 0 && (
					<div className={classes.count}>{result.count * qty}</div>
				)}
			</div>

			{Boolean(item) && (
				<Popover
					className={classes.popover}
					classes={{
						paper: classes.paper,
					}}
					open={resultOpen && !hidden}
					anchorEl={resultEl}
					anchorOrigin={{
						vertical: 'center',
						horizontal: 'left',
					}}
					transformOrigin={{
						vertical: 'center',
						horizontal: 'right',
					}}
					onClose={resultTPClose}
					transitionDuration={100}
				>
					<Tooltip item={item} count={recipe.result.count} />
				</Popover>
			)}
		</div>
	);
};

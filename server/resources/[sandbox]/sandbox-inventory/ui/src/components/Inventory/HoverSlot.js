import React, { Fragment, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { fallbackItem, getItemImage, getItemLabel } from './item';

const initialState = {
	mouseX: null,
	mouseY: null,
};
const useStyles = makeStyles((theme) => ({
	hover: {
		position: 'absolute',
		top: 0,
		left: 0,
		pointerEvents: 'none',
		zIndex: 1,
	},
	img: {
		height: 190,
		width: '100%',
		overflow: 'hidden',
		zIndex: 3,
		backgroundSize: '50%',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
	},
	label: {
		bottom: 7,
		left: 0,
		right: 0,
		position: 'absolute',
		textAlign: 'center',
		padding: '0 5px',
		width: '100%',
		zIndex: 4,
		margin: 'auto',
		maxWidth: '90%',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		whiteSpace: 'nowrap',
	},
	slot: {
		width: 165,
		height: 190,
		position: 'relative',
		zIndex: 2,
		border: '1px solid #1c1c1c6e',
		'&.mini': {
			width: 132,
			height: 152,
		},
		'&:not(.broken)': {
			backgroundColor: `${theme.palette.secondary.light}61`,
		},
		'&.broken': {
			backgroundColor: `${theme.palette.error.dark}4a`,
			borderColor: `${theme.palette.error.dark}6e`,
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
		bottom: 0,
		left: 0,
		position: 'absolute',
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
}));

export default (props) => {
	const classes = useStyles();
	const hover = useSelector((state) => state.inventory.hover);
	const items = useSelector((state) => state.inventory.items);
	const [state, setState] = React.useState(initialState);

	const itemData = Boolean(hover) ? items[hover.Name] ?? fallbackItem : null;

	const calcDurability = () => {
		if (!Boolean(hover) || !Boolean(itemData?.durability)) null;
		return Math.ceil(
			100 -
				((Math.floor(Date.now() / 1000) - hover?.CreateDate) /
					itemData?.durability) *
					100,
		);
	};
	const durability = calcDurability();

	const broken = durability <= 0;

	const mouseMove = (event) => {
		event.preventDefault();
		setState({
			mouseX: event.clientX,
			mouseY: event.clientY,
		});
	};

	useEffect(() => {
		document.addEventListener('mousemove', mouseMove);
		return () => document.removeEventListener('mousemove', mouseMove);
	}, []);

	if (hover) {
		return (
			<div
				className={classes.hover}
				style={
					state.mouseY !== null && state.mouseX !== null
						? {
								top: state.mouseY,
								left: state.mouseX,
								transform: 'translate(-50%, -50%)',
						  }
						: undefined
				}
			>
				<div
					className={`${classes.slot} rarity-${itemData.rarity}${
						Boolean(broken) ? ' broken' : ''
					}`}
				>
					{Boolean(hover) && (
						<div
							className={classes.img}
							style={{
								backgroundImage: `url(${getItemImage(
									hover,
									itemData,
								)})`,
							}}
						></div>
					)}
					{Boolean(itemData) && (
						<div className={classes.label}>
							{getItemLabel(hover, itemData)}
						</div>
					)}
					{Boolean(hover) && hover.Count > 0 && (
						<div className={classes.count}>{hover.Count}</div>
					)}
					{Boolean(itemData?.durability) &&
					Boolean(hover?.CreateDate) &&
					!broken ? (
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
					) : null}
					{hover.shop && Boolean(itemData) && (
						<div className={classes.price}>
							{hover.free ||
							!Boolean(hover.Price ?? itemData.price)
								? 'FREE'
								: (hover.Price ?? itemData.price) * hover.Count}
						</div>
					)}
				</div>
			</div>
		);
	} else {
		return <Fragment />;
	}
};

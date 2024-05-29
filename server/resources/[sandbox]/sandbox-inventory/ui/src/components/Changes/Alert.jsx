import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Fade, Slide } from '@mui/material';
import { fallbackItem, getItemImage, getItemLabel } from '../Inventory/item';

const useStyles = makeStyles((theme) => ({
	container: {
		width: 285,
		height: 60,
		pointerEvents: 'none',
		display: 'flex',
		zIndex: 1,
		background: `${theme.palette.secondary.dark}80`,
		borderLeft: `4px solid ${theme.palette.primary.main}`,
		'&.add': {
			borderColor: theme.palette.success.main,
		},
		'&.removed': {
			borderColor: theme.palette.error.main,
		},
		'&.used': {
			borderColor: theme.palette.info.main,
		},
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
	itemName: {
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
}));

export default ({ alert }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const items = useSelector((state) => state.inventory.items);
	const itemData = Boolean(alert) ? items[alert.item] ?? fallbackItem : null;

	const [show, setShow] = useState(true);

	useEffect(() => {
		let t = setTimeout(() => {
			setShow(false);
		}, 3000);

		return () => {
			clearTimeout(t);
		};
	}, []);

	const onAnimEnd = () => {
		dispatch({
			type: 'DISMISS_ALERT',
			payload: {
				id: alert.id,
			},
		});
	};

	const getTypeLabel = () => {
		switch (alert.type) {
			case 'add':
				return 'Added';
			case 'removed':
				return 'Removed';
			case 'used':
				return 'Used';
			default:
				return alert.type;
		}
	};

	return (
		<Slide direction="up" in={show} onExited={onAnimEnd}>
			<div className={`${classes.container} ${alert.type}`}>
				{Boolean(itemData) ? (
					<div
						className={classes.image}
						style={{
							backgroundImage: `url(${getItemImage(
								alert.item,
								itemData,
							)})`,
						}}
					></div>
				) : (
					<div className={classes.image}></div>
				)}
				{Boolean(itemData) && (
					<div className={classes.label}>
						<div className={classes.itemName}>
							{getItemLabel(alert.item, itemData)}
						</div>
						<small>{getTypeLabel()}</small>
					</div>
				)}
				<div className={classes.count}>
					{alert.count > 0 ? alert.count : '-'}
				</div>
			</div>
		</Slide>
	);
};

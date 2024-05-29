import React, { useState, useEffect } from 'react';
import { CircularProgress, LinearProgress, Popover } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useSelector } from 'react-redux';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	slotWrap: {
		display: 'inline-block',
		boxSizing: 'border-box',
		flexGrow: 0,
		width: 'calc(20% - 4px)',
		maxWidth: 170,
		zIndex: 1,
		position: 'relative',
		color: theme.palette.text.main,
		'&:not(.disabled)': {
			transition: 'background ease-in 0.15s',
			'&:hover': {
				backgroundColor: `${theme.palette.secondary.dark}9e`,
			},
		},
		'&.disabled': {
			color: `${theme.palette.text.alt}80 !important`,
		},
	},
	slot: {
		width: '100%',
		height: 190,
		backgroundColor: `${theme.palette.secondary.light}61`,
		position: 'relative',
		zIndex: 2,
	},
	text: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		textAlign: 'center',

		'& svg': {
			display: 'block',
			margin: 'auto',
			fontSize: 36,
			marginBottom: 16,
		},
	},
}));

export default ({ onClick, canAdd }) => {
	const classes = useStyles();
	const hover = useSelector((state) => state.inventory.hover);

	return (
		<div
			className={`${classes.slotWrap} ${
				Boolean(hover) && canAdd ? '' : 'disabled'
			}`}
			onMouseUp={canAdd ? onClick : null}
		>
			<div className={classes.slot}>
				<div className={classes.text}>
					<FontAwesomeIcon
						className={classes.icon}
						icon={['fas', 'plus']}
					/>
					Add To Shop
				</div>
			</div>
		</div>
	);
};

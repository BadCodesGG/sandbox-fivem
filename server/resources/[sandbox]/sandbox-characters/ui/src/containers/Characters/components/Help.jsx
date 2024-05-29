import React, { Fragment, useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import { Slide } from '@mui/material';

const useStyles = makeStyles((theme) => ({
	container: {
		position: 'absolute',
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		height: 40,
		width: 'fit-content',
		pointerEvents: 'none',
		display: 'flex',
		zIndex: 1,
		background: `${theme.palette.secondary.dark}80`,
		borderLeft: `4px solid ${theme.palette.info.main}`,
		'& small': {
			fontSize: 12,
			display: 'block',
			lineHeight: '40px',
			padding: '0 5px',
		},
	},
	label: {
		color: theme.palette.text.main,
		fontSize: 18,
		lineHeight: '40px',
		textShadow: '0 0 5px #000',
		paddingLeft: 5,
		paddingRight: 15,
		flex: 1,
		borderLeft: `1px solid ${theme.palette.border.divider}`,
		height: 'fit-content',
		display: 'flex',

		'& .highlight': {
			color: theme.palette.primary.main,
			fontWeight: 'bold',
			marginRight: 4,
			'&:not(:first-of-type)': {
				marginLeft: 2,
			},
		},
	},
}));

export default ({ message }) => {
	const classes = useStyles();
	return (
		<Slide direction="up" in={true}>
			<div className={classes.container}>
				<small>HELP</small>
				<div className={classes.label}>
					<span className="highlight">Double Click</span>
					To Play As Character.
					<span className="highlight">Right Click</span>
					To Delete Character
				</div>
			</div>
		</Slide>
	);
};

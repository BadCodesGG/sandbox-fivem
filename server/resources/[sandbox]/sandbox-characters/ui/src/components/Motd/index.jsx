import React, { Fragment, useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import { Slide } from '@mui/material';

const useStyles = makeStyles((theme) => ({
	container: {
		position: 'absolute',
		top: '5%',
		height: 40,
		width: 'fit-content',
		pointerEvents: 'none',
		display: 'flex',
		zIndex: 1,
		background: `${theme.palette.secondary.dark}80`,
		borderLeft: `4px solid ${theme.palette.primary.main}`,
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
		paddingLeft: 15,
		paddingRight: 15,
		flex: 1,
		borderLeft: `1px solid ${theme.palette.border.divider}`,
		height: 'fit-content',
		display: 'flex',
	},
}));

export default ({ message }) => {
	const classes = useStyles();
	return (
		<Slide direction="right" in={true}>
			<div className={classes.container}>
				<small>MOTD</small>
				<div className={classes.label}>{message}</div>
			</div>
		</Slide>
	);
};

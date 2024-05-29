import React, { useState } from 'react';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		textAlign: 'center',
	},
	content: {
		margin: 'auto',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		height: 'fit-content',
		width: 'fit-content',
		width: '80%',
		fontSize: 28,
		fontWeight: 'bold',
		color: (app) => app.color,
	},
}));

export default (props) => {
	const appData = useAppData('blueline');
	const classes = useStyles(appData);

	return (
		<div className={classes.wrapper}>
			<div className={classes.content}>Not Authorized</div>
		</div>
	);
};

import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Paper, Button, LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import chroma from 'chroma-js';

import Nui from '../../../util/Nui';
import { useAlert, useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	reputation: {
		height: 60,
		width: '100%',
		position: 'relative',
		textAlign: 'center',
		borderBottom: `1px solid ${theme.palette.text.alt}`,
		background: theme.palette.secondary.dark,
	},
	fill: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		height: '100%',
		background: (app) => chroma(app.color).darken(),
		borderRight: (app) => `1px solid ${chroma(app.color).brighten()}`,
	},
	repDetails: {
		zIndex: 10,
		height: 'fit-content',
		width: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	jobName: {
		fontSize: 18,
	},
	levelName: {
		fontSize: 12,

		'& small': {
			'&::before': {
				content: '" - "',
			},

			fontSize: 10,
			marginLeft: 4,
		},
	},
}));

export default ({ rep }) => {
	const appData = useAppData('labor');
	const classes = useStyles(appData);

	const normalise = (value = 500) => {
		const min = rep?.current?.value ?? 0;
		const max = rep?.next?.value ?? 1000;
		return ((value - min) * 100) / (max - min);
	};

	return (
		<div className={classes.reputation}>
			<div
				className={classes.fill}
				style={{
					width:
						rep.value == rep.next?.value
							? '100%'
							: `${(rep.value / rep.next?.value) * 100}%`,
				}}
			></div>
			<div className={classes.repDetails}>
				<div className={classes.jobName}>{rep.label}</div>
				<div className={classes.levelName}>
					{rep.current?.label ?? 'No Rank'}
					{Boolean(rep.next) && (
						<small>{`${rep.value} / ${rep.next?.value}`}</small>
					)}
				</div>
			</div>
		</div>
	);

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={12} style={{ position: 'relative', height: 38 }}>
					<div className={classes.details}>
						<div className={classes.title}>{rep.label}</div>
					</div>
				</Grid>
			</Grid>
			<Grid container>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<div className={classes.progressLabel}>
						{rep.current?.label ?? 'No Rank'}
					</div>
				</Grid>
				<Grid item xs={8} style={{ position: 'relative' }}>
					<div className={classes.progressContainer}>
						<LinearProgress
							variant="determinate"
							value={normalise(rep.value)}
						/>
					</div>
				</Grid>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<div className={classes.progressLabel}>
						{rep.next?.label ?? 'Unknown'}
					</div>
				</Grid>
			</Grid>
		</Paper>
	);
};

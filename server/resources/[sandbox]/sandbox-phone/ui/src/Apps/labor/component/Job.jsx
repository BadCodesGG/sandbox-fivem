import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Paper, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import chroma from 'chroma-js';

import Nui from '../../../util/Nui';
import { CurrencyFormat } from '../../../util/Parser';
import { useAlert, useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	job: {
		padding: 10,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		borderRadius: 4,
		position: 'relative',
		marginBottom: 8,
		borderLeft: (app) => `2px solid ${app.color}`,
		overflow: 'hidden',
	},
	jobDetails: {
		display: 'flex',
	},
	mainInfo: {
		flexGrow: 1,
	},
	name: {
		fontSize: 18,
	},
	pay: {
		color: theme.palette.success.main,
		fontSize: 14,
	},
	footer: {
		marginTop: 10,
	},
	restrictedJob: {
		height: 'fit-content',
		width: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		fontSize: 135,
		opacity: 0.25,
		zIndex: -1,
		color: theme.palette.error.light,
	},
	actions: {
		background: (app) => app.color,

		'&:hover:not(.disabled)': {
			background: (app) => chroma(app.color).darken(),
		},
	},
}));

export default ({ job, myGroup, disabled }) => {
	const appData = useAppData('labor');
	const classes = useStyles(appData);
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);

	const onStart = async () => {
		try {
			let res = await (
				await Nui.send('StartLaborJob', {
					job: job.Id,
					isWorkgroup: Boolean(myGroup),
				})
			).json();
			if (res) {
				showAlert(`Started ${job.Name}`);
			} else showAlert('Unable to Start Job');
		} catch (err) {
			console.error(err);
			showAlert('Unable to Start Job');
		}
	};

	const onQuit = async () => {
		try {
			let res = await (await Nui.send('QuitLaborJob', job.Id)).json();
			if (res) {
				showAlert(`Quit ${job.Name}`);
			} else showAlert('Unable to Quit Job');
		} catch (err) {
			console.error(err);
			showAlert('Unable to Quit Job');
		}
	};

	return (
		<div className={classes.job}>
			<div className={classes.jobDetails}>
				<div className={classes.mainInfo}>
					<div className={classes.name}>{job.Name}</div>
					{job.Salary > 0 && (
						<div className={classes.pay}>
							{CurrencyFormat.format(job.Salary)}
						</div>
					)}
				</div>
				<div className={classes.jobCount}>
					{job.Limit == 0
						? `${job.OnDuty.length} / ∞`
						: `${job.OnDuty.length} / ${job.Limit}`}
				</div>
			</div>
			<div className={classes.footer}>
				<Button
					fullWidth
					color="inherit"
					variant="contained"
					className={`${classes.actions} ${
						(Boolean(myGroup) &&
							myGroup.Creator.ID != player.Source) ||
						Boolean(player.TempJob) ||
						disabled
							? 'disabled'
							: ''
					}`}
					disabled={
						(Boolean(myGroup) &&
							myGroup.Creator.ID != player.Source) ||
						Boolean(player.TempJob) ||
						disabled
					}
					onClick={onStart}
				>
					Start
				</Button>
			</div>
			{Boolean(job.Restricted) && (
				<div className={classes.restrictedJob}>
					<FontAwesomeIcon icon={['fad', 'shield-halved']} />
				</div>
			)}
		</div>
	);

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={7} style={{ position: 'relative', height: 65 }}>
					<div className={classes.details}>
						<div className={classes.title}>{job.Name}</div>
						{job.Salary > 0 && (
							<div className={classes.pay}>${job.Salary}</div>
						)}
					</div>
				</Grid>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<div className={classes.duty}>
						{job.Limit == 0
							? job.OnDuty.length
							: `${job.OnDuty.length} / ${job.Limit}`}
					</div>
				</Grid>
				<Grid item xs={3} style={{ position: 'relative' }}>
					{job.OnDuty.filter((p) => p.Joiner == player.Source)
						.length > 0 ||
					(Boolean(myGroup) &&
						job.OnDuty.filter((p) => p.Joiner == myGroup.Creator.ID)
							.length > 0) ? (
						<Button
							variant="text"
							className={classes.actions}
							disabled={
								(Boolean(myGroup) &&
									myGroup.Creator.ID != player.Source) ||
								disabled
							}
							onClick={onQuit}
						>
							Quit
						</Button>
					) : (
						<Button
							variant="text"
							className={classes.actions}
							disabled={
								(Boolean(myGroup) &&
									myGroup.Creator.ID != player.Source) ||
								Boolean(player.TempJob) ||
								disabled
							}
							onClick={onStart}
						>
							Start
						</Button>
					)}
				</Grid>
			</Grid>
		</Paper>
	);
};

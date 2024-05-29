import React from 'react';
import { useSelector } from 'react-redux';
import { Grid, Paper, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import chroma from 'chroma-js';
import { useAppData } from '../../../hooks';

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
	myGroupIcon: {
		height: 'fit-content',
		width: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		fontSize: 135,
		opacity: 0.05,
		zIndex: -1,
		color: theme.palette.error.light,
	},
	actions: {
		background: (app) => app.color,

		'&:hover:not(.disabled)': {
			background: (app) => chroma(app.color).darken(),
		},
	},
	member: {
		fontSize: 12,
		marginLeft: 16,
	},
}));

export default ({ group, isInGroup, onJoin, disabled }) => {
	const appData = useAppData('labor');
	const classes = useStyles(appData);
	const player = useSelector((state) => state.data.data.player);

	return (
		<div className={classes.job}>
			<div className={classes.jobDetails}>
				<div className={classes.mainInfo}>
					<div className={classes.name}>
						{group.Creator.First} {group.Creator.Last}
					</div>
				</div>
				<div className={classes.jobCount}>
					{group.Members.length + 1} / 5
				</div>
			</div>
			<div className={classes.members}>
				{group.Members.map((m) => {
					return (
						<div className={classes.member}>
							{m.First} {m.Last}
						</div>
					);
				})}
			</div>
			<div className={classes.footer}>
				<Button
					fullWidth
					color="inherit"
					variant="contained"
					className={`${classes.actions} ${
						isInGroup ||
						group.Members.length >= 4 ||
						disabled ||
						group.Working ||
						Boolean(player.TempJob)
							? 'disabled'
							: ''
					}`}
					disabled={
						isInGroup ||
						group.Members.length >= 4 ||
						disabled ||
						group.Working ||
						Boolean(player.TempJob)
					}
					onClick={() => onJoin(group)}
				>
					Join
				</Button>
			</div>
			<div className={classes.myGroupIcon}>
				<FontAwesomeIcon
					icon={['fad', 'crown']}
					style={{ color: 'gold' }}
				/>
			</div>
		</div>
	);
};

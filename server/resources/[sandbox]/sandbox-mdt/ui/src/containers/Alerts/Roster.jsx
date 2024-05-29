import React from 'react';
import { useSelector } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';

import RosterSection from './components/RosterSection';

import Radios from './Radios';

const useStyles = makeStyles((theme) => ({
	container: {
		height: '55%',
		width: '100%',
		overflowY: 'hidden',
		overflowX: 'auto',
	},
}));

const stupidConfig = {
	police: [
		{ job: "tow", width: 4 },
		{ job: "prison", width: 4 },
		{ job: "ems", width: 5 },
		{ job: "police", width: 5 },
	],
	ems: [
		{ job: "prison", width: 5 },
		{ job: "police", width: 5 },
		{ job: "ems", width: 8 },
	],
	prison: [
		{ job: "ems", width: 5 },
		{ job: "police", width: 5 },
		{ job: "prison", width: 8 },
	],
}

export default () => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);
	const job = useSelector((state) => state.app.govJob);
	const units = useSelector((state) => state.alerts.units);

	if (!user || (job.Id != 'police' && job.Id != 'ems' && job.Id != 'tow' && job.Id != 'prison')) return null;

	if (job.Id == "tow") {
		return (
			<Grid className={classes.container} container>
				<Grid item xs={6}></Grid>
				<RosterSection fullHeight width={6} type="tow" units={units?.tow?.filter((m) => m.operatingUnder === null) ?? Array()} />
			</Grid>
		);
	} else {
		return (
			<Grid className={classes.container} container columns={18}>
				{stupidConfig[job.Id].map(item => <RosterSection key={item.job} width={item.width} type={item.job} units={units?.[item.job]?.filter((m) => m.operatingUnder === null) ?? Array()} />)}
				<Radios />
			</Grid>
		);
	}
};

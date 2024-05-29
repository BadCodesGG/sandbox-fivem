import React from 'react';
import { ListItem, ListItemText, Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router';

import { VehicleTypes } from '../../../data';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '5px 10px 5px 10px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ vehicle }) => {
	const classes = useStyles();
	const history = useNavigate();
	const myJob = useSelector(state => state.app.govJob);
	const jobData = useSelector(state => state.data.data.governmentJobsData)?.[myJob.Id];

	const onClick = () => {
		history(`/vehicles?vehicle=${vehicle.VIN}&fleet-manage=1`);
	};

	const workplaceName = myJob?.Workplaces?.find(w => w.Id == vehicle.Owner?.Workplace)

	return (
		<ListItem className={classes.wrapper} button onClick={onClick}>
			<Grid container>
				<Grid item xs={2}>
					<ListItemText
						primary="VIN"
						secondary={vehicle.VIN}
					/>
				</Grid>
				<Grid item xs={1}>
					<ListItemText primary="Plate" secondary={vehicle.RegisteredPlate} />
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Make / Model"
						secondary={`${vehicle.Make} ${vehicle.Model}${vehicle.Type !== 0 ? ` [${VehicleTypes[vehicle.Type] ?? 'Vehicle'}]` : ''}`}
					/>
				</Grid>
				<Grid item xs={1}>
					<ListItemText
						primary="Dept."
						secondary={workplaceName ? workplaceName : "All"}
					/>
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary="Assigned Employees"
						secondary={vehicle.GovAssigned?.length > 0 ? vehicle.GovAssigned.map(g => `(${g.Callsign ?? 'N/A'}) ${g.First[0]}. ${g.Last}`).join(", ") : 'Non Assigned'}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Storage"
						secondary={vehicle.Storage?.Name ?? "Unknown"}
					/>
				</Grid>
				<Grid item xs={1}>
					<ListItemText
						primary="Reg. Date"
						secondary={vehicle.RegistrationDate ? <Moment date={vehicle.RegistrationDate} unix format="LL" /> : 'Unknown'}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};

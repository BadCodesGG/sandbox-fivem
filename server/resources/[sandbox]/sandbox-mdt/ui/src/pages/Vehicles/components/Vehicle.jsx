import React from 'react';
import { ListItemButton, ListItemText, Grid, Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import qs from 'qs';
import { useNavigate, useLocation } from 'react-router';

import { VehicleTypes } from '../../../data';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '5px 10px 5px 10px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	alt: {
		color: theme.palette.text.alt,
	}
}));

export default ({ vehicle }) => {
	const classes = useStyles();
	const location = useLocation();
	const history = useNavigate();

	let qry = qs.parse(location.search.slice(1));
	const vehicleId = qry.vehicle;

	const onClick = () => {
		let s = qs.parse(location.search.slice(1));
		s.vehicle = vehicle.VIN;
		delete s["fleet-manage"]
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
	};

	return (
		<ListItemButton className={classes.wrapper} onClick={onClick} selected={vehicleId == vehicle.VIN}>
			<Grid container>
				<Grid item xs={6}>
					<ListItemText
						primary={
							<Typography noWrap>
								{(vehicle.Type && vehicle.Type !== 0) ? `(${VehicleTypes[vehicle.Type]}) ` : ''}
								{`${vehicle.Make} ${vehicle.Model}`}
							</Typography>
						}
					/>
				</Grid>
				<Grid item xs={6}>
					<ListItemText
						primary={vehicle.Owner.Type === 0 ? (
							<Typography noWrap>
								Owner: State ID {`${vehicle.Owner?.Id}`}
							</Typography>
						) : (
							<Typography noWrap>
								Owner: Organization/Business
							</Typography>
						)}
					/>
				</Grid>
				<Grid item xs={6}>
					<ListItemText className={classes.alt} primary={`Plate: ${vehicle.RegisteredPlate}`} />
				</Grid>
				<Grid item xs={6}>
					<ListItemText className={classes.alt} primary={`VIN: ${vehicle.VIN}`} />
				</Grid>
				{/* <Grid item xs={3}>
					<ListItemText
						primary="Make / Model"
						secondary={`${vehicle.Make} ${vehicle.Model}`}
					/>
				</Grid> */}
				{/* <Grid item xs={2}>
					<ListItemText
						primary="Registration Date"
						secondary={vehicle.RegistrationDate ? <Moment date={vehicle.RegistrationDate} unix format="LL" /> : 'Unknown'}
					/>
				</Grid> */}
				{/* <Grid item xs={2}>
					<ListItemText
						primary="Impounded"
						secondary={vehicle.Storage?.Type === 0 ? 'Yes' : 'No'}
					/>
				</Grid> */}
			</Grid>
		</ListItemButton>
	);
};

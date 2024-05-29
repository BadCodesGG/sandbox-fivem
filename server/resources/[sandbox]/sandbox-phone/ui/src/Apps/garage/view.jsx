import React, { useEffect, useState, useMemo, Fragment } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import {
	AppBar,
	Grid,
	Tooltip,
	IconButton,
	List,
	Paper,
	ListItem,
	ListItemText,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import chroma from 'chroma-js';

import Nui from '../../util/Nui';
import { useNavigate, useParams } from 'react-router';
import { useAlert, useAppData } from '../../hooks';
import { AppContainer } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	subheader: {
		background: (app) => chroma(app.color).darken(3),
		fontSize: 14,
		padding: 15,
		lineHeight: '25px',
		height: 48,
	},
	content: {
		padding: 10,
		height: '92%',
		overflowX: 'hidden',
		overflowY: 'auto',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: '#1de9b6',
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	section: {
		padding: 10,
		'&:not(:last-of-type)': {
			marginBottom: 15,
		},
		'& h3': {
			borderBottom: (app) => `1px solid ${app.color}`,
		},
	},
	status: {
		color: theme.palette.success.main,
		'&::before': {
			content: '" - "',
			color: theme.palette.text.main,
		},
		'&.spawned': {
			color: theme.palette.error.main,
		},
	},
}));

export default (props) => {
	const appData = useAppData('garage');
	const classes = useStyles(appData);
	const dispatch = useDispatch();
	const history = useNavigate();
	const showAlert = useAlert();
	const params = useParams();
	const { vin } = params;
	const garages = useSelector((state) => state.data.data.garages);
	const car = useSelector((state) => state.data.data.myVehicles).filter(
		(v) => v.VIN == vin,
	)[0];

	useEffect(() => {
		if (!Boolean(car)) {
			history('/apps/garage', { replace: true });
		}
	}, [car]);

	const getGarage = () => {
		switch (car?.Storage?.Type) {
			case 0:
				return garages.impound;
			case 1:
				return garages[car.Storage.Id];
			case 2:
				return car.PropertyStorage;
		}
	};
	const garage = getGarage();

	const onGPS = async () => {
		try {
			let res = await (await Nui.send('Garage:TrackVehicle', vin)).json();
			showAlert(res ? 'Vehicle Marked on GPS' : 'Unable To Mark Vehicle');
		} catch (err) {
			console.error(err);
			showAlert('Unable To Mark Vehicle');
		}
	};

	if (!Boolean(car)) return null;

	const GenerateEngineBodyDiagnostics = (value) => {
		const _partDmg = Math.ceil(((value ?? 1000) / 1000) * 100);
		switch (true) {
			case _partDmg >= 90:
				return 'Excellent';
			case _partDmg >= 70 && _partDmg < 90:
				return 'Good';
			case _partDmg >= 50 && _partDmg < 70:
				return 'Fair';
			case _partDmg >= 30 && _partDmg < 50:
				return 'Needs Work';
			case _partDmg < 30:
				return "You're fucked";
			default:
				return 'Unknown';
		}
	};

	const GeneratePartsDiagnostics = (value) => {
		const _partDmg = Math.ceil(value);
		switch (true) {
			case _partDmg >= 90:
				return 'Excellent';
			case _partDmg >= 70 && _partDmg < 90:
				return 'Good';
			case _partDmg >= 50 && _partDmg < 70:
				return 'Fair';
			case _partDmg >= 30 && _partDmg < 50:
				return 'Needs Work';
			case _partDmg < 30:
				return "You're fucked";
			default:
				return 'Unknown';
		}
	};

	return (
		<AppContainer
			appId="garage"
			titleOverride={`${car.Make} ${car.Model}`}
			actions={
				<Fragment>
					<Tooltip title="Route To Vehicle">
						<span>
							<IconButton onClick={onGPS}>
								<FontAwesomeIcon
									icon={['fas', 'location-crosshairs']}
								/>
							</IconButton>
						</span>
					</Tooltip>
				</Fragment>
			}
		>
			<AppBar position="static" className={classes.subheader}>
				<Grid container style={{ textAlign: 'center' }}>
					<Grid item xs={6}>
						VIN: {car.VIN}
					</Grid>
					<Grid item xs={6}>
						Plate: {car.RegisteredPlate}
					</Grid>
				</Grid>
			</AppBar>
			<div className={classes.content}>
				<Paper className={classes.section}>
					<h3>Storage</h3>
					<div>
						{garage?.label ?? 'Unknown'}
						{Boolean(car.Spawned) ? (
							<span className={`${classes.status} spawned`}>
								Out
							</span>
						) : (
							<span className={classes.status}>
								{car.Storage.Type == 0
									? 'In Impound'
									: 'In Garage'}
							</span>
						)}
						{car.Storage.Type == 0 && (
							<List className={classes.data}>
								<ListItem>
									<ListItemText
										primary="Fine"
										secondary={`$${car.Storage.Fine}`}
									/>
								</ListItem>
								{Boolean(car.Storage.TimeHold) && (
									<ListItem>
										<ListItemText
											primary="Hold Release"
											secondary={
												<Moment
													className={
														classes.postedTime
													}
													interval={1000}
													fromNow
													date={
														+car.Storage.TimeHold
															.ExpiresAt * 1000
													}
												/>
											}
										/>
									</ListItem>
								)}
							</List>
						)}
					</div>
				</Paper>
				<Paper className={classes.section}>
					<h3>Diagnostics</h3>
					<div>
						<List className={classes.data}>
							<ListItem>
								<ListItemText
									primary="Mileage"
									secondary={`${car.Mileage} Miles`}
								/>
							</ListItem>
							<ListItem>
								<ListItemText
									primary="Body"
									secondary={GenerateEngineBodyDiagnostics(
										car.Damage?.Body,
									)}
								/>
							</ListItem>
							<ListItem>
								<ListItemText
									primary="Engine"
									secondary={GenerateEngineBodyDiagnostics(
										car.Damage?.Engine,
									)}
								/>
							</ListItem>
							{car.DamagedParts &&
								Object.keys(car.DamagedParts).map((part) => {
									return (
										<ListItem key={part}>
											<ListItemText
												primary={part
													.split(
														/(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])/g,
													)
													.join(' ')}
												secondary={GeneratePartsDiagnostics(
													car.DamagedParts[part],
												)}
											/>
										</ListItem>
									);
								})}
						</List>
					</div>
				</Paper>
			</div>
		</AppContainer>
	);
};

import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { ListItem, ListItemText } from '@mui/material';
import { Link } from 'react-router-dom';
import chroma from 'chroma-js';
import { useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
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

export default ({ vehicle }) => {
	const appData = useAppData('garage');
	const classes = useStyles(appData);
	const garages = useSelector((state) => state.data.data.garages);

	const getGarage = () => {
		switch (vehicle.Storage.Type) {
			case 0:
				return garages.impound;
			case 1:
				return garages[vehicle.Storage.Id];
			case 2:
				return vehicle.PropertyStorage;
		}
	};
	const garage = getGarage();

	return (
		<ListItem
			divider
			button
			component={Link}
			to={`/apps/garage/view/${vehicle.VIN}`}
		>
			<ListItemText
				primary={`${vehicle.Make} ${vehicle.Model}`}
				secondary={
					<span>
						{garage?.label ?? 'Unknown'}
						{Boolean(vehicle.Spawned) ? (
							<span className={`${classes.status} spawned`}>
								Out
							</span>
						) : (
							<span className={classes.status}>
								{vehicle.Storage.Type == 0
									? 'In Impound'
									: 'In Garage'}
							</span>
						)}
					</span>
				}
			/>
		</ListItem>
	);
};

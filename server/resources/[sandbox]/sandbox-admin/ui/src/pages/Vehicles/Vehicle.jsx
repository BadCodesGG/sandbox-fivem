import React from 'react';
import {
	Avatar,
	List,
	ListItem,
	ListItemAvatar,
	ListItemText,
	Grid,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import moment from 'moment';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	mugshot: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		margin: 'auto',
		height: 60,
		width: 60,
	}
}));

export default ({ vehicle }) => {
	const classes = useStyles();
	const history = useHistory();

	const onClick = () => {
		history.push(`/vehicle/${vehicle.Entity}`);
	};

	return (
		<ListItem className={classes.wrapper} button onClick={onClick}>
			<Grid container>
				<Grid item xs={2}>
					<ListItemText
						primary="Owner"
						secondary={vehicle.OwnerId ?? '?'}
					/>
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary="Make/Model"
						secondary={`${vehicle.Make ?? 'Unknown'} ${vehicle.Model ?? 'Unknown'}`}
					/>
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary="VIN"
						secondary={vehicle.VIN}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Plate"
						secondary={vehicle.Plate}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};

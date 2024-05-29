import React, { Fragment } from 'react';
import { useDispatch } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../../util/Nui';
import {
	GlobalNotifications,
	AppNotifications,
	Zoom,
	Volume,
	Sounds,
	Colors,
	Wallpapers,
} from './settings';
import { useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	rowHeader: {
		background: (app) => app.color,
		fontSize: 12,
		padding: 16,
		color: theme.palette.text.main,
		fontWeight: 'bold',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
}));

export default (props) => {
	const appData = useAppData('settings');
	const classes = useStyles(appData);
	const dispatch = useDispatch();

	const UpdateSetting = (type, val) => {
		try {
			dispatch({
				type: 'UPDATE_DATA',
				payload: {
					type: 'player',
					id: 'PhoneSettings',
					key: type,
					data: val,
				},
			});
			Nui.send('UpdateSetting', {
				type: type,
				val: val,
			})
				.then((res) => {})
				.catch((err) => {
					console.error(err);
				});
		} catch (err) {

		}
	};

	return (
		<Fragment>
			<Grid item xs={12} className={classes.rowHeader}>
				Notifications
			</Grid>
			<GlobalNotifications UpdateSetting={UpdateSetting} />
			<AppNotifications />
			<Grid item xs={12} className={classes.rowHeader}>
				Personalization
			</Grid>
			<Volume UpdateSetting={UpdateSetting} />
			<Sounds />
			<Wallpapers />
			<Zoom UpdateSetting={UpdateSetting} />
			<Colors />
		</Fragment>
	);
};

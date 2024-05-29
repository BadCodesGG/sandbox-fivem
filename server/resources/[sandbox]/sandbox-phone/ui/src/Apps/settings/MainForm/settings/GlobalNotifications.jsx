import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Grid, Switch, Paper } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	container: {
		display: 'flex',
		padding: 5,
		background: theme.palette.secondary.dark,
		transition: 'background ease-in 0.15s',
		borderBottom: `1px solid ${theme.palette.border.divider}`,

		'&:hover': {
			background: theme.palette.secondary.main,
			cursor: 'pointer',
		},
	},
	label: {
		flexGrow: 1,
		fontSize: 18,
		lineHeight: '38px',
	},
	icon: {
		width: 45,
		textAlign: 'center',
		lineHeight: '38px',
	},
	arrow: {
		fontSize: 20,
	},
}));

export default ({ UpdateSetting }) => {
	const classes = useStyles();
	const notifications = useSelector(
		(state) => state.data.data.player.PhoneSettings.notifications,
	);

	const [notifs, setNotifs] = useState(notifications);

	const toggleNotifs = () => {
		UpdateSetting('notifications', !notifs);
		setNotifs(!notifs);
	};

	return (
		<Grid item xs={12} className={classes.container} onClick={toggleNotifs}>
			<div className={classes.icon}>
				<FontAwesomeIcon icon={['fas', 'bell-on']} />
			</div>
			<div className={classes.label}>Notifications</div>
			<div className={classes.action}>
				<Switch
					className={classes.arrow}
					checked={notifs}
					color="primary"
				/>
			</div>
		</Grid>
	);

	return (
		<Paper className={classes.rowWrapper} onClick={toggleNotifs}>
			<Grid item xs={12}>
				<Grid container>
					<Grid item xs={2} style={{ position: 'relative' }}>
						<FontAwesomeIcon
							className={classes.avatarIcon}
							icon={['fas', 'bell-on']}
						/>
					</Grid>
					<Grid
						item
						xs={8}
						style={{ paddingLeft: 5, position: 'relative' }}
					>
						<span className={classes.sectionHeader}>
							Notifications
						</span>
					</Grid>
					<Grid item xs={2} style={{ position: 'relative' }}>
						<Switch
							className={classes.arrow}
							checked={notifs}
							color="primary"
						/>
					</Grid>
				</Grid>
			</Grid>
		</Paper>
	);
};

import React, { memo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { Grid, Avatar } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Version from './components/Version';
import Form from './MainForm';
import { useAppData } from '../../hooks';
import { AppContainer } from '../../components';

const useStyles = makeStyles((theme) => ({
	avatar: {
		margin: 'auto',
		height: 125,
		width: 125,
		border: (app) => `2px solid ${app.color}`,
		transition: 'border ease-in 0.15s',

		'&:hover': {
			borderColor: theme.palette.primary.main,
			cursor: 'pointer',
		},
	},
	inner: {
		height: '100%',
		display: 'flex',
		flexDirection: 'column',
	},
	upper: {
		height: '24%',
	},
	settingsList: {
		overflow: 'auto',
		flexGrow: 1,
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
}));

export default memo(() => {
	const appData = useAppData('settings');
	const classes = useStyles(appData);
	const navigate = useNavigate();

	const player = useSelector((state) => state.data.data.player);

	return (
		<AppContainer appId="settings">
			<div className={classes.inner}>
				<Grid container className={classes.upper}>
					<Grid item xs={12} style={{ padding: 12 }}>
						<Avatar
							className={classes.avatar}
							src={player.Mugshot}
							alt={player.First[0]}
							onClick={() => navigate(`/apps/settings/profile`)}
						/>
					</Grid>
				</Grid>
				<Grid className={classes.settingsList} container>
					<Form />
				</Grid>
				<Version />
			</div>
		</AppContainer>
	);

	return (
		<div className={classes.wrapper}>
			<Grid
				className={classes.settingsList}
				container
				justify="flex-start"
			>
				<Form />
			</Grid>
			<Version />
		</div>
	);
});

import React, { Fragment, useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { AppBar, Grid, Tooltip, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader } from '../../components';
import Job from './component/Job';
import AppContainer from '../../components/AppContainer';
import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: theme.palette.primary.main,
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	body: {
		padding: 10,
		height: '88.75%',
		overflowY: 'auto',
		overflowX: 'hidden',
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
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	jobs: {
		padding: 8,
	},
}));

export default ({ jobs, groups, myGroup, loading, onRefresh }) => {
	const classes = useStyles();
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);

	const onQuit = async () => {
		try {
			if (Boolean(player.TempJob)) {
				let jobData = jobs[player.TempJob];

				let res = await (
					await Nui.send('QuitLaborJob', player.TempJob)
				).json();
				if (res) {
					showAlert(`Quit ${jobData.Name}`);
				} else showAlert('Unable to Quit Job');
			}
		} catch (err) {
			console.error(err);
			showAlert('Unable to Quit Job');
		}
	};

	return (
		<AppContainer
			appId="labor"
			actions={
				<Fragment>
					{Boolean(player.TempJob) && (
						<Tooltip title="Quit Job">
							<IconButton onClick={onQuit}>
								<FontAwesomeIcon
									icon={['fad', 'person-from-portal']}
								/>
							</IconButton>
						</Tooltip>
					)}
					<Tooltip title="Refresh Jobs">
						<IconButton onClick={onRefresh}>
							<FontAwesomeIcon
								className={`fa ${loading ? 'fa-spin' : ''}`}
								icon={['fas', 'arrows-rotate']}
							/>
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			{!Boolean(jobs) ? (
				<Loader static text="Loading" />
			) : Object.keys(jobs).length > 0 ? (
				<div className={classes.jobs}>
					{Object.keys(jobs)
						.sort(
							(a, b) =>
								Boolean(jobs[b].Restricted) -
								Boolean(jobs[a].Restricted),
						)
						.map((k) => {
							return (
								<Job
									key={`labor-${k}`}
									job={jobs[k]}
									myGroup={myGroup}
									disabled={loading}
								/>
							);
						})}
				</div>
			) : (
				<div className={classes.emptyMsg}>No Jobs Available</div>
			)}
		</AppContainer>
	);
};

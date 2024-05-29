import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { List, ListItem, ListItemText } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router';
import { throttle } from 'lodash';


import { AppContainer, Loader } from '../../components';
import Nui from '../../util/Nui';
import { useAlert, useJobPermissions } from '../../hooks';

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
	content: {
		height: '93.75%',
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
	tabPanel: {},
	phoneTab: {
		minWidth: '33.333%',
	},
	alert: {
		width: 'fit-content',
		margin: 'auto',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	item: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	list: {
		height: '100%',
		width: '100%',
		overflow: 'auto',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const sendAlert = useAlert();
	const history = useNavigate();
	const hasPerm = useJobPermissions();
	const rosters = useSelector((state) => state.com.roster);
	const rostersRefreshed = useSelector((state) => state.com.rosterUpdated);
	const externalJobs = useSelector((state) => state.data.data.externalJobs);
	const player = useSelector((state) => state.data.data.player);
	const [loading, setLoading] = useState(false);

	const manageJob = (jobId) => {
		history(`/apps/comanager/view/${jobId}`);
		dispatch({
			type: 'SET_COM_TAB',
			payload: { tab: 0 },
		});
	};

	const fetchRoster = useMemo(
		() =>
			throttle(async () => {
				setLoading(true);
				try {
					let res = await (await Nui.send('FetchRoster', {})).json();

					// let res = {
					// 	rosterData: {
					// 		police: [
					// 			{
					// 				SID: 2,
					// 				First: 'Bob',
					// 				Last: 'Smith',
					// 				Phone: '555-555-5555',
					// 				JobData: {
					// 					Workplace: {
					// 						Id: 'lspd',
					// 						Name: 'Los Santos Police Department',
					// 					},
					// 					Name: 'Police',
					// 					Grade: {
					// 						Id: 'dchief',
					// 						Name: 'Dep. Chief',
					// 						Level: 8,
					// 					},
					// 					Id: 'police',
					// 				},
					// 			}
					// 		]
					// 	},
					// }

					if (res && res.rosterData) {
						dispatch({
							type: 'UPDATE_ROSTERS',
							payload: {
								roster: res.rosterData,
							},
						});
					} else throw res;
				} catch (err) {
					console.error(err);
					sendAlert("Unable to Load Roster's");
					dispatch({
						type: 'UPDATE_ROSTERS',
						payload: {
							roster: false,
						},
					});
				}

				setLoading(false);
			}, 5000),
		[],
	);

	useEffect(() => {
		if ((player.Jobs && player.Jobs.length) > 0) {
			if (!rosters || Date.now() - rostersRefreshed >= 180000) {
				fetchRoster();
			}
		}
	}, []);

	return (
		<AppContainer appId="comanager">
			{loading ? (
				<Loader static text="Loading" />
			) : (
				<>
					{(player.Jobs && player.Jobs.length) > 0 ? (
						<List className={classes.list}>
							{player.Jobs.map((job) => {
								if (!externalJobs.includes(job.Id)) {
									return (
										<ListItem
											button
											key={`job-${job.Id}`}
											onClick={() => manageJob(job.Id)}
											className={classes.item}
										>
											<ListItemText
												primary={
													<span>
														{job.Workplace
															? job.Workplace
																	?.Name
															: job.Name}
													</span>
												}
												secondary={`Employed as ${job.Grade.Name}`}
											/>
										</ListItem>
									);
								}
							})}
						</List>
					) : (
						<div className={classes.emptyMsg}>
							You're Not Employed at a Company
						</div>
					)}
				</>
			)}
		</AppContainer>
	);
};

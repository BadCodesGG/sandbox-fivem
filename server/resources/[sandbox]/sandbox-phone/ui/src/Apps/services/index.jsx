import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import {
	List,
	ListItem,
	IconButton,
	Grid,
	ListItemText,
	Typography,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { AppContainer } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '93.5%',
		padding: '0 0px 0 10px',
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
	summary: {
		//backgroundColor: 'red',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useNavigate();
	const callData = useSelector((state) => state.call.call);
	const services = useSelector((state) => state.data.data.services);
	const [loading, setLoading] = useState(false);
	const showAlert = useAlert();

	const SetGPS = async (location, jobName) => {
		try {
			let res = await (
				await Nui.send('Services:SetGPS', {
					location: location,
					jobName: jobName,
				})
			).json();
			if (res) {
				showAlert('GPS route set!');
			} else {
				showAlert('Unable to set GPS!');
			}
		} catch (err) {
			showAlert('Unable to set GPS!');
		}
	};

	const onCall = async (number) => {
		if (!Boolean(callData) && number) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number: number,
						isAnon: false,
					})
				).json();
				if (res) {
					history(`/apps/phone/call/${number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.error(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (
						await Nui.send('Services:GetServices')
					).json();
					if (res) {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'services',
								data: res,
							},
						});
					} else {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'services',
								data: Array(),
							},
						});
					}
				} catch (err) {
					console.error(err);
					dispatch({
						type: 'SET_DATA',
						payload: {
							type: 'services',
							data: Array(),
						},
					});
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	return (
		<AppContainer appId="services">
			{Boolean(services) && services.length > 0 ? (
				<List>
					{services.map(function (data, index) {
						return (
							<List component="nav">
								<ListItem
									divider
									style={{
										backgroundColor: data.jobColor
											? data.jobColor
											: '#f00',
									}}
								>
									<ListItemText>
										<Grid
											container
											justifyContent="space-around"
											alignItems="center"
										>
											<Grid xs={6}>
												<Typography
													style={{
														color: data.jobTextColor
															? data.jobTextColor
															: '#fff',
													}}
												>
													{data.jobIcon ? (
														<FontAwesomeIcon
															icon={[
																'fas',
																data.jobIcon,
															]}
														/>
													) : (
														<FontAwesomeIcon
															icon={[
																'fas',
																'building',
															]}
														/>
													)}{' '}
													{data.jobLabel}
												</Typography>
											</Grid>
											<Grid
												xs={6}
												style={{
													textAlign: 'right',
													paddingRight: '10px',
												}}
											>
												<span
													style={{
														width: '15px',
														height: '15px',
														borderRadius: '50%',
														backgroundColor:
															data.players
																.length > 1
																? 'green'
																: 'orange',
														display: 'inline-block',
														marginRight: '10px',
														verticalAlign: 'middle',
													}}
												></span>
												<IconButton
													aria-label="map"
													onClick={() =>
														SetGPS(
															data.jobLocation,
															data.jobName,
														)
													}
												>
													<FontAwesomeIcon
														icon={[
															'fas',
															'location-crosshairs',
														]}
													/>
												</IconButton>
												{data.phoneNumber && <IconButton
													aria-label="call"
													onClick={() => onCall(data.phoneNumber)}
												>
													<FontAwesomeIcon
														icon={[
															'fas',
															'phone',
														]}
													/>
												</IconButton>}
											</Grid>
										</Grid>
									</ListItemText>
								</ListItem>
							</List>
						);
					})}
				</List>
			) : (
				<List sx={{ width: '100%' }}>
					<ListItem>
						<ListItemText>
							No services are available at this time
						</ListItemText>
					</ListItem>
				</List>
			)}
		</AppContainer>
	);
};

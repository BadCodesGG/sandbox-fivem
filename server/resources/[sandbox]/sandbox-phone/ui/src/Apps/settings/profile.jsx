import React, { Fragment } from 'react';
import { useSelector } from 'react-redux';
import { Avatar, Grid, IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CopyToClipboard } from 'react-copy-to-clipboard';

import { useMyApps, useAlert } from '../../hooks';
import { AppContainer } from '../../components';
import Nui from '../../util/Nui';
import Version from './components/Version';

const useStyles = makeStyles((theme) => ({
	avatar: {
		margin: 'auto',
		height: 125,
		width: 125,
		border: `2px solid ${theme.palette.primary.main}`,
		transition: 'border ease-in 0.15s',
	},
	inner: {
		height: '100%',
		display: 'flex',
		flexDirection: 'column',
	},
	myInfo: {
		textAlign: 'center',

		'& .name': {
			fontSize: 22,
		},
		'& .number': {
			fontSize: 16,
			color: theme.palette.primary.main,
			transition: 'color ease-in 0.15s',
			'&:hover': {
				cursor: 'pointer',
				color: theme.palette.primary.dark,
			},
		},
	},
	settingsList: {
		overflow: 'auto',
		flexGrow: 1,
		padding: 8,
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
	container: {
		borderRadius: 8,
		background: theme.palette.secondary.dark,
		border: `1px solid ${theme.palette.border.divider}`,
		padding: 12,
		fontFamily: 'Kanit',

		'&:not(:last-of-type)': {
			marginBottom: 8,
		},
	},
	containerHeader: {
		fontSize: 16,
		fontWeight: 'bold',
		borderBottom: `1px solid ${theme.palette.primary.main}`,
	},
	containerBody: {
		padding: 8,
	},
	bodyItem: {
		color: theme.palette.text.alt,
		fontSize: 12,
	},
	highlight: {
		color: theme.palette.text.main,
		fontWeight: 'bold',
		fontSize: 14,
	},
}));

export default (props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const myApps = useMyApps();
	const player = useSelector((state) => state.data.data.player);

	const onCopyLink = () => {
		showAlert('Number Copied To Clipboard');
	};

	const onShare = async () => {
		try {
			let res = await (await Nui.send('ShareMyContact')).json();
			showAlert(
				res
					? 'Contact Shared to All Nearby'
					: 'Unable to Share Contact',
			);
		} catch (err) {
			console.error(err);
			showAlert('Unable to Share Contact');
		}
	};

	return (
		<AppContainer
			appId="settings"
			actions={
				<Fragment>
					<Tooltip title="Share Contact Nearby">
						<IconButton onClick={onShare}>
							<FontAwesomeIcon
								icon={['far', 'share-from-square']}
							/>
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			<div className={classes.inner}>
				<Grid container>
					<Grid item xs={12} style={{ padding: 12 }}>
						<Avatar
							className={classes.avatar}
							src={player.Mugshot}
							alt={player.First[0]}
						/>
					</Grid>
					<Grid item xs={12} className={classes.myInfo}>
						<div className="name">
							{player.First} {player.Last}
						</div>

						<CopyToClipboard
							text={player.Phone}
							onCopy={onCopyLink}
						>
							<div className="number">{player.Phone}</div>
						</CopyToClipboard>
					</Grid>
				</Grid>
				<div className={classes.settingsList}>
					<div className={classes.container}>
						<div className={classes.containerHeader}>
							Personal Details
						</div>
						<div className={classes.containerBody}>
							<div className={classes.bodyItem}>
								<span className={classes.highlight}>
									Server ID:{' '}
								</span>
								{player.Source}
							</div>
							<div className={classes.bodyItem}>
								<span className={classes.highlight}>
									State ID:{' '}
								</span>
								{player.SID}
							</div>
							<div className={classes.bodyItem}>
								<span className={classes.highlight}>
									Passport ID:{' '}
								</span>
								{player.User}
							</div>
						</div>
					</div>

					<div className={classes.container}>
						<div className={classes.containerHeader}>Licenses</div>
						<div className={classes.containerBody}>
							{Object.keys(player.Licenses)
								.sort((a, b) => (a < b ? -1 : a > b ? 1 : 0))
								.map((k) => {
									let licenseData = player.Licenses[k];

									if (licenseData?.Suspended) {
										return (
											<div className={classes.bodyItem}>
												<span
													className={
														classes.highlight
													}
												>
													{`${k}: `}
												</span>
												Suspended
											</div>
										);
									} else {
										if (licenseData?.Active) {
											return (
												<div
													className={classes.bodyItem}
												>
													<span
														className={
															classes.highlight
														}
													>
														{`${k}: `}
													</span>
													Valid
												</div>
											);
										} else {
											return (
												<div
													className={classes.bodyItem}
												>
													<span
														className={
															classes.highlight
														}
													>
														{`${k}: `}
													</span>
													None
												</div>
											);
										}
									}
								})}
						</div>
					</div>

					<div className={classes.container}>
						<div className={classes.containerHeader}>
							Application Identities
						</div>
						<div className={classes.containerBody}>
							{Object.keys(player.Alias).map((k) => {
								let alias = player.Alias[k];
								let app = myApps[k];
								if (!Boolean(app)) return null;
								if (alias instanceof Object) {
									return (
										<div
											key={`alias-${k}`}
											className={classes.bodyItem}
										>
											<span className={classes.highlight}>
												{`${app?.label} `}
											</span>
											{alias.name}
										</div>
									);
								} else {
									return (
										<div
											key={`alias-${k}`}
											className={classes.bodyItem}
										>
											<span className={classes.highlight}>
												{`${app?.label} `}
											</span>
											{alias}
										</div>
									);
								}
							})}
						</div>
					</div>
				</div>
				<Version />
			</div>
		</AppContainer>
	);
};

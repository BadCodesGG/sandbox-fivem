import React, { Fragment } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	IconButton,
	List,
	ListItem,
	ListItemSecondaryAction,
	ListItemText,
	Tooltip,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate, useParams } from 'react-router';
import { useAlert, useAppData } from '../../hooks';
import { AppContainer } from '../../components';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	header: {
		display: 'inline-block',
		fontSize: 16,
		marginLeft: 8,
		'& svg': {
			marginRight: 4,
		},
	},
	content: {
		height: '87%',
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
	links: {
		width: '100%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	link: {
		textAlign: 'center',
		fontSize: 28,
		padding: 10,
		transition: 'color ease-in 0.15s',

		'&:hover': {
			cursor: 'pointer',
			color: (app) => app.color,
		},
	},
	noRaces: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default () => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const navigate = useNavigate();
	const dispatch = useDispatch();
	const showAlert = useAlert();

	const onDuty = useSelector((state) => state.data.data.onDuty);
	const alias = useSelector(
		(state) => state.data.data.player?.Profiles?.redline,
	);
	const races = useSelector((state) => state.race.races);
	const invites = useSelector((state) => state.race.invites);

	const onAccept = async (id) => {
		try {
			let res = await (await Nui.send('AcceptInvite', id)).json();
			if (Boolean(res)) {
				dispatch({
					type: 'REMOVE_INVITE',
					payload: {
						id,
					},
				});
				dispatch({
					type: 'I_RACE',
					payload: {
						state: true,
					},
				});
				showAlert('Event Invite Accepted');
				navigate(`/apps/redline/view/${id}`);
			} else {
				showAlert('Unable To Accept Event Invite');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Accepting Event Invite');
		}
	};

	const onDecline = async (id) => {
		try {
			let res = await (await Nui.send('DeclineInvite', id)).json();
			if (Boolean(res)) {
				dispatch({
					type: 'REMOVE_INVITE',
					payload: {
						id,
					},
				});
				showAlert('Event Invite Declined');
			} else {
				showAlert('Unable To Decline Event Invite');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Declining Event Invite');
		}
	};

	return (
		<AppContainer
			appId="redline"
			titleOverride="Redline - Event Invites"
			actionShow={Boolean(alias) && onDuty != 'police'}
			actions={
				<Fragment>
					<IconButton onClick={() => navigate(-1)}>
						<FontAwesomeIcon icon={['far', 'arrow-left']} />
					</IconButton>
				</Fragment>
			}
		>
			<Fragment>
				<div className={classes.content}>
					{invites.filter((invite) => Boolean(races[invite.id]))
						.length > 0 ? (
						<List>
							{invites
								.filter((invite) => Boolean(races[invite.id]))
								.map((invite) => {
									let raceData = races[invite.id];
									return (
										<ListItem>
											<ListItemText
												primary={raceData.name}
											/>
											<ListItemSecondaryAction>
												<IconButton
													onClick={() =>
														onDecline(invite.id)
													}
												>
													<FontAwesomeIcon
														icon={['fas', 'x']}
													/>
												</IconButton>
												<IconButton
													onClick={() =>
														onAccept(invite.id)
													}
												>
													<FontAwesomeIcon
														icon={['fas', 'check']}
													/>
												</IconButton>
											</ListItemSecondaryAction>
										</ListItem>
									);
								})}
						</List>
					) : (
						<div className={classes.noRaces}>
							No Pending Event Invites
						</div>
					)}
				</div>
			</Fragment>
		</AppContainer>
	);
};

import React, { Fragment } from 'react';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router';
import { IconButton } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { AppContainer } from '../../components';
import { useAppData } from '../../hooks';
import { useSelector } from 'react-redux';
import Invite from './components/Invite';

const useStyles = makeStyles((theme) => ({
	list: {
		borderTop: `1px solid ${theme.palette.border.divider}`,
	},
	inviteCount: {
		position: 'absolute',
		fontSize: 12,
		bottom: 0,
		right: 0,
		zIndex: 10,
		background: theme.palette.error.main,
		padding: '2px 6px',
		borderRadius: 20,
	},
	noInvites: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default () => {
	const appData = useAppData('chatter');
	const classes = useStyles(appData);
	const navigate = useNavigate();

	const invites = useSelector((state) => state.chatter.invites);

	return (
		<AppContainer
			appId="chatter"
			titleOverride="Chatter - Group Invites"
			actions={
				<Fragment>
					<IconButton
						onClick={() =>
							navigate('/apps/chatter', { replace: true })
						}
					>
						<FontAwesomeIcon icon={['far', 'home']} />
					</IconButton>
				</Fragment>
			}
		>
			{Boolean(invites) && Object.keys(invites).length > 0 ? (
				Object.keys(invites).map((channel) => {
					let invite = invites[channel];
					return (
						<Invite key={`inv-${invite.group}`} invite={invite} />
					);
				})
			) : (
				<div className={classes.noInvites}>You Have No Invites</div>
			)}
		</AppContainer>
	);
};

import React, { Fragment } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate, useParams } from 'react-router';
import { useAppData } from '../../hooks';
import { AppContainer } from '../../components';

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
	const { racer } = useParams();

	const onDuty = useSelector((state) => state.data.data.onDuty);
	const alias = useSelector(
		(state) => state.data.data.player?.Profiles?.redline,
	);

	return (
		<AppContainer
			appId="redline"
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
					<div className={classes.noRaces}>
						Racer Profiles Coming Soon
					</div>
				</div>
			</Fragment>
		</AppContainer>
	);
};

import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { AppBar, Toolbar, IconButton, Divider, Grid } from '@mui/material';
import { Link, useNavigate, useLocation } from 'react-router-dom';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useBranding, useCitySeal } from '../../hooks';
import Nui from '../../util/Nui';
import Account from './Account';

const useStyles = makeStyles((theme) => ({
	cityLogoContainer: {
		display: 'flex',
		flexDirection: 'column',
		justifyContent: 'center',
	},
	cityLogo: {
		width: 90,
		paddingLeft: 10,
	},
	branding: {
		marginLeft: 10,
		marginRight: 50,
		fontSize: 22,
		'& small': {
			display: 'block',
			fontSize: 16,
			color: theme.palette.text.alt,
		},
	},
	navbar: {
		backgroundColor: theme.palette.secondary.main,
		width: '100%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		userSelect: 'none',
	},
	title: {
		display: 'flex',
		alignContent: 'center',
		background: theme.palette.secondary.light,
		margin: 10,
		borderRadius: 1000,
	},
	right: {
		marginRight: 10,
		maxWidth: '50%',
		alignSelf: 'stretch',
	},
	rightNav: {
		display: 'flex',
		padding: '10px 0',
		flexDirection: 'row-reverse',
	},
	user: {
		marginRight: 10,
		textAlign: 'right',
		fontSize: 18,
		'& small': {
			color: theme.palette.text.alt,
		},
	},
	callsign: {
		fontSize: 14,
		color: theme.palette.primary.main,
	},
	motd: {
		margin: 'auto 10px auto 0px',
	},
	middle: {
		flexGrow: 1,
		alignSelf: 'stretch',
		zIndex: 2,
	}
}));

export default ({ businessData, children }) => {
	const classes = useStyles();
	const history = useNavigate();
	const location = useLocation();
	const dispatch = useDispatch();
	const getSeal = useCitySeal();
	const job = useSelector((state) => state.app.govJob);
	const attorney = useSelector((state) => state.app.attorney);
	const hidden = useSelector((state) => state.app.hidden);

	const branding = useBranding(job, attorney);


	const onClose = () => {
		Nui.send('Close');
	};

	const hoverChange = (state) => {
		if (!hidden && !location.pathname.startsWith('/admin') && !location.pathname.startsWith('/system')) {
			dispatch({
				type: 'SET_OPACITY_MODE',
				payload: {
					state,
				},
			});
		}
	};

	return (
		<AppBar elevation={0} position="relative" color="secondary" className={classes.navbar}>
			<Toolbar disableGutters sx={{ justifyContent: 'space-between' }}>
				<div className={classes.title}>
					<div className={classes.cityLogoContainer}>
						<img src={getSeal()} className={classes.cityLogo} />
					</div>
					<div className={classes.branding}>
						<p>
							{branding.primary}
							<small>{branding.secondary}</small>
						</p>
					</div>
				</div>
				<div
					className={classes.middle}
					onMouseEnter={() => hoverChange(true)}
					onMouseLeave={() => hoverChange(false)}
				>
				</div>
				<div className={classes.right}>
					<Grid container direction="column" justifyContent="space-between" spacing={4}>
						<Grid item xs={12}>
							<div className={classes.rightNav}>
								<IconButton onClick={onClose}>
									<FontAwesomeIcon icon={['fas', 'xmark']} />
								</IconButton>
								<IconButton onClick={() => history(1)}>
									<FontAwesomeIcon icon={['fas', 'arrow-right']} />
								</IconButton>
								<IconButton onClick={() => history(-1)}>
									<FontAwesomeIcon icon={['fas', 'arrow-left']} />
								</IconButton>
								{/* <Divider orientation="vertical" flexItem />
								<p className={classes.motd}>Message of the Day</p> */}
							</div>
						</Grid>
						<Grid item xs={12} >
							<div className={classes.user}>
								<Account />
							</div>
						</Grid>
					</Grid>
				</div>
			</Toolbar>
			{children}
		</AppBar>
	);
};

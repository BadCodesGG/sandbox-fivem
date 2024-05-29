import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate, useLocation } from 'react-router-dom';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useAlert } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	footer: {
		background: '#252726',
		height: '7%',
		borderBottomLeftRadius: 30,
		borderBottomRightRadius: 30,
		textAlign: 'center',
		width: '100%',
	},
	inner: {
		gap: '2%',
		display: 'flex',
		color: '#ffffff',
		lineHeight: '65px',
		fontSize: '20px',
		width: '96%',
		position: 'absolute',
		left: 0,
		right: -5,
		margin: 'auto',
	},
	fButton: {
		width: '32%',
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
			cursor: 'pointer',
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useNavigate();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const { pathname } = useLocation();
	const locked = useSelector((state) => state.phone.locked);

	const ToggleExpando = () => {
		dispatch({
			type: 'TOGGLE_EXPANDED',
		});
	};

	const ToggleLock = () => {
		dispatch({
			type: 'TOGGLE_LOCKED',
		});
		showAlert(locked ? 'Phone Position Unlocked - Drag To Move' : 'Phone Position Locked');
	};

	const GoHome = () => {
		history('/');
	};

	const GoBack = () => {
		const match = pathname == "/apps/music" ? true : false;
		if(match){
			history('/');
		} else {
			history(-1);
		}
	};

	return (
		<div className={classes.footer}>
			<div className={classes.inner}>
				<div className={classes.fButton} onClick={ToggleLock}>
					<FontAwesomeIcon
						icon={['fas', locked ? 'unlock' : 'floppy-disk']}
					/>
				</div>
				<div className={classes.fButton} onClick={GoHome}>
					<FontAwesomeIcon icon={['far', 'rectangle-wide']} />
				</div>
				<div className={classes.fButton} onClick={GoBack}>
					<FontAwesomeIcon icon="chevron-left" />
				</div>
			</div>
		</div>
	);
};

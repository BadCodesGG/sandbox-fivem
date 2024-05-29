import React from 'react';
import { useSelector } from 'react-redux';
import { Fade, LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { styled } from '@mui/material/styles';
import { linearProgressClasses } from '@mui/material/LinearProgress';

import logo from '../../assets/imgs/logo_banner.png';

const useStyles = makeStyles((theme) => ({
	container: {
		height: 'fit-content',
		width: 800,
		position: 'absolute',
		bottom: 0,
		top: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		background: theme.palette.secondary.dark,
		borderLeft: `4px solid ${theme.palette.primary.main}`,
	},
	details: {
		width: '100%',
		padding: 25,
		textAlign: 'center',
	},
	label: {
		color: theme.palette.text.main,
		fontSize: 28,
		textShadow: '0 0 5px #000',
		textAlign: 'center',
		padding: 15,
	},
	img: {
		maxWidth: 450,
		width: '100%',
		borderBottom: `2px solid ${theme.palette.border.divider}`,
		marginBottom: 15,
	},
}));

export default () => {
	const classes = useStyles();

	const loading = useSelector((state) => state.loader.loading);
	const message = useSelector((state) => state.loader.message);

	const BorderLinearProgress = styled(LinearProgress)(({ theme }) => ({
		height: 4,
		[`&.${linearProgressClasses.colorPrimary}`]: {
			backgroundColor: theme.palette.secondary.dark,
		},
		[`& .${linearProgressClasses.bar}`]: {
			backgroundColor: theme.palette.primary.main,
		},
	}));

	if (!loading) return null;
	return (
		<Fade in={true} duration={1000}>
			<div className={classes.container}>
				<div className={classes.details}>
					<img className={classes.img} src={logo} />
					<div className={classes.label}>{message}</div>
				</div>
				<BorderLinearProgress
					classes={{
						bar: classes.progressbar,
						bar1: classes.progressbar,
					}}
				/>
			</div>
		</Fade>
	);
};

import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';


const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		borderRadius: 4,
		marginBottom: 10,
	},
	appInfo: {
		paddingBottom: 5,
		marginBottom: 5,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'filter ease-in 0.15s',
		'&.clickable:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	appName: {
		height: 'fit-content',
		color: theme.palette.text.alt,
		textTransform: 'uppercase',
		top: 0,
		bottom: 0,
		margin: 'auto',
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		fontSize: 12,
	},
	label: {
		fontSize: 18,
		color: theme.palette.text.alt,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	value: {
		display: 'block',
		fontSize: 14,
		color: theme.palette.text.alt,
		whiteSpace: 'wrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	time: {
		color: theme.palette.success.main,
		fontSize: 14,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		textAlign: 'right'
	},
	eqBars: {
		transform: "scale(1, -1) translate(0, -24px)"
	},
	eqBars1: {
		animationName: "short-eq",
		animationDuration: "0.5s",
		animationIterationCount: "infinite",
		animationDelay: "0s"
	},
	eqBars2: {
		animationName: "tall-eq",
		animationDuration: "0.5s",
		animationIterationCount: "infinite",
		animationDelay: "0.17s"
	},
	eqBars3: {
		animationName: "short-eq",
		animationDuration: "0.5s",
		animationIterationCount: "infinite",
		animationDelay: "0.34s"
	},
	eqBarWrapper: {
		textAlign: "right",
		display: "block",
		fill: "#fff"
	}
}));

Number.prototype.pad = function (size) {
	var s = String(this);
	while (s.length < (size || 2)) {
		s = '0' + s;
	}
	return s;
};

export default () => {
	const dispatch = useDispatch();
	const musicDetails = useSelector((state) => state.music?.currentSong);
	const zoom = useSelector(
		(state) => state.data.data.player.PhoneSettings?.zoom,
	);
	const classes = useStyles(zoom);

	return (
		<Fragment>
			<style>
				{
					`
					@keyframes short-eq {
						0% {
						  height: 8px
						}
					  
						50% {
						  height: 4px
						}
					  
						100% {
						  height: 8px
						}
					  }
					  
					  @keyframes tall-eq {
						0% {
						  height: 16px
						}
					  
						50% {
						  height: 6px
						}
					  
						100% {
						  height: 16px
						}
					  }
					`
				}
			</style>
			<Grid container className={classes.wrapper}>
				<Grid item xs={12} className={classes.appInfo}>
					<Grid container>
						<Grid item xs={6} style={{ position: 'relative' }}>
							<span className={classes.appName}>Currently Playing</span>
						</Grid>
						<Grid item xs={6} style={{ position: 'relative' }}>
							<span className={classes.eqBarWrapper}>
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
									<rect className={`${classes.eqBars} ${classes.eqBars1}`} x="4" y="4" width="3.7" height="8"/>
									<rect className={`${classes.eqBars} ${classes.eqBars2}`} x="10.2" y="4" width="3.7" height="16"/>
									<rect className={`${classes.eqBars} ${classes.eqBars3}`} x="16.3" y="4" width="3.7" height="11"/>
								</svg>
							</span>
						</Grid>
					</Grid>
				</Grid>
				<Grid item xs={12}>
					<Grid container>
						<Grid item xs={12} className={classes.label}>
							{musicDetails.title}
						</Grid>
					</Grid>
				</Grid>
				<Grid item xs={12}>
					<Grid container>
						<Grid item xs={12} className={classes.value}>
							{musicDetails.label_name}
						</Grid>
					</Grid>
				</Grid>
			</Grid>
		</Fragment>
	);
};

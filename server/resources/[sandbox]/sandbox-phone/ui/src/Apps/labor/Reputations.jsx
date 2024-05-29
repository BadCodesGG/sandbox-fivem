import React, { Fragment, useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { AppBar, Grid, Tooltip, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader } from '../../components';
import Reputation from './component/Reputation';
import AppContainer from '../../components/AppContainer';

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
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	body: {
		padding: 10,
		height: '88.75%',
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
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default ({ myReputations, loading, onRefresh }) => {
	const classes = useStyles();

	return (
		<AppContainer
			appId="labor"
			actions={
				<Fragment>
					<Tooltip title="Refresh Jobs">
						<IconButton onClick={onRefresh}>
							<FontAwesomeIcon
								className={`fa ${loading ? 'fa-spin' : ''}`}
								icon={['fas', 'arrows-rotate']}
							/>
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			{!Boolean(myReputations) ? (
				<Loader static text="Loading" />
			) : myReputations.length > 0 ? (
				<div style={{ marginTop: 4 }}>
					{myReputations
						.sort((a, b) => a.label.localeCompare(b.label))
						.map((rep) => {
							return (
								<Reputation
									key={`labor-${rep.id}`}
									rep={rep}
									disabled={loading}
								/>
							);
						})}
				</div>
			) : (
				<div className={classes.emptyMsg}>No Reputation Built</div>
			)}
		</AppContainer>
	);
};

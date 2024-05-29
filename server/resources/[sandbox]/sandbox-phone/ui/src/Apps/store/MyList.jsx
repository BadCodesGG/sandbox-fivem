import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { TextField, Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { useMyApps } from '../../hooks';
import App from './App';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	search: {
		height: '10%',
	},
	searchInput: {
		width: '100%',
		height: '100%',
	},
	content: {
		maxHeight: '90%',
		overflowY: 'auto',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useNavigate();
	const apps = useMyApps();
	const installed = useSelector(
		(state) => state.data.data.player?.Apps?.installed,
	);

	const [searchVal, setSearchVal] = useState('');
	const onSearchChange = (e) => {
		setSearchVal(e.target.value);
	};

	const [filtered, setFiltered] = useState(Array());
	useEffect(() => {
		setFiltered(
			installed
				.filter(
					(k) =>
						apps[k]?.canUninstall &&
						(apps[k]?.label
							.toUpperCase()
							.includes(searchVal.toUpperCase()) ||
							searchVal === ''),
				)
				.map((k) => apps[k]),
		);
	}, [searchVal]);

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
				<TextField
					variant="standard"
					className={classes.searchInput}
					label="Search For App"
					value={searchVal}
					onChange={onSearchChange}
				/>
			</div>
			<Grid container justify="flex-start" className={classes.content}>
				{filtered.length > 0 ? (
					filtered.map((app) => {
						return (
							<App key={app.name} app={app} installed={true} />
						);
					})
				) : (
					<Grid item xs={12} className={classes.emptyMsg}>
						No Apps Available To Uninstall
					</Grid>
				)}
			</Grid>
		</div>
	);
};

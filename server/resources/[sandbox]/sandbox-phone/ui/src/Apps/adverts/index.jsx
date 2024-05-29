import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import { AppContainer } from '../../components';
import ActionButtons from './ActionButtons';
import { useAppData } from '../../hooks';
import { TextField } from '@mui/material';
import Advert from './components/Advert';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '91.8%',
		overflow: 'hidden',
	},
	tabPanel: {
		height: '100%',
	},
	add: {
		position: 'absolute',
		bottom: '12%',
		right: '10%',
		backgroundColor: '#f9a825',
		opacity: 0.3,
		'&:hover': {
			backgroundColor: '#f9a825',
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
	delete: {
		position: 'absolute',
		bottom: '19%',
		right: '10%',
		backgroundColor: theme.palette.error.main,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: theme.palette.error.main,
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
	bump: {
		position: 'absolute',
		bottom: '26%',
		right: '10%',
		backgroundColor: theme.palette.error.light,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: theme.palette.error.light,
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},

	searchBar: {
		padding: 10,
		background: (app) => app?.color,
		textAlign: 'center',
	},
	ads: {
		maxHeight: '88%',
		overflow: 'auto',
	},
}));

export default (props) => {
	const appData = useAppData('adverts');
	const classes = useStyles(appData);

	const adverts = useSelector((state) => state.data.data.adverts);

	const [filtered, setFiltered] = useState(
		Object.keys(adverts).filter((a) => a !== '0'),
	);
	const [searchVal, setSearchVal] = useState('');

	useEffect(() => {
		setFiltered(
			Object.keys(adverts).filter(
				(a) => a !== '0' && adverts[a].title.includes(searchVal),
			),
		);
	}, [searchVal, adverts]);

	const onChange = (e) => {
		setSearchVal(e.target.value);
	};

	return (
		<AppContainer appId="adverts" actions={<ActionButtons />}>
			<div className={classes.searchBar}>
				<TextField
					fullWidth
					label="Search Adverts"
					color="secondary"
					onChange={onChange}
				/>
			</div>
			<div className={classes.ads}>
				{filtered
					.sort((a, b) => {
						let aItem = adverts[a];
						let bItem = adverts[b];
						return bItem.time - aItem.time;
					})
					.map((ad, i) => {
						return (
							<Advert key={`advert-${i}`} advert={adverts[ad]} />
						);
					})}
			</div>
		</AppContainer>
	);
};

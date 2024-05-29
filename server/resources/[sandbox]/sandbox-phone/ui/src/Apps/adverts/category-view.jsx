import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Categories } from './data';
import ActionButtons from './ActionButtons';
import Advert from './components/Advert';
import { useParams } from 'react-router';
import { AppContainer } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	adsWrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	header: {
		width: '100%',
		padding: 10,
		fontSize: 20,
		height: 50,
		borderBottom: `1px solid ${theme.palette.text.main}`,
	},
	title: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		margin: 'auto',
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const params = useParams();
	const { category } = params;
	const catData = Categories.filter((cat) => cat.label === category)[0];
	const adverts = useSelector((state) => state.data.data.adverts);

	const [filtered, setFiltered] = useState(Object());

	useEffect(() => {
		let t = Object();
		Object.keys(adverts)
			.filter((a) => a !== '0')
			.map((a) => {
				let ad = adverts[a];
				if (ad.categories.includes(category)) t[a] = ad;
			});
		setFiltered(t);
	}, [adverts]);

	return (
		<AppContainer
			appId="adverts"
			titleOverride={catData.label}
			colorOverride={catData.color}
		>
			{Object.keys(filtered)
				.filter((a) => a !== '0')
				.sort((a, b) => {
					let aItem = filtered[a];
					let bItem = filtered[b];
					return bItem.time - aItem.time;
				})
				.map((ad, i) => {
					return <Advert key={`advert-${i}`} advert={filtered[ad]} />;
				})}
		</AppContainer>
	);
});

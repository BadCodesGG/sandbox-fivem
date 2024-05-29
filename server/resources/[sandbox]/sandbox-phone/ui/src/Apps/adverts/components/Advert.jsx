import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { Grid, Paper, Chip, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { NumericFormat } from 'react-number-format';

import { Categories } from '../data';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useAlert, useAppData } from '../../../hooks';
import Nui from '../../../util/Nui';

const useStyles = makeStyles((theme) => ({
	convo: {
		'&::before': {
			background: 'transparent !important',
		},
		width: '95%',
		background: theme.palette.secondary.dark,
		padding: '10px 12px 0 12px',
		margin: '2px 0',
		transition: 'background 400ms',
		'&:hover': {
			background: theme.palette.secondary.main,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
		margin: '2.5% auto',
	},
	title: {
		fontSize: 22,
		color: '#f9a825',
	},
	time: {
		fontSize: 12,
		color: theme.palette.text.main,
		float: 'right',
		lineHeight: '25px',
	},
	desc: {
		fontSize: 16,
		color: theme.palette.text.light,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		padding: 5,
	},
	categories: {
		display: 'flex',
		justifyContent: 'flex-start',
		flexWrap: 'wrap',
		'& > *': {
			margin: theme.spacing(0.5),
		},
	},
	authorPane: {
		borderTop: '1px solid #f9a825',
		marginTop: 10,
	},
	author: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		right: '1%',
		margin: 'auto',
		fontSize: 12,
		color: theme.palette.text.main,
	},

	adContainer: {
		display: 'flex',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		background: theme.palette.secondary.main,
	},
	info: {
		padding: '10px 10px 10px 16px',
		flexGrow: 1,
		width: '85%',
		transition: 'background ease-in 0.15s',

		'&:hover': {
			background: theme.palette.secondary.light,
			cursor: 'pointer',
		},
	},
	icons: {
		padding: 10,
		width: '15%',
		lineHeight: '57px',
		transition: 'background ease-in 0.15s',
		textAlign: 'center',
		fontSize: 22,

		'&:hover': {
			background: theme.palette.secondary.light,
			cursor: 'pointer',
		},
	},
	coName: {
		fontSize: 22,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	categories: {
		width: 'fit-content',
	},
	price: {
		display: 'inline-block',
		textAlign: 'left',
	},
	priceValue: {
		'&::before': {
			content: '"$"',
			color: theme.palette.success.main,
			marginRight: 1,
		},
		fontSize: 14,
	},
	noprice: {
		textAlign: 'left',
		fontSize: 14,
	},
	yours: {
		color: 'gold',
		fontSize: 10,
		lineHeight: '14px',

		'&::after': {
			content: '"|"',
			color: theme.palette.text.main,
			fontSize: 14,
			marginLeft: 4,
			marginRight: 4,
		},
	},
	postedTime: {
		display: 'inline-block',
		fontSize: 14,

		'&::after': {
			content: '"|"',
			color: theme.palette.text.main,
			marginLeft: 4,
			marginRight: 4,
		},
	},
}));

export default ({ advert }) => {
	const appData = useAppData('adverts');
	const classes = useStyles(appData);
	const history = useNavigate();
	const showAlert = useAlert();
	const callData = useSelector((state) => state.call.call);
	const myId = useSelector((state) => state.data.data.player.Source);
	const cats = Categories.filter((cat) => {
		return advert.categories.includes(cat.label);
	});

	const onClick = () => {
		history(`/apps/adverts/view/${advert.id}`);
	};

	const onCall = async () => {
		if (!Boolean(callData)) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number: advert.number,
						isAnon: false,
					})
				).json();
				if (res) {
					history(`/apps/phone/call/${advert.number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.error(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	return (
		<div className={classes.adContainer}>
			<div className={classes.info} onClick={onClick}>
				<div className={classes.coName}>{advert.title}</div>
				<div>
					<Moment
						className={classes.postedTime}
						interval={60000}
						fromNow
						date={+advert.time}
					/>
					{advert.id === myId ? (
						<span className={classes.yours}>(Your Ad)</span>
					) : null}
					{advert.price != null && advert.price !== '' ? (
						<div className={classes.price}>
							<NumericFormat
								className={classes.priceValue}
								value={advert.price}
								displayType={'text'}
								thousandSeparator={true}
							/>
						</div>
					) : (
						<div className={classes.noprice}>Price Negotiable</div>
					)}
				</div>
			</div>
			{advert.id !== myId && (
				<div className={classes.icons} onClick={onCall}>
					<FontAwesomeIcon icon="phone" />
				</div>
			)}
		</div>
	);

	return (
		<Paper className={classes.convo} onClick={onClick}>
			<Grid container>
				<Grid item xs={12} style={{ position: 'relative' }}>
					<div>
						<span className={classes.title}>{advert.title} </span>
					</div>
					<div className={classes.desc}>{advert.short}</div>
					<div>
						{advert.price != null && advert.price !== '' ? (
							<div className={classes.price}>
								<NumericFormat
									className={classes.priceValue}
									value={advert.price}
									displayType={'text'}
									thousandSeparator={true}
								/>
							</div>
						) : (
							<div className={classes.noprice}>
								Price Negotiable
							</div>
						)}
					</div>
					<div className={classes.categories}>
						{cats.map((cat, i) => {
							return (
								<Chip
									key={`advert-cat-${i}`}
									size="small"
									style={{ backgroundColor: cat.color }}
									label={cat.label}
								/>
							);
						})}
					</div>
				</Grid>
				<Grid item xs={12} className={classes.authorPane}>
					<Grid container style={{ height: 40, padding: '0 5px' }}>
						<Grid
							item
							xs={5}
							style={{ textAlign: 'left', lineHeight: '40px' }}
						>
							<Moment
								className={classes.postedTime}
								interval={60000}
								fromNow
								date={+advert.time}
							/>
						</Grid>
						<Grid
							item
							xs={7}
							style={{ textAlign: 'right', lineHeight: '40px' }}
						>
							{advert.id === myId ? (
								<span className={classes.yours}>(Your Ad)</span>
							) : null}
							{advert.author}
						</Grid>
					</Grid>
				</Grid>
			</Grid>
		</Paper>
	);
};

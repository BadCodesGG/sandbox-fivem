import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { IconButton, TextField } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { NumericFormat } from 'react-number-format';

import Nui from '../../../util/Nui';
import { Modal, Loader } from '../../../components';
import { CurrencyFormat } from '../../../util/Parser';
import { useAlert } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	coin: {
		display: 'flex',
		padding: '14px 14px 8px 8px',
		marginBottom: 4,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		borderRadius: 8,
	},
	icon: {
		width: 40,
		textAlign: 'center',
		fontSize: 22,
		lineHeight: '55px',
		color: (app) => app.color,
	},
	details: {
		flexGrow: 1,
	},
	name: {
		fontSize: 18,
	},
	short: {
		fontSize: 14,
		'&::before': {
			content: '"$"',
		},
		'& small': {
			fontSize: 12,
		},
	},
	actions: {
		lineHeight: '48px',
		'& svg': {
			fontSize: 18,
		},
	},
}));

export default ({ coin, owned, appData, onBuy, onSell }) => {
	const classes = useStyles(appData);
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);

	const [loading, setLoading] = useState(false);

	return (
		<div className={classes.coin}>
			<div className={classes.icon}>
				<FontAwesomeIcon icon={['fab', 'bitcoin']} />
			</div>
			<div className={classes.details}>
				<div className={classes.name}>{coin.Name}</div>
				<div className={classes.short}>
					{coin.Short}

					{Boolean(owned.Quantity) && (
						<small> - Balance: {owned.Quantity}</small>
					)}
				</div>
			</div>
			<div className={classes.actions}>
				{Boolean(coin.Sellable) && (
					<IconButton
						onClick={() =>
							onSell(
								coin.Short,
								isNaN(coin.Sellable)
									? coin.Price
									: coin.Sellable,
							)
						}
					>
						<FontAwesomeIcon icon="dollar-sign" />
					</IconButton>
				)}
				{Boolean(coin.Buyable) && (
					<IconButton onClick={() => onBuy(coin.Short, coin.Price)}>
						<FontAwesomeIcon icon="shopping-cart" />
					</IconButton>
				)}
			</div>
		</div>
	);
};

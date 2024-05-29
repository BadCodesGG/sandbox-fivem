import React, { useState, useEffect, useMemo, Fragment } from 'react';
import { useSelector } from 'react-redux';
import { MenuItem, Tooltip, IconButton, TextField } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { NumericFormat } from 'react-number-format';
import { CopyToClipboard } from 'react-copy-to-clipboard';

import Nui from '../../util/Nui';
import { useAlert, useAppData } from '../../hooks';
import { Modal, AppContainer, Loader } from '../../components';
import { CurrencyFormat } from '../../util/Parser';
import Coin from './components/Coin';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		padding: '0 10px',
		fontFamily: 'Kanit',
	},
	content: {
		height: '92%',
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
	balance: {
		margin: 'auto',
		fontSize: 14,
		padding: 10,
		borderBottom: (app) => `1px solid ${app.color}`,
	},
	currency: {
		fontSize: 22,
		color: theme.palette.success.main,
	},
	editorField: {
		marginBottom: 15,
	},
	wallet: {
		paddingTop: 25,
	},
	highlight: {
		color: theme.palette.success.main,
		transition: 'color ease-in 0.15s',

		'&:hover': {
			color: theme.palette.success.dark,
			cursor: 'pointer',
		},
	},
}));

export default () => {
	const appData = useAppData('crypto');
	const classes = useStyles(appData);
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);

	const tcoins = useSelector((state) => state.data.data.cryptoCoins);

	const [loading, setLoading] = useState(false);
	const [showingWallet, setShowingWallet] = useState(false);
	const [sending, setSending] = useState(false);
	const [selling, setSelling] = useState(null);
	const [buying, setBuying] = useState(false);
	const [coins, setCoins] = useState(null);

	const CalcPortfolioValue = () => {
		if (!Boolean(coins)) return 0;
		let val = 0;

		Object.keys(player.Crypto).forEach((crypto) => {
			let cData = coins.filter((c) => c.Short == crypto)[0];
			if (Boolean(cData)) {
				if (Boolean(cData.Sellable)) {
					if (isNaN(cData.Sellable)) {
						val += player.Crypto[crypto] * cData.Price;
					} else {
						val += player.Crypto[crypto] * cData.Sellable;
					}
				}
			}
		});

		return val;
	};

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('GetCryptoCoins')).json();
					if (res) {
						setCoins(res);
					} else {
						setCoins(Array());
					}
				} catch (err) {
					console.error(err);
					setCoins(tcoins);
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	const startBuying = (short, price) => {
		setBuying({
			Short: short,
			Price: price,
			Quantity: 1,
		});
	};

	const startSelling = (short, price) => {
		setSelling({
			Short: short,
			Price: price,
			Quantity: 1,
		});
	};

	const onTransfer = async (e) => {
		setLoading(true);
		try {
			const cData = coins.filter(
				(c) => c.Short == e.target.coin.value,
			)[0];

			if (Boolean(cData)) {
				let res = await (
					await Nui.send('TransferCrypto', {
						Short: e.target.coin.value,
						Quantity: +e.target.quantity.value,
						Target: e.target.target.value,
					})
				).json();

				if (res) {
					showAlert(`Sent ${e.target.quantity.value} ${cData.Short}`);
				} else {
					showAlert(`Unable to Transfer ${cData.Short}`);
				}
			} else {
				showAlert('Invalid Currency');
			}
		} catch (err) {
			console.error(err);
			showAlert(`Unable to Transfer Crypto`);
		}
		setSending(false);
		setLoading(false);
	};

	const onBuy = async (e) => {
		setLoading(true);
		try {
			let res = await (
				await Nui.send('BuyCrypto', {
					Short: buying.Short,
					Quantity: buying.Quantity,
				})
			).json();

			if (Boolean(res)) {
				showAlert(`Purchased $${buying.Short}`);
				setBuying(null);
			} else {
				showAlert(`Unable to Buy $${buying.Short}`);
			}
		} catch (err) {
			console.error(err);
			showAlert(`Unable to Buy $${buying.Short}`);
		}
		setBuying(null);
		setLoading(false);
	};

	const onSell = async (e) => {
		setLoading(true);
		try {
			let res = await (
				await Nui.send('SellCrypto', {
					Short: selling.Short,
					Quantity: selling.Quantity,
				})
			).json();

			if (!res.error) {
				showAlert(`Sold ${e.target.quantity.value} $${selling.Short}`);
				setSelling(null);
			} else {
				showAlert(`Unable to Sell $${selling.Short}`);
			}
		} catch (err) {
			console.error(err);
			showAlert(`Unable to Sell $${selling.Short}`);
		}
		setSelling(false);
		setLoading(false);
	};

	return (
		<AppContainer
			appId="crypto"
			actions={
				<Fragment>
					<Tooltip title="Your Wallet Information">
						<IconButton onClick={() => setShowingWallet(true)}>
							<FontAwesomeIcon icon={['far', 'wallet']} />
						</IconButton>
					</Tooltip>
					<Tooltip title="Transfer Crypto">
						<IconButton onClick={() => setSending(true)}>
							<FontAwesomeIcon
								icon={['far', 'arrow-up-from-dotted-line']}
							/>
						</IconButton>
					</Tooltip>
					<Tooltip title="Refresh Coin Listing">
						<IconButton onClick={fetch}>
							<FontAwesomeIcon
								className={`fa ${loading ? 'fa-spin' : ''}`}
								icon={['far', 'arrows-rotate']}
							/>
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			{loading ? (
				<Loader static text="Loading Coins" />
			) : (
				<div className={classes.wrapper}>
					<div className={classes.balance}>
						<div>Balance</div>
						<div className={classes.currency}>
							{CurrencyFormat.format(CalcPortfolioValue())}
						</div>
					</div>
					<div className={classes.coins}>
						{Boolean(coins) &&
							coins
								.filter(
									(c) =>
										c.Buyable ||
										Boolean(player?.Crypto[c.Short]),
								)
								.map((coin) => {
									return (
										<Coin
											appData={appData}
											key={coin.Short}
											coin={coin}
											owned={{
												Quantity:
													player.Crypto[coin.Short],
											}}
											onBuy={startBuying}
											onSell={startSelling}
										/>
									);
								})}
					</div>
				</div>
			)}
			{showingWallet && (
				<Modal
					open={showingWallet}
					title="Your Wallet Information"
					onClose={() => setShowingWallet(false)}
				>
					<div className={classes.wallet}>
						Wallet Address:{' '}
						<CopyToClipboard
							text={player.CryptoWallet}
							key={player.CryptoWallet}
							onCopy={() => showAlert('Wallet Address Copied')}
						>
							<span className={classes.highlight}>
								{player.CryptoWallet}
							</span>
						</CopyToClipboard>
					</div>
				</Modal>
			)}
			{sending && (
				<Modal
					form
					formStyle={{ position: 'relative' }}
					open={true}
					title="Send Crypto"
					onClose={() => setSending(false)}
					onAccept={onTransfer}
					submitLang="Send"
					closeLang="Cancel"
				>
					<>
						{loading && <Loader static text="Sending" />}
						<TextField
							fullWidth
							required
							select
							label="Coin"
							name="coin"
							className={classes.editorField}
							disabled={loading}
							defaultValue={Object.keys(player?.Crypto)[0]}
						>
							{Object.keys(player.Crypto).map((crypto) => {
								const cData = coins.filter(
									(c) => c.Short == crypto,
								)[0];
								if (!Boolean(cData)) return null;
								return (
									<MenuItem key={crypto} value={crypto}>
										{cData.Name}
									</MenuItem>
								);
							})}
						</TextField>
						<TextField
							fullWidth
							required
							label="Target Wallet ID"
							name="target"
							className={classes.editorField}
							disabled={loading}
							// type="tel"
							// isNumericString
							// customInput={TextField}
						/>
						<NumericFormat
							fullWidth
							required
							label="Quantity"
							name="quantity"
							allowNegative={false}
							className={classes.editorField}
							disabled={loading}
							type="tel"
							customInput={TextField}
						/>
					</>
				</Modal>
			)}
			{Boolean(selling) && (
				<Modal
					form
					formStyle={{ position: 'relative' }}
					open={true}
					title={`Sell $${selling.Short}`}
					onClose={() => setSelling(null)}
					onAccept={onSell}
					submitLang="Sell"
					closeLang="Cancel"
				>
					<>
						{loading && <Loader static text="Selling" />}
						<TextField
							fullWidth
							label="Price Per Unit"
							disabled={true}
							className={classes.editorField}
							value={CurrencyFormat.format(selling.Price)}
						/>
						<NumericFormat
							fullWidth
							required
							label="Quantity"
							name="quantity"
							className={classes.editorField}
							disabled={loading}
							value={selling.Quantity}
							onChange={(e) =>
								setSelling({
									...selling,
									Quantity: isNaN(e.target.value)
										? selling.Quantity
										: +e.target.value,
								})
							}
							isAllowed={({ floatValue }) =>
								floatValue >= 1 &&
								floatValue <= player.Crypto[selling.Short]
							}
							type="tel"
							allowNegative={false}
							customInput={TextField}
						/>
						<TextField
							fullWidth
							label="You Will Receive"
							disabled={true}
							className={classes.editorField}
							value={CurrencyFormat.format(
								selling.Price * selling.Quantity,
							)}
						/>
					</>
				</Modal>
			)}
			{Boolean(buying) && (
				<Modal
					form
					formStyle={{ position: 'relative' }}
					open={true}
					title={`Buy $${buying.Short}`}
					onClose={() => setBuying(null)}
					onAccept={onBuy}
					submitLang={`Buy $${buying.Short}`}
					closeLang="Cancel"
				>
					<>
						{loading && <Loader static text="Buying" />}
						<TextField
							fullWidth
							label="Price Per Unit"
							disabled={true}
							className={classes.editorField}
							value={CurrencyFormat.format(buying.Price)}
						/>
						<NumericFormat
							fullWidth
							required
							allowNegative={false}
							label="Quantity"
							className={classes.editorField}
							value={buying.Quantity}
							disabled={loading}
							onChange={(e) =>
								setBuying({
									...buying,
									Quantity: +e.target.value,
								})
							}
							type="tel"
							customInput={TextField}
						/>
						<TextField
							fullWidth
							label="You Will Pay"
							disabled={true}
							className={classes.editorField}
							value={CurrencyFormat.format(
								buying.Price * buying.Quantity,
							)}
						/>
					</>
				</Modal>
			)}
		</AppContainer>
	);
};

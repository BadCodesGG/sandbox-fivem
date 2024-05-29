import React, { Fragment, useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate, useParams } from 'react-router-dom';
import {
	Grid,
	AppBar,
	TextField,
	Pagination,
	Select,
	MenuItem,
	Button,
	IconButton,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { NumericFormat } from 'react-number-format';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { AppContainer, Loader } from '../../components';

import Nui from '../../util/Nui';
import { useAlert, useMyApps } from '../../hooks';
import { Modal } from '../../components';
import Transaction from './component/Transaction';

import { getAccountName, getAccountType } from './utils';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
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
	content: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		height: 'fit-content',
		width: '100%',
		padding: '5px 7.5% 5px 2%',
		textAlign: 'center',
		margin: 'auto',
		fontSize: 28,
		'& svg': {
			color: theme.palette.primary.main,
			fontSize: 35,
		},
	},
	subBar: {
		padding: 15,
		textAlign: 'left',
		lineHeight: '30px',
		backgroundColor: theme.palette.secondary.light,
	},
	currency: {
		color: theme.palette.success.main,
	},
	editField: {
		marginBottom: 20,
		width: '100%',
	},

	accBtnStatic: {
		zIndex: 1,
		padding: 5,
		lineHeight: '60px',
		textAlign: 'center',
		fontSize: 22,
		height: 65,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		border: `1px solid ${theme.palette.border.divider}`,
		borderLeft: `2px solid ${theme.palette.secondary.light}`,
		transition: 'border ease-in 0.15s',
		userSelect: 'none',
		'&:not(:last-of-type)': {
			marginBottom: 4,
		},
		'& .currency': {
			'&::before': {
				content: '"$"',
				marginRight: 2,
				color: theme.palette.success.main,
			},
		},
	},
	accountBody: {
		padding: '0 4px',
		height: '73%',
	},
	transactions: {
		maxHeight: '90%',
		height: '100%',
		overflow: 'auto',
		padding: '0 15px',
	},
}));

const NumericFormatCustom = React.forwardRef((props, ref) => {
	const { inputRef, onChange, ...other } = props;
	const withValueLimit = ({ floatValue }) =>
		floatValue >= 1 && floatValue <= 10000000;

	return (
		<NumericFormat
			{...other}
			getInputRef={inputRef}
			isAllowed={withValueLimit}
			onValueChange={(values) => {
				onChange({
					target: {
						name: props.name,
						value: values.floatValue,
					},
				});
			}}
			thousandSeparator
			isNumericString
			prefix="$"
		/>
	);
});

export default (props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useNavigate();
	const dispatch = useDispatch();
	const params = useParams();
	const { account } = params;
	const myAccounts = useSelector((state) => state.data.data.bankAccounts);
	const accountData =
		myAccounts?.accounts &&
		myAccounts.accounts.find((acc) => acc.Account == account);

	const [moreTransactions, setMoreTransactions] = useState(false);
	const [accTrans, setAccTrans] = useState(Array());
	const [loading, setLoading] = useState(0);

	const [transfer, setTransfer] = useState(false);
	const [tState, setTState] = useState({
		targetType: false,
		target: '',
		amount: '',
		description: '',
	});

	const apps = useMyApps();
	const app = apps["bank"];

	useEffect(() => {
		setAccTrans(Array());
		setMoreTransactions(false);

		if (accountData?.Permissions?.TRANSACTIONS) {
			getTransactions();
		}
	}, [accountData]);

	const getTransactions = async () => {
		try {
			//setLoading(true);
			let res = await (
				await Nui.send('Banking:GetTransactions', {
					account: accountData.Account,
					offset: accTrans.length,
					perPage: 15,
				})
			).json();

			if (res?.data) {
				setMoreTransactions(res.more);

				setAccTrans([
					...accTrans,
					...res.data,
				]);
			}
		} catch (err) {
			console.log(err);
		}

		//setLoading(false);
	};

	const openTransferModal = () => {
		if (accountData.Permissions?.WITHDRAW) {
			if (accountData.Balance > 0) {
				setTState({
					targetType: false,
					target: tState.target,
					amount: '',
				});
				setTransfer(true);
			} else {
				showAlert('No Balance to Transfer');
			}
		}
	};

	const onTChange = (e) => {
		setTState({
			...tState,
			[e.target.name]: e.target.value,
		});
	};

	const onTransfer = async (e) => {
		e.preventDefault();
		setLoading(1);

		try {
			let res = await (
				await Nui.send('Banking:Transfer', {
					account: accountData.Account,
					targetType: tState.targetType,
					target: tState.target,
					amount:
						tState.amount > accountData.Balance
							? accountData.Balance
							: tState.amount,
					description: tState.description,
				})
			).json();
			if (res) {
				showAlert('Funds Transferred Successfully');
				setTimeout(() => {
					history(-1);
				}, 250);
			} else {
				showAlert('Error Transferring Funds');
			}
		} catch (err) {
			showAlert('Error Transferring Funds');
		}

		setTransfer(false);
		setTState({
			targetType: false,
			target: '',
			amount: '',
			description: '',
		});
		setLoading(0);
	};

	const [billing, setBilling] = useState(false);
	const [bState, setBState] = useState({
		target: '',
		description: '',
		amount: '',
	});

	const openBilling = () => {
		if (accountData.Permissions?.BILL) {
			setBilling(true);
		}
	};

	const onBChange = (e) => {
		setBState({
			...bState,
			[e.target.name]: e.target.value,
		});
	};

	const onBill = async (e) => {
		e.preventDefault();
		setLoading(2);

		try {
			let res = await (
				await Nui.send('Banking:Bill', {
					fromAccount: accountData.Account,
					target: bState.target,
					description: bState.description,
					amount: bState.amount,
				})
			).json();
			if (res) {
				showAlert('Bill Sent Successfully');
				history(-1);
			} else {
				showAlert('Error Creating Bill');
			}
		} catch (err) {
			showAlert('Error Creating Bill');
		}

		setBilling(false);
		setBState({
			target: '',
			description: '',
			amount: '',
		});
		setLoading(0);
	};

	return (
		<AppContainer
			appId="bank"
			titleOverride={getAccountName(accountData)}
			actions={
				<Fragment>
					{accountData.Permissions?.BILL && (
						<IconButton
							onClick={() => openBilling()}
							disabled={Boolean(loading)}
						>
							<FontAwesomeIcon
								icon={['far', 'file-invoice-dollar']}
							/>
						</IconButton>
					)}
					{accountData.Permissions?.WITHDRAW && (
						<IconButton
							onClick={() => openTransferModal()}
							disabled={Boolean(loading)}
						>
							<FontAwesomeIcon
								icon={['far', 'money-bill-1-wave']}
							/>
						</IconButton>
					)}
				</Fragment>
			}
		>
			{loading ? (
				<div className={classes.wrapper}>
					<Loader
						static
						text={
							loading === 1
								? 'Completing Transfer'
								: 'Creating Bill'
						}
					/>
				</div>
			) : Boolean(accountData) ? (
				<Fragment>
					<AppBar position="static">
						<Grid container className={classes.subBar}>
							<Grid item xs={12}>
								Account Number: {accountData.Account}
							</Grid>
							<Grid item xs={12}>
								Account Type: {getAccountType(accountData)}
							</Grid>
						</Grid>
					</AppBar>
					<div className={classes.accBtnStatic}>
						<div className={classes.details}>
							<div className={classes.detail}>
								<span className="currency">
									{accountData.Permissions?.BALANCE
										? accountData.Balance.toLocaleString(
											'en-US',
										)
										: '???'}
								</span>
							</div>
						</div>
					</div>
					{accountData.Permissions?.TRANSACTIONS && (
						<div className={classes.accountBody}>
							<div className={classes.transactions}>
								{Boolean(accTrans) &&
									accTrans.length > 0 ? (
									<Fragment>
										{accTrans
											.sort((a, b) => b.Timestamp - a.Timestamp)
											.map((transactionLog, k) => {
												return (
													<Transaction
														key={`trans-${k}`}
														transaction={transactionLog}
													/>
												);
											})}
										{(moreTransactions && accTrans.length < 100) && (
											<Button
												fullWidth
												color="success"
												onClick={() => {
													getTransactions();
												}}
											>
												Load More
											</Button>
										)}
									</Fragment>
								) : (
									<Fragment>No Transaction History</Fragment>
								)}
							</div>
						</div>
					)}
					<Modal
						form
						open={billing}
						title="Send Bill"
						submitLang="Bill"
						onAccept={onBill}
						onClose={() => setBilling(false)}
					>
						<TextField
							required
							fullWidth
							className={classes.editField}
							label="Billing State ID"
							name="target"
							type="text"
							value={bState.target}
							helperText={'The State ID of who you want to bill.'}
							inputProps={{
								maxLength: 6,
							}}
							onChange={onBChange}
						/>
						<TextField
							required
							fullWidth
							className={classes.editField}
							label="Billing Description"
							name="description"
							type="text"
							value={bState.description}
							multiline={true}
							inputProps={{
								maxLength: 240,
							}}
							onChange={onBChange}
						/>
						<TextField
							required
							fullWidth
							className={classes.editField}
							label="Bill Amount"
							name="amount"
							value={bState.amount}
							onChange={onBChange}
							InputProps={{
								inputComponent: NumericFormatCustom,
							}}
							inputProps={{
								maxLength: 16,
							}}
						/>
					</Modal>
					<Modal
						form
						open={transfer}
						title="Transfer Funds"
						submitLang="Transfer"
						onAccept={onTransfer}
						onClose={() => setTransfer(false)}
					>
						<TextField
							disabled
							required
							fullWidth
							className={classes.editField}
							value={accountData.Account}
							label="Transfering From"
							name="source"
							type="text"
						/>
						<Select
							id="targetType"
							name="targetType"
							className={classes.editField}
							value={tState.targetType}
							onChange={onTChange}
						>
							<MenuItem value={false}>
								Transfer By Bank Account
							</MenuItem>
							<MenuItem value={true}>
								Transfer By State ID
							</MenuItem>
						</Select>
						<TextField
							required
							fullWidth
							className={classes.editField}
							label="Transfering To"
							name="target"
							type="text"
							helperText={
								tState.targetType
									? 'Transferring By State ID'
									: 'Transferring By Bank Account'
							}
							value={tState.target}
							inputProps={{
								maxLength: 6,
							}}
							onChange={onTChange}
						/>
						<TextField
							required
							fullWidth
							className={classes.editField}
							label="Transfering Amount"
							helperText={`Max Transferable: $${accountData.Balance.toLocaleString(
								'en-US',
							)}`}
							name="amount"
							value={tState.amount}
							onChange={onTChange}
							InputProps={{
								inputComponent: NumericFormatCustom,
							}}
							inputProps={{
								maxLength: 16,
							}}
						/>
						<TextField
							fullWidth
							multiline
							className={classes.editField}
							label="Transfering Description"
							helperText={'Not Required but Recommended'}
							name="description"
							value={tState.description}
							onChange={onTChange}
							inputProps={{
								maxLength: 240,
							}}
						/>
					</Modal>
				</Fragment>
			) : (
				<div className={classes.wrapper}>
					<p>Something Went Wrong</p>
				</div>
			)}
		</AppContainer>
	);
};

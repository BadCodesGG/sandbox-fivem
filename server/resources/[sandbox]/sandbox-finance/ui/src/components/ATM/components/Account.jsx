import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import {
	Grid,
	Button,
	List,
	ListItem,
	TextField,
	ListItemText,
	ButtonGroup,
} from '@mui/material';
import { NumericFormat } from 'react-number-format';
import { toast } from 'react-toastify';

import Nui from '../../../util/Nui';
import { Modal, Loader } from '../../';
import { CurrencyFormat } from '../../../util/Parser';

import { getAccountType } from '../../Bank/utils';

const useStyles = makeStyles((theme) => ({
	container: {
		background: theme.palette.secondary.dark,
		borderLeft: `2px solid ${theme.palette.primary.main}`,
		padding: 5,
		height: '100%',
		width: '100%',
	},
	accountName: {
		fontSize: 24,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	money: {
		color: theme.palette.success.main,
	},
	quickBtn: {
		display: 'block',
		padding: 10,
	},
	field: {
		marginBottom: 15,
	},
	blockContent: {
		fontSize: 18,
		marginLeft: 20,
		height: 'fit-content',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&:not(:last-of-type)': {
			marginBottom: 10,
		},
	},
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const user = useSelector((state) => state.data.data.character);
	const accounts = useSelector((state) => state.data.data.accounts);
	const sel = useSelector((state) => state.bank.selected);

	const [loading, setLoading] = useState(null);

	const [account, setAccount] = useState(
		accounts.filter((a) => a.Account == sel).length > 0
			? accounts.filter((a) => a.Account == sel)[0]
			: null,
	);

	const [depositing, setDepositing] = useState(false);
	const [withdrawing, setWithdrawing] = useState(false);

	useEffect(() => {
		let f = accounts.filter((a) => a.Account == sel);
		if (f.length > 0) {
			setAccount(f[0]);
		} else setAccount(null);
	}, [accounts, sel]);

	const onDeposit = async (e) => {
		e.preventDefault();

		if (!account?.Permissions?.DEPOSIT) {
			setDepositing(false);
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Deposit', {
					account: account.Account,
					amount: e.target.amount.value,
					comments: e.target.notes.value,
				})
			).json();

			if (res?.state) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account.Account,
						data: {
							...account,
							Balance: +account.Balance + +e.target.amount.value,
						},
					},
				});

				dispatch({
					type: 'SET_DATA',
					payload: {
						type: 'character',
						data: {
							...user,
							Cash: user.Cash - +e.target.amount.value,
						},
					},
				});
				toast.success('Funds Deposited');
			} else {
				toast.error('Unable To Deposit Funds');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Deposit Funds');
		}

		setLoading(false);
		setDepositing(false);
	};

	const onWithdraw = async (e) => {
		e.preventDefault();

		if (!account?.Permissions?.WITHDRAW) {
			setWithdrawing(false);
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Withdraw', {
					account: account.Account,
					amount: e.target.amount.value,
					comments: e.target.notes.value,
				})
			).json();

			if (res?.state) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account.Account,
						data: {
							...account,
							Balance: +account.Balance - +e.target.amount.value,
						},
					},
				});

				dispatch({
					type: 'SET_DATA',
					payload: {
						type: 'character',
						data: {
							...user,
							Cash: user.Cash + +e.target.amount.value,
						},
					},
				});
				toast.success('Funds Withdrawn');
			} else {
				toast.error('Unable To Withdraw Funds');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Withdraw Funds');
		}

		setLoading(false);
		setWithdrawing(false);
	};

	if (!Boolean(account)) return null;
	return (
		<>
			<Grid container spacing={2}>
				<Grid item xs={12} className={classes.accountName}>
					{account.Name}
				</Grid>
				<Grid item xs={12}>
					<List>
						<ListItem>
							<ListItemText
								primary="Account Type"
								secondary={getAccountType(account)}
							/>
							<ListItemText
								primary="Available Balance"
								secondary={
									account?.Permissions?.BALANCE ? (
										<span className={classes.money}>
											{CurrencyFormat.format(
												account.Balance,
											)}
										</span>
									) : (
										<span>???</span>
									)
								}
							/>
							<ListItemText
								primary="Account Number"
								secondary={account.Account}
							/>
						</ListItem>
					</List>
				</Grid>
				<Grid item xs={12}>
					<List>
						<ListItem>
							<ButtonGroup fullWidth>
								<Button
									fullWidth
									color="success"
									variant="contained"
									className={classes.quickBtn}
									disabled={
										!account?.Permissions?.DEPOSIT &&
										user.Cash == 0
									}
									onClick={() => setDepositing(true)}
								>
									Deposit Cash
								</Button>
								<Button
									fullWidth
									color="warning"
									variant="contained"
									className={classes.quickBtn}
									disabled={
										!account?.Permissions?.WITHDRAW ||
										account.Balance == 0
									}
									onClick={() => setWithdrawing(true)}
								>
									Withdraw Cash
								</Button>
							</ButtonGroup>
						</ListItem>
					</List>
				</Grid>
			</Grid>
			<>
				{account?.Permissions?.DEPOSIT && (
					<Modal
						open={depositing}
						title={`Deposit Funds Into ${account.Name}`}
						closeLang="Cancel"
						maxWidth="sm"
						onClose={() => setDepositing(false)}
						onSubmit={onDeposit}
					>
						{loading && <Loader static text="Loading" />}
						<NumericFormat
							fullWidth
							required
							label="Deposit To"
							className={classes.field}
							disabled={true}
							type="tel"
							isNumericString
							value={account.Account}
							customInput={TextField}
						/>
						<NumericFormat
							fullWidth
							required
							label="Amount"
							name="amount"
							className={classes.field}
							disabled={loading}
							type="tel"
							isNumericString
							customInput={TextField}
						/>
						<TextField
							fullWidth
							multiline
							minRows={3}
							className={classes.input}
							disabled={loading}
							label="Transaction Comment"
							name="notes"
							variant="outlined"
						/>
					</Modal>
				)}
				{account?.Permissions?.WITHDRAW && (
					<Modal
						open={withdrawing}
						title={`Withdraw Funds From ${account.Name}`}
						closeLang="Cancel"
						maxWidth="sm"
						onClose={() => setWithdrawing(false)}
						onSubmit={onWithdraw}
					>
						{loading && <Loader static text="Loading" />}
						<NumericFormat
							fullWidth
							required
							label="Withdraw From"
							className={classes.field}
							disabled={true}
							type="tel"
							isNumericString
							value={account.Account}
							customInput={TextField}
						/>
						<NumericFormat
							fullWidth
							required
							label="Amount"
							name="amount"
							className={classes.field}
							disabled={loading}
							type="tel"
							isNumericString
							customInput={TextField}
						/>
						<TextField
							fullWidth
							multiline
							minRows={3}
							className={classes.input}
							disabled={loading}
							label="Transaction Comment"
							name="notes"
							variant="outlined"
						/>
					</Modal>
				)}
			</>
		</>
	);
};

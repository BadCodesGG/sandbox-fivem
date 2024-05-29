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
	Alert,
	MenuItem,
	ListItemSecondaryAction,
	IconButton,
	ButtonGroup,
} from '@mui/material';
import { NumericFormat } from 'react-number-format';
import { toast } from 'react-toastify';

import Nui from '../../../util/Nui';
import { Modal, Loader } from '../../';
import Transaction from './Transaction';
import { CurrencyFormat } from '../../../util/Parser';

import { getAccountType } from '../utils';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

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

const Types = [
	{
		value: false,
		label: 'Account Number',
	},
	{
		value: true,
		label: 'State ID',
	},
];

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
	const [accTrans, setAccTrans] = useState(Array());
	const [moreTransactions, setMoreTransactions] = useState(false);

	const [viewingOwners, setViewingOwners] = useState(false);
	const [renaming, setRenaming] = useState(false);
	const [depositing, setDepositing] = useState(false);
	const [withdrawing, setWithdrawing] = useState(false);
	const [transferring, setTransferring] = useState(false);
	const [addOwner, setAddOwner] = useState(false);

	const [xferType, setXferType] = useState(false);
	useEffect(() => {
		if (transferring) setXferType(false);
	}, [transferring]);

	useEffect(() => {
		setAccTrans([]);
		setMoreTransactions(false);

		let f = accounts.filter((a) => a.Account == sel);
		if (f.length > 0) {
			setAccount(f[0]);
		} else setAccount(null);
	}, [accounts, sel]);

	useEffect(() => {
		setAccTrans([]);
		setMoreTransactions(false);

		if (account?.Permissions?.TRANSACTIONS) {
			getTransactions();
		}
	}, [account]);

	const getTransactions = async () => {
		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:GetTransactions', {
					account: account.Account,
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

		setLoading(false);
	};

	const onRename = async (e) => {
		e.preventDefault();

		if (account.Type == 'organization' || !account?.Permissions?.MANAGE) {
			setRenaming(false);
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Rename', {
					account: account.Account,
					name: e.target.name.value,
				})
			).json();

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account.Account,
						data: {
							...account,
							Name: e.target.name.value,
						},
					},
				});
				toast.success('Account Renamed');
			} else {
				toast.error('Unable To Rename Account');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Rename Account');
		}

		setLoading(false);
		setRenaming(false);
	};

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

				setAccTrans([
					{
						Amount: e.target.amount.value,
						Type: 'deposit',
						TransactionAccount: false,
						Title: 'Cash Deposit',
						Data: {
							character: user.SID,
						},
						Account: account.Account,
						Timestamp: Date.now() / 1000,
						Description:
							e.target.notes.value ?? 'No Description',
					},
					accTrans.splice(-1),
				]);

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

				setAccTrans([
					{
						Amount: e.target.amount.value,
						Type: 'withdraw',
						TransactionAccount: false,
						Title: 'Cash Withdrawal',
						Data: {
							character: user.SID,
						},
						Account: account.Account,
						Timestamp: Date.now() / 1000,
						Description:
							e.target.notes.value ?? 'No Description',
					},
					...accTrans.splice(-1),
				])

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

	const onTransfer = async (e) => {
		e.preventDefault();

		if (!account?.Permissions?.WITHDRAW) {
			setWithdrawing(false);
			return;
		}

		let xferType = e.target.type.value === 'true';
		if (xferType && e.target.target.value == user.SID) {
			toast.error(
				'Cannot Transfer To Your Own State ID, Use Account Numbers',
			);
			return;
		}

		if (!xferType && e.target.target.value == account.Account) {
			toast.error('Cannot Transfer Funds To The Same Account');
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Transfer', {
					account: account.Account,
					type: xferType,
					target: e.target.target.value,
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

				setAccTrans([
					{
						Amount: e.target.amount.value,
						Type: 'transfer',
						TransactionAccount: false,
						Title: 'Outgoing Bank Transfer',
						Data: {
							character: user.SID,
						},
						Account: account.Account,
						Timestamp: Date.now() / 1000,
						Description: `Transfer To Account: ${e.target.target.value
							}.${e.target.notes.value != ''
								? ` Description: ${e.target.notes.value}`
								: ''
							}`,
					},
					...accTrans.splice(-1)
				]);

				if (!xferType) {
					let t = accounts.filter(
						(a) => a.Account == e.target.target.value,
					);

					if (t.length > 0) {
						dispatch({
							type: 'UPDATE_DATA',
							payload: {
								type: 'accounts',
								id: t[0].Account,
								data: {
									...t[0],
									Balance:
										+t[0].Balance + +e.target.amount.value,
								},
							},
						});

						setAccTrans([
							{
								Amount: e.target.amount.value,
								Type: 'transfer',
								TransactionAccount: false,
								Title: 'Incoming Bank Transfer',
								Data: {
									character: user.SID,
								},
								Account: t[0].Account,
								Timestamp: Date.now() / 1000,
								Description: `Transfer From Account: ${account.Account
									}.${e.target.notes.value != ''
										? ` Description: ${e.target.notes.value}`
										: ''
									}`,
							},
							...accTrans.splice(-1)
						])
					}
				}

				toast.success('Funds Transferred');
			} else {
				toast.error('Unable To Transfer Funds');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Transfer Funds');
		}

		setTransferring(false);
		setLoading(false);
	};

	const onAddOwner = async (e) => {
		e.preventDefault();

		if (
			account.Type != 'personal_savings' ||
			account.Owner != user.SID ||
			!account?.Permissions?.MANAGE
		) {
			setAddOwner(false);
			return;
		}

		if (user.SID == e.target.target.value) {
			toast.error('You Cannot Add Yourself As A Joint Owner');
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:AddJoint', {
					account: account.Account,
					target: e.target.target.value,
				})
			).json();

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account.Account,
						data: {
							...account,
							JointOwners: [
								...account.JointOwners,
								+e.target.target.value,
							],
						},
					},
				});
				toast.success('Joint Owner Added');
			} else {
				toast.error('Unable To Add Joint Owner');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Add Joint Owner');
		}

		setLoading(false);
		setAddOwner(false);
	};

	const onRemoveOwner = async (stateId) => {
		if (
			account.Type != 'personal_savings' ||
			account.Owner != user.SID ||
			!account?.Permissions?.MANAGE
		) {
			setAddOwner(false);
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:RemoveJoint', {
					account: account.Account,
					target: stateId,
				})
			).json();

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account.Account,
						data: {
							...account,
							JointOwners: account.JointOwners.filter(
								(o) => o != stateId,
							),
						},
					},
				});
				toast.success('Joint Owner Removed');
			} else {
				toast.error('Unable To Remove Joint Owner');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Remove Joint Owner');
		}

		setLoading(false);
		setAddOwner(false);
	};

	if (!Boolean(account)) return null;
	return (
		<>
			<Grid container spacing={2}>
				<Grid item xs={12} className={classes.accountName}>
					{account.Name}
				</Grid>
				<Grid item xs={6}>
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
				<Grid item xs={6}>
					<List>
						<ListItem>
							<ButtonGroup fullWidth>
								{account.Type != 'organization' && (
									<Button
										fullWidth
										color="success"
										variant="contained"
										disabled={
											loading ||
											!account?.Permissions?.WITHDRAW
										}
										className={classes.quickBtn}
										onClick={() => setRenaming(true)}
									>
										Change Account Nickname
									</Button>
								)}
								{account.Type == 'personal_savings' &&
									account.Owner == user.SID && (
										<Button
											fullWidth
											color="info"
											variant="contained"
											disabled={
												loading ||
												!account?.Permissions?.WITHDRAW
											}
											className={classes.quickBtn}
											onClick={() =>
												setViewingOwners(true)
											}
										>
											Manage Joint Owners
										</Button>
									)}
							</ButtonGroup>
						</ListItem>
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
								<Button
									fullWidth
									color="info"
									variant="contained"
									className={classes.quickBtn}
									disabled={
										!account?.Permissions?.WITHDRAW ||
										account.Balance == 0
									}
									onClick={() => setTransferring(true)}
								>
									Transfer Funds
								</Button>
							</ButtonGroup>
						</ListItem>
					</List>
				</Grid>
				{account?.Permissions?.TRANSACTIONS ? (
					<Grid item xs={12}>
						<List
							className={classes.blockContent}
							style={{
								paddingRight: 10,
								height: 550,
							}}
						>
							{Boolean(accTrans) && accTrans.length > 0 ? (
								accTrans
									.sort((a, b) => b.Timestamp - a.Timestamp)
									.map((t, k) => {
										return (
											<Transaction
												key={`${account.Account}-${k}`}
												transaction={t}
											/>
										);
									})
							) : (
								<ListItem
									style={{
										textAlign: 'center',
									}}
								>
									No Recent Transactions
								</ListItem>
							)}
							{(Boolean(accTrans) &&
								moreTransactions && accTrans?.length < 100) && (
									<Button
										fullWidth
										color="success"
										variant="contained"
										style={{
											marginTop: 10,
										}}
										onClick={() => {
											getTransactions();
										}}
									>
										Load More
									</Button>
								)}
						</List>
					</Grid>
				) : (
					<Grid item xs={12}>
						<List>
							<ListItem>
								<ListItemText primary="You Don't Have Permission To View Transaction History For This Account" />
							</ListItem>
						</List>
					</Grid>
				)}
			</Grid>
			<>
				{account?.Permissions?.MANAGE &&
					account.Type != 'organization' && (
						<Modal
							open={renaming}
							title={`Rename ${account.Name}`}
							closeLang="Cancel"
							maxWidth="sm"
							onClose={() => setRenaming(false)}
							onSubmit={onRename}
						>
							{loading && <Loader static text="Loading" />}
							<TextField
								fullWidth
								required
								className={classes.input}
								label="Account Nickname"
								defaultValue={account.Name}
								name="name"
								variant="outlined"
							/>
						</Modal>
					)}
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
				{account?.Permissions?.WITHDRAW && (
					<Modal
						open={transferring}
						title={`Transfer Funds From ${account.Name}`}
						closeLang="Cancel"
						maxWidth="sm"
						onClose={() => setTransferring(false)}
						onSubmit={onTransfer}
					>
						{loading && <Loader static text="Loading" />}
						<NumericFormat
							fullWidth
							required
							label="Transfer From"
							className={classes.field}
							disabled={true}
							type="tel"
							isNumericString
							value={account.Account}
							customInput={TextField}
						/>
						<TextField
							select
							fullWidth
							required
							name="type"
							className={classes.field}
							label="Transfer Type"
							onChange={(e) => setXferType(e.target.value)}
							value={xferType}
						>
							{Types.map((option) => (
								<MenuItem
									key={option.value}
									value={option.value}
								>
									{option.label}
								</MenuItem>
							))}
						</TextField>
						<NumericFormat
							fullWidth
							required
							label={xferType ? 'State ID' : 'Account Number'}
							name="target"
							className={classes.field}
							disabled={loading}
							type="tel"
							isNumericString
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
				{account?.Permissions?.MANAGE &&
					account.Type == 'personal_savings' && (
						<>
							<Modal
								open={viewingOwners}
								title={`${account.Name} Joint Owners`}
								closeLang="Close"
								acceptLang="Add Owner"
								maxWidth="sm"
								onClose={() => setViewingOwners(false)}
								onAccept={
									account.Owner == user.SID
										? () => setAddOwner(true)
										: null
								}
							>
								<List>
									{account.JointOwners.length > 0 ? (
										account.JointOwners.map((o) => {
											return (
												<ListItem
													key={`${account.Account}-${o}`}
												>
													<ListItemText
														primary="State ID"
														secondary={o}
													/>
													<ListItemSecondaryAction>
														<IconButton
															onClick={() =>
																onRemoveOwner(o)
															}
														>
															<FontAwesomeIcon
																icon={[
																	'fas',
																	'x',
																]}
															/>
														</IconButton>
													</ListItemSecondaryAction>
												</ListItem>
											);
										})
									) : (
										<ListItem>
											<Alert
												style={{ width: '100%' }}
												variant="filled"
												severity="error"
											>
												No Joint Owners
											</Alert>
										</ListItem>
									)}
								</List>
							</Modal>
							{account.Owner == user.SID && (
								<Modal
									open={addOwner}
									title={`Add Joint Owner To ${account.Name}`}
									closeLang="Cancel"
									maxWidth="sm"
									onClose={() => setAddOwner(false)}
									onSubmit={onAddOwner}
								>
									{loading && (
										<Loader static text="Loading" />
									)}
									<NumericFormat
										fullWidth
										required
										label="State ID"
										name="target"
										className={classes.field}
										disabled={loading}
										type="tel"
										isNumericString
										customInput={TextField}
									/>
								</Modal>
							)}
						</>
					)}
			</>
		</>
	);
};

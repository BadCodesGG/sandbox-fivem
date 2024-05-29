import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { FormControl, Select, MenuItem, FormHelperText } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { Modal } from '../../components';
import Bill from './component/Bill';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	emptyMsg: {
		color: theme.palette.text.alt,
		height: 'fit-content',
		width: 'fit-content',
		fontSize: 20,
		fontWeight: 'bold',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	editField: {
		marginBottom: 20,
		width: '100%',
	},
}));

export default ({ setLoading, refreshAccounts }) => {
	const classes = useStyles();
	const showAlert = useAlert();
	const bankData = useSelector((state) => state.data.data.bankAccounts);
	const myAccounts = bankData?.accounts;
	const pendingBills = bankData?.pendingBills;

	const personalAccount =
		myAccounts && myAccounts.filter((acc) => acc.Type == 'personal')[0];

	const [acceptBilling, setAcceptBilling] = useState(false);
	const [bState, setBState] = useState({
		bill: 0,
		withAccount: personalAccount.Account,
	});

	const onBChange = (e) => {
		setBState({
			...bState,
			[e.target.name]: e.target.value,
		});
	};

	const openAcceptBilling = (bill) => {
		setBState({
			billData: bill,
			billId: bill.Id,
			withAccount: personalAccount.Account,
		});
		setAcceptBilling(true);
	};

	const onAcceptBill = async (e) => {
		e.preventDefault();
		setLoading('Accepting Bill');

		const payingAccount =
			myAccounts &&
			myAccounts.filter((acc) => acc.Account == bState.withAccount)[0];
		if (payingAccount && payingAccount.Balance >= bState?.billData.Amount) {
			try {
				let res = await (
					await Nui.send('Banking:AcceptBill', {
						bill: bState.billId,
						account: bState.withAccount,
					})
				).json();
				if (res) {
					showAlert('Bill Has Been Paid');
				} else {
					showAlert('Error Paying Bill');
				}
				setTimeout(() => refreshAccounts(), 750);
			} catch (err) {
				showAlert('Error Paying Bill');
				setLoading(false);
			}

			setAcceptBilling(false);
			setBState({
				bill: 0,
				withAccount: personalAccount.Account,
			});
		} else {
			showAlert('Insufficient Funds to Pay Bill');
			setLoading(false);
		}
	};

	const onDenyBill = async (bill) => {
		setLoading('Dismissing Bill');
		try {
			let res = await (
				await Nui.send('Banking:DismissBill', {
					bill: bill.Id,
				})
			).json();
			if (res) {
				showAlert('Bill Has Been Dismissed');
				setTimeout(() => {
					refreshAccounts();
				}, 750);
			} else {
				showAlert('Error Dismissing Bill');
				setLoading(false);
			}
		} catch (err) {
			showAlert('Error Dismissing Bill');
			setLoading(false);
		}
	};

	const getAccountName = (acc) => {
		switch (acc.Type) {
			case 'personal':
				return 'Personal Account';
			case 'personal_savings':
				return 'Personal Savings Account';
			default:
				return acc.Name;
		}
	};

	if (pendingBills.length > 0) {
		return (
			<div className={classes.wrapper}>
				<div>
					{pendingBills
						.sort((a, b) => b.Timestamp - a.Timestamp)
						.map((bill) => {
							return (
								<Bill
									key={`bill-${bill.Id}`}
									bill={bill}
									onPay={() => openAcceptBilling(bill)}
									onDecline={() => onDenyBill(bill)}
								/>
							);
						})}
				</div>
				<Modal
					form
					open={acceptBilling}
					title={`Accept Bill of $${bState.billData?.Amount}`}
					submitLang="Accept Bill"
					onAccept={onAcceptBill}
					onClose={() => setAcceptBilling(false)}
				>
					<FormControl className={classes.editField}>
						<Select
							id="withAccount"
							name="withAccount"
							value={bState.withAccount}
							onChange={onBChange}
						>
							{myAccounts.map((account) => {
								return (
									<MenuItem
										key={account.Account}
										value={account.Account}
										disabled={
											!account.Permissions?.WITHDRAW
										}
									>
										{`${getAccountName(account)} - ${
											account.Account
										}`}
									</MenuItem>
								);
							})}
						</Select>
						<FormHelperText>
							Select the account that you wish to pay with.
						</FormHelperText>
					</FormControl>
				</Modal>
			</div>
		);
	} else {
		return (
			<div className={classes.wrapper}>
				<div className={classes.emptyMsg}>No Pending Bills</div>
			</div>
		);
	}
};

import React, { useState, Fragment, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Tooltip,
	IconButton,
	List,
	ListItem,
	ListItemText,
	Alert,
	AlertTitle,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useNavigate, useParams } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { AppContainer, Loader } from '../../components';
import Moment from 'react-moment';
import { throttle } from 'lodash';

import Nui from '../../util/Nui';
import { CurrencyFormat } from '../../util/Parser';
import { useAlert, useAppData } from '../../hooks';
import { Modal } from '../../components';
import { getActualRemainingAmount, getLoanIdentifierType, getNextPaymentAmount } from './utils';

const useStyles = makeStyles((theme) => ({
	loanInfo: {
		fontFamily: 'Kanit',
		padding: 16,
	},
	balanceLabel: {
		fontSize: 12,
		color: theme.palette.text.alt,
	},
	balance: {
		fontSize: 26,
		color: theme.palette.success.main,
	},
	duePaymentContainer: {},
	duePaymentLabel: {
		fontSize: 12,
		color: theme.palette.text.alt,
	},
	paymentBalance: {
		fontSize: 22,
		color: theme.palette.success.main,
	},
	header: {
		textAlign: 'center',
		fontSize: 20,
		color: theme.palette.text.main,
		position: 'relative',

		'& span': {
			background: theme.palette.secondary.main,
			padding: 4,
			zIndex: 1,
			position: 'relative',
		},

		'&::before': {
			content: '" "',
			display: 'block',
			height: 2,
			background: (app) => app.color,
			width: '100%',
			position: 'absolute',
			top: 0,
			bottom: 0,
			margin: 'auto',
			zIndex: 0,
		},
	},
	editField: {
		marginBottom: 20,
		width: '100%',
		'& p': {
			marginTop: 0,
		},
	},
}));

export default (props) => {
	const appData = useAppData('loans');
	const classes = useStyles(appData);
	const showAlert = useAlert();
	const history = useNavigate();
	const params = useParams();
	const dispatch = useDispatch();

	const { loan } = params;
	const myLoans = useSelector((state) => state.data.data.bankLoans.loans);

	const loanTypeIcons = {
		vehicle: 'car-side',
		property: 'house-building',
	};
	const loanData = myLoans && myLoans.find((l) => l._id == loan);
	if (!loanData) return null;

	const [loading, setLoading] = useState(false);

	const [weeklyPayment, setWeeklyPayment] = useState(false);
	const [WPState, setWPState] = useState({});

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('Loans:GetData')).json();
					if (res) {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'bankLoans',
								data: res,
							},
						});
					} else {
						throw res;
					}
				} catch (err) {
					console.error(err);
				}
				setLoading(false);
			}, 3500),
		[],
	);

	const openWeeklyPayment = (ahead) => {
		if (ahead) {
			let minWeeks = 1;
			if (loanData.MissedPayments > 1) {
				const remainingPayments =
					loanData.TotalPayments - loanData.PaidPayments;
				minWeeks = loanData.MissedPayments;
				if (minWeeks > remainingPayments) {
					minWeeks = remainingPayments;
				}
			}
			setWPState({
				minWeeks,
				weeks: minWeeks,
				allowAhead: true,
			});
		} else {
			setWPState({
				minWeeks: 1,
				weeks: 1,
				allowAhead: false,
			});
		}
		setWeeklyPayment(true);
	};

	const makeWeeklyPayment = async (e) => {
		e.preventDefault();
		setWeeklyPayment(false);
		setLoading(true);

		try {
			let res = await (
				await Nui.send('Loans:Payment', {
					loan: loanData._id,
					weeks: WPState.weeks,
					paymentAhead: WPState.allowAhead,
				})
			).json();
			if (res && res.success) {
				if (res.paidOff) {
					showAlert(`Loan Paid Off Completely!`);
				} else {
					showAlert(
						`Loan Payment of $${res.paymentAmount} Successful`,
					);
				}
				fetch();
			} else {
				showAlert(res.message ?? 'Loan Payment Failed');
			}
		} catch (err) {
			showAlert('Loan Payment Failed');
		}
		setLoading(false);
	};

	return (
		<AppContainer
			appId="loans"
			actions={
				<Fragment>
					{!loading &&
						Boolean(loanData) &&
						(loanData.Defaulted ? (
							<Tooltip title="Pay Loan Debt">
								<span>
									<IconButton
										onClick={() => openWeeklyPayment()}
									>
										<FontAwesomeIcon
											icon={['far', 'sack-dollar']}
										/>
									</IconButton>
								</span>
							</Tooltip>
						) : (
							<Tooltip title="Make Next Payment">
								<span>
									<IconButton
										onClick={() => openWeeklyPayment()}
									>
										<FontAwesomeIcon
											icon={['far', 'circle-dollar']}
										/>
									</IconButton>
								</span>
							</Tooltip>
						))}
					<Tooltip title={loanData._id}>
						<span>
							<IconButton>
								<FontAwesomeIcon
									icon={[
										'fas',
										loanTypeIcons[loanData.Type] ?? 'coin',
									]}
								/>
							</IconButton>
						</span>
					</Tooltip>
				</Fragment>
			}
		>
			<div className={classes.loanInfo}>
				{(loanData.Defaulted || loanData.MissedPayments > 0) && (
					<Alert
						variant="filled"
						color="error"
						style={{ marginBottom: 16 }}
					>
						<AlertTitle>Loan Has Defaulted</AlertTitle>
						{loanData.Defaulted
							? `This loan has been defaulted because you missed to many payments. The asset(s) relating to this loan have been seized temporarily until you pay the amount missed. Failing to pay within a month of the loan being defaulted, your asset(s) are at high risk of being permanently seized.`
							: loanData.MissedPayments > 0 &&
							  `You have missed the last ${
									loanData.MissedPayments > 1
										? `${loanData.MissedPayments} payments`
										: 'payment'
							  } for this loan. If ${
									loanData.MissablePayments
							  } consecutive payments are missed, the loan will be defaulted on and the asset(s) relating to this loan will be seized.`}
					</Alert>
				)}
				<div className={classes.balanceContainer}>
					<div className={classes.balanceLabel}>Current Balance</div>
					{getActualRemainingAmount(loanData) > 0 ? (
						<div className={classes.balance}>
							{CurrencyFormat.format(
								getActualRemainingAmount(loanData),
							)}
						</div>
					) : (
						<div className={classes.balance}>Loan Paid Off</div>
					)}
				</div>

				{loanData.Remaining > 0 && (
					<div className={classes.duePaymentContainer}>
						<div className={classes.duePaymentLabel}>
							Payment Due On{' '}
							<Moment
								unix
								date={loanData.NextPayment}
								format="L"
							/>
						</div>
						<div className={classes.paymentBalance}>
							{CurrencyFormat.format(
								getNextPaymentAmount(loanData),
							)}
						</div>
					</div>
				)}

				<div className={classes.header}>
					<span>Loan Details</span>
				</div>
				<List>
					<ListItem>
						<ListItemText
							primary={getLoanIdentifierType(loanData.Type)}
							secondary={loanData.AssetIdentifier}
						/>
					</ListItem>
				</List>
				<List>
					<ListItem>
						<ListItemText
							primary="Total Loan"
							secondary={CurrencyFormat.format(loanData.Total)}
						/>
						<ListItemText
							primary="Down Payment"
							secondary={CurrencyFormat.format(
								loanData.DownPayment,
							)}
						/>
						<ListItemText
							primary="Total Paid"
							secondary={CurrencyFormat.format(loanData.Paid)}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Payments"
							secondary={`${loanData.PaidPayments} / ${loanData.TotalPayments}`}
						/>
						{Boolean(loanData.MissedPayments) &&
							loanData.MissedPayments > 0 && (
								<ListItemText
									primary="Missed Payments"
									secondary={`${loanData.MissedPayments} / ${loanData.MissablePayments}`}
								/>
							)}
					</ListItem>
				</List>
			</div>

			{loading ? (
				<Loader static text={'Completing Loan Payment...'} />
			) : loanData ? (
				<div className={classes.accountBody}></div>
			) : (
				<p>There was big fuckup oh no.</p>
			)}

			<Modal
				form
				open={weeklyPayment}
				title={`Loan Payment - $${getNextPaymentAmount(
					loanData,
					WPState.weeks,
				).toLocaleString('en-US')}`}
				submitLang="Make Payment"
				closeLang="Cancel"
				onAccept={makeWeeklyPayment}
				onClose={() => setWeeklyPayment(false)}
			>
				<p className={classes.editField}>
					Loan Payments are taken from your Personal Checking Account.
					Due Payment: $
					{getNextPaymentAmount(
						loanData,
						WPState.weeks,
					).toLocaleString('en-US')}
					.
				</p>
				{/* {WPState.allowAhead && <TextField
                    type="number"
                    required
                    fullWidth
                    className={classes.editField}
                    label="Amount of Payments Ahead"
                    name="weeks"
                    value={WPState.weeks}
                    onChange={onWPChange}
                    helperText="The number of weeks worth of payments to make."
                    inputProps={{
                        type: 'number',
                        min: 1,
                        max: (loanData.TotalPayments - loanData.PaidPayments),
                        maxLength: 4,
                    }}
                />} */}
			</Modal>
		</AppContainer>
	);
};

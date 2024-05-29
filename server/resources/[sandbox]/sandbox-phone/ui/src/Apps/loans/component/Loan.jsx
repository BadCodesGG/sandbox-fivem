import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Paper } from '@mui/material';
import { Link, useNavigate } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';
import chroma from 'chroma-js';

import {
	getLoanTypeName,
	getActualRemainingAmount,
	getNextPaymentAmount,
} from '../utils';
import { useAppData } from '../../../hooks';
import { CurrencyFormat } from '../../../util/Parser';

const useStyles = makeStyles((theme) => ({
	loan: {
		padding: 10,
		borderRadius: 14,
		border: (app) => `1px solid ${app.color}`,
		position: 'relative',
		marginBottom: 8,
		fontFamily: 'Kanit',
		minHeight: 150,
		height: '100%',
		transition: 'background ease-in 0.15s',

		'&:hover': {
			background: (app) => `${chroma(app.color).darken(4)}80`,
			cursor: 'pointer',
		},
	},
	branding: {
		fontSize: 22,
		color: (app) => chroma(app.color).brighten(),

		'& small': {
			display: 'block',
			fontSize: 12,
			color: theme.palette.text.alt,
		},
	},
	status: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 14,
		right: 14,
		borderRadius: 8,

		'&.paid': {
			background: (app) => chroma(app.color).brighten(),
			padding: 4,
			color: theme.palette.secondary.dark,
		},
		'&.default': {
			background: theme.palette.error.main,
			padding: 4,
		},
	},
	loanBalance: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		bottom: 14,
		right: 14,
		textAlign: 'right',
	},
	balance: {
		fontSize: 22,
		letterSpacing: 4,
		color: theme.palette.success.main,
	},
	loanDate: {
		fontSize: 12,
		color: theme.palette.text.alt,
	},
	typeIcon: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		bottom: 14,
		left: 14,
	},
}));

export default ({ loan }) => {
	const appData = useAppData('loans');
	const classes = useStyles(appData);
	const navigate = useNavigate();
	const loanRemainingAmount = getActualRemainingAmount(loan);
	const loanRemainingPayments = loan.TotalPayments - loan.PaidPayments;

	const onClick = () => {
		navigate(`/apps/loans/view/${loan._id}`);
	};

	const getNextDuePayment = () => {
		if (loan.NextPayment) {
			return <Moment unix date={loan.NextPayment} calendar />;
		} else {
			return 'No Due Payments';
		}
	};

	const getWarning = () => {
		if (loan.Defaulted) {
			return 'This loan has been defaulted because you missed too many payments.';
		} else if (loan.MissedPayments > 0) {
			if (loan.MissedPayments > 1) {
				return `You missed the last ${loan.MissedPayments} payments for this loan.`;
			} else {
				return 'You missed the last payment for this loan.';
			}
		} else {
			return false;
		}
	};

	const getLoanLabel = () => {
		switch (loan.Type) {
			case 'vehicle':
				return 'Auto';
			case 'property':
				return 'Home';
			default:
				return 'Personal';
		}
	};

	const getLoanIcon = () => {
		switch (loan.Type) {
			case 'vehicle':
				return 'car';
			case 'property':
				return 'house';
			default:
				return 'questionmark';
		}
	};

	return (
		<div className={classes.loan} onClick={onClick}>
			<div className={classes.branding}>
				<span>SB Financial</span>
				<small>{getLoanLabel()} Loan</small>
			</div>
			{loan.Remaining > 0 ? (
				loan.Defaulted ||
				(loan.MissablePayments > 1 &&
					loan.MissedPayments >= loan.MissablePayments - 1) ? (
					<div className={`${classes.status} default`}>Defaulted</div>
				) : (
					<div className={`${classes.status} repayment`}>
						In Repayment
					</div>
				)
			) : (
				<div className={`${classes.status} paid`}>Repaid</div>
			)}
			<div className={classes.typeIcon}>
				<FontAwesomeIcon icon={getLoanIcon()} />
			</div>
			<div className={classes.loanBalance}>
				<div className={classes.balance}>
					{CurrencyFormat.format(loanRemainingAmount)}
				</div>
				<div className={classes.loanDate}>
					Approved On <Moment unix date={loan.Creation} format="L" />
				</div>
			</div>
		</div>
	);

	return (
		<Link to={`/apps/loans/view/${loan._id}`} className={classes.link}>
			<Paper
				className={`${classes.account} ${
					loan.Defaulted ||
					(loan.MissablePayments > 1 &&
						loan.MissedPayments >= loan.MissablePayments - 1)
						? classes.defaultedAccount
						: loan.MissedPayments > 0 && classes.missedLastPayment
				}`}
			>
				<div className={classes.accountDetails}>
					<h3>{getLoanTypeName(loan.Type)} Loan</h3>
					<p>
						Interest Rate: {loan.InterestRate}%<br />
						Remaining Payments: {loanRemainingPayments}
						<br />
						Next Payment Due: {getNextDuePayment()}
						<br />
						{loan.Remaining > 0 && loan.NextPayment && (
							<span>
								Next Payment Amount:{' '}
								<span className={classes.currency}>
									$
									{getNextPaymentAmount(loan).toLocaleString(
										'en-US',
									)}
								</span>
							</span>
						)}
					</p>
					{getWarning() && (
						<p>
							<b>{getWarning()}</b>
						</p>
					)}
				</div>
				<div className={classes.accountBalance}>
					<h2>
						Remaining:{' '}
						<span>
							${loanRemainingAmount.toLocaleString('en-US')}
						</span>
					</h2>
				</div>
				<FontAwesomeIcon
					className={classes.backIcon}
					icon={['fas', 'hand-holding-dollar']}
				/>
			</Paper>
		</Link>
	);
};

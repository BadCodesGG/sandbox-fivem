import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Loan from './component/Loan';
import { getLoanTypeName } from './utils';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	accountList: {
		padding: 8,
	},
	emptyLogo: {
		width: '100%',
		fontSize: 170,
		textAlign: 'center',
		marginTop: '25%',
		color: `#30518c29`,
	},
	emptyMsg: {
		color: theme.palette.text.alt,
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
	},
	subTitle: {
		textAlign: 'center',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		marginBottom: 10,
		'& h3': {
			color: '#30518c',
			fontWeight: 400,
			fontSize: 19,
			marginBottom: 5,
		},
	},
}));

export default ({ loanType, onFetch }) => {
	const classes = useStyles();
	const myLoans = useSelector((state) => state.data.data.bankLoans.loans);

	if (myLoans && myLoans.length > 0) {
		return (
			<div className={classes.wrapper}>
				{
					<div className={classes.accountList}>
						{myLoans &&
							myLoans?.length > 0 &&
							myLoans
								.sort((a, b) => b.NextPayment - a.NextPayment)
								.map((loan) => {
									return (
										<Loan
											key={loan._id}
											loan={loan}
											onFetch={onFetch}
										/>
									);
								})}
					</div>
				}
			</div>
		);
	} else {
		return (
			<div className={classes.wrapper}>
				<div className={classes.emptyLogo}>
					<FontAwesomeIcon icon={['fas', 'face-disappointed']} />
				</div>
				<div className={classes.emptyMsg}>
					You Have No {getLoanTypeName(loanType)} Loans
				</div>
			</div>
		);
	}
};

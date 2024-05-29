import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Account from './component/Account';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	accountList: {
		padding: 5,
		display: 'flex',
		flexDirection: 'column',
		gap: 8,

		'& .glare-wrapper': {
			borderRadius: '15px !important',
		}
	},
	emptyMsg: {
		color: theme.palette.text.alt,
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const myAccounts = useSelector(
		(state) => state.data.data.bankAccounts,
	)?.accounts;

	const personalAccount =
		myAccounts && myAccounts.filter((acc) => acc.Type == 'personal');
	const personalSavingsAccounts =
		myAccounts &&
		myAccounts.filter((acc) => acc.Type == 'personal_savings');
	const organizationAccounts =
		myAccounts && myAccounts.filter((acc) => acc.Type == 'organization');

	if (myAccounts && personalSavingsAccounts && organizationAccounts) {
		return (
			<div className={classes.wrapper}>
				<div className={classes.accountList}>
					{personalAccount?.length > 0 &&
						personalAccount.map((acc) => {
							return <Account key={acc.Account} acc={acc} />;
						})}
					{personalSavingsAccounts?.length > 0 &&
						personalSavingsAccounts.map((acc) => {
							return <Account key={acc.Account} acc={acc} />;
						})}
					{organizationAccounts.length > 0 &&
						organizationAccounts.map((acc) => {
							return <Account key={acc.Account} acc={acc} />;
						})}
				</div>
			</div>
		);
	} else {
		return (
			<div className={classes.wrapper}>
				<div className={classes.emptyMsg}>No Accounts?</div>
			</div>
		);
	}
});

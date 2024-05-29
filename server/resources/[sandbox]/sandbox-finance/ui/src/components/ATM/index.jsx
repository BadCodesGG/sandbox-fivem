import React, { useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { TextField, Slide, MenuItem } from '@mui/material';
import { toast } from 'react-toastify';
import useKeypress from 'react-use-keypress';

import { Titlebar } from '../';
import AccountButton from '../Bank/components/AccountButton';
import Nui from '../../util/Nui';
import Account from './components/Account';

const useStyles = makeStyles((theme) => ({
	container: {},
	wrapper: {},
	content: {
		height: 'calc(624px - 108px)',
		display: 'flex',
		gap: 4,
		overflow: 'hidden',
	},
	accounts: {
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	accountContainer: {
		flex: 1,
		overflow: 'hidden',
	},
	account: {
		background: theme.palette.secondary.dark,
		border: `1px solid ${theme.palette.border.divider}`,
		padding: 10,
		height: '100%',
		width: '100%',
	},
	field: {
		marginBottom: 15,
	},
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const containerRef = useRef(null);
	const accountRef = useRef(null);

	const user = useSelector((state) => state.data.data.character);
	const accounts = useSelector((state) => state.data.data.accounts);
	const selected = useSelector((state) => state.bank.selected);

	useEffect(() => {
		if (accounts.length > 0) {
			setPersonal(accounts.filter((a) => a.Type == 'personal'));
			setSavings(accounts.filter((a) => a.Type == 'personal_savings'));
			setOrganization(accounts.filter((a) => a.Type == 'organization'));
		} else {
			setPersonal(Array());
			setSavings(Array());
			setOrganization(Array());
		}
	}, [accounts]);

	const [personal, setPersonal] = useState(Array());
	const [savings, setSavings] = useState(Array());
	const [organization, setOrganization] = useState(Array());

	const [loading, setLoading] = useState(false);

	const [titleRendered, setTitleRendered] = useState(false);
	const [accsRendered, setAccsRendered] = useState(false);

	useEffect(() => {
		const f = async () => {
			setLoading(true);
			try {
				let res = await (await Nui.send('Bank:Fetch')).json();

				if (Boolean(res?.accounts)) {
					dispatch({
						type: 'SET_DATA',
						payload: {
							type: 'accounts',
							data: res.accounts,
						},
					});
					dispatch({
						type: 'SET_DATA',
						payload: {
							type: 'transactions',
							data: res.transactions,
						},
					});
				} else toast.error('Error Loading Accounts');
			} catch (err) {
				console.log(err);
				toast.error('Error Loading Accounts');
			}

			setLoading(false);
		};
		if (process.env.NODE_ENV == 'production') f();
	}, []);

	useKeypress(['Escape'], () => {
		Nui.send('Close');
	});

	return (
		<div className={classes.container}>
			<Titlebar onAnimEnd={() => setTitleRendered(true)} />
			<div className={classes.content} ref={containerRef}>
				<Slide
					in={titleRendered}
					direction="down"
					container={containerRef.current}
					onEntered={() => setAccsRendered(true)}
				>
					<div className={classes.accounts}>
						{personal.map((acc) => {
							return (
								<AccountButton key={acc.Account} account={acc} />
							);
						})}
						{savings.map((acc) => {
							return (
								<AccountButton key={acc.Account} account={acc} />
							);
						})}
						{organization.map((acc) => {
							return (
								<AccountButton key={acc.Account} account={acc} />
							);
						})}
					</div>
				</Slide>
				<div ref={accountRef} className={classes.accountContainer}>
					<Slide
						in={Boolean(selected) && accsRendered}
						direction="right"
						container={accountRef.current}
					>
						<div className={classes.account}>
							{Boolean(selected) && <Account />}
						</div>
					</Slide>
				</div>
			</div>
		</div>
	);
};

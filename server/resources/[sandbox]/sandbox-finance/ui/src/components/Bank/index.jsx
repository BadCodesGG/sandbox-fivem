import React, { useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { TextField, Slide, MenuItem } from '@mui/material';
import { toast } from 'react-toastify';
import useKeypress from 'react-use-keypress';

import { Titlebar, Loader, Modal } from '../';
import AccountButton from './components/AccountButton';
import Nui from '../../util/Nui';
import Account from './components/Account';

const useStyles = makeStyles((theme) => ({
	container: {},
	wrapper: {},
	content: {
		height: 'calc(936px - 108px)',
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

const Types = [
	{
		value: 'personal_savings',
		label: 'Personal Saving',
	},
];

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
	const [creating, setCreating] = useState(false);

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

	const onCreate = async (e) => {
		e.preventDefault();

		if (
			accounts.filter(
				(a) => a.Owner == user.SID && a.Type == 'personal_savings',
			).length > 0
		) {
			toast.error('You May Only Own 1 Savings Account');
			setCreating(false);
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Register', {
					type: e.target.type.value,
					name: e.target.name.value,
				})
			).json();

			dispatch({
				type: 'ADD_DATA',
				payload: {
					type: 'accounts',
					data: res,
				},
			});
			dispatch({
				type: 'SELECT_ACCOUNT',
				payload: {
					account: res.Account,
				},
			});
		} catch (e) {
			console.log(e);
			toast.error('Unable To Open Account');
		}

		setLoading(false);
		setCreating(false);
	};

	return (
		<div className={classes.container}>
			<Titlebar
				onCreate={() => setCreating(true)}
				onAnimEnd={() => setTitleRendered(true)}
			/>
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
			<Modal
				open={creating}
				title="Open New Account"
				closeLang="Cancel"
				maxWidth="sm"
				onClose={() => setCreating(false)}
				onSubmit={onCreate}
			>
				{loading && <Loader static text="Loading" />}
				<TextField
					select
					fullWidth
					required
					name="type"
					className={classes.field}
					disabled={true}
					label="Account Type"
					defaultValue="personal_savings"
				>
					{Types.map((option) => (
						<MenuItem key={option.value} value={option.value}>
							{option.label}
						</MenuItem>
					))}
				</TextField>
				<TextField
					fullWidth
					required
					name="name"
					className={classes.field}
					label="Account Name"
				/>
			</Modal>
		</div>
	);
};

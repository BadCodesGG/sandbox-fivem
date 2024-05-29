import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CurrencyFormat } from '../../../util/Parser';

const useStyles = makeStyles((theme) => ({
	container: {
		zIndex: 1,
		width: 300,
		height: 100,
		padding: 5,
		lineHeight: '25px',
		display: 'flex',
		background: `${theme.palette.secondary.dark}`,
		border: `1px solid ${theme.palette.border.divider}`,
		borderLeft: `2px solid ${theme.palette.secondary.light}`,
		transition: 'border ease-in 0.15s',
		userSelect: 'none',
		'&:not(:last-of-type)': {
			marginBottom: 4,
		},
		'&.active': {
			borderLeft: `2px solid ${theme.palette.primary.main}`,
		},
		'&:hover': {
			borderLeft: `2px solid ${theme.palette.primary.light}`,
			cursor: 'pointer',
		},
	},
	accIcon: {
		width: 48,
		display: 'block',
		fontSize: 18,
		padding: 5,
		paddingLeft: 0,
		textAlign: 'center',
		borderRight: `1px solid ${theme.palette.border.divider}`,
		lineHeight: '85px',
	},
	details: {
		padding: 5,
		width: 240,
		paddingTop: 15,
	},
	detail: {
		lineHeight: '35px',
		fontSize: 18,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		maxWidth: '100%',

		'&.currency': {
			color: theme.palette.success.main,
		},
	},
}));

export default ({ account }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const sel = useSelector((state) => state.bank.selected);

	const onClick = () => {
		dispatch({
			type: 'SELECT_ACCOUNT',
			payload: {
				account: Boolean(sel == account.Account) ? null : account.Account,
			},
		});
	};

	const getAccountIcon = () => {
		switch (account.Type) {
			case 'personal_savings':
				return 'piggy-bank';
			case 'organization':
				return 'building';
			default:
				return 'money-check-dollar';
		}
	};

	return (
		<div
			className={`${classes.container} ${sel == account?.Account ? 'active' : ''
				}`}
			onClick={onClick}
		>
			<div className={classes.accIcon}>
				<FontAwesomeIcon icon={getAccountIcon()} />
			</div>
			<div className={classes.details}>
				<div className={classes.detail}>{account.Name}</div>
				<div className={`${classes.detail} currency`}>
					{account.Permissions?.BALANCE ? CurrencyFormat.format(account.Balance) : "???"}
				</div>
			</div>
		</div>
	);
};

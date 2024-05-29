import React from 'react';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Tilt from 'react-parallax-tilt';

import { CurrencyFormat } from '../../../util/Parser';
import { getAccountName } from '../utils';
import { useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	container: {
		zIndex: 1,
		height: 100,
		padding: 5,
		lineHeight: '25px',
		display: 'flex',
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		border: `1px solid ${theme.palette.border.divider}`,
		borderLeft: `2px solid ${theme.palette.secondary.light}`,
		transition: 'border ease-in 0.15s',
		userSelect: 'none',
		'&:not(:last-of-type)': {
			marginBottom: 4,
		},
		'&.active': {
			borderLeft: `2px solid #268f3a`,
		},
		'&:hover': {
			borderLeft: `2px solid #134d1e`,
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

	card: {
		height: 175,
		margin: 'auto',
		padding: 25,
		borderRadius: 15,
		background: `${theme.palette.secondary.dark}d1`,
		border: `2px solid transparent`,
		backdropFilter: 'blur(10px)',
		position: 'relative',
		fontFamily: 'PT Sans',
		transition: 'border ease-in 0.15s',
		zIndex: 5,

		'&:hover': {
			border: (app) => `2px solid ${app.color}`,
			cursor: 'pointer',
		},
	},
	branding: {
		fontStyle: 'italic',
		fontWeight: 'bold',
	},
	accountName: {
		fontSize: 12,
		position: 'absolute',
		top: 25,
		right: 25,
		height: 'fit-content',
		width: 'fit-content',
	},
	balance: {
		fontSize: 24,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 25,
		height: 'fit-content',
		width: 'fit-content',
		margin: 'auto',
	},
	accountNumber: {
		textAlign: 'center',
		fontFamily: 'monospace',
		letterSpacing: 6,
		position: 'absolute',
		bottom: 15,
		left: 0,
		right: 0,
		height: 'fit-content',
		margin: 'auto',
	},
}));

const MaskAccountNumber = (s) => {
	let count = 0;
	return s
		.split('')
		.reverse()
		.map((n, i) => (!n.match(/\d/) ? n : count < 4 ? (count++, n) : 'x'))
		.reverse()
		.join('');
};

export default ({ acc }) => {
	const appData = useAppData('bank');
	const classes = useStyles(appData);
	const navigate = useNavigate();
	const accountName = getAccountName(acc);

	const onClick = () => {
		navigate(`/apps/bank/view/${acc.Account}`);
	};

	const getAccountIcon = () => {
		switch (acc.Type) {
			case 'personal_savings':
				return 'piggy-bank';
			case 'organization':
				return 'building';
			default:
				return 'money-check-dollar';
		}
	};

	return (
		<Tilt glareEnable>
			<div className={classes.card} onClick={onClick}>
				<div className={classes.branding}>
					TISA <FontAwesomeIcon icon="pancakes" />
				</div>
				<div className={classes.accountName}>{accountName}</div>
				<div className={classes.balance}>
					{acc.Permissions?.BALANCE
						? CurrencyFormat.format(acc.Balance)
						: '???'}
				</div>
				<div className={classes.accountNumber}>
					{MaskAccountNumber(`${acc.Account}`)}
				</div>
			</div>
		</Tilt>
	);
};

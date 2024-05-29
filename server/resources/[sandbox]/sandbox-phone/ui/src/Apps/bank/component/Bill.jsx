import React from 'react';
import { makeStyles } from '@mui/styles';
import { IconButton, Paper } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';
import { useAppData } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	container: {
		zIndex: 1,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		border: `1px solid ${theme.palette.border.divider}`,
		borderLeft: (app) => `2px solid ${app.color}`,
		transition: 'border ease-in 0.15s',
		userSelect: 'none',
		'&:not(:last-of-type)': {
			marginBottom: 16,
		},
	},
	detailsContainer: {
		lineHeight: '25px',
		display: 'flex',
		padding: 5,
	},
	accIcon: {
		display: 'inline-block',
		fontSize: 18,
		padding: 5,
		textAlign: 'center',
		borderLeft: `1px solid ${theme.palette.border.divider}`,
		lineHeight: '70px',

		'& .positive': {
			color: theme.palette.success.main,
		},
		'& .negative': {
			color: theme.palette.error.main,
		},
	},
	details: {
		padding: 5,
		paddingTop: 15,
		flexGrow: 1,
	},
	detail: {
		lineHeight: '35px',
		fontSize: 18,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		maxWidth: '100%',

		'& .currency': {
			color: theme.palette.success.main,
			'&::before': {
				content: '"$"',
			},
			'&::after': {
				borderRight: `1px solid ${theme.palette.border.divider}`,
				content: '" "',
				marginRight: 4,
			},
		},
	},
	description: {
		padding: 8,
		borderTop: `1px solid ${theme.palette.border.divider}`,
	},
    timestamp: {
        fontSize: 12,
        color: theme.palette.text.alt,
    }
}));

export default ({ bill, onPay, onDecline }) => {
	const appData = useAppData('bank');
	const classes = useStyles(appData);

	return (
		<div className={classes.container}>
			<div className={classes.detailsContainer}>
				<div className={classes.details}>
					<div className={classes.detail}>
						<span className="currency">{bill.Amount}</span>
						{bill.Name}
					</div>
					<div className={classes.timestamp}>
						Received <Moment unix date={bill.Timestamp} fromNow />
					</div>
				</div>
				<div className={classes.accIcon}>
					<IconButton className="positive" onClick={onPay}>
						<FontAwesomeIcon icon="check" />
					</IconButton>
					<IconButton className="negative" onClick={onDecline}>
						<FontAwesomeIcon icon="x" />
					</IconButton>
				</div>
			</div>
			<div className={classes.description}>
				{Boolean(bill.Description)
					? bill.Description
					: 'Bill Has No Description'}
			</div>
		</div>
	);
};

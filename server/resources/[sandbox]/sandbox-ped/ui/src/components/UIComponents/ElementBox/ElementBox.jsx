import React from 'react';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	inner: {
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	header: {
		color: theme.palette.text.main,
		position: 'relative',
		padding: 14,
		width: 'fit-content',
		fontSize: 18,
		letterSpacing: 2,
		textTransform: 'uppercase',
		whiteSpace: 'nowrap',
		maxWidth: '90%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		margin: 'auto',
	},
}));

export default (props) => {
	const classes = useStyles();
	return (
		<div className={classes.inner}>
			{Boolean(props.label) && (
				<div className={classes.header}>
					<div
						style={{
							maxWidth: '100%',
							overflow: 'hidden',
							textOverflow: 'ellipsis',
						}}
					>
						{props.label}
					</div>
				</div>
			)}
			<div className={props.bodyClass}>{props.children}</div>
		</div>
	);
};

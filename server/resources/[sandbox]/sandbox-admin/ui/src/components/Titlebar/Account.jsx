import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Avatar } from '@material-ui/core';

const useStyles = makeStyles((theme) => ({
	user: {
		display: 'flex',
		gap: 10,
		marginRight: 10,
	},
	inner: {
		textAlign: 'right',
		'& small': {
			display: 'block',
			color: theme.palette.text.alt,
		},
	},
	avatar: {
		top: 0,
		bottom: 0,
		margin: 'auto',
	}
}));

export default () => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);
	const permissionName = useSelector(state => state.app.permissionName)

	return (
		<div className={classes.user}>
			<div className={classes.inner}>
				<small>
					{permissionName ?? 'Staff'}
				</small>
				<span>
					{user?.Name}
				</span>
			</div>
			<Avatar className={classes.avatar} src={user?.Avatar} />
		</div>
	);
};

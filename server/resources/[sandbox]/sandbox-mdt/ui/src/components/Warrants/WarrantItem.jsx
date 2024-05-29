import React from 'react';
import { ListItemButton, ListItemText } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import Truncate from '@nosferatu500/react-truncate';
import { Link } from 'react-router-dom';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		userSelect: 'none',
		transition: 'background ease-in 0.15s',
		'&:hover': {
			cursor: 'pointer',
			background: theme.palette.secondary.dark,
		},
	},
	time: {
		fontSize: 14,
		color: theme.palette.text.alt,
	},
}));

export default ({ warrant }) => {
	const classes = useStyles();

	return (
		<>
			<ListItemButton
				className={classes.wrapper}
				component={Link}
				to={`/warrants?warrant=${warrant.id}`}
			>
				<ListItemText
					primary={
						<Truncate lines={1}>
							{warrant.title}
						</Truncate>
					}
					secondary={
						<Truncate lines={1}>
							Expires:{' '}
							<Moment
								date={warrant.expires}
								fromNow
								withTitle
								titleFormat="LLLL"
								interval={60000}
							/>
						</Truncate>
					}
				/>
			</ListItemButton>
		</>
	);
};

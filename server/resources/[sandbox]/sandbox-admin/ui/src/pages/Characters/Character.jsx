import React from 'react';
import {
	ListItem,
	ListItemText,
	Grid,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { useHistory } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	mugshot: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		margin: 'auto',
		height: 60,
		width: 60,
	}
}));

export default ({ player }) => {
	const classes = useStyles();
	const history = useHistory();

	const onClick = () => {
		history.push(`/player/${player.Online}`);
	};

	return (
		<ListItem className={classes.wrapper} button disabled={!player.Online} onClick={onClick}>
			<Grid container>
				<Grid item xs={4}>
					<ListItemText
						primary="Character State ID"
						secondary={`${player.SID}`}
					/>
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary="Character Name"
						secondary={`${player.First} ${player.Last}`}
					/>
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary="User"
						secondary={`${player.User}`}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};

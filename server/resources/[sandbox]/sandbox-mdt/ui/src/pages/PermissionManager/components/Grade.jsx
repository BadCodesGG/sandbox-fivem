import React from 'react';
import {
	Avatar,
	List,
	ListItemButton,
	ListItemAvatar,
	ListItemText,
	Grid,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import moment from 'moment';
import { useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '10px 5px 10px 5px',
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

export default ({ grade, onClick }) => {
	const classes = useStyles();

	return (
		<ListItemButton className={classes.wrapper} onClick={onClick}>
			<Grid container>
				<Grid item xs={4}>
					<ListItemText
						primary={grade.Name}
					//secondary={`${grade.Name} ${grade.Last}`}
					/>
				</Grid>
				<Grid item xs={4}>
					<ListItemText primary={`Level ${grade.Level ?? 1}`} />
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary={`${Object.keys(grade.Permissions).length ?? 0} Permissions`}
					/>
				</Grid>
			</Grid>
		</ListItemButton>
	);
};

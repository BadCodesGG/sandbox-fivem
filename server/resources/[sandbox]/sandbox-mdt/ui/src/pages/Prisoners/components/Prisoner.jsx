import React from 'react';
import { ListItemButton, ListItemText, Grid, ListItemSecondaryAction, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import moment from 'moment';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ prisoner, onStartReduction }) => {
	const classes = useStyles();
	const history = useNavigate();

	const startReduction = async (e) => {
		e.stopPropagation();

		onStartReduction(prisoner);
	};

	const viewProfile = () => {
		history(`/people?person=${prisoner.SID}`);
	};

	const timeRemain = Math.ceil(moment.duration(prisoner.Jailed.Release - (Date.now() / 1000), 's').asMinutes());

	return (
		<ListItemButton className={classes.wrapper} onClick={viewProfile}>
			<Grid container>
				<Grid item xs={3}>
					<ListItemText
						primary="Prisoner Name"
						secondary={`${prisoner.First} ${prisoner.Last} (State ID: ${prisoner.SID})`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Total Sentence"
						secondary={`${timeRemain} Months Remaining of ${prisoner.Jailed.Duration} Month Sentence`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Sentenced At"
						secondary={`${moment(prisoner.Jailed.Time * 1000).format('lll')}`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Release Time"
						secondary={`${moment(prisoner.Jailed.Release * 1000).format('lll')}`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Current DOC Reductions"
						secondary={`${prisoner.Jailed.Reduced ?? 0} Months`}
					/>
				</Grid>
			</Grid>
			<ListItemSecondaryAction>
				<IconButton onClick={startReduction}>
					<FontAwesomeIcon
						icon={['fas', 'timer']}
					/>
				</IconButton>
			</ListItemSecondaryAction>
		</ListItemButton>
	);
};

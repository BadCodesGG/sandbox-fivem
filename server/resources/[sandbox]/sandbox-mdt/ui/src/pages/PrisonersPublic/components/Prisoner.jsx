import React, { useState } from 'react';
import { ListItemButton, ListItemText, Grid, ListItemSecondaryAction, IconButton, Tooltip } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { makeStyles } from '@mui/styles';
import moment from 'moment';
import Nui from '../../../util/Nui';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ prisoner }) => {
	const classes = useStyles();
	const timeRemain = Math.ceil(moment.duration(prisoner.Jailed.Release - (Date.now() / 1000), 's').asMinutes());
	const [disabled, setDisabled] = useState(false);

	const requestVisit = async () => {
		setDisabled(true);

		try {
			let res = await (
				await Nui.send('DOCRequestVisitation', {
					SID: prisoner.SID,
				})
			).json();
			if (res?.success) {
				toast.success("Visitation Requested. Please Wait");
			} else {
				if (res?.message) {
					toast.error(res.message);
				} else {
					toast.error('Error Requesting Visitation');
				}
			};
		} catch (err) {
			console.log(err);
			toast.error('Error Requesting Visitation');
		}
	};

	return (
		<ListItemButton className={classes.wrapper}>
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
			</Grid>
			<ListItemSecondaryAction>
				<Tooltip title="Let DOC Know You Are Here">
					<IconButton onClick={requestVisit} disabled={disabled}>
						<FontAwesomeIcon
							icon={['fas', 'phone-volume']}
						/>
					</IconButton>
				</Tooltip>
			</ListItemSecondaryAction>
		</ListItemButton>
	);
};

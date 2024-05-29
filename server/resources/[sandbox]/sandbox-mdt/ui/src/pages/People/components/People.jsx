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
import qs from 'qs';
import { useSelector } from 'react-redux';
import { useNavigate, useLocation } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 20,
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

export default ({ person }) => {
	const classes = useStyles();
	const history = useNavigate();
	const location = useLocation();
	const govJobs = useSelector(state => state.data.data.governmentJobs);

	let qry = qs.parse(location.search.slice(1));
	const personId = qry.person;

	const onClick = () => {
		let s = qs.parse(location.search.slice(1));
		s.person = person.SID;
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
	};

	const jobCount = person.Jobs?.length ?? 0
	let isGovernment = false;

	if (jobCount > 0 && govJobs?.length > 0) {
		isGovernment = person.Jobs?.find(j => govJobs.includes(j.Id));
	}

	return (
		<ListItemButton className={classes.wrapper} onClick={onClick} selected={personId == person.SID}>
			<Grid container>
				<Grid item xs={2}>
					<ListItemAvatar>
						<Avatar className={classes.mugshot} src={person.Mugshot} alt={person.First} />
					</ListItemAvatar>
				</Grid>
				<Grid item xs={5}>
					<ListItemText
						primary="Name"
						secondary={`${person.First} ${person.Last}`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText primary="State ID" secondary={person.SID} />
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary="Date of Birth"
						secondary={moment(person.DOB).format('LL')}
					/>
				</Grid>
			</Grid>
		</ListItemButton>
	);
};

import React from 'react';
import { useSelector } from 'react-redux';
import { ListItemButton, ListItemText, Grid, Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import moment from 'moment';
import qs from 'qs';
import { useNavigate, useLocation } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '5px 10px 5px 10px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	alt: {
		color: theme.palette.text.alt,
	}
}));

const warrantStates = {
	active: 'Active',
	void: 'Void',
	served: 'Served',
	expired: 'Expired',
}

export default ({ warrant }) => {
	const classes = useStyles();
	const location = useLocation();
	const history = useNavigate();
	const myJob = useSelector(state => state.app.govJob);

	let qry = qs.parse(location.search.slice(1));
	const warrantId = qry.warrant;

	const onClick = () => {
		let s = qs.parse(location.search.slice(1));
		s.warrant = warrant.id;
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
	};

	return (
		<ListItemButton className={classes.wrapper} onClick={onClick} selected={warrantId == warrant.id}>
			<Grid container>
				<Grid item xs={7}>
					<ListItemText
						primary={`#${warrant.id} - ${warrant.title}`}
					/>
				</Grid>
				<Grid item xs={5}>
					{myJob?.Id && <ListItemText
						primary={`Issued By ${warrant.creatorName} [${warrant.creatorCallsign}]`}
					/>}
				</Grid>
				<Grid item xs={12}>
					<ListItemText
						primary={(warrant.state === "active" || warrant.state === "expired") ? `${warrantStates[warrant?.state] ?? 'Unknown'} - ${warrant.state === "active" ? "Expires" : "Expired"} ${moment(warrant.expires).format('LLLL')}` : warrantStates[warrant?.state]}
					/>
				</Grid>
			</Grid>
		</ListItemButton>
	);
};

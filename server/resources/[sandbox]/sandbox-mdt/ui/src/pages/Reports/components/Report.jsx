import React from 'react';
import { ListItemButton, ListItemText, Grid, Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useNavigate, useLocation } from 'react-router';
import { ReportTypes, GetOfficerNameFromReportType, GetOfficerJobFromReportType } from '../../../data';
import { TitleCase } from '../../../util/Parser';
import { usePerson } from '../../../hooks';
import qs from 'qs';

import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '5px 10px 5px 10px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ report }) => {
	const classes = useStyles();
	const history = useNavigate();
	const location = useLocation();
	const formatPerson = usePerson();

	let qry = qs.parse(location.search.slice(1));
	const reportId = qry.report;

	const onClick = () => {
		let s = qs.parse(location.search.slice(1));
		s.report = report.id;
		s.mode = "view"
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
	};

	const reportTypeName = ReportTypes.find(r => r.value == report.type)?.short ?? 'Incident';

	return (
		<ListItemButton className={classes.wrapper} onClick={onClick} selected={reportId == report.id}>
			<Grid container spacing={1}>
				<Grid item xs={12}>
					<ListItemText primary={<Typography noWrap><strong>{`${reportTypeName} #${report.id ?? 0} - `}</strong>{report.title}</Typography>} />
				</Grid>
				{/* <Grid item xs={2}>
					{report.suspects.length == 1 ? (
						<ListItemText
							primary={report.type === 0 ? "Suspects" : "People Involved"}
							secondary={`${report.suspects[0].suspect?.[0]?.First} ${report.suspects[0].suspect?.[0]?.Last}`}
						/>
					) : (
						<ListItemText
							primary={report.type === 0 ? "Suspects" : "People Involved"}
							secondary={`${report.suspects.length} ${report.type === 0 ? "Suspects" : "People Involved"}`}
						/>
					)}
				</Grid> */}
				{/* <Grid item xs={4}>
					<ListItemText
						primary={report.type === 0 ? `Primary ${reporterName}` : `${reporterName} Involved`}
						secondary={`${report.primaries
							.slice(0, 2)
							.map((o) => {
								return formatPerson(o.First, o.Last, o.Callsign, o.SID, false, true);
							})
							.join(', ')}${report.primaries.length - 2 > 0
								? ` +${report.primaries.length - 2}`
								: ''
							}`}
					/>
				</Grid> */}
				<Grid item xs={8}>
					<ListItemText secondary={`Created By ${report.creatorName}`} />
				</Grid>
				<Grid item xs={4}>
					<ListItemText secondary={<span>Created <Moment date={report.created} fromNow /></span>} />
				</Grid>
			</Grid>
		</ListItemButton>
	);
};

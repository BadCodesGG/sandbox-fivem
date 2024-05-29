import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	callsign: {
		fontSize: 18,
		color: theme.palette.primary.main,
	},
}));

export default () => {
	const classes = useStyles();
	const cData = useSelector((state) => state.app.user);
	const job = useSelector(state => state.app.govJob);

	if (!cData || !job) {
		return null;
	}

	switch (job?.Id) {
		case 'police':
		case 'prison':
			return (
				<>
					<span>
						{job.Grade?.Name} {cData.First[0]}. {cData.Last}
					</span>
					{Boolean(cData) && (
						<>
							{' '}[
							<span className={classes.callsign}>
								{cData.Callsign}
							</span>
							]
						</>
					)}
				</>
			);
		case 'government':
			return (
				<>
					<span>
						{job.Grade?.Name} {cData.First} {cData.Last}
					</span>
				</>
			);
		case 'ems':
			return (
				<>
					<span>
						{job.Grade?.Name} {cData.First[0]}. {cData.Last}
					</span>
					{Boolean(cData) && (
						<>
							{' '}[
							<span className={classes.callsign}>
								{cData.Callsign}
							</span>
							]
						</>
					)}
				</>
			);
		default:
			return null;
	}
};

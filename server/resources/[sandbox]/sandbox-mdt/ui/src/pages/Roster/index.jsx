import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Grid,
	Fade,
	TextField,
	InputAdornment,
	Button,
	IconButton,
	Skeleton,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useLocation } from 'react-router';
import qs from 'qs';

import Nui from '../../util/Nui';
import { SplitView, Loader } from '../../components';
import Officer from './components/Officer';
import Panel from './components/Panel';
import HireForm from './components/HireForm';
import { usePermissions } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		height: '100%',
		overflow: 'hidden',
	},
	search: {
		padding: '10px 5px 10px 5px',
		height: '100%',
		maxHeight: '95%',
		display: 'flex',
		flexDirection: 'column',
		overflow: 'hidden',
		width: '100%',
	},
	panel: {
		padding: '10px 5px 10px 5px',
		height: '100%',
		display: 'flex',
		flexDirection: 'column',
		maxHeight: '100%',
		overflowY: 'scroll',
	},
	officers: {
		overflowX: 'hidden',
		overflowY: 'auto',
		maxHeight: '100%',
		flexGrow: 1,
	},
	hireBtn: {
		height: '100%',
	},
	nWrapper: {
		padding: '10px 5px 10px 5px',
		height: '100%',
		display: 'flex',
		flexDirection: 'column',
		justifyContent: 'center',
		alignContent: 'center',
		textAlign: 'center',
		fontSize: 22,
	},
	nWrapperIcon: {
		opacity: '50%',
		color: theme.palette.primary.main,
		fontSize: 80,
		marginBottom: 20,
	},
	wow: {
		maxHeight: '100%',
		height: '100%',
		width: '100%',
	}
}));

export default ({ systemAdminMode = false }) => {
	const classes = useStyles();
	const location = useLocation();
	const hasPerm = usePermissions();
	const myJob = useSelector(state => state.app.govJob);
	const governmentJobs = useSelector(state => state.data.data.governmentJobs);
	const [selectedJob, setSelectedJob] = useState(myJob.Id);

	const allJobData = useSelector(state => state.data.data.governmentJobsData);
	const jobData = useSelector(state => state.data.data.governmentJobsData)?.[selectedJob];

	const isHighCommand = hasPerm('PD_HIGH_COMMAND') || hasPerm('SAFD_HIGH_COMMAND') || hasPerm('DOC_HIGH_COMMAND');
	const canHire = hasPerm('MDT_HIRE') || isHighCommand;

	let qry = qs.parse(location.search.slice(1));

	const [loading, setLoading] = useState(false);
	const [officers, setOfficers] = useState(Array());
	const [search, setSearch] = useState('');
	const [workplace, setWorkplace] = useState(false);
	const [filtered, setFiltered] = useState(Array());
	const [selected, setSelected] = useState(null);
	// const [selected, setSelected] = useState({
	// 	_id: '6088b90c93a7b379e0c83ef2',
	// 	SID: 1,
	// 	User: '606c22a749c1c980e8289b35',
	// 	Phone: '121-195-9016',
	// 	Gender: 0,
	// 	Callsign: 400,
	// 	Origin: 'United States',
	// 	First: 'Testy',
	// 	Last: 'McTest',
	// 	DOB: '1991-01-01T07:59:59.000Z',
	// 	Qualifications: ['fto'],
	// 	Jobs: [
	// 		{
	// 			Workplace: {
	// 				Id: 'lspd',
	// 				Name: 'Los Santos Police Department',
	// 			},
	// 			Name: 'Police',
	// 			Grade: {
	// 				Id: 'chief',
	// 				Name: 'Chief',
	// 			},
	// 			Id: 'police',
	// 		},
	// 	]
	// });
	const [panel, setPanel] = useState(null);
	const [hire, setHire] = useState(false);

	const onRender = async () => {
		setLoading(true);
		setPanel(false);

		try {
			let res = await (
				await Nui.send('RosterView', {
					job: selectedJob,
				})
			).json();

			setOfficers(res);
			setLoading(false);
		} catch (err) {
			console.log(err);
			setLoading(false);
		}
	};

	useEffect(() => {
		setWorkplace(false);
		onRender();
	}, [selectedJob]);

	useEffect(() => {
		let rgx = new RegExp(search, 'i');
		setFiltered(
			officers.filter(o => {
				const govJob = o.Jobs?.find(j => j.Id == selectedJob);
				if (`${o.First} ${o.Last}`.match(rgx) || (o.Callsign && o.Callsign?.toString().match(rgx))) {
					if (govJob && (!workplace || govJob.Workplace.Id === workplace)) {
						return true;
					}
				}
			})
		);
	}, [officers, search, workplace]);

	const onSelect = async (oSID) => {
		setLoading(true);

		try {
			let res = await (
				await Nui.send('RosterSelect', {
					job: selectedJob,
					person: oSID,
				})
			).json();

			if (res) {
				setSelected(res);
				setPanel(true);
			} else {
				setPanel(false);
			}
		} catch (err) {
			console.log(err);
			setPanel(false);
		}

		setLoading(false);
	};

	const onAnimEnd = () => {
		setSelected(null);
	};

	const onUpdate = () => {
		onSelect(selected?.SID);

		setTimeout(() => {
			onRender();
		}, 100);
	};

	return (
		<div className={classes.wrapper}>
			<SplitView hideButton expanded={true}>
				<div className={classes.search}>
					<Grid container spacing={1}>
						{systemAdminMode && <Grid item xs={6}>
							<TextField
								select
								fullWidth
								variant="standard"
								label="Agency"
								className={classes.editorField}
								value={selectedJob}
								onChange={(e) => {
									setPanel(false);
									setSelectedJob(e.target.value);
								}}
							>
								{governmentJobs.map(job => (
									<MenuItem key={job} value={job}>
										{allJobData[job]?.Name ?? 'Unknown'}
									</MenuItem>
								))}
							</TextField>
						</Grid>}
						<Grid item xs={systemAdminMode ? 6 : 4}>
							<TextField
								select
								fullWidth
								variant="standard"
								label="Department"
								className={classes.editorField}
								value={workplace}
								onChange={(e) => setWorkplace(e.target.value)}
							>
								<MenuItem key={false} value={false}>
									All Departments
								</MenuItem>
								{jobData.Workplaces.map(w => (
									<MenuItem key={w.Id} value={w.Id}>
										{w.Name}
									</MenuItem>
								))}
							</TextField>
						</Grid>
						<Grid item xs={systemAdminMode ? 10 : 6}>
							<TextField
								fullWidth
								label="Search By Name or Callsign"
								variant="standard"
								value={search}
								onChange={(e) =>
									setSearch(e.target.value)
								}
								InputProps={{
									endAdornment: (
										<InputAdornment position="end">
											{search != '' && (
												<IconButton
													size="small"
													type="button"
													onClick={() => setSearch('')}
												>
													<FontAwesomeIcon
														icon={['fas', 'xmark']}
													/>
												</IconButton>
											)}
										</InputAdornment>
									),
								}}
							/>
						</Grid>
						{canHire && (
							<Grid item xs={2}>
								<Button
									className={classes.hireBtn}
									variant="outlined"
									onClick={() => setHire(true)}
									fullWidth
								>
									Hire
								</Button>
							</Grid>
						)}
					</Grid>
					<div item xs={12} style={{ width: '100%', overflow: 'hidden' }}>
						<div className={classes.officers}>
							{filtered
								.sort((a, b) => a.Callsign - b.Callsign)
								.map((officer, k) => {
									return (
										<Officer
											key={`offcr-${k}`}
											selected={selected?.SID == officer.SID}
											officer={officer}
											onSelect={() => onSelect(officer.SID)}
											disabled={loading}
											selectedJob={selectedJob}
										/>
									);
								})}
						</div>
					</div>
				</div>
				{!loading && selected ? (
					<Fade in={panel} onExited={onAnimEnd}>
						<div className={classes.panel}>
							<Panel officer={selected} onUpdate={onUpdate} selectedJob={selectedJob} />
						</div>
					</Fade>
				) : (
					<div className={classes.nWrapper}>
						{loading ? (
							<Loader text="Loading" />
						) : (
							<>
								<FontAwesomeIcon className={classes.nWrapperIcon} icon={['fas', 'user-tie']} />
								<div>None Selected</div>
							</>
						)}
					</div>
				)}
			</SplitView>
			{canHire && (
				<HireForm
					systemAdminMode={systemAdminMode}
					selectedJob={selectedJob}
					open={hire}
					onUpdate={onUpdate}
					onClose={() => setHire(false)}
				/>
			)}
		</div>
	);
};

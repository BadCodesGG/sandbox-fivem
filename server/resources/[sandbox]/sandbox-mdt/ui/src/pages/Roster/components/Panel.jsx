import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Avatar,
	ListItem,
	ListItemText,
	Grid,
	List,
	TextField,
	Button,
	MenuItem,
	ButtonGroup,
	Select,
	Chip,
	FormControl,
	InputLabel,
	Box,
	OutlinedInput,
	DialogContent,
	DialogContentText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { toast } from 'react-toastify';
import moment from 'moment';
import { usePermissions } from '../../../hooks';
import { Modal } from '../../../components';
import Nui from '../../../util/Nui';

const parseDutyTime = (dutyTime, job) => {
	if (dutyTime && dutyTime[job]) {
		const afterTime = moment().subtract(7, 'days').unix();
		let timeWorked = 0;
		dutyTime[job].forEach(t => {
			if (t.time >= afterTime) {
				timeWorked += t.minutes;
			}
		});

		if (timeWorked > 0) {
			return moment.duration(timeWorked, "minutes").humanize();
		} else {
			return '0 minutes';
		}

	} else {
		return '0 minutes';
	}
}

const checkSuspension = (data, job) => {
	const now = moment().unix();
	if (data && data[job] && data[job].Expires > now) {
		return {
			...data[job],
			ExpiresIn: moment(data[job].Expires * 1000).fromNow(true),
			ExpiresAt: moment(data[job].Expires * 1000).format("LLL")
		}
	}
}

const useStyles = makeStyles((theme) => ({
	wrapper: {
		//padding: 20,
		height: '100%',
		//background: theme.palette.secondary.main,
	},
	inner: {
		padding: 10,
		//background: theme.palette.secondary.dark,
		height: '100%',
		overflowY: 'scroll',
		//border: `3px inset ${theme.palette.border.divider}`,
	},
	avatar: {
		height: 250,
		width: 250,
		margin: 'auto',
		transition: 'filter ease-in 0.15s',
		'&.hoverable:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	field: {
		marginTop: 20,
	},
	hoverable: {
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ selectedJob, officer, onUpdate }) => {
	const classes = useStyles();
	const hasPerm = usePermissions();
	const user = useSelector((state) => state.app.user);
	const myJob = useSelector(state => state.app.govJob);
	const jobData = useSelector(state => state.data.data.governmentJobsData)?.[selectedJob];
	const availablePermissions = useSelector(state => state.data.data.permissions);
	const availableQualifications = useSelector(state => state.data.data.qualifications);

	const officerGovJobData = officer.Jobs?.find(j => j.Id == selectedJob);
	if (!officerGovJobData) return null;

	const isHighCommand = hasPerm('PD_HIGH_COMMAND') || hasPerm('SAFD_HIGH_COMMAND') || hasPerm('DOJ_JUDGE') || hasPerm('DOC_HIGH_COMMAND');
	const canFire = hasPerm('MDT_FIRE') || isHighCommand;
	const canPromote = hasPerm('MDT_PROMOTE') || isHighCommand;
	const canEdit = hasPerm('MDT_EDIT_EMPLOYEE') || isHighCommand;

	const [picture, setPicture] = useState(false);
	const [callsign, setCallsign] = useState(false);
	const [qualEdit, setQualEdit] = useState(false);
	const [jobEdit, setJobEdit] = useState(false);
	const [jobFire, setJobFire] = useState(false);
	const [pendingQuals, setPendingQual] = useState(Array());
	const [pJob, setPJob] = useState(officerGovJobData);

	const [viewingDutyHours, setViewingDutyHours] = useState(false);

	const [pending, setPending] = useState({
		picture: officer.Mugshot ?? '',
		callsign: Boolean(officer.Callsign) ? officer.Callsign : '',
	});

	const [jobSuspend, setJobSuspend] = useState(false);
	const [suspendDays, setSuspendDays] = useState('3');

	const [revokingSuspend, setRevokingSuspend] = useState(false);

	const isSuspended = checkSuspension(officer.MDTSuspension, selectedJob);

	useEffect(() => {
		setPicture(false);
		setCallsign(false);
		setPJob(officer.Jobs?.find(j => j.Id == selectedJob));
		setPendingQual(officer.Qualifications ?? Array());
		setPending({
			picture: officer.Mugshot ?? '',
			callsign: Boolean(officer.Callsign) ? officer.Callsign : '',
		});
	}, [officer]);

	const onSavePicture = async (e) => {
		e.preventDefault();
		if (!canEdit) return;

		try {
			let res = await (
				await Nui.send('Update', {
					type: 'person',
					SID: officer.SID,
					Key: 'Mugshot',
					Data: pending.picture,
				})
			).json();
			if (res) {
				toast.success('Profile Picture Updated');
				onUpdate();
				setPicture(false);
			} else toast.error('Unable to Update Profile Picture');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Profile Picture');
		}
	};

	const onSaveCallsign = async (e) => {
		e.preventDefault();
		if (!canEdit) return;
		if (officer.Callsign == pending.callsign) {
			toast.success('Callsign Updated');
			setCallsign(false);
			return;
		}

		try {
			let res = await (
				await Nui.send('CheckCallsign', parseInt(pending.callsign))
			).json();

			if (res) {
				let res2 = await (
					await Nui.send('Update', {
						type: 'person',
						SID: officer.SID,
						Key: 'Callsign',
						Data: parseInt(pending.callsign),
					})
				).json();
				if (res2) {
					toast.success('Callsign Updated');
					onUpdate();
					setCallsign(false);
				} else toast.error('Unable to Update Callsign');
			} else toast.error('Callsign Already Assigned');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Callsign');
		}
	};

	const onSaveJob = async (e) => {
		e.preventDefault();
		if (!canPromote) return;

		try {
			let res = await (
				await Nui.send('ManageEmployment', {
					SID: officer.SID,
					data: pJob,
					JobId: myJob?.Id
				})
			).json();
			if (res) {
				toast.success('Employment Updated');
				onUpdate();
				setJobEdit(false);
			} else toast.error('Unable to Update Employment');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Employment');
		}
	};

	const onQualChange = (e) => {
		setPendingQual([...e.target.value]);
	};

	const onSaveQuals = async (e) => {
		e.preventDefault();
		if (!isHighCommand) return;

		try {
			let res = await (
				await Nui.send('Update', {
					type: 'person',
					SID: officer.SID,
					Key: 'Qualifications',
					Data: pendingQuals,
				})
			).json();
			if (res) {
				toast.success('Qualifications Updated');
				onUpdate();
				setQualEdit(false);
			} else toast.error('Unable to Update Qualifications');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Qualifications');
		}
	};

	const fireEmployee = async () => {
		if (!canFire) return;

		try {
			let res = await (
				await Nui.send('FireEmployee', {
					SID: officer.SID,
					JobId: pJob.Id,
				})
			).json();

			if (res) {
				toast.success('Employee Terminated');
				onUpdate();
			} else toast.error('Unable to Fire Employee');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Fire Employee');
		}
	};

	const suspendEmployee = async () => {
		if (!canFire) return;

		setJobSuspend(false);

		if (isNaN(parseInt(suspendDays))) {
			toast.error('Unable to Suspend Employee');
			return;
		};

		try {
			let res = await (
				await Nui.send('SuspendEmployee', {
					SID: officer.SID,
					JobId: pJob.Id,
					Length: parseInt(suspendDays)
				})
			).json();

			if (res) {
				toast.success('Employee Suspended');
				onUpdate();
			} else toast.error('Unable to Suspend Employee');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Suspend Employee');
		}
	};

	const unsuspendEmployee = async () => {
		if (!canFire) return;

		setRevokingSuspend(false);

		try {
			let res = await (
				await Nui.send('UnsuspendEmployee', {
					SID: officer.SID,
					JobId: pJob.Id,
				})
			).json();

			if (res) {
				toast.success('Employee Suspension Revoked');
				onUpdate();
			} else toast.error('Unable to Revoke Suspension');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Revoke Suspension');
		}
	};

	const onPrintBadge = async () => {
		try {
			await Nui.send('Close', {})
			Nui.send('PrintBadge', {
				SID: officer.SID,
				JobId: pJob?.Id,
			});
		} catch (err) {
			console.log(err);
		}
	}

	return (
		<div className={classes.wrapper}>
			<Grid container style={{ height: '100%' }}>
				{(officer.SID != user.SID && !officer.MDTSystemAdmin) && <Grid item xs={12}>
					<ButtonGroup fullWidth>
						{canPromote && <Button onClick={() => setJobEdit(true)}>
							Edit
						</Button>}
						{canFire && <Button onClick={() => setJobFire(true)}>
							Fire
						</Button>}
						{(canFire && !isSuspended && (pJob.Id === 'police' || pJob.Id === 'ems')) && <Button onClick={() => setJobSuspend(true)}>
							Suspend
						</Button>}
						{(canFire && isSuspended && (pJob.Id === 'police' || pJob.Id === 'ems')) && <Button onClick={() => setRevokingSuspend(true)}>
							Revoke Suspension
						</Button>}
						{isHighCommand && <Button onClick={() => setQualEdit(true)}>
							Qual.
						</Button>}
						{isHighCommand && <Button onClick={() => onPrintBadge()}>
							Badge
						</Button>}
						{isHighCommand && <Button onClick={() => setQualEdit(true)}>
							Qualifications
						</Button>}
						{isHighCommand && <Button onClick={() => onPrintBadge()}>
							Badge
						</Button>}
					</ButtonGroup>
				</Grid>}
				{(isHighCommand && officer.SID === user.SID) && <Grid item xs={12}>
					<ButtonGroup fullWidth>
						<Button onClick={() => setQualEdit(true)}>
							Qualifications
						</Button>
						<Button onClick={() => onPrintBadge()}>
							Badge
						</Button>
					</ButtonGroup>
				</Grid>}
				<Grid item xs={6}>
					<div className={classes.inner} style={{ marginRight: 10 }}>
						<Avatar
							className={`${classes.avatar}${canEdit ? ' hoverable' : ''}`}
							src={Boolean(officer?.Mugshot) ? officer?.Mugshot : ''}
							alt={officer.First}
							onClick={canEdit ? () => setPicture(true) : null}
						/>
						<List>
							<ListItem>
								<ListItemText
									primary="State ID"
									secondary={officer.SID}
								/>
							</ListItem>
							<ListItem>
								<ListItemText
									primary="Name"
									secondary={`${officer.First} ${officer.Last}`}
								/>
							</ListItem>
							{(pJob.Id === 'police' || (pJob.Id === 'ems' && pJob.Workplace?.Id === 'safd') || (pJob.Id === "prison" && pJob.Workplace?.Id == "corrections")) && <ListItem>
								<ListItemText
									onClick={
										canEdit
											? () => setCallsign(true)
											: null
									}
									className={
										canEdit ? classes.hoverable : ''
									}
									primary="Callsign"
									secondary={
										Boolean(officer.Callsign)
											? officer.Callsign
											: 'Not Set'
									}
								/>
							</ListItem>}
							<ListItem>
								<ListItemText
									primary="Phone Number"
									secondary={officer.Phone}
								/>
							</ListItem>
						</List>
					</div>
				</Grid>
				<Grid item xs={6}>
					<div className={classes.inner} style={{ marginLeft: 10 }}>
						<List>
							{isSuspended && <ListItem>
								<ListItemText
									primary="Suspended"
									secondary={`This person has ${isSuspended.ExpiresIn} remaining of their ${isSuspended.Length} day suspension. Expires At: ${isSuspended.ExpiresAt}`}
								/>
							</ListItem>}
							{isSuspended && <ListItem>
								<ListItemText
									primary="Suspended By"
									secondary={`[${isSuspended.Actioned.Callsign}] ${isSuspended.Actioned.First[0]}. ${isSuspended.Actioned.Last}`}
								/>
							</ListItem>}
							<ListItem>
								<ListItemText
									primary="Department"
									secondary={officerGovJobData?.Workplace?.Name}
								/>
							</ListItem>
							<ListItem>
								<ListItemText
									primary="Rank"
									secondary={officerGovJobData?.Grade?.Name}
								/>
							</ListItem>
							<ListItem>
								<ListItemText
									primary="Qualifications"
									secondary={
										Boolean(officer.Qualifications) && officer.Qualifications.length > 0
											? officer.Qualifications
												.map(q => availableQualifications[q]?.name ?? 'Unknown')
												.join(', ')
											: 'No Qualifications'
									}
								/>
							</ListItem>
							<ListItem>
								<ListItemText
									primary="Permissions"
									secondary={
										Object.keys(jobData.Workplaces.find(w => w.Id == officerGovJobData?.Workplace?.Id)?.Grades.find(g => g.Id == officerGovJobData?.Grade.Id)?.Permissions)
											.map(k => availablePermissions[k]?.name ?? 'Unknown')
											.join(', ')
									}
								/>
							</ListItem>
							{officer?.LastClockOn?.[pJob.Id] && <ListItem>
								<ListItemText
									primary="Last Clocked On"
									secondary={`${pJob.Name}: ${moment(officer?.LastClockOn?.[pJob.Id] * 1000).format('LLL')} (${moment(officer?.LastClockOn?.[pJob.Id] * 1000).fromNow()})`}
								/>
							</ListItem>}
							{officer?.TimeClockedOn?.[pJob.Id] && <ListItem button onClick={() => setViewingDutyHours(true)}>
								<ListItemText
									primary="Time Worked in the Last Week"
									secondary={`${pJob.Name}: ${parseDutyTime(officer.TimeClockedOn, pJob.Id)}`}
								/>
							</ListItem>}
						</List>
					</div>
				</Grid>
			</Grid>
			<Modal
				open={picture}
				maxWidth="sm"
				title="Update Profile Picture"
				onSubmit={onSavePicture}
				onClose={() => setPicture(false)}
			>
				<Avatar
					className={classes.avatar}
					src={pending.picture}
					alt={officer.First}
				/>
				<TextField
					fullWidth
					required
					label="Image URL"
					variant="standard"
					name="picture"
					value={pending.picture}
					className={classes.field}
					onChange={(e) =>
						setPending({
							...pending,
							picture: e.target.value,
						})
					}
				/>
			</Modal>
			<Modal
				open={callsign}
				maxWidth="sm"
				title="Update Callsign"
				onSubmit={onSaveCallsign}
				onClose={() => setCallsign(false)}
			>
				<TextField
					fullWidth
					required
					label="Callsign"
					helperText="3 characters long, NUMBERS ONLY"
					variant="standard"
					name="callsign"
					value={pending.callsign}
					className={classes.field}
					inputProps={{
						pattern: '[0-9]{3}',
						maxLength: 3,
					}}
					onChange={(e) => {
						let v = e.target.value;
						if (/[0-9\b]+$/.test(v))
							setPending({
								...pending,
								callsign: e.target.value,
							});
					}}
				/>
			</Modal>
			<Modal
				open={jobEdit}
				maxWidth="sm"
				title="Update Job"
				onSubmit={onSaveJob}
				onClose={() => setJobEdit(false)}
			>
				<TextField
					select
					fullWidth
					disabled={!isHighCommand || pJob.Id === "ems"}
					label="Department"
					className={classes.editorField}
					value={pJob.Workplace.Id}
					onChange={(e) =>
						setPJob({
							...pJob,
							Workplace: jobData.Workplaces.find(w => w.Id == e.target.value),
							Grade: jobData.Workplaces.find(w => w.Id == e.target.value)?.Grades.sort((a, b) => a.Level - b.Level)[0],
						})
					}
				>
					{jobData.Workplaces.map((w) => (
						<MenuItem key={w.Id} value={w.Id}>
							{w.Name}
						</MenuItem>
					))}
				</TextField>
				<TextField
					select
					fullWidth
					disabled={!canPromote}
					label="Rank"
					className={classes.editorField}
					value={pJob.Grade.Id}
					onChange={(e) =>
						setPJob({
							...pJob,
							Grade: jobData.Workplaces.find(
								(w) => w.Id == pJob.Workplace.Id
							)?.Grades.find(
								(g) => g.Id == e.target.value
							),
						})
					}
				>
					{jobData.Workplaces.find(w => w.Id == pJob.Workplace.Id)?.Grades.map(g => (
						<MenuItem
							key={g.Id}
							value={g.Id}
							disabled={!hasPerm(true) && g.Level >= myJob.Grade.Level}
						>
							{g.Name}
						</MenuItem>
					))}
				</TextField>
			</Modal>

			<Modal
				open={qualEdit}
				maxWidth="sm"
				title="Update Qualifications"
				onSubmit={onSaveQuals}
				onClose={() => setQualEdit(false)}
			>
				<FormControl fullWidth className={classes.editorField}>
					<InputLabel>
						Qualifications
					</InputLabel>
					<Select
						multiple
						fullWidth
						value={pendingQuals}
						onChange={onQualChange}
						input={
							<OutlinedInput fullWidth label="Qualifications" />
						}
						renderValue={(selected) => (
							<Box style={{ display: 'flex', flexWrap: 'wrap' }}>
								{selected.map((value) => (
									<Chip
										key={value}
										label={availableQualifications[value]?.name ?? 'Unknown'}
										style={{ margin: 2 }}
									/>
								))}
							</Box>
						)}
					>
						{Object.keys(availableQualifications)
							.filter(qual => {
								const data = availableQualifications[qual];
								if (data) {
									if (!data.restrict) return true;

									if (data.restrict.weapon && (pJob.Id == "police" || pJob.Id === "prison")) {
										return true;
									}

									if (data.restrict.job && data.restrict.job === pJob.Id && (!data.restrict.workplace || data.restrict.workplace == pJob?.Workplace?.Id)) {
										return true
									}
								}
								return false;
							}).map(qual => (
								<MenuItem key={`q-${qual}`} value={qual}>
									{availableQualifications[qual]?.name}
								</MenuItem>
							)
							)}
					</Select>
				</FormControl>
			</Modal>
			<Modal
				open={jobFire}
				maxWidth="sm"
				title={`Fire ${officer.First} ${officer.Last}?`}
				acceptLang="Yes"
				closeLang="No"
				onAccept={fireEmployee}
				onClose={() => setJobFire(false)}
			>
				<DialogContent>
					<DialogContentText>
						Are you sure you want to terminate{' '}
						{officerGovJobData?.Workplace?.Name} {officerGovJobData?.Grade.Name}{' '}
						{officer.First} {officer.Last}?
					</DialogContentText>
				</DialogContent>
			</Modal>
			<Modal
				open={jobSuspend}
				maxWidth="sm"
				title={`Suspend ${officer.First} ${officer.Last}?`}
				acceptLang="Yes"
				closeLang="No"
				onAccept={suspendEmployee}
				onClose={() => setJobSuspend(false)}
			>
				<TextField
					fullWidth
					required
					label="Suspension Length (Days)"
					variant="standard"
					name="suspension"
					value={suspendDays}
					className={classes.field}
					InputProps={{
						inputProps: {
							min: 0,
							max: 100,
							pattern: '0-9',
						},
					}}
					onChange={(e) =>
						setSuspendDays(e.target.value)
					}
				/>
				<DialogContent>
					<DialogContentText>
						Are you sure you want to suspend{' '}
						{officerGovJobData?.Workplace?.Name} {officerGovJobData?.Grade.Name}{' '}
						{officer.First} {officer.Last} for {suspendDays} days?
					</DialogContentText>
				</DialogContent>
			</Modal>
			<Modal
				open={revokingSuspend}
				maxWidth="sm"
				title={`Revoke Suspension for ${officer.First} ${officer.Last}?`}
				acceptLang="Yes"
				closeLang="No"
				onAccept={unsuspendEmployee}
				onClose={() => setRevokingSuspend(false)}
			>
				<DialogContent>
					<DialogContentText>
						Are you sure you want to revoke the suspension for{' '}
						{officerGovJobData?.Workplace?.Name} {officerGovJobData?.Grade.Name}{' '}
						{officer.First} {officer.Last}?
					</DialogContentText>
				</DialogContent>
			</Modal>
			<Modal
				open={viewingDutyHours}
				maxWidth="sm"
				title="Recent Sessions on Duty"
				onClose={() => setViewingDutyHours(false)}
			>
				<DialogContent>
					<DialogContentText>
						{officer.TimeClockedOn && officer.TimeClockedOn[pJob.Id] && officer.TimeClockedOn[pJob.Id].map(session => {
							return <p>{moment(session.time * 1000).format('LLL')} - {moment.duration(session.minutes, "minutes").humanize()}</p>
						})}
					</DialogContentText>
				</DialogContent>
			</Modal>
		</div>
	);
};

import React, { useEffect, useState, useMemo } from 'react';
import { useSelector } from 'react-redux';
import {
	Autocomplete,
	TextField,
	MenuItem,
	ListItem,
	ListItemText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import Moment from 'react-moment';

import { usePermissions } from '../../../hooks';
import { Modal } from '../../../components';
import Nui from '../../../util/Nui';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
	option: {
		transition: 'background ease-in 0.15s',
		border: `1px solid ${theme.palette.border.divider}`,
		'&:hover': {
			background: theme.palette.secondary.main,
			cursor: 'pointer',
		},
		'&.selected': {
			color: theme.palette.primary.main,
		},
	},
}));

export default ({ systemAdminMode, selectedJob, open, onUpdate, onClose }) => {
	const classes = useStyles();
	const hasPerm = usePermissions();

	const isHighCommand = hasPerm('PD_HIGH_COMMAND') || hasPerm('SAFD_HIGH_COMMAND') || hasPerm('DOC_HIGH_COMMAND');
	const canHire = hasPerm('MDT_HIRE') || isHighCommand;

	const myJob = useSelector(state => state.app.govJob);
	const jobData = useSelector(state => state.data.data.governmentJobsData)?.[selectedJob];
	const defaultWorkplace = (myJob.Id === selectedJob) ? myJob.Workplace.Id : jobData.Workplaces[0].Id;

	const [characters, setCharacters] = useState(Array());
	const [state, setState] = useState({
		TargetSID: '',
		JobId: myJob.Id,
		Workplace: jobData.Workplaces.find(w => w.Id == defaultWorkplace),
		Grade: jobData.Workplaces.find(w => w.Id == defaultWorkplace)?.Grades.sort((a, b) => a.Level - b.Level)[0],
	});

	useEffect(() => {
		setState({
			TargetSID: '',
			JobId: myJob.Id,
			Workplace: jobData.Workplaces.find(w => w.Id == defaultWorkplace),
			Grade: jobData.Workplaces.find(w => w.Id == defaultWorkplace)?.Grades.sort((a, b) => a.Level - b.Level)[0],
		})
	}, [selectedJob]);

	const onSubmit = async (e) => {
		e.preventDefault();
		if (!canHire) return;

		try {
			let res = await (
				await Nui.send('HireEmployee', {
					SID: parseInt(state.TargetSID),
					JobId: state.JobId,
					WorkplaceId: state.Workplace.Id,
					GradeId: state.Grade.Id,
				})
			).json();
			if (res) {
				toast.success(`State ID ${state.TargetSID} Has Been Hired As ${state.Workplace.Name} ${state.Grade.Name}`);
				onUpdate();
				onClose();
			} else throw res;
		} catch (err) {
			console.log(err);
			toast.error('Unable to Hire Person');
		}
	};

	return (
		<Modal
			open={open}
			title="Hire New"
			submitLang="Hire"
			onSubmit={onSubmit}
			onClose={onClose}
		>
			<TextField
				fullWidth
				variant="standard"
				name="SID"
				value={state.TargetSID}
				onChange={(e) => setState({
					...state,
					TargetSID: e.target.value
				})}
				label="New Hire State ID"
			/>
			{systemAdminMode && <TextField
				select
				fullWidth
				variant="standard"
				disabled
				label="Agency"
				className={classes.editorField}
				value={selectedJob}
			>
				<MenuItem
					key={selectedJob}
					value={selectedJob}
				>
					{jobData?.Name}
				</MenuItem>
			</TextField>}
			{(selectedJob == 'police' || selectedJob == 'government') && <TextField
				select
				fullWidth
				variant="standard"
				//disabled={!isHighCommand}
				label="Department"
				className={classes.editorField}
				value={state.Workplace.Id}
				onChange={(e) =>
					setState({
						...state,
						Workplace: jobData.Workplaces.find(
							(w) => w.Id == e.target.value,
						),
						Grade: jobData.Workplaces.find(
							(w) => w.Id == e.target.value,
						)?.Grades.sort((a, b) => a.Level - b.Level)[0],
					})
				}
			>
				{jobData.Workplaces.map((w) => (
					<MenuItem key={w.Id} value={w.Id}>
						{w.Name}
					</MenuItem>
				))}
			</TextField>}
			<TextField
				select
				fullWidth
				variant="standard"
				disabled
				label="Rank"
				className={classes.editorField}
				value={state.Grade?.Id}
			>
				<MenuItem
					key={state.Grade.Id}
					value={state.Grade.Id}
				>
					{state.Grade.Name}
				</MenuItem>
			</TextField>
		</Modal>
	);
};

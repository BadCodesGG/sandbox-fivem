import React, { useEffect, useState } from 'react';
import { TextField, MenuItem } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { Modal } from '../../../components';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ open, existing = null, onSubmit, onClose }) => {
	const classes = useStyles();

	const initalState = {
		title: 'Stolen',
		description: '',
	};

	const [state, setState] = useState({
		...initalState,
		title: Boolean(existing) ? existing.title : 'Stolen',
		description: Boolean(existing) ? existing.description : '',
	});

	useEffect(() => {
		setState({
			...state,
			...existing,
		});
	}, [existing]);

	const internalSubmit = (e) => {
		e.preventDefault();
		onSubmit(state);
		setState({ ...initalState });
	};

	const onChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	return (
		<Modal
			open={open}
			maxWidth="sm"
			title="Add New Flag"
			submitLang="Create"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<TextField
				required
				select
				fullWidth
				name="title"
				label="Flag Title"
				className={classes.editorField}
				value={state.title}
				onChange={onChange}
			>
				<MenuItem key="Stolen" value="Stolen">
					Stolen
				</MenuItem>
				<MenuItem key="Seized" value="Seized">
					Seized
				</MenuItem>
				<MenuItem key="Flagged" value="Flagged">
					Flagged
				</MenuItem>
				<MenuItem key="PD Trashed/Broken" value="PD Trashed/Broken">
					PD Trashed/Broken
				</MenuItem>
			</TextField>
			<TextField
				required
				fullWidth
				multiline
				minRows={4}
				name="description"
				label="Flag Description"
				className={classes.editorField}
				value={state.description}
				onChange={onChange}
			/>
		</Modal>
	);
};

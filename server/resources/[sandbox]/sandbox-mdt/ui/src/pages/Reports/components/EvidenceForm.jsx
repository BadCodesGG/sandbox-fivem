import React, { useEffect, useState } from 'react';
import { TextField, MenuItem } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { Modal } from '../../../components';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export const EvidenceTypes = [
	{
		label: 'Photo',
		value: 'photo',
		style: {
			backgroundColor: '#9542f5',
		},
	},
	{
		label: 'Casing',
		value: 'casing',
		style: {
			backgroundColor: '#969696',
		},
	},
	{
		label: 'Projectile',
		value: 'projectile',
		style: {
			backgroundColor: '#de4628',
			color: '#ffffff',
		},
	},
	{
		label: 'Weapon',
		value: 'weapon',
		style: {
			backgroundColor: '#8f032b',
		},
	},
	{
		label: 'Paint Fragment',
		value: 'fragment',
		style: {
			backgroundColor: '#038f11',
		},
	},
	{
		label: 'Other',
		value: 'other',
		style: {
			backgroundColor: '#1eadd9',
		},
	},
];

const initalState = {
	type: '',
	label: '',
	value: '',
};

export default ({ open, onSubmit, onClose }) => {
	const classes = useStyles();

	const [state, setState] = useState({
		type: '',
		label: '',
		value: '',
	});

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
			title={'Add New Evidence'}
			submitLang={'Add'}
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<TextField
				variant="standard"
				required
				select
				fullWidth
				name="type"
				label="Type"
				className={classes.editorField}
				value={state.type}
				onChange={onChange}
			>
				{EvidenceTypes.map((option) => (
					<MenuItem key={option.value} value={option.value}>
						{option.label}
					</MenuItem>
				))}
			</TextField>
			<TextField
				required
				fullWidth
				name="label"
				label="Label"
				variant="standard"
				className={classes.editorField}
				value={state.label}
				onChange={onChange}
			/>
			<TextField
				required
				fullWidth
				variant="standard"
				name="value"
				label="Evidence Identifier"
				className={classes.editorField}
				value={state.value}
				onChange={onChange}
			/>
		</Modal>
	);
};

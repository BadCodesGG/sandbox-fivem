import React, { useState } from 'react';
import { TextField } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { Modal } from '../../../components';
import { toast } from 'react-toastify';
import moment from 'moment';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ open, data, onSubmit, onClose }) => {
	const classes = useStyles();

	const initialState = {
		reduction: '',
	}

	const [state, setState] = useState({
		...initialState,
	});

	const internalSubmit = (e) => {
		e.preventDefault();
		const reductionTime = parseInt(state.reduction);
		let timeRemain = data?.Jailed?.Duration ?? 0;
		if (data?.Jailed?.Release) {
			timeRemain = Math.ceil(moment.duration(data.Jailed.Release - (Date.now() / 1000), 's').asMinutes());
		};

		if (!isNaN(reductionTime) && reductionTime > 0 && reductionTime <= 100) {
			if (reductionTime <= timeRemain) {
				onSubmit({
					SID: data.SID,
					reduction: reductionTime,
				});
				setState({ ...initialState });
			} else {
				toast.error("Cannot Reduce More than the Remaining Sentence");
			}
		} else {
			toast.error("Invalid Reduction");
		};
	};

	return (
		<Modal
			open={open}
			maxWidth="md"
			title={`Reduce Sentence for ${data?.First} ${data?.Last}`}
			submitLang="Reduce"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<p>Are you sure you want to reduce the sentence for {data?.First} {data?.Last} (State ID: {data?.SID})</p>
			<TextField
				required
				fullWidth
				variant="standard"
				name="reduction"
				label="Reduction Amount"
				className={classes.editorField}
				value={state.reduction}
				InputProps={{
					inputProps: {
						min: 0,
						max: 3,
					},
				}}
				onChange={(e) => {
					let v = e.target.value;
					if (v == "" || /[0-9\b]+$/.test(v))
						setState({
							...state,
							reduction: e.target.value,
						});
				}}
			/>
		</Modal>
	);
};

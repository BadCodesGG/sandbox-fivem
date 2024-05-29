import React, { useMemo, useState, useEffect } from 'react';
import {
	Grid,
	TextField,
	Autocomplete,
	ListItem,
	ListItemText,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { debounce } from 'lodash';
import { toast } from 'react-toastify';
import Moment from 'react-moment';

import Nui from '../../../util/Nui';
import { ChargeCalculator, Modal } from '../../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
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
	calculator: {
		height: '100%',
	},
}));

export const PleaTypes = [
	{
		label: 'Guilty',
		value: 'guilty',
	},
	{
		label: 'Not Guilty',
		value: 'not-guilty',
	},
	{
		label: 'No Contest',
		value: 'no-contest',
	},
	{
		label: 'Unknown',
		value: 'unknown',
	},
];

export const initialState = {
	suspectInput: '',
	suspect: null,
	charges: Array(),
	plea: 'unknown',
};

export default ({ open, onSubmit, onEdit, onCancel, suspect = null, preSuspect = null }) => {
	const classes = useStyles();
	const [characters, setCharacters] = useState(Array());
	const [input, setInput] = useState('');
	const [selectedSus, setSelectedSus] = useState(null);
	const [state, setState] = useState(initialState);
	const [loading, setLoading] = useState(false);

	useEffect(() => {
		setState(Boolean(suspect) ? suspect : initialState);
	}, [suspect]);

	const fetch = useMemo(
		() =>
			debounce(async (v) => {
				setLoading(true);
				try {
					let res = await (
						await Nui.send('InputSearch', {
							type: 'people',
							term: v,
						})
					).json();
					setCharacters(res);
				} catch (err) {
					setCharacters(Array());
				}
				setLoading(false);
			}, 1000),
		[],
	);

	const fetchOne = async (sid) => {
		setLoading(true);
		try {
			let res = await (
				await Nui.send('InputSearchSID', {
					term: sid,
				})
			).json();

			if (res && res.length > 0 && res[0].SID) {
				setSelectedSus(res[0]);
			}
			return res;
		} catch (err) { }

		setLoading(false);
	};

	useEffect(() => {
		if (input && input.length > 0) {
			setLoading(true);
			setCharacters(Array());

			fetch(input);
		} else {
			setLoading(false);
			setCharacters(Array());
		}
	}, [input]);

	useEffect(() => {
		if (preSuspect) {
			fetchOne(preSuspect);
		};
	}, [preSuspect]);

	const onChargeAdd = (charge) => {
		if (state.charges.filter((c) => c.id == charge.id).length > 0) {
			setState({
				...state,
				charges: state.charges.map((c) => {
					if (c.id == charge.id)
						return { id: charge.id, count: c.count + 1 };
					else return c;
				}),
			});
		} else {
			setState({
				...state,
				charges: [...state.charges, { id: charge.id, count: 1 }],
			});
		}
	};

	const onChargeRemove = (charge) => {
		setState({
			...state,
			charges: state.charges.filter((c) => c.id != charge.id),
		});
	};

	const validate = (e) => {
		e.preventDefault();
		if (selectedSus == null && !suspect) {
			toast.error('Must Select Suspect');
		} else if (state.plea == '') {
			toast.error('Must Select Plea');
		} else if (state.charges.length == 0) {
			toast.error('Must Add Charges');
		} else {
			Boolean(suspect)
				? onEdit({ ...suspect, ...state })
				: onSubmit({ ...state, ...selectedSus });
			setState(initialState);
		}
	};

	const cancel = () => {
		onCancel();
	};

	return (
		<Modal
			open={open}
			maxWidth="xl"
			title={`${Boolean(suspect) ? 'Edit' : 'Add'} Suspect`}
			acceptLang={`${Boolean(suspect) ? 'Edit' : 'Add'} Suspect`}
			closeLang="Cancel"
			onAccept={validate}
			onClose={cancel}
		>
			<div className={classes.wrapper}>
				<Grid container style={{ height: '100%' }}>
					<Grid item xs={12}>
						<Grid container spacing={2}>
							<Grid item xs={6}>
								{Boolean(suspect) ? (
									<TextField
										fullWidth
										className={classes.editorField}
										disabled={true}
										label="Suspect"
										value={`${suspect.First} ${suspect.Last}`}
										variant="standard"
									/>
								) : (
									<Autocomplete
										loading={loading}
										fullWidth
										className={classes.editorField}
										getOptionLabel={(option) => {
											return `${option.First} ${option.Last} [${option.SID}]`;
										}}
										options={characters}
										autoComplete
										includeInputInList
										autoHighlight
										filterSelectedOptions
										name="suspect"
										value={selectedSus}
										onChange={(e, nv) => {
											setSelectedSus(nv);
										}}
										onInputChange={(e, nv) =>
											setInput(nv)
										}
										renderInput={(params) => (
											<TextField
												{...params}
												name="suspectInput"
												label="Suspect"
												fullWidth
												variant="standard"
											/>
										)}
										renderOption={(props, option) => {
											return (
												<ListItem
													{...props}
													key={`${option.SID}`}
													className={`${classes.option
														}${selectedSus?.SID ==
															option.SID
															? ' selected'
															: ''
														}`}
												>
													<ListItemText
														primary={`${option.First} ${option.Last} [${option.SID}]`}
														secondary={<span>DOB: <Moment date={option.DOB * 1000} format="LL" /></span>}
													/>
												</ListItem>
											);
										}}
									/>
								)}
							</Grid>
							<Grid item xs={6}>
								<div>
									<TextField
										select
										fullWidth
										variant="standard"
										label="Plea"
										className={classes.editorField}
										value={state.plea}
										onChange={(e) =>
											setState({
												...state,
												plea: e.target.value,
											})
										}
									>
										{PleaTypes.map((option) => (
											<MenuItem
												key={option.value}
												value={option.value}
											>
												{option.label}
											</MenuItem>
										))}
									</TextField>
								</div>
							</Grid>
						</Grid>
					</Grid>
					<Grid item xs={12} style={{ height: '60%' }}>
						<ChargeCalculator
							wrapperClass={classes.calculator}
							selected={state.charges}
							onChange={onChargeAdd}
							onRemove={onChargeRemove}
						/>
					</Grid>
					<h3>Please Remember To Press Sentence On The Suspect After The Report Is Submitted! It Also Checks Their Parole. Charges Should Be Stacked - The System Stacks Fines But Not Time For The Same Charge.</h3>
				</Grid>
			</div>
		</Modal>
	);
};

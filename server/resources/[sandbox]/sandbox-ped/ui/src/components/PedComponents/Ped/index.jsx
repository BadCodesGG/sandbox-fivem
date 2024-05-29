import ElementBox from '../../UIComponents/ElementBox/ElementBox';
import React, { useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import { connect, useDispatch, useSelector } from 'react-redux';

import { Checkbox, Ticker } from '../../UIComponents';
import { SetPed } from '../../../actions/pedActions';
import Nui from '../../../util/Nui';
import PedModels from './peds';
import { Alert, Select, FormControl, MenuItem, ListItemText, OutlinedInput } from '@mui/material';

const useStyles = makeStyles((theme) => ({
	body: {
		maxHeight: '100%',
		overflow: 'hidden',
		margin: 25,
		display: 'grid',
		gridGap: 0,
		gridTemplateColumns: '100%',
		justifyContent: 'space-around',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const gender = useSelector((state) => state.app.gender);
	const peds = PedModels[gender];
	const curr =
		peds.indexOf(props.model) == -1 ? 0 : peds.indexOf(props.model);

	const whitelistedPeds = useSelector((state) => state.app.whitelistedPeds);
	const [cPed, setCPed] = useState('none');
	const [disabled, setDisabled] = useState(false);

	useEffect(() => {
		if (whitelistedPeds.find(p => p.model === props.model)) {
			setCPed(props.model);
		} else {
			setCPed('none');
		};
	}, [props.model]);

	const onChange = async (v, d) => {
		try {
			setDisabled(true);
			const payload = { value: peds[v] };
			let res = await (await Nui.send('SetPed', payload)).json();
			if (res) {
				dispatch({
					type: 'UPDATE_PED',
					payload,
				});
			}
			setDisabled(false);
		} catch (err) {
			console.log(err);
			setDisabled(false);
		}
	};

	const onWLChange = async (ped) => {
		if (ped === 'none') {
			onChange(0);
			return;
		};

		try {
			setDisabled(true);
			const payload = { value: ped };
			let res = await (await Nui.send('SetPed', payload)).json();
			if (res) {
				dispatch({
					type: 'UPDATE_PED',
					payload,
				});
			}
			setDisabled(false);
		} catch (err) {
			console.log(err);
			setDisabled(false);
		}
	};

	return (
		<>
			<ElementBox bodyClass={classes.body}>
				<Alert severity="warning">
					Using any other model than 0 (MP Ped) may result in some
					options within the customization options not working as
					intended, or at all. YOU'VE BEEN WARNED.
				</Alert>
			</ElementBox>
			<ElementBox label={'Ped Model'} bodyClass={classes.body}>
				<Ticker
					label={'Model'}
					data={{}}
					current={curr}
					min={0}
					max={peds.length - 1}
					disabled={disabled}
					onChange={onChange}
				/>
			</ElementBox>
			{whitelistedPeds.length > 0 && <ElementBox label={'Whitelisted Ped Model'} bodyClass={classes.body}>
				<Select
					name="wlPed"
					disabled={disabled}
					fullWidth
					value={cPed}
					onChange={e => onWLChange(e.target.value)}
					input={<OutlinedInput fullWidth />}
				>
					<MenuItem key="none" value="none">
						<ListItemText primary="None" />
					</MenuItem>
					{whitelistedPeds.map(c => {
						return (
							<MenuItem key={c.model} value={c.model}>
								<ListItemText primary={c.label} />
							</MenuItem>
						);
					})}
				</Select>
			</ElementBox>}
		</>
	);
};

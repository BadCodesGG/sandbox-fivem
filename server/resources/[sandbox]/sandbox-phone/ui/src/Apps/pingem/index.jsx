import React, { useState } from 'react';
import { makeStyles } from '@mui/styles';
import { Button, TextField } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { NumericFormat } from 'react-number-format';
import chroma from 'chroma-js';

import img from './map.webp';

import Nui from '../../util/Nui';
import { AppInput } from '../../components';
import { useAlert, useAppData, useMyStates } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		//background: theme.palette.secondary.main,
		background: `linear-gradient( rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.65) ), url(${img})`,
		backgroundPosition: 'center',
		position: 'relative',
	},
	branding: {
		fontFamily: 'Kanit',
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		top: 100,
		left: 0,
		right: 0,
		margin: 'auto',
		fontSize: 45,
		fontStyle: 'italic',
		textAlign: 'center',
		fontWeight: 'bold',

		'& svg': {
			marginRight: 8,
		},
	},
	slogan: {
		fontSize: 12,
		fontStyle: 'normal',
		width: '75%',
		margin: 'auto',
	},
	content: {
		position: 'absolute',
		width: '100%',
		height: 'fit-content',
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		padding: 10,
		paddingTop: 15,
		borderTop: (app) => `1px solid ${app.color}`,
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
	},
	alert: {
		backgroundColor: '#8E1467',
		marginBottom: 15,
	},
	primary: {
		backgroundColor: (app) => app.color,
		color: theme.palette.secondary.dark,

		'&:hover': {
			backgroundColor: (app) => chroma(app.color).darken(),
		},
	},
	editorField: {
		marginBottom: 15,
	},
	icon: {
		marginRight: 5,
	},
}));

export default (props) => {
	const appData = useAppData('pingem');
	const classes = useStyles(appData);
	const hasState = useMyStates();
	const showAlert = useAlert();

	const [target, setTarget] = useState('');

	const onChange = (e) => {
		setTarget(+e.target.value);
	};

	const onPing = async () => {
		try {
			let res = await (
				await Nui.send('PingEm:Send', {
					target,
					type: false,
				})
			).json();
			if (res) {
				showAlert('Sent Ping');
			} else showAlert('Unable To Send Ping');
		} catch (err) {
			showAlert('Unable To Send Ping');
		}
	};

	const onAnonPing = async () => {
		try {
			let res = await (
				await Nui.send('PingEm:Send', {
					target,
					type: true,
				})
			).json();
			if (res) {
				showAlert('Sent Ping');
			} else showAlert('Unable To Send Ping');
		} catch (err) {
			showAlert('Unable To Send Ping');
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.branding}>
				<FontAwesomeIcon icon="map-pin" />
				FINDR
				<div class={classes.slogan}>
					Helping Your Directionally Challenged Friends Since 1969
				</div>
			</div>
			<div className={classes.content}>
				<NumericFormat
					fullWidth
					required
					app={appData}
					label="Target State ID"
					name="target"
					className={classes.editorField}
					type="tel"
					value={target}
					onChange={onChange}
					variant="standard"
					customInput={AppInput}
				/>
				<Button
					fullWidth
					className={classes.primary}
					variant="contained"
					onClick={onPing}
				>
					Send Ping
				</Button>
				{hasState('PHONE_VPN') && (
					<Button
						style={{ marginTop: 15 }}
						fullWidth
						variant="outlined"
						color="warning"
						onClick={onAnonPing}
					>
						<FontAwesomeIcon
							className={classes.icon}
							icon={['fas', 'user-secret']}
						/>
						Send Anonymous Ping
					</Button>
				)}
			</div>
		</div>
	);
};

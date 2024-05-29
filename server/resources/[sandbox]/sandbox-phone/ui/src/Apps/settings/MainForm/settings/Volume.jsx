import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Grid, Slider, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	container: {
		display: 'flex',
		padding: 5,
		background: theme.palette.secondary.dark,
		transition: 'background ease-in 0.15s',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	label: {
		flexGrow: 1,
		fontSize: 18,
		lineHeight: '38px',
	},
	icon: {
		width: 45,
		textAlign: 'center',
		lineHeight: '38px',
	},
	action: {
		width: 226,
		marginRight: 12,
		display: 'flex',

		'& svg': {
			fontSize: 18,
			lineHeight: '38px',
		},
	},
	arrow: {
		fontSize: 20,
	},
	mute: {
		color: theme.palette.error.main,
	},
	unmute: {
		color: theme.palette.error.main,
	},
	actionBtn: {
		width: 30,
		height: 30,

		'&.mute': {
			marginRight: 8,
			color: theme.palette.error.main,
		},
		'&.unmute': {
			marginRight: 8,
			color: theme.palette.success.main,
		},
		'&:not(.unmute):not(.mute)': {
			marginLeft: 8,
		},
	},
}));

export default ({ UpdateSetting }) => {
	const classes = useStyles();
	const volume = useSelector(
		(state) => state.data.data.player.PhoneSettings.volume,
	);

	const [state, setState] = useState(volume);

	useEffect(() => {
		setState(volume);
	}, [volume]);

	const onVolumeChange = (e, newVal) => {
		e.preventDefault();
		setState(newVal);
	};

	const onSave = () => {
		UpdateSetting('volume', state);
	};

	const toggleMute = (e) => {
		e.preventDefault();
		if (volume === 0) UpdateSetting('volume', 100);
		else UpdateSetting('volume', 0);
	};

	return (
		<Grid item xs={12} className={classes.container}>
			<div className={classes.icon}>
				<FontAwesomeIcon icon={['fas', 'volume-high']} />
			</div>
			<div className={classes.label}>Volume</div>
			<div className={classes.action}>
				<IconButton
					onClick={toggleMute}
					className={`${classes.actionBtn} ${
						volume == 0 ? 'unmute' : 'mute'
					}`}
				>
					{volume == 0 ? (
						<FontAwesomeIcon icon={['far', 'volume']} />
					) : (
						<FontAwesomeIcon icon={['far', 'volume-xmark']} />
					)}
				</IconButton>
				<Slider
					value={state}
					onChange={onVolumeChange}
					step={1}
					min={0}
					max={100}
				/>
				<IconButton
					disabled={state == volume}
					onClick={onSave}
					className={classes.actionBtn}
				>
					<FontAwesomeIcon icon={['far', 'save']} />
				</IconButton>
			</div>
		</Grid>
	);
};

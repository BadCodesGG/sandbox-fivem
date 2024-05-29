import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Grid, Slider, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Modal } from '../../../../components';

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
		marginLeft: 8,

		'&.left': {
			marginRight: 8,
		},
		'&.right': {
			marginLeft: 8,
		},
	},
}));

export default ({ UpdateSetting }) => {
	const classes = useStyles();
	const zoom = useSelector(
		(state) => state.data.data.player.PhoneSettings.zoom,
	);

	const [state, setState] = useState(zoom);
	const [zoomInfo, setZoomInfo] = useState(false);

	useEffect(() => {
		setState(zoom);
	}, [zoom]);

	const onChange = (e, newVal) => {
		e.preventDefault();
		setState(newVal);
	};

	const onSave = () => {
		UpdateSetting('zoom', state);
	};

	return (
		<Grid item xs={12} className={classes.container}>
			<div className={classes.icon}>
				<FontAwesomeIcon icon={['fas', 'magnifying-glass']} />
			</div>
			<div className={classes.label}>Zoom</div>
			<div className={classes.action}>
				<IconButton
					onClick={() => setZoomInfo(true)}
					className={`${classes.actionBtn} left`}
				>
					<FontAwesomeIcon icon={['far', 'question']} />
				</IconButton>
				<Slider
					value={state}
					onChange={onChange}
					step={1}
					min={80}
					max={100}
				/>
				<IconButton
					disabled={state == zoom}
					onClick={onSave}
					className={`${classes.actionBtn} right`}
				>
					<FontAwesomeIcon icon={['far', 'save']} />
				</IconButton>
			</div>
			<Modal
				open={zoomInfo}
				title="Phone Zoom"
				onClose={() => setZoomInfo(false)}
			>
				<p>Zooming only works when the phone is minimized.</p>
				<p>
					Zooming may have adverse effects on some features, things
					like hover tooltips may not work correctly (or at all on
					lower zooms). <b>You've been warned</b>.
				</p>
			</Modal>
		</Grid>
	);
};

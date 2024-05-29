/* eslint-disable react/prop-types */
import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { SelectSpawn } from '../../../util/NuiEvents';
import Nui from '../../../util/Nui';

const useStyles = makeStyles((theme) => ({
	container: {
		width: 300,
		height: 50,
		padding: 5,
		lineHeight: '25px',
		display: 'flex',
		background: `${theme.palette.secondary.dark}80`,
		borderLeft: `2px solid ${theme.palette.secondary.light}`,
		transition: 'border ease-in 0.15s',
		userSelect: "none",
		'&:not(:last-of-type)': {
			marginBottom: 4,
		},
		'&.active': {
			borderColor: theme.palette.primary.main,
		},
		'&:hover': {
			borderColor: theme.palette.primary.dark,
			cursor: 'pointer',
		},
	},
	spawnIcon: {
		width: 48,
		display: 'block',
		fontSize: 18,
		padding: 5,
		paddingLeft: 0,
		textAlign: 'center',
		borderRight: `1px solid ${theme.palette.border.divider}`,
		lineHeight: '35px',
	},
	details: {
		padding: 5,
	},
	detail: {
		lineHeight: '35px',
		fontSize: 18,
	},
}));

export default ({ spawn, onPlay }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const selected = useSelector((state) => state.spawn.selected);

	const onClick = () => {
		Nui.send(SelectSpawn, { spawn });
		dispatch({
			type: 'SELECT_SPAWN',
			payload: spawn,
		});
	};

	return (
		<Fade in={true}>
			<div
				className={`${classes.container} ${
					selected?.id == spawn?.id ? 'active' : ''
				}`}
				onDoubleClick={onPlay}
				onClick={onClick}
			>
				<div className={classes.spawnIcon}>
					<FontAwesomeIcon
						icon={Boolean(spawn.icon) ? spawn.icon : 'location-dot'}
					/>
				</div>
				<div className={classes.details}>
					<div className={classes.detail}>{spawn.label}</div>
				</div>
			</div>
		</Fade>
	);
};

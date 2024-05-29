import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Menu, MenuItem, Tooltip, Chip } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	item: {
		margin: 0,
		cursor: 'pointer',
		// transition: 'background ease-in 0.15s',
		// border: `1px solid ${theme.palette.border.divider}`,
		// margin: 7.5,
		// transition: 'filter ease-in 0.15s',
		// '&:hover': {
		// 	filter: 'brightness(0.8)',
		// 	cursor: 'pointer',
		// },
	},
}));

export default ({ data, isLast, isPrimary, isTow = null }) => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);

	if (user.SID === data.character?.SID) {
		return (
			<Tooltip
				placement={isPrimary ? 'top' : 'bottom'}
				title={`${data.character.First[0]}. ${data.character.Last} (You)`}
			>
				<b className={classes.item} style={{ fontSize: isPrimary ? 18 : null }}>{`${(Boolean(isTow) && data.character) ? `${data.character.First[0]}. ${data.character.Last}` : data.primary
					} (You)`}</b>
			</Tooltip>
		);
	} else {
		return (
			<Tooltip placement={isPrimary ? 'top' : 'bottom'} title={data.character ? `${data.character?.First[0]}. ${data.character?.Last}` : "???"}>
				<span className={classes.item} style={{ fontSize: isPrimary ? 18 : null }}>{`${(Boolean(isTow) && data.character) ? `${data.character?.First[0]}. ${data.character?.Last}` : data.primary}`}</span>
			</Tooltip>
		);
	}
};

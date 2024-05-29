/* eslint-disable react/prop-types */
import React from 'react';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useDispatch } from 'react-redux';

import { STATE_CREATE } from '../../../util/States';

const useStyles = makeStyles((theme) => ({
	container: {
		height: 100,
		padding: 5,
		lineHeight: '25px',
		display: 'inline-block',
		background: `${theme.palette.secondary.dark}80`,
		borderLeft: `2px solid ${theme.palette.success.main}`,
		textAlign: 'center',
		marginRight: 15,
		'&:hover': {
			borderColor: theme.palette.success.dark,
			cursor: 'pointer',
		},
	},
	details: {
		padding: '5px 5px 5px 10px',
		fontSize: 22,
		lineHeight: '85px',

		'& svg': {
			marginRight: 8,
			color: theme.palette.success.main,
		},
	},
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const onClick = () => {
		dispatch({
			type: 'SET_STATE',
			payload: { state: STATE_CREATE },
		});
	};

	return (
		<Fade in={true}>
			<div className={classes.container} onClick={onClick}>
				<div className={classes.details}>
					<FontAwesomeIcon icon="plus-circle" />
				</div>
			</div>
		</Fade>
	);
};

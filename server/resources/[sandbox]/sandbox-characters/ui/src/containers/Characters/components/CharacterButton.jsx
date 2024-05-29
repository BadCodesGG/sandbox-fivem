/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import Moment from 'react-moment';
import {
	Fade,
	Dialog,
	DialogActions,
	DialogContent,
	DialogContentText,
	DialogTitle,
	Button,
} from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../../util/Nui';
import { SelectCharacter, DeleteCharacter } from '../../../util/NuiEvents';

const useStyles = makeStyles((theme) => ({
	container: {
		width: 300,
		height: 100,
		padding: 5,
		lineHeight: '25px',
		display: 'inline-flex',
		background: `${theme.palette.secondary.dark}80`,
		borderLeft: `2px solid ${theme.palette.secondary.light}`,
		transition: 'border ease-in 0.15s',
		userSelect: "none",
		'&:not(:last-of-type)': {
			marginRight: 4,
		},
		'&.active': {
			borderColor: theme.palette.primary.main,
		},
		'&:hover': {
			borderColor: theme.palette.primary.dark,
			cursor: 'pointer',
		},
	},
	stateId: {
		width: 48,
		display: 'block',
		fontSize: 18,
		padding: 5,
		paddingLeft: 0,
		textAlign: 'center',
		borderRight: `1px solid ${theme.palette.border.divider}`,
		lineHeight: '85px',
	},
	details: {
		padding: 5,
	},
	detail: {
		lineHeight: '24px',
		'&.name': {
			fontSize: 18,
		},
		'&.job': {
			fontSize: 14,
		},
		'&.played': {
			fontSize: 14,
			'& small': {
				fontSize: 12,
			},
		},
	},
}));

export default ({ character }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const selected = useSelector((state) => state.characters.selected);

	const [open, setOpen] = useState(false);

	const onClick = () => {
		dispatch({
			type: 'LOADING_SHOW',
			payload: { message: 'Getting Spawn Points' },
		});
		dispatch({
			type: 'SELECT_CHARACTER',
			payload: {
				character: character,
			},
		});
		Nui.send(SelectCharacter, { id: character.ID });
	};

	const onRightClick = (e) => {
		e.preventDefault();
		setOpen(true);
	};

	const onDelete = () => {
		dispatch({
			type: 'LOADING_SHOW',
			payload: { message: 'Deleting Character' },
		});
		Nui.send(DeleteCharacter, { id: character.ID });
	};

	return (
		<Fade in={true}>
			<div
				className={`${classes.container} ${
					selected?.ID == character?.ID ? 'active' : ''
				}`}
				onDoubleClick={onClick}
				onContextMenu={onRightClick}
			>
				<div className={classes.stateId}>{character.SID}</div>
				<div className={classes.details}>
					<div className={`${classes.detail} name`}>
						{character.First} {character.Last}
					</div>
					<div className={`${classes.detail} job`}>
						{!Boolean(character?.Jobs) ||
						character?.Jobs?.length == 0 ? (
							<span>Unemployed</span>
						) : character?.Jobs?.length == 1 ? (
							<span>
								{character?.Jobs[0].Workplace
									? `${character?.Jobs[0].Workplace.Name} - ${character?.Jobs[0].Grade.Name}`
									: `${character?.Jobs[0].Name} - ${character?.Jobs[0].Grade.Name}`}
							</span>
						) : (
							<span>{character?.Jobs?.length} Jobs</span>
						)}
					</div>
					<div className={`${classes.detail} played`}>
						Last Played:{' '}
						{+character.LastPlayed === -1 ? (
							<span className={classes.highlight}>Never</span>
						) : (
							<span className={classes.highlight}>
								<small>
									<Moment
										date={+character.LastPlayed}
										format="M/D/YYYY h:mm:ss A"
										withTitle
									/>
								</small>
							</span>
						)}
					</div>
				</div>
				<Dialog open={open} onClose={() => setOpen(false)}>
					<DialogTitle>{`Delete ${character.First} ${character.Last}?`}</DialogTitle>
					<DialogContent>
						<DialogContentText>
							Are you sure you want to delete {character.First}{' '}
							{character.Last}? This action is completely &
							entirely irreversible by{' '}
							<i>
								<b>anyone</b>
							</i>{' '}
							including staff. Proceed?
						</DialogContentText>
					</DialogContent>
					<DialogActions>
						<Button onClick={() => setOpen(false)} color="inherit">
							No
						</Button>
						<Button onClick={onDelete} color="primary" autoFocus>
							Yes
						</Button>
					</DialogActions>
				</Dialog>
			</div>
		</Fade>
	);
};

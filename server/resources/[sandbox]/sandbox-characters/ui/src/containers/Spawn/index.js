import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Button, ButtonGroup } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../util/Nui';
import { Motd } from '../../components';
import logo from '../../assets/imgs/logo_banner.png';

import SpawnButton from './components/SpawnButton';
import { STATE_CHARACTERS } from '../../util/States';
import { PlayCharacter } from '../../util/NuiEvents';

const useStyles = makeStyles((theme) => ({
	canvas: {
		height: '100vh',
		width: '100vw',
		position: 'relative',
	},
	logo: {
		width: 300,
		height: 169,
		position: 'absolute',
		right: 0,
		top: 0,
	},
	spawnContainer: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		margin: 'auto',
		width: 'fit-content',
		height: 'fit-content',
		gap: 4,
		maxWidth: 310,
		maxHeight: 600,
		height: '100%',
		overflow: 'auto',
	},
	spawnInfo: {
		height: 'fit-content',
		width: 300,
		position: 'absolute',
		right: 0,
		left: 0,
		bottom: 40,
		margin: 'auto',
		borderLeft: `4px solid ${theme.palette.primary.main}`,
	},
	charInfo: {
		background: `${theme.palette.secondary.dark}80`,
		padding: 10,
	},
	button: {
		borderRadius: 0,
	},
	label: {
		fontSize: 18,
	},
	data: {
		fontSize: 22,
		color: theme.palette.primary.dark,
		fontWeight: 'bold',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const motd = useSelector((state) => state.characters.motd);
	const spawns = useSelector((state) => state.spawn.spawns);
	const selected = useSelector((state) => state.spawn.selected);
	const selectedChar = useSelector((state) => state.characters.selected);

	const onSpawn = () => {
		Nui.send(PlayCharacter, {
			spawn: selected,
			character: selectedChar,
		});
		dispatch({
			type: 'LOADING_SHOW',
			payload: { message: 'Spawning' },
		});
		dispatch({
			type: 'UPDATE_PLAYED',
		});
		dispatch({ type: 'DESELECT_CHARACTER' });
		dispatch({ type: 'DESELECT_SPAWN' });
	};

	const goBack = () => {
		dispatch({ type: 'DESELECT_CHARACTER' });
		dispatch({ type: 'DESELECT_SPAWN' });
		dispatch({
			type: 'SET_STATE',
			payload: { state: STATE_CHARACTERS },
		});
	};

	return (
		<div className={classes.canvas}>
			{Boolean(motd) && <Motd message={motd} />}
			<img className={classes.logo} src={logo} />
			<div className={classes.spawnContainer}>
				{spawns.map((spawn, i) => {
					return (
						<SpawnButton key={i} spawn={spawn} onPlay={onSpawn} />
					);
				})}
			</div>
			<div className={classes.spawnInfo}>
				<div className={classes.charInfo}>
					<div className={classes.label}>Spawning As</div>
					<div className={classes.data}>
						{selectedChar.First} {selectedChar.Last}
					</div>
					<div className={classes.label}>At</div>
					{Boolean(selected) ? (
						<div className={classes.data}>{selected.label}</div>
					) : (
						<div className={classes.data}>(No Spawn Selected)</div>
					)}
				</div>
				<ButtonGroup fullWidth className={classes.buttons}>
					<Button
						fullWidth
						variant="contained"
						color="error"
						onClick={goBack}
						className={classes.button}
					>
						Cancel
					</Button>
					{Boolean(selected) && (
						<Button
							fullWidth
							variant="contained"
							color="success"
							onClick={onSpawn}
							className={classes.button}
						>
							Play
						</Button>
					)}
				</ButtonGroup>
			</div>
		</div>
	);

	return (
		<>
			<div className={classes.container}>
				<div className={classes.wrapper}>
					<div className={classes.innerWrapper}>
						<div className={classes.header}>
							<span>Select Your Spawn</span>
						</div>
						<div className={classes.body}>
							{props.spawns.map((spawn, i) => {
								return (
									<SpawnButton
										key={i}
										type="button"
										spawn={spawn}
									/>
								);
							})}
						</div>
					</div>
				</div>
			</div>
			<div className={classes.actions}>
				<ButtonGroup>
					<Button onClick={goBack} className={classes.negative}>
						Cancel
					</Button>
					{Boolean(props.selected) && (
						<Button onClick={onSpawn} className={classes.positive}>
							Play
						</Button>
					)}
				</ButtonGroup>
			</div>
		</>
	);
};

import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import { Motd } from '../../components';
import logo from '../../assets/imgs/logo_banner.png';

import CharacterButton from './components/CharacterButton';
import Help from './components/Help';
import CreateCharacter from './components/CreateCharacter';

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
	charContainer: {
		position: 'absolute',
		bottom: 100,
		left: 0,
		right: 0,
		margin: 'auto',
		width: 'fit-content',
		height: 'fit-content',
		gap: 4,
		maxWidth: '95.3vw',
		height: 101,
		overflow: 'auto',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: `${theme.palette.primary.main}80`,
			transition: 'background ease-in 0.15s',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: `${theme.palette.primary.dark}80`,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
}));

export default (props) => {
	const classes = useStyles();

	const characters = useSelector((state) => state.characters.characters);
	const characterLimit = useSelector(
		(state) => state.characters.characterLimit,
	);
	const motd = useSelector((state) => state.characters.motd);

	return (
		<div className={classes.canvas}>
			{Boolean(motd) && <Motd message={motd} />}
			<Help />
			<img className={classes.logo} src={logo} />
			<div className={classes.charContainer}>
				{characters.length < characterLimit && <CreateCharacter />}
				{characters.length > 0 &&
					characters.map((char, i) => {
						return (
							<CharacterButton key={i} id={i} character={char} />
						);
					})}
			</div>
		</div>
	);
};

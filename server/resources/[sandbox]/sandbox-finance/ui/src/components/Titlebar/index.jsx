import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { AppBar, Toolbar, IconButton, Divider, Fade } from '@mui/material';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Fleeca from '../../assets/img/fleeca.png';
import Maze from '../../assets/img/maze.png';
import BlaineCo from '../../assets/img/blaineco.png';
import UnionDepo from '../../assets/img/ud.png';

import Nui from '../../util/Nui';
import { CurrencyFormat } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
	container: {
		height: 100,
		width: '100%',
		borderLeft: `4px solid ${theme.palette.primary.main}`,
		display: 'flex',
		background: `${theme.palette.secondary.dark}`,
		color: theme.palette.text.main,
		zIndex: 100,
		marginBottom: 8,
	},
	branding: {
		flex: 1,
		position: 'relative',
	},
	bankLogo: {
		width: 200,
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	cash: {
		fontSize: 18,
		lineHeight: '100px',
		marginRight: 10,

		'& .currency': {
			color: theme.palette.success.main,
		},
	},
	close: {
		fontSize: 16,
		padding: 5,
		paddingLeft: 15,
		lineHeight: '90px',
		marginRight: 10,
		borderLeft: `2px solid ${theme.palette.border.divider}`,
	},
}));

export default ({ onCreate, onAnimEnd }) => {
	const classes = useStyles();
	const brand = useSelector((state) => state.app.brand);
	const app = useSelector((state) => state.app.app);
	const user = useSelector((state) => state.data.data.character);

	const getBranding = () => {
		switch (brand) {
			case 'fleeca':
				return Fleeca;
			case 'maze':
				return Maze;
			case 'blaineco':
				return BlaineCo;
			case 'ud':
				return UnionDepo;
			default:
				return Fleeca;
		}
	};

	const onClose = () => {
		Nui.send('Close');
	};

	return (
		<Fade in={true} onEntered={onAnimEnd}>
			<div className={classes.container}>
				<div className={classes.branding}>
					<img src={getBranding()} className={classes.bankLogo} />
				</div>
				<div className={classes.cash}>
					Your Cash:{' '}
					<span className="currency">
						{CurrencyFormat.format(user.Cash)}
					</span>
				</div>
				{app == 'BANK' && (
					<div className={classes.close}>
						<IconButton onClick={Boolean(onCreate) && onCreate}>
							<FontAwesomeIcon icon="plus-circle" />
						</IconButton>
					</div>
				)}
				<div className={classes.close}>
					<IconButton onClick={onClose}>
						<FontAwesomeIcon icon="x" />
					</IconButton>
				</div>
			</div>
		</Fade>
	);
};

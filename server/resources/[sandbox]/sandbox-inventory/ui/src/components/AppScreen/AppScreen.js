import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	outsideDiv: {
		width: '100vw',
		height: '100vh',
		display: 'flex',
		justifyContent: 'center',
		alignItems: 'center',
		zIndex: -1,
		background: 'rgba(0,0,0,0.75)',
	},
	insideDiv: {
		width: '90%',
		height: '60vh',
	},
	dialog: {
		display: 'flex',
		flexDirection: 'column',
		margin: 'auto',
		width: 'fit-content',
		zIndex: -1,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const hoverOrigin = useSelector((state) => state.inventory.hoverOrigin);

	const onClick = () => {
		if (Boolean(hoverOrigin)) {
			Nui.send('FrontEndSound', 'DISABLED');
			dispatch({
				type: 'SET_HOVER',
				payload: null,
			});
			dispatch({
				type: 'SET_HOVER_ORIGIN',
				payload: null,
			});
		}
	};

	return (
		<>
			{!props.hidden && itemsLoaded && (
				<div className={classes.outsideDiv} onClick={onClick}>
					<div className={classes.insideDiv}>{props.children}</div>
				</div>
			)}
		</>
	);
};

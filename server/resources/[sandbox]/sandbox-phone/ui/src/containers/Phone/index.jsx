import React, { useState, memo, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router';
import Draggable, { DraggableCore } from 'react-draggable';

import PhoneContents from './PhoneContents';

export default memo((props) => {
	const history = useNavigate();
	const dispatch = useDispatch();
	const locked = useSelector((state) => state.phone.locked);
	const position = useSelector((state) => state.phone.position);
	const visible = useSelector((state) => state.phone.visible);
	const phonePos = useSelector(
		(state) => state.data.data.player.PhonePosition,
	);
	const zoom = useSelector(
		(state) => state.data.data.player.PhoneSettings?.zoom,
	);

	const clear = useSelector((state) => state.phone.clear);
	useEffect(() => {
		if (clear) {
			setTimeout(() => {
				history('/', { replace: true });
				dispatch({ type: 'CLEARED_HISTORY' });
			}, 2000);
		}
	}, [clear]);

	const useStyles = makeStyles((theme) => ({
		outer: {
			height: '100vh',
			width: '100vw',
			position: 'absolute',
			top: 0,
			bottom: 0,
			left: 0,
			right: 0,
			margin: 'auto',
			overflow: 'hidden',
		},

		wrapper: {
			height: `calc(1000px * ${zoom / 100})`,
			width: `calc(500px * ${zoom / 100})`,
			overflow: 'hidden',
		},
	}));
	const classes = useStyles();

	const [pos, setPos] = useState({ ...(phonePos ?? position) });

	useEffect(() => {
		setPos({ ...phonePos });
	}, [phonePos]);

	const onChange = (e, p) => {
		e.preventDefault();
		e.stopPropagation();
		setPos({ x: p.x, y: p.y });
		dispatch({
			type: 'SET_POSITION',
			payload: {
				x: p.x,
				y: p.y,
			},
		});
	};

	return (
		<Slide direction="up" in={visible}>
			<div className={classes.outer} id="outer">
				<Draggable
					handle=".drag-handle"
					bounds="#outer"
					defaultPosition={{ ...position }}
					position={pos}
					onDrag={onChange}
				>
					<div
						className={`${classes.wrapper} ${
							locked ? '' : 'drag-handle'
						}`}
					>
						{<PhoneContents />}
					</div>
				</Draggable>
			</div>
		</Slide>
	);
});

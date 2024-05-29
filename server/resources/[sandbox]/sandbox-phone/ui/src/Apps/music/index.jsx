import React, { useEffect, useState, createRef  } from 'react';
import { AppContainer } from '../../components';
import { useDispatch } from 'react-redux';

export default (props) => {
	const dispatch = useDispatch();

	function showApp(){
		dispatch({
			type: 'MUSIC_APP_OPEN',
			payload: {
				show: true
			},
		});
	}

	return (
		<AppContainer appId="music">
			{showApp()}
		</AppContainer>
	);
};

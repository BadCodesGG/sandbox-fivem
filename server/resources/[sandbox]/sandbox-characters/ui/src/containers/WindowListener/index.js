import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';

export default ({ children }) => {
	const dispatch = useDispatch();

	const handleEvent = (event) => {
		if (!event.isTrusted) {
			console.log('Untrusted Event Bruv');
			return;
		}

		const { type, data } = event.data;
		if (type != null) dispatch({ type, payload: { ...data } });
	};

	useEffect(() => {
		window.addEventListener('message', handleEvent);

		// returned function will be called on component unmount
		return () => {
			window.removeEventListener('message', handleEvent);
		};
	}, []);

	return React.Children.only(children);
};

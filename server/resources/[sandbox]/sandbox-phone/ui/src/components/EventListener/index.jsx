import React, { useEffect } from 'react';

export default ({ children, event, onEvent, state }) => {
	const handleEvent = (e) => {
		if (!e.isTrusted) {
			console.log('Untrusted Event Bruv');
			return;
		}

		const { type, data } = e.data;
		if (type == event) onEvent({ ...data });
	};

	useEffect(() => {
		window.addEventListener('message', handleEvent);

		// returned function will be called on component unmount
		return () => {
			window.removeEventListener('message', handleEvent);
		};
	}, [state]);

	return React.Children.only(children);
};

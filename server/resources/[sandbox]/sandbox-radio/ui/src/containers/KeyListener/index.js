import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import Nui from '../../util/Nui';

const KeyListener = props => {
	const handleEvent = event => {
		const { dispatch } = props;
		if (event.keyCode === 127 || event.keyCode === 27) {
			Nui.send('Close');
		}
	};

	useEffect(() => {
		window.addEventListener('keydown', handleEvent);

		return () => {
			window.removeEventListener('keydown', handleEvent);
		};
	}, []);

	return React.Children.only(props.children);
};

KeyListener.propTypes = {
	dispatch: PropTypes.func.isRequired,
	children: PropTypes.element.isRequired,
};

export default connect(null, null)(KeyListener);

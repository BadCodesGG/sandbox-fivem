import '@babel/polyfill';
import React from 'react';
import ReactDOM from 'react-dom';
import { createRoot } from 'react-dom/client';
import { Provider } from 'react-redux';

import App from 'containers/App';

import WindowListener from 'containers/WindowListener';

import configureStore from './configureStore';

const initialState = {};
const store = configureStore(initialState);

const MOUNT_NODE = document.getElementById('app');
const root = createRoot(MOUNT_NODE); // createRoot(container!) if you use TypeScript

const render = () => {
	root.render(
		<Provider store={store}>
			<WindowListener>
				<App />
			</WindowListener>
		</Provider>,
	);
};

if (module.hot) {
	module.hot.accept(['./containers/App'], () => {
		ReactDOM.unmountComponentAtNode(MOUNT_NODE);
		render();
	});
}

render();

import React from 'react';
import { Button } from '@mui/material';
import Nui from '../../util/Nui';

export class ErrorBoundary extends React.Component {
	constructor(props) {
		super(props);
		this.props = props;
		this.state = { hasError: false };
	}

	static onClose() {
		Nui.send('Crashed');
	}

	static getDerivedStateFromError(error) {
		return { hasError: true };
	}

	componentDidCatch(error, errorInfo) {
		console.error('Phone Caught Error', error, errorInfo);
	}

	componentDidUpdate(previousProps, previousState) {
		if (previousProps.children !== this.props.children)
			this.setState({ hasError: false });
	}

	render() {
		if (this.state.hasError) {
			return (
				<div
					style={{
						width: '100vw',
						height: '100vh',
						background: '#00000080',
					}}
				>
					<div
						style={{
							width: 'fit-content',
							height: 'fit-content',
							position: 'absolute',
							top: 0,
							bottom: 0,
							left: 0,
							right: 0,
							margin: 'auto',
							textAlign: 'center',
						}}
					>
						<h1>Inventory Crashed</h1>
						<h1>😟</h1>
						<h3>
							Try closing & re-opening it, if it continues to
							crash please make a support ticket.
						</h3>
						<Button fullWidth color="primary" variant="contained">
							Close Inventory
						</Button>
					</div>
				</div>
			);
		}

		return this.props.children;
	}
}

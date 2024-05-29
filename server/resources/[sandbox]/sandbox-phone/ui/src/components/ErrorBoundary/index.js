import React from 'react';

export class ErrorBoundary extends React.Component {
	constructor(props) {
		super(props);
		this.props = props;
		this.state = { hasError: false };
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
						display: 'flex',
						overflow: 'hidden',
						margin: 'auto',
						background: '#1e1e1e',
						height: '99%',
						width: '97%',
						position: 'absolute',
						left: 4,
						bottom: 0,
						borderRadius: 35,
					}}
				>
					<div
						style={{
							height: 'fit-content',
							width: '60%',
							fontSize: 18,
							fontWeight: 'bold',
							position: 'absolute',
							top: 0,
							bottom: 0,
							left: 0,
							right: 0,
							margin: 'auto',
							textAlign: 'center',
						}}
					>
						<h1>Phone Crashed</h1>
						<h1>😟</h1>
						<h3>
							Try Reopening it, if it continues to crash make a
							support ticket.
						</h3>
					</div>
				</div>
			);
		}

		return this.props.children;
	}
}

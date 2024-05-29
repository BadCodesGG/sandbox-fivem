import React from 'react';
import { makeStyles } from '@mui/styles';
import { Route, Routes } from 'react-router';

import links from './links';
import { Navbar, ErrorBoundary } from '../../components';
import Titlebar from '../../components/Titlebar';

import Error from '../../pages/Error';
import PrisonersPublic from '../../pages/PrisonersPublic';

const useStyles = makeStyles((theme) => ({
	container: {
		height: '100%',
	},
	wrapper: {
		maxHeight: 'calc(100% - 193px)',
		flexGrow: 1,
	},
	content: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	maxHeight: {
		height: '100%',
	},
	mdt: {
		display: 'flex',
		flexDirection: 'column',
		height: '100%',
	}
}));

export default () => {
	const classes = useStyles();

	return (
		<div className={classes.container}>
			<div className={classes.mdt}>
				<div>
					<Titlebar>
						<Navbar links={links("public-prison")} />
					</Titlebar>
				</div>
				<div className={classes.wrapper}>
					<ErrorBoundary>
						<div className={classes.content}>
							<Routes>
								<Route exact path="/" element={<PrisonersPublic />} />
								<Route element={<Error />} />
							</Routes>
						</div>
					</ErrorBoundary>
				</div>
			</div>
		</div>
	);
};

import React from 'react';
import { makeStyles } from '@mui/styles';
import { Route, Routes } from 'react-router';

import links from './links';
import { Navbar, ErrorBoundary } from '../../components';
import Titlebar from '../../components/Titlebar';

import { Landing } from '../../pages/Public';
import Error from '../../pages/Error';
import PenalCode from '../../pages/PenalCode';
import Warrants from '../../pages/Warrants';
import Library from '../../pages/Library';

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
						<Navbar links={links("public")} />
					</Titlebar>
				</div>
				<div className={classes.wrapper}>
					<ErrorBoundary>
						<div className={classes.content}>
							<Routes>
								<Route exact path="/warrants" element={<Warrants />} />
								<Route exact path="/penal-code" element={<PenalCode />} />
								<Route exact path="/library" element={<Library />} />

								<Route exact path="/" element={<Landing />} />
								<Route element={<Error />} />
							</Routes>
						</div>
					</ErrorBoundary>
				</div>
			</div>
		</div>
	);
};

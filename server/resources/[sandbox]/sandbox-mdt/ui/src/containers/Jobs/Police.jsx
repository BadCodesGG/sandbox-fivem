import React from 'react';
import { useSelector } from 'react-redux';
import { Grid, Alert } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Route, Routes } from 'react-router';

import links from './links';
import { Navbar, AdminRoute, ErrorBoundary } from '../../components';

import Error from '../../pages/Error';
import Reports from '../../pages/Reports';
import Roster from '../../pages/Roster';
import People from '../../pages/People';
import PenalCode from '../../pages/PenalCode';
import Vehicles from '../../pages/Vehicles';
import Properties from '../../pages/Properties';
import PermissionManager from '../../pages/PermissionManager';
import Firearms from '../../pages/Firearms';
import Warrants from '../../pages/Warrants';
import FleetManager from '../../pages/FleetManager';
import Library from '../../pages/Library';
import { Dashboard, CreateBOLO } from '../../pages/Police';
import { AdminCharges, AdminNotice } from '../../pages/Admin';

import Titlebar from '../../components/Titlebar';

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
	noCallsign: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	mdt: {
		display: 'flex',
		flexDirection: 'column',
		height: '100%',
	}
}));

export default () => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);
	const job = useSelector((state) => state.app.govJob);

	return (
		<div className={classes.container}>
			{!user.Callsign ? (
				<Alert variant="filled" severity="error" className={classes.noCallsign}>
					<p>
						Your callsign has not yet been assigned, in order to access the Electronic Records System you
						will need to have a callsign.
					</p>
					<p>If you're not sure why you're seeing this message, contact a superior.</p>
				</Alert>
			) : (
				<div className={classes.mdt}>
					<div>
						<Titlebar>
							<Navbar links={links(job?.Id)} />
						</Titlebar>
					</div>
					<div className={classes.wrapper}>
						<ErrorBoundary>
							<div className={classes.content}>
								<Routes>
									<Route exact path="/reports" element={<Reports />} />
									<Route exact path="/people" element={<People />} />
									<Route exact path="/vehicles" element={<Vehicles />} />
									<Route exact path="/properties" element={<Properties />} />
									<Route exact path="/firearms" element={<Firearms />} />
									<Route exact path="/warrants" element={<Warrants />} />
									<Route exact path="/roster" element={<Roster />} />
									<Route exact path="/penal-code" element={<PenalCode />} />
									<Route exact path="/library" element={<Library />} />
									<Route exact path="create/bolo" element={<CreateBOLO />} />
									<Route exact path="fleet-manager" element={<FleetManager job="police" />} />

									<Route exact path="create/notice" element={<AdminNotice />} />
									<Route path="/admin" element={<AdminRoute permission={'PD_HIGH_COMMAND'} />}>
										<Route exact path="permissions" element={<PermissionManager job="police" />} />
									</Route>
									<Route exact path="/" element={<Dashboard />} />
									<Route element={<Error />} />
									<Route path="/system" element={<AdminRoute permission={true} />}>
										<Route exact path="charges" element={<AdminCharges />} />
										<Route exact path="gov-roster" element={<Roster systemAdminMode />} />
										<Route
											exact
											path="gov-permissions"
											element={<PermissionManager job="system" />}
										/>
									</Route>
								</Routes>
							</div>
						</ErrorBoundary>
					</div>
				</div>
			)}
		</div>
	);
};

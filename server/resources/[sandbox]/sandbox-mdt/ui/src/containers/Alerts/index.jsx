import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { makeStyles } from '@mui/styles';

import { usePermissions } from '../../hooks';
import Notifications from './Notifications';
import Roster from './Roster';
import Dispatch from './Dispatch';
import { ErrorBoundary } from '../../components';

export default () => {
	const showing = useSelector((state) => state.alerts.showing);
	const job = useSelector((state) => state.app.govJob);
	const connected = useSelector((state) => state.alerts.socketConnected);

	const dispatch = useDispatch();
	const useStyles = makeStyles((theme) => ({
		container: {
			height: '100%',
			width: '100%',
			maxWidth: 1000,
			position: 'fixed',
			top: 0,
			bottom: 0,
			right: 0,
			paddingTop: 20,
			margin: 'auto',
			zIndex: showing ? 1 : -1,
		},
	}));

	useEffect(() => {
		if (process.env.NODE_ENV != 'production') {
			dispatch({
				type: 'ALERTS_WS_CONNECT',
				payload: {
					url: 'http://localhost:4002/mdt-alerts',
					token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lc3BhY2UiOiJtZHQtYWxlcnRzIiwic291cmNlIjo5OSwiam9iIjoicG9saWNlIiwiY2FsbHNpZ24iOiIxMDEiLCJkZXZlbG9wbWVudCI6dHJ1ZSwiaWF0IjoxNjk0OTU0Mjg2fQ.a7oKjM2QTpi-dh_3Ay8fhM-vymTSJQKU_PpA6UTcmVA',
				}
			});
		}
	}, []);

	const classes = useStyles();
	const hasPerm = usePermissions();

	if (!hasPerm('police_alerts') && !hasPerm('ems_alerts') && !hasPerm('tow_alerts') && !hasPerm('doc_alerts')) return null;
	if (!connected) return null;

	return (
		<>
			<div className={classes.container}>
				<Notifications />
				<ErrorBoundary>{showing && <Roster />}</ErrorBoundary>
			</div>
			{showing && job.Id !== "tow" && <Dispatch />}
		</>
	);
};

import React, { useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import Alert from './components/Alert';
import { ErrorBoundary } from '../../components';

export default () => {
	const dispatch = useDispatch();
	const alerts = useSelector((state) => state.alerts.alerts);
	const showing = useSelector((state) => state.alerts.showing);

	const visibleOffsetRef = useRef(null);
	const [visibleAlerts, setVisibleAlerts] = useState(Array());
	const [visibleOffset, setVisibleOffset] = useState(1);

	const units = useSelector((state) => state.alerts.units);
	const myUnit = useSelector((state) => state.alerts.myUnit);
	const myUnitData = units?.[myUnit?.job]?.find(u => u.primary === myUnit?.primary);
	const myCallsign = myUnitData?.operatingUnder !== null ? myUnitData?.operatingUnder : myUnitData?.primary

	const useStyles = makeStyles((theme) => ({
		container: {
			height: showing ? '45%' : '100%',
			maxWidth: 650,
			marginLeft: 'auto',
			overflowY: 'auto',
			overflowX: 'hidden',
		},
	}));
	const classes = useStyles();

	const onReset = () => {
		dispatch({
			type: 'RESET_ALERTS',
		});
	};

	const containerRef = useRef(null);

	useEffect(() => {
		const handler = containerRef.current.addEventListener("scrollend", (e) => {
			if (e.target.id === "alertsScrollContainer") {
				const percentage = (e.target.scrollTop / (e.target.scrollHeight - e.target.clientHeight)) * 100;
				if (percentage < 5) {
					setVisibleOffset(1);
				}
			}
		});

		return () => {
			removeEventListener("scrollend", handler);
		}
	}, []);

	useEffect(() => {
		setVisibleAlerts(
			alerts
				.filter((a) => (!a.attached?.includes(myCallsign) && (Date.now() - a.time) > 300000))
				.sort((a, b) => b.time - a.time)
				.filter((a, index) => index <= visibleOffset * 10)
		)

		visibleOffsetRef.current = visibleOffset;
	}, [alerts, visibleOffset]);

	return (
		<div className={classes.container} ref={containerRef} id="alertsScrollContainer" onScroll={(e) => {
			const percentage = (e.target.scrollTop / (e.target.scrollHeight - e.target.clientHeight)) * 100;
			if (percentage > 80 && alerts.length > (visibleOffset * 10)) {
				setVisibleOffset(visibleOffset + 1)
			}
		}}>
			{Boolean(alerts) && <ErrorBoundary mini onRefresh={onReset}>
				{/* Calls that we are attached to */}
				{alerts
					.filter((a) => (showing && a.attached.includes(myCallsign)))
					.sort((a, b) => b.time - a.time)
					.map((alert, k) => {
						return <Alert key={`em-alert-${alert.id}`} alert={alert} />;
					})}

				{/* Recent Calls as they come in */}
				{alerts
					.filter((a) => ((a.onScreen || showing) && !a.attached?.includes(myCallsign) && (Date.now() - a.time) <= 300000))
					.sort((a, b) => b.time - a.time)
					.map((alert, k) => {
						return <Alert key={`em-alert-${alert.id}`} alert={alert} />;
					})}
				{showing && visibleAlerts.map((alert, k) => {
					return <Alert key={`em-alert-${alert.id}`} alert={alert} />;
				})}
			</ErrorBoundary>}
		</div>
	);
};

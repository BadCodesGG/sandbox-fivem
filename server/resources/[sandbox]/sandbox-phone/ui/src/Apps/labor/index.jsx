import React, { useState, useEffect, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';

import Nui from '../../util/Nui';
import { Tabs, Tab } from '../../components';
import { useAppData, useMyStates } from '../../hooks';
import Jobs from './Jobs';
import Groups from './Groups';
import Reputations from './Reputations';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '93%',
	},
	tabPanel: {
		height: '100%',
	},
	phoneTab: {
		minWidth: '25%',
	},
}));

export default () => {
	const appData = useAppData('labor');
	const classes = useStyles();
	const dispatch = useDispatch();
	const hasState = useMyStates();
	const player = useSelector((state) => state.data.data.player);
	const activeTab = useSelector((state) => state.labor.tab);

	const handleTabChange = (_, tab) => {
		dispatch({
			type: 'SET_LABOR_TAB',
			payload: { tab: tab },
		});
	};

	const [loading, setLoading] = useState(false);
	const [jobs, setJobs] = useState(null);
	const [filtered, setFiltered] = useState(null);
	const [groups, setGroups] = useState(null);
	const [myGroup, setMyGroup] = useState(null);
	const [myReputations, setMyReputations] = useState(null);

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('GetLaborDetails')).json();
					if (res) {
						setJobs(res.jobs);
						setGroups(res.groups);
						setMyReputations(res.reputations);
					} else {
						setJobs(Array());
						setGroups(Array());
						setMyReputations(Array());
					}
				} catch (err) {
					console.error(err);
					// setJobs(Object());
					// setGroups(Array());
					// setMyReputations(Array());
					setJobs({
						Mining: {
							Id: 'Mining',
							Name: 'Mining',
							Salary: 100000,
							Limit: 10,
							OnDuty: Array(),
						},
						Salvaging: {
							Id: 'Salvaging',
							Name: 'Salvaging',
							Salary: 100000,
							Limit: 10,
							OnDuty: Array(),
						},
						Chopping: {
							Id: 'Chopping',
							Name: 'Chopping',
							Salary: 100000,
							Limit: false,
							OnDuty: Array(),
							Restricted: {
								state: 'ACCESS_LSUNDERGROUND',
							},
						},
					});
					setGroups([
						{
							Creator: {
								ID: 2,
								First: 'Test',
								Last: 'Test',
							},
							Members: [
								{
									ID: 1,
									First: 'Test',
									Last: 'Test',
								},
								{
									ID: 3,
									First: 'Test',
									Last: 'Test',
								},
								{
									ID: 4,
									First: 'Test',
									Last: 'Test',
								},
							],
							Working: false,
						},
						{
							Creator: {
								ID: 5,
								First: 'Test',
								Last: 'Test',
							},
							Members: [
								{
									ID: 6,
									First: 'Test',
									Last: 'Test',
								},
								{
									ID: 7,
									First: 'Test',
									Last: 'Test',
								},
							],
							Working: true,
						},
					]);
					setMyReputations([
						{
							id: 'mining',
							label: 'Mining',
							value: 500,
							next: {
								label: 'Rank 1',
								value: 500,
							},
						},
						{
							id: 'Salvaging',
							label: 'Salvaging',
							value: 500,
							next: {
								label: 'Rank 1',
								value: 500,
							},
						},
					]);
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	useEffect(() => {
		if (!Boolean(groups)) return;
		setMyGroup(
			groups.filter(
				(wg) =>
					wg?.Creator?.ID == player.Source ||
					(Boolean(wg?.Members) &&
						wg?.Members.filter((m) => m.ID == player.Source)
							.length > 0),
			)[0],
		);
	}, [groups]);

	useEffect(() => {
		if (!Boolean(jobs) || !Boolean(player) || loading) return;
		setFiltered(
			Object.keys(jobs)
				.filter(
					(k) =>
						!jobs[k].Restricted ||
						(Boolean(jobs[k].Restricted) &&
							Boolean(jobs[k].Restricted?.state) &&
							hasState(jobs[k].Restricted.state)),
				)
				.reduce((obj, key) => {
					obj[key] = jobs[key];
					return obj;
				}, {}),
		);
	}, [jobs, player, loading]);

	return (
		<div className={classes.wrapper}>
			<div className={classes.content}>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 0}
					id="jobs"
				>
					{activeTab === 0 && (
						<Jobs
							jobs={filtered}
							groups={groups}
							myGroup={myGroup}
							loading={loading}
							onRefresh={fetch}
						/>
					)}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 1}
					id="groups"
				>
					{activeTab === 1 && (
						<Groups
							groups={groups}
							myGroup={myGroup}
							loading={loading}
							onRefresh={fetch}
						/>
					)}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 2}
					id="groups"
				>
					{activeTab === 2 && (
						<Reputations
							myReputations={myReputations}
							loading={loading}
							onRefresh={fetch}
						/>
					)}
				</div>
			</div>
			<div className={classes.tabs}>
				<Tabs
					value={activeTab}
					onChange={handleTabChange}
					app={appData}
					textColor="inherit"
					variant="fullWidth"
					scrollButtons={false}
				>
					<Tab
						app={appData}
						className={classes.phoneTab}
						label="Jobs"
					/>
					<Tab
						app={appData}
						className={classes.phoneTab}
						label="Groups"
					/>
					<Tab
						app={appData}
						className={classes.phoneTab}
						label="Reputation"
					/>
				</Tabs>
			</div>
		</div>
	);
};

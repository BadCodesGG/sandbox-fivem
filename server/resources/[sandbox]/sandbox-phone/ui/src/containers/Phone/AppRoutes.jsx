import React, { memo } from 'react';
import { Route, Routes } from 'react-router';
import Loadable from 'react-loadable';
import { useSelector } from 'react-redux';

import { AppLoader, Home, List, Notifications } from '../../components';
import { useMyApps } from '../../hooks';
import MusicPlayer from '../Music';

export default memo(({ apps }) => {
	const limited = useSelector((state) => state.phone.limited);

	const musicShow = useSelector((state) => state.music.show);

	const DynamicLoad = (app, subapp) => {
		const LoadableSubComponent = Loadable({
			loader: () =>
				import(`../../Apps/${app}/${subapp != null ? subapp.app : ''}`),
			delay: 300, // 0.3 seconds
			loading: () => {
				return <AppLoader app={apps[app]} />;
			},
		});
		LoadableSubComponent.preload(); // Hopefully load the shit? idk lol
		return <LoadableSubComponent />;
	};

	if (limited) {
		return (
			<Routes>
				<Route
					exact
					path={`/apps/phone/call/:number?`}
					element={DynamicLoad('phone', { app: 'call' })}
				/>
				<Route path={`/`} element={DynamicLoad('phone')} />
			</Routes>
		);
	} else {
		return (
			<>
				<MusicPlayer show={musicShow}/>
				<Routes>
					{Boolean(apps) && Object.keys(apps).length > 0
						? Object.keys(apps)
								.filter((app, i) => app !== 'home' || app !== 'music')
								.map((app, i) => {
									let routes = [];

									let appData = apps[app];

									if (Boolean(app) && Boolean(appData)) {
										routes.push(
											<Route
												key={i}
												exact
												path={`/apps/${app}/${appData.params}`}
												element={DynamicLoad(app)}
											/>,
										);

										if (appData.internal != null) {
											{
												appData.internal.map(
													(subapp, k) => {
														routes.push(
															<Route
																key={
																	Object.keys(
																		apps,
																	).length + k
																}
																exact
																path={`/apps/${app}/${
																	subapp.app
																}/${
																	subapp.params !=
																	null
																		? subapp.params
																		: ''
																}`}
																element={DynamicLoad(
																	app,
																	subapp,
																)}
															/>,
														);
													},
												);
											}
										}
									}

									return routes;
								})
						: null}
					<Route exact path="/apps" element={<List />} />
					<Route exact path="/" element={<Home />} />
				</Routes>
			</>
		);
	}
});

import React, { useEffect, useState, useMemo } from 'react';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';

import ChopList from './ChopList';
import Reputations from './Reputations';
import { AppContainer, Tabs, Tab } from '../../components';
import { useAppData } from '../../hooks';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	inner: {
		height: '99%',
		display: 'flex',
		flexDirection: 'column',
	},
	content: {
		flexGrow: 1,
		overflow: 'hidden',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	tabPanel: {
		top: 0,
		height: '97.5%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	},
	phoneTab: {
		minWidth: '50%',
	},
}));

export default (props) => {
	const appData = useAppData('chopper');
	const classes = useStyles(appData);

	const [loading, setLoading] = useState(false);
	const [tab, setTab] = useState(0);

	const [banned, setBanned] = useState(false);
	const [chops, setChops] = useState(Array());
	const [reps, setReps] = useState(Array());

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (
						await Nui.send('GetChopperDetails')
					).json();
					if (res) {
						setBanned(res.banned ?? false);
						setChops(res.chopList ?? Array());
						setReps(res.reputations ?? Array());
					} else {
						setChops(Array());
						setReps(Array());
					}
				} catch (err) {
					console.log(err);
					setChops(Array());
					setReps(Array());
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	const handleTabChange = (event, tab) => {
		setTab(tab);
	};

	return (
		<AppContainer appId="chopper">
			{banned ? (
				<div className={classes.emptyMsg}>Banned</div>
			) : (
				<div className={classes.inner}>
					<div className={classes.content}>
						<div
							className={classes.tabPanel}
							role="tabpanel"
							hidden={tab !== 0}
							id="latest"
						>
							{tab === 0 && <ChopList chopList={chops} />}
						</div>
						<div
							className={classes.tabPanel}
							role="tabpanel"
							hidden={tab !== 1}
							id="categories"
						>
							{tab === 1 && <Reputations myReputations={reps} />}
						</div>
					</div>
					<div className={classes.tabs}>
						<Tabs
							app={appData}
							value={tab}
							onChange={handleTabChange}
							scrollButtons={false}
							textColor="inherit"
							variant="fullWidth"
						>
							<Tab
								app={appData}
								className={classes.phoneTab}
								icon={
									<FontAwesomeIcon
										icon={['fas', 'screwdriver-wrench']}
									/>
								}
							/>
							<Tab
								app={appData}
								className={classes.phoneTab}
								icon={
									<FontAwesomeIcon
										icon={['fas', 'list-timeline']}
									/>
								}
							/>
						</Tabs>
					</div>
				</div>
			)}
		</AppContainer>
	);
};

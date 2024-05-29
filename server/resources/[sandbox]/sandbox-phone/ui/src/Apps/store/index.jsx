import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import { useAppData } from '../../hooks';
import { AppContainer, Tabs, Tab } from '../../components';
import MyList from './MyList';
import StoreList from './StoreList';

const useStyles = makeStyles((theme) => ({
	content: {
		height: '92%',
		padding: '10px 5px 10px 10px',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	tabPanel: {
		height: '99%',
	},
	phoneTab: {
		minWidth: '33.3%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const appData = useAppData('store');
	const activeTab = useSelector((state) => state.store.tab);

	const handleTabChange = (event, tab) => {
		dispatch({
			type: 'SET_STORE_TAB',
			payload: { tab: tab },
		});
	};

	return (
		<AppContainer appId="store">
			<div className={classes.content}>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 0}
					id="recent"
				>
					{activeTab === 0 && <StoreList />}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 1}
					id="keypad"
				>
					{activeTab === 1 && <MyList />}
				</div>
			</div>
			<div className={classes.tabs}>
				<Tabs
					value={activeTab}
					onChange={handleTabChange}
					app={appData}
					textColor="inherited"
					variant="fullWidth"
					scrollButtons={false}
				>
					<Tab
						className={classes.phoneTab}
						app={appData}
						label="Store"
					/>
					<Tab
						className={classes.phoneTab}
						app={appData}
						label="Installed"
					/>
				</Tabs>
			</div>
		</AppContainer>
	);
};

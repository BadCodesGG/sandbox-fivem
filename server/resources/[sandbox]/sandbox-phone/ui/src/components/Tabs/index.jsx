import React from 'react';
import { Tabs } from '@mui/material';
import { withStyles } from '@mui/styles';

const SBTabs = withStyles((theme) => ({
	root: {
		borderBottom: ({ app }) => `1px solid #${app.color}`,
	},
	indicator: {
		backgroundColor: ({ app }) => app.color,
	},
}))(Tabs);

export default SBTabs;

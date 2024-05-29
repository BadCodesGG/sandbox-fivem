import React from 'react';
import { Tab } from '@mui/material';
import { withStyles } from '@mui/styles';

const SBTab = withStyles((theme) => ({
	root: {
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: ({ app }) => app.color,
		},
		'&:selected': {
			color: ({ app }) => app.color,
		},
		'&:focus': {
			color: ({ app }) => app.color,
		},
	},
	selected: {
		color: ({ app }) => app.color,
	},
}))(Tab);

export default SBTab;

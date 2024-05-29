import React, { Fragment } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/pro-solid-svg-icons';
import { far } from '@fortawesome/pro-regular-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import {
	CssBaseline,
	ThemeProvider,
	createTheme,
	StyledEngineProvider,
	Fade,
} from '@mui/material';

import AppScreen from '../../components/AppScreen/AppScreen';
import Inventory from '../../components/Inventory/Inventory';
import HoverSlot from '../../components/Inventory/HoverSlot';
import Hotbar from '../../components/Inventory/Hotbar';
import ChangeAlerts from '../../components/Changes';
import StaticTooltip from '../../components/Inventory/StaticTooltip';
import { ErrorBoundary } from '../../components/ErrorBoundary';

library.add(fab, fas, far);

const muiTheme = createTheme({
	typography: {
		fontFamily: ['Source Sans Pro'],
	},
	palette: {
		primary: {
			main: '#e9b91c',
			light: '#f7d35c',
			dark: '#997708',
			contrastText: '#ffffff',
		},
		secondary: {
			main: '#141414',
			light: '#1c1c1c',
			dark: '#0f0f0f',
			contrastText: '#ffffff',
		},
		error: {
			main: '#6e1616',
			light: '#a13434',
			dark: '#430b0b',
		},
		success: {
			main: '#52984a',
			light: '#60eb50',
			dark: '#244a20',
		},
		warning: {
			main: '#f09348',
			light: '#f2b583',
			dark: '#b05d1a',
		},
		info: {
			main: '#247ba5',
			light: '#247ba5',
			dark: '#175878',
		},
		text: {
			main: '#ffffff',
			alt: '#cecece',
			info: '#919191',
			light: '#ffffff',
			dark: '#000000',
		},
		rarities: {
			rare1: '#ffffff',
			rare2: '#52984a',
			rare3: '#247ba5',
			rare4: '#8e3bb8',
			rare5: '#f2d411',
			rare6: '#ff8000',
			rare7: '#e6cc80',
		},
		border: {
			main: '#e0e0e008',
			light: '#ffffff',
			dark: '#26292d',
			input: 'rgba(255, 255, 255, 0.23)',
			divider: 'rgba(255, 255, 255, 0.12)',
		},
		mode: 'dark',
	},
	components: {
		MuiCssBaseline: {
			styleOverrides: {
				'.fade-enter': {
					opacity: 0,
				},
				'.fade-exit': {
					opacity: 1,
				},
				'.fade-enter-active': {
					opacity: 1,
				},
				'.fade-exit-active': {
					opacity: 0,
				},
				'.fade-enter-active, .fade-exit-active': {
					transition: 'opacity 500ms',
				},
				'*': {
					'&::-webkit-scrollbar': {
						width: 4,
					},
					'&::-webkit-scrollbar-thumb': {
						background: '#1c1c1c',
						transition: 'background ease-in 0.15s',
					},
					'&::-webkit-scrollbar-thumb:hover': {
						background: '#101010',
					},
					'&::-webkit-scrollbar-track': {
						background: 'transparent',
					},

					'& input[type=number]': {
						'-moz-appearance': 'textfield',
					},
					'& input[type=number]::-webkit-outer-spin-button': {
						'-webkit-appearance': 'none',
						margin: 0,
					},
					'& input[type=number]::-webkit-inner-spin-button': {
						'-webkit-appearance': 'none',
						margin: 0,
					},
				},
				html: {
					background:
						process.env.NODE_ENV != 'production'
							? '#1e1e1e'
							: 'transparent',
				},
			},
		},
		MuiTooltip: {
			styleOverrides: {
				tooltip: {
					fontSize: 16,
					backgroundColor: '#151515',
					border: '1px solid rgba(255, 255, 255, 0.23)',
					boxShadow: `0 0 10px #000`,
				},
			},
		},
		MuiPaper: {
			styleOverrides: {
				root: {
					background: '#0f0f0f',
				},
			},
		},
	},
});

export default () => {
	const dispatch = useDispatch();
	const hidden = useSelector((state) => state.app.hidden);
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const items = useSelector((state) => state.inventory.items);
	const staticTooltip = useSelector((state) => state.inventory.staticTooltip);

	const onHide = () => {
		dispatch({
			type: 'HIDE_SECONDARY_INVENTORY',
		});
		dispatch({
			type: 'RESET_INVENTORY',
		});
	};

	return (
		<StyledEngineProvider injectFirst>
			<ThemeProvider theme={muiTheme}>
				<CssBaseline />
				<Hotbar />
				<ChangeAlerts />
				{Boolean(itemsLoaded) && Boolean(staticTooltip) && (
					<StaticTooltip
						item={items[staticTooltip.Name]}
						instance={staticTooltip}
					/>
				)}
				<Fade in={!hidden} timeout={500} onExited={onHide}>
					<div>
						<ErrorBoundary>
							<Fragment>
								<AppScreen>
									<Inventory />
								</AppScreen>
								<HoverSlot />
							</Fragment>
						</ErrorBoundary>
					</div>
				</Fade>
			</ThemeProvider>
		</StyledEngineProvider>
	);
};

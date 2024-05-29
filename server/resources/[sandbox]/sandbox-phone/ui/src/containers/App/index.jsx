import React from 'react';
import { useSelector } from 'react-redux';
import CssBaseline from '@mui/material/CssBaseline';
import {
	ThemeProvider,
	createTheme,
	StyledEngineProvider,
} from '@mui/material';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/pro-solid-svg-icons';
import { far } from '@fortawesome/pro-regular-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { fad } from '@fortawesome/pro-duotone-svg-icons';
import { HashRouter as Router } from 'react-router-dom';
import chroma from 'chroma-js';

import 'react-image-lightbox/style.css';

import Phone from '../Phone';
import Notifications from '../Notifications';

library.add(fab, fas, far, fad);

export default (props) => {
	const player = useSelector((state) => state.data.data.player);
	const phoneColors = useSelector(
		(state) => state.data.data.player?.PhoneSettings?.colors,
	);
	const phoneOpen = useSelector((state) => state.phone.visible);

	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Source Sans Pro', 'sans-serif'],
		},
		palette: {
			primary: {
				main: Boolean(phoneColors) ? phoneColors.accent : '#b40000',
				light: Boolean(phoneColors)
					? `${chroma(phoneColors.accent).brighten()}`
					: '#c33333',
				dark: Boolean(phoneColors)
					? `${chroma(phoneColors.accent).darken()}`
					: '#7e0000',
				contrastText: '#ffffff',
			},
			secondary: {
				main: '#252726',
				light: '#303331',
				dark: '#1d1e1e',
				contrastText: '#cecece',
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
				light: '#ffffff',
				dark: '#000000',
				alt: '#cecece',
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
			MuiTooltip: {
				styleOverrides: {
					popper: {
						zIndex: '999000001 !important',
					},
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
						background: '#151515',
					},
				},
			},
			MuiAutocomplete: {
				styleOverrides: {
					paper: {
						boxShadow: '0 0 25px #000',
					},
				},
			},
			MuiBackdrop: {
				styleOverrides: {
					root: {
						height: '90%',
						width: '90%',
						margin: 'auto',
					},
				},
			},
			MuiPopover: {
				styleOverrides: {
					root: {
						zIndex: '999000001 !important',
					},
				},
			},
			MuiCssBaseline: {
				styleOverrides: {
					'*': {
						'.app': {
							height: '100vh',
							width: '100vw',
						},
						'&::-webkit-outer-spin-button, &::-webkit-inner-spin-button':
							{
								WebkitAppearance: 'none',
								margin: 0,
							},
						'&::-webkit-scrollbar': {
							width: 6,
						},
						'&::-webkit-scrollbar-thumb': {
							background: '#ffffff52',
						},
						'&::-webkit-scrollbar-thumb:hover': {
							background: Boolean(phoneColors)
								? phoneColors.accent
								: '#dd1e36',
						},
						'&::-webkit-scrollbar-track': {
							background: 'transparent',
						},
						'.twitter-picker': {
							backgroundColor: '#2e3037 !important',
						},
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
						'.ReactModal__Overlay': {
							zIndex: '999000010 !important',
						},
						'.ck-balloon-panel': {
							zIndex: '999000001 !important',
						},
						'.ck.ck-list__item .ck-button .ck-button__label': {
							lineHeight: '34px !important',
						},
						'--ck-border-radius': 4,
						'--ck-custom-background': '#121212',
						'--ck-custom-foreground': 'hsl(255, 3%, 18%)',
						'--ck-custom-border': 'hsl(300, 1%, 22%)',
						'--ck-custom-white': 'hsl(0, 0%, 100%)',
						'--ck-color-base-foreground':
							'var(--ck-custom-background)',
						'--ck-color-focus-border': 'hsl(208, 90%, 62%)',
						'--ck-color-text': 'hsl(0, 0%, 98%)',
						'--ck-color-shadow-drop': 'hsla(0, 0%, 0%, 0.2)',
						'--ck-color-shadow-inner': 'hsla(0, 0%, 0%, 0.1)',
						'--ck-color-button-default-background':
							'var(--ck-custom-background)',
						'--ck-color-button-default-hover-background':
							'hsl(270, 1%, 22%)',
						'--ck-color-button-default-active-background':
							'hsl(270, 2%, 20%)',
						'--ck-color-button-default-active-shadow':
							'hsl(270, 2%, 23%)',
						'--ck-color-button-default-disabled-background':
							'var(--ck-custom-background)',
						'--ck-color-button-on-background':
							'var(--ck-custom-foreground)',
						'--ck-color-button-on-hover-background':
							'hsl(255, 4%, 16%)',
						'--ck-color-button-on-active-background':
							'hsl(255, 4%, 14%)',
						'--ck-color-button-on-active-shadow':
							'hsl(240, 3%, 19%)',
						'--ck-color-button-on-disabled-background':
							'var(--ck-custom-foreground)',
						'--ck-color-button-action-background':
							'hsl(168, 76%, 42%)',
						'--ck-color-button-action-hover-background':
							'hsl(168, 76%, 38%)',
						'--ck-color-button-action-active-background':
							'hsl(168, 76%, 36%)',
						'--ck-color-button-action-active-shadow':
							'hsl(168, 75%, 34%)',
						'--ck-color-button-action-disabled-background':
							'hsl(168, 76%, 42%)',
						'--ck-color-button-action-text':
							'var(--ck-custom-white)',
						'--ck-color-button-save': 'hsl(120, 100%, 46%)',
						'--ck-color-button-cancel': 'hsl(15, 100%, 56%)',
						'--ck-color-dropdown-panel-background':
							'var(--ck-custom-background)',
						'--ck-color-dropdown-panel-border':
							'var(--ck-custom-foreground)',
						'--ck-color-split-button-hover-background':
							'var(--ck-color-button-default-hover-background)',
						'--ck-color-split-button-hover-border':
							'var(--ck-custom-foreground)',
						'--ck-color-input-background':
							'var(--ck-custom-background)',
						'--ck-color-input-border': 'hsl(257, 3%, 43%)',
						'--ck-color-input-text': 'hsl(0, 0%, 98%)',
						'--ck-color-input-disabled-background':
							'hsl(255, 4%, 21%)',
						'--ck-color-input-disabled-border': 'hsl(250, 3%, 38%)',
						'--ck-color-input-disabled-text': 'hsl(0, 0%, 78%)',
						'--ck-color-labeled-field-label-background':
							'var(--ck-custom-background)',
						'--ck-color-list-background':
							'var(--ck-custom-background)',
						'--ck-color-list-button-hover-background':
							'var(--ck-color-base-foreground)',
						'--ck-color-list-button-on-background':
							'var(--ck-color-base-active)',
						'--ck-color-list-button-on-background-focus':
							'var(--ck-color-base-active-focus)',
						'--ck-color-list-button-on-text':
							'var(--ck-color-base-background)',
						'--ck-color-panel-background':
							'var(--ck-custom-background)',
						'--ck-color-panel-border': 'var(--ck-custom-border)',
						'--ck-color-toolbar-background':
							'var(--ck-custom-background)',
						'--ck-color-toolbar-border': 'var(--ck-custom-border)',
						'--ck-color-tooltip-background': 'hsl(252, 7%, 14%)',
						'--ck-color-tooltip-text': 'hsl(0, 0%, 93%)',
						'--ck-color-image-caption-background':
							'hsl(0, 0%, 97%)',
						'--ck-color-image-caption-text': 'hsl(0, 0%, 20%)',
						'--ck-color-widget-blurred-border': 'hsl(0, 0%, 87%)',
						'--ck-color-widget-hover-border': 'hsl(43, 100%, 68%)',
						'--ck-color-widget-editable-focus-background':
							'var(--ck-custom-white)',
						'--ck-color-link-default': 'hsl(190, 100%, 75%)',
						'--ck-color-base-background': '#0a0a0a',
						'--ck-color-base-border': 'rgba(255, 255, 255, 0.23)',
						'--ck-color-focus-border': '#fff',
						'.ck-content pre': {
							color: '#ffffff',
							background: '#191919',
							borderColor: 'rgba(255, 255, 255, 0.23)',
						},
					},
					html: {
						'.ck-content': {
							minHeight: 300,
						},
						background:
							process.env.NODE_ENV != 'production'
								? '#1e1e1e'
								: 'transparent',
						'input::-webkit-outer-spin-button, input::-webkit-inner-spin-button':
							{
								WebkitAppearance: 'none',
								margin: 0,
							},
					},
				},
			},
		},
	});

	if (!Boolean(player)) return null;
	return (
		<StyledEngineProvider injectFirst>
			<ThemeProvider theme={muiTheme}>
				<CssBaseline />
				<Router>
					<Phone />
					{!phoneOpen && <Notifications />}
				</Router>
			</ThemeProvider>
		</StyledEngineProvider>
	);
};

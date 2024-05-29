import React from 'react';
import CssBaseline from '@mui/material/CssBaseline';
import {
	ThemeProvider,
	createTheme,
	StyledEngineProvider,
} from '@mui/material';
import { library } from '@fortawesome/fontawesome-svg-core';
import { far } from '@fortawesome/pro-regular-svg-icons';
import Radio from '../Radio';

library.add(far);

export default (props) => {
	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Source Sans Pro', 'sans-serif'],
		},
		palette: {
			primary: {
				main: '#E5A502',
				light: '#E8A933',
				dark: '#FA5800',
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
			MuiCssBaseline: {
				styleOverrides: {
					html: {
						background:
							process.env.NODE_ENV != 'production'
								? '#1e1e1e'
								: 'transparent',
						'& body': {
							background: 'transparent !important',
						},
					},
				},
			},
		},
	});

	return (
		<StyledEngineProvider injectFirst>
			<ThemeProvider theme={muiTheme}>
				<CssBaseline />
				<Radio />
			</ThemeProvider>
		</StyledEngineProvider>
	);
};

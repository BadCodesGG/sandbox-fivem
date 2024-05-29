import React from 'react';
import CssBaseline from '@mui/material/CssBaseline';
import {
    ThemeProvider,
    createTheme,
    StyledEngineProvider,
} from '@mui/material';
import { useSelector } from 'react-redux';

import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/pro-solid-svg-icons';
import { far } from '@fortawesome/pro-regular-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';

import Menu from '../../components/Menu/Menu';

library.add(fab, fas, far);

export default () => {
    const muiTheme = createTheme({
        typography: {
            fontFamily: ['Source Sans Pro'],
        },
        palette: {
            primary: {
                main: '#E5A502',
                light: '#E8A933',
                dark: '#FA5800',
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
                main: '#4056b3',
                light: '#247ba5',
                dark: '#175878',
            },
            text: {
                main: '#ffffff',
                alt: '#A7A7A7',
                info: '#919191',
                light: '#ffffff',
                dark: '#000000',
            },
            alt: {
                green: '#008442',
                greenDark: '#064224',
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
                    body: {
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
                    },
                    html: {
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
                    '*': {
                        '&::-webkit-scrollbar': {
                            width: 0,
                        },
                        '&::-webkit-scrollbar-thumb': {
                            background: '#E5A50280',
                        },
                        '&::-webkit-scrollbar-thumb:hover': {
                            background: '#E5A50240',
                        },
                        '&::-webkit-scrollbar-track': {
                            background: '#0f0f0f',
                        },
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

    return (
        <StyledEngineProvider injectFirst>
            <ThemeProvider theme={muiTheme}>
                <CssBaseline />
                <Menu />
            </ThemeProvider>
        </StyledEngineProvider>
    );
};

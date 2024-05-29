import '@babel/polyfill';
import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import PropTypes from 'prop-types';
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
import "react-circular-progressbar/dist/styles.css";

import Action from '../Action2';
import Hud from '../Hud';
import Notifications from '../Notifications';
import List from '../../components/List';
import Input from '../../components/Input';
import Confirm from '../../components/Confirm';
import InfoOverlay from '../../components/InfoOverlay';
import Overlay from '../../components/Overlay';
import { Progress, ThirdEye, GemTable } from '../../components';

import Interaction from '../../components/Interaction';

import LCD from '../../assets/fonts/lcd.ttf';
import Dead from './Dead';
import Blindfold from './Blindfold';
import Ingredients from '../../components/Meth';
import DeathTexts from './DeathTexts';
import Arcade from '../Arcade';
import Flashbang from './Flashbang';
import Settings from '../Settings';

library.add(fab, fas, far);

const LCDFont = {
    fontFamily: 'LCD',
    fontStyle: 'normal',
    fontDisplay: 'swap',
    fontWeight: 400,
    src: `
      url(${LCD}) format('truetype')
    `,
};

const App = ({ hidden }) => {
    const progShowing = useSelector((state) => state.progress.showing);
    const isLis = useSelector((state) => state.list.showing);
    const isInp = useSelector((state) => state.input.showing);
    const isConf = useSelector((state) => state.confirm.showing);
    const isMeth = useSelector((state) => state.meth.showing);

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
                        '@font-face': [LCDFont],
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
                            width: 6,
                        },
                        '&::-webkit-scrollbar-thumb': {
                            background: 'rgba(0, 0, 0, 0.5)',
                            transition: 'background ease-in 0.15s',
                        },
                        '&::-webkit-scrollbar-thumb:hover': {
                            background: '#ffffff17',
                        },
                        '&::-webkit-scrollbar-track': {
                            background: 'transparent',
                        },
                    },
                    '@keyframes critical': {
                        '0%, 49%': {
                            backgroundColor: '#0f0f0f',
                        },
                        '50%, 100%': {
                            backgroundColor: '#1b1c2c',
                        },
                    },
                    '@keyframes critical-border': {
                        '0%, 49%': {
                            borderColor: '#ffffffc7',
                        },
                        '50%, 100%': {
                            borderColor: `#de3333`,
                        },
                    },
                    '@keyframes flash': {
                        '0%': {
                            opacity: 1,
                        },
                        '50%': {
                            opacity: 0.1,
                        },
                        '100%': {
                            opacity: 1,
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
                <Dead />
                <Blindfold />
                <Flashbang />
                <DeathTexts />
                <InfoOverlay />
                <Overlay />
                <Hud />
                <Notifications />
                <Action />
                {isMeth && <Ingredients />}
                {isLis && <List />}
                {isInp && <Input />}
                {isConf && <Confirm />}
                {progShowing && <Progress />}
                <ThirdEye />
                <Interaction />
                <GemTable />
                <Settings />
            </ThemeProvider>
        </StyledEngineProvider>
    );
};

App.propTypes = {
    hidden: PropTypes.bool.isRequired,
};

const mapStateToProps = (state) => ({ hidden: state.app.hidden });

export default connect(mapStateToProps)(App);

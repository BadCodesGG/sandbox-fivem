import React, { useEffect, useState, useRef } from 'react';
import { useSelector } from 'react-redux';
import { Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import ScrollableFeed from 'react-scrollable-feed';

import Message from './components/Message';
import Input from './Input';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        position: 'relative',
        height: '100%',
        width: '100%',
    },
    messages: {
        position: 'absolute',
        top: 25,
        left: 25,
        height: '25%',
        width: '30vw',
        paddingTop: 10,
        // background: `${theme.palette.secondary.dark}a6`,
        // border: `1px solid ${theme.palette.border.input}`,
        // borderBottom: 'none',

        // '&.hiding': {
        //     borderBottom: `1px solid ${theme.palette.border.input}`,
        // },
    },
    inner: {
        maxHeight: '100%',
        height: '100%',
        display: 'flex',
        flexFlow: 'row',
        overflow: 'auto',
        flexWrap: 'wrap',
        gap: '1%',
        alignContent: 'flex-start',

        '&::-webkit-scrollbar': {
            display: 'none',
        },
    },
}));

export default () => {
    const classes = useStyles();
    const hidden = useSelector((state) => state.app.hidden);
    const inputting = useSelector((state) => state.app.inputting);
    const messages = useSelector((state) => state.chat.messages);
    const scrollableRef = useRef(null);

    const [to, setTo] = useState(null);
    const [to2, setTo2] = useState(null);
    const [showing, setShowing] = useState(false);
    const [previewing, setPreviewing] = useState(false);

    useEffect(() => {
        if (hidden && showing) {
            setTo(
                setTimeout(() => {
                    setShowing(false);
                }, 2500),
            );
        } else if (!hidden && Boolean(to)) {
            if (!showing) setShowing(true);
            clearTimeout(to);
            setTo(null);
        } else if (!hidden && !showing) {
            setShowing(true);
        }
    }, [hidden]);

    useEffect(() => {
        if (!hidden) return;

        if (hidden) {
            setPreviewing(true);
            if (!Boolean(to2)) clearTimeout(to2);
            setTo2(
                setTimeout(() => {
                    setPreviewing(false);
                }, 6000),
            );
        }
    }, [messages]);

    useEffect(() => {
        if (scrollableRef?.current) {
            scrollableRef.current.scrollToBottom();
        };
    }, [messages, scrollableRef]);

    const onScrollDown = () => {
        if (scrollableRef?.current && document.getElementsByClassName('stupidShit')) {
            document.getElementsByClassName('stupidShit')[0].scrollTop = document.getElementsByClassName('stupidShit')[0].scrollTop + 100;
        };
    };

    const onScrollUp = () => {
        if (scrollableRef?.current && document.getElementsByClassName('stupidShit')) {
            document.getElementsByClassName('stupidShit')[0].scrollTop = document.getElementsByClassName('stupidShit')[0].scrollTop - 100;
        };
    };

    return (
        <div className={classes.wrapper}>
            <Slide
                direction="down"
                in={showing || previewing}
                mountOnEnter
                unmountOnExit
            >
                <div
                    className={`${classes.messages}${hidden && showing ? ' hiding' : ''
                        }`}
                >
                    <ScrollableFeed className={`${classes.inner} stupidShit`} ref={scrollableRef}>
                        {messages
                            .sort((a, b) => a.time - b.time)
                            .map((msg, i) => {
                                return (
                                    <Message key={`msg-${i}`} message={msg} />
                                );
                            })}
                    </ScrollableFeed>
                </div>
            </Slide>
            {inputting && <Input onScrollDown={onScrollDown} onScrollUp={onScrollUp} />}
        </div>
    );
};

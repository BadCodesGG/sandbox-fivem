import React from 'react';
import {
    Default,
    OOC,
    Server,
    PDDispatch,
    EMSDispatch,
    InternalDispatch,
    Dispatch,
    TestResults,
    DOCDispatch,
} from './Templates';

export default ({ message }) => {
    const getMessageTemplate = () => {
        if (!Boolean(message.message)) return null;

        switch (message.type) {
            case 'ooc':
                return <OOC message={message} />;
            case 'server':
                return <Server message={message} />;
            case '911':
                return <PDDispatch message={message} />;
            case '311':
                return <EMSDispatch message={message} />;
            case '411':
                return <InternalDispatch message={message} />;
            case '411A':
                return <DOCDispatch message={message} />;
            case 'dispatch':
                return <Dispatch message={message} />;
            case 'tests':
                return <TestResults message={message} />;
            case 'system':
                return <Default message={message} />;
        }
    };

    return <>{getMessageTemplate()}</>;
};

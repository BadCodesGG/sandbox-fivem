import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';

import Nui from '../../util/Nui';

export default ({ children }) => {
    const dispatch = useDispatch();
    const handleEvent = (event) => {
        const { type, data } = event.data;
        if (type != null) dispatch({ type, payload: { ...data } });
    };

    const handleKeyEvent = (event) => {
        if (event.keyCode === 27) {
            Nui.send('Close');
            dispatch({
                type: 'CLEAR_MENU',
            });
        } else if (event.keyCode === 16) {
            if (document?.activeElement?.nodeName !== 'TEXTAREA') {
                Nui.send('ToggleFocusLoss');
            }
        }
    };

    useEffect(() => {
        window.addEventListener('message', handleEvent);
        window.addEventListener('keyup', handleKeyEvent);

        // returned function will be called on component unmount
        return () => {
            window.removeEventListener('message', handleEvent);
        };
    }, []);

    return React.Children.only(children);
};

import React from 'react';
import { useSelector } from 'react-redux';

import Default from './layouts/Default';
import Minimap from './layouts/Minimap';
import Center from './layouts/Center';
import Condensed from './layouts/Condensed';

export default () => {
    const config = useSelector((state) => state.hud.config);
    switch (config.layout) {
        case 'minimap':
            return <Minimap />;
        case 'center':
            return <Center />;
        case 'condensed':
            return <Condensed />;
        default:
            return <Default />;
    }
};

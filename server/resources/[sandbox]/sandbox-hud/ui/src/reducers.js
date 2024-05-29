import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import notifReducer from 'containers/Notifications/reducer';
import actionReducer from './containers/Action/reducer';
import action2Reducer from './containers/Action2/reducer';
import hudReducer from './containers/Hud/reducer';
import locationReducer from './components/Location/reducer';
import statusReducer from './components/Status/reducer';
import vehicleReducer from './components/Vehicle/reducer';
import progressReducer from './components/Progress/reducer';
import thirdEyeReducer from './components/ThirdEye/reducer';
import interactionReducer from './components/Interaction/reducer';
import listReducer from './components/List/reducer';
import inputReducer from './components/Input/reducer';
import confirmReducer from './components/Confirm/reducer';
import infoOverlayReducer from './components/InfoOverlay/reducer';
import overlayReducer from './components/Overlay/reducer';
import gemReducer from './components/GemTable/reducer';
import methReducer from './components/Meth/reducer';
import arcadeReducer from './containers/Arcade/reducer';

export default () =>
    combineReducers({
        app: appReducer,
        notification: notifReducer,
        action: actionReducer,
        action2: action2Reducer,
        interaction: interactionReducer,
        hud: hudReducer,
        location: locationReducer,
        status: statusReducer,
        vehicle: vehicleReducer,
        progress: progressReducer,
        thirdEye: thirdEyeReducer,
        list: listReducer,
        input: inputReducer,
        confirm: confirmReducer,
        infoOverlay: infoOverlayReducer,
        overlay: overlayReducer,
        gemTable: gemReducer,
        meth: methReducer,
        arcade: arcadeReducer,
    });

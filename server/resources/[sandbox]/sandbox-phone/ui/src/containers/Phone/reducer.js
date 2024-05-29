import Nui from '../../util/Nui';

export const initialState = {
	visible: process.env.NODE_ENV != 'production',
	clear: false,
	expanded: true,
	limited: false,
	locked: true,
	position: {
		x: 1000,
		y: 250,
	},
	time: {
		hour: 4,
		minute: 20,
	},
	apps:
		process.env.NODE_ENV == 'production'
			? {}
			: {
					phone: {
						storeLabel: 'Phone',
						label: 'Phone',
						icon: 'phone',
						name: 'phone',
						color: '#21a500',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'call',
								params: ':number?',
							},
							{
								app: 'recent',
								params: '',
							},
						],
					},
					messages: {
						storeLabel: 'Messages',
						label: 'Messages',
						icon: 'comment',
						name: 'messages',
						color: '#ff0000',
						canUninstall: false,
						unread: 5,
						params: '',
						internal: [
							{
								app: 'new',
							},
							{
								app: 'convo',
								params: ':number?',
							},
						],
					},
					contacts: {
						storeLabel: 'Contacts',
						label: 'Contacts',
						icon: 'address-book',
						name: 'contacts',
						color: '#ff6a00',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'add',
								params: ':number?',
							},
							{
								app: 'view',
								params: ':id',
							},
							{
								app: 'caller',
								params: ':id',
							},
						],
					},
					store: {
						storeLabel: 'App Store',
						label: 'App Store',
						icon: 'hippo',
						name: 'store',
						color: '#ad8d1a',
						canUninstall: false,
						unread: 0,
						params: '',
					},
					settings: {
						storeLabel: 'Settings',
						label: 'Settings',
						icon: 'gear',
						name: 'settings',
						color: '#18191e',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'software',
								params: '',
							},
							{
								app: 'profile',
								params: '',
							},
							{
								app: 'app_notifs',
								params: '',
							},
							{
								app: 'sounds',
								params: '',
							},
							{
								app: 'wallpaper',
								params: '',
							},
							{
								app: 'colors',
								params: '',
							},
						],
					},
					email: {
						storeLabel: 'Email',
						label: 'Email',
						icon: 'envelope',
						name: 'email',
						color: '#10909c',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':id',
							},
						],
					},
					bank: {
						storeLabel: 'Fleeca',
						label: 'Fleeca',
						icon: 'bank',
						name: 'bank',
						color: '#268f3a',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':account',
							},
							{
								app: 'bill',
								params: '',
							},
						],
					},
					loans: {
						storeLabel: 'Loans',
						label: 'Loans',
						icon: ['far', 'money-check-dollar'],
						name: 'loans',
						color: '#30a60f',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':loan',
							},
						],
					},
					twitter: {
						storeLabel: 'Spammer',
						label: 'Spammer',
						icon: ['far', 'face-awesome'],
						name: 'twitter',
						color: '#c4b404',
						canUninstall: true,
						unread: 0,
						// restricted: {
						// 	state: 'PHONE_VPN',
						// },
						params: '',
						internal: [
							{
								app: 'profile',
								params: '',
							},
						],
					},
					chatter: {
						storeLabel: 'Chatter',
						label: 'Chatter',
						icon: ['fab', 'rocketchat'],
						name: 'chatter',
						color: '#2d2835',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'channel',
								params: ':channel',
							},
							{
								app: 'join',
								params: ':channel',
							},
							{
								app: 'config',
								params: ':channel',
							},
							{
								app: 'invites',
								params: '',
							},
						],
					},
					adverts: {
						storeLabel: 'Ads',
						label: 'Ads',
						icon: ['fab', 'adversal'],
						name: 'adverts',
						color: '#870b30',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':id',
							},
							{
								app: 'category-view',
								params: ':category',
							},
							{
								app: 'add',
								params: '',
							},
							{
								app: 'edit',
								params: '',
							},
						],
					},
					documents: {
						storeLabel: 'Documents',
						label: 'Documents',
						icon: 'file-lines',
						name: 'documents',
						color: '#820366',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':id',
							},
							{
								app: 'new',
								params: '',
							},
							{
								app: 'edit',
								params: ':id',
							},
						],
					},
					redline: {
						storeLabel: 'Redline',
						label: 'Redline',
						name: 'redline',
						icon: ['far', 'gauge-simple-high'],
						color: '#9d1614',
						hidden: true,
						store: false,
						canUninstall: true,
						unread: 0,
						params: ':tab?',
						restricted: {
							state: 'RACE_DONGLE',
						},
						internal: [
							{
								app: 'completed',
								params: '',
							},
							{
								app: 'new',
								params: '',
							},
							{
								app: 'admin',
								params: '',
							},
							{
								app: 'view',
								params: ':race',
							},
							{
								app: 'profile',
								params: ':racer',
							},
							{
								app: 'tracks',
								params: ':track?',
							},
							{
								app: 'invites',
								params: '',
							},
						],
					},
					blueline: {
						storeLabel: 'Trials',
						label: 'Trials',
						name: 'blueline',
						icon: ['fas', 'stopwatch-20'],
						color: '#1258a3',
						hidden: true,
						store: false,
						canUninstall: true,
						unread: 0,
						params: ':tab?',
						// restricted: {
						// 	job: {
						// 		police: true,
						// 	},
						// },
						internal: [
							{
								app: 'completed',
								params: '',
							},
							{
								app: 'new',
								params: '',
							},
							{
								app: 'admin',
								params: '',
							},
							{
								app: 'view',
								params: ':race',
							},
						],
					},
					comanager: {
						storeLabel: 'BizWiz',
						label: 'BizWiz',
						name: 'comanager',
						icon: 'briefcase',
						color: '#db5004',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':jobId',
							},
						],
					},
					labor: {
						storeLabel: 'Jobs',
						label: 'Jobs',
						name: 'labor',
						icon: ['fad', 'pickaxe'],
						color: '#05737d',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					crypto: {
						storeLabel: 'DigiDollar',
						label: 'DigiDollar',
						name: 'crypto',
						icon: ['far', 'circle-dollar'],
						color: '#354f34',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					dyn8: {
						storeLabel: 'Dynasty 8',
						label: 'Dynasty 8',
						name: 'dyn8',
						icon: ['fad', 'sign-hanging'],
						color: '#136231',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					homemanage: {
						storeLabel: 'Properties',
						label: 'Properties',
						name: 'homemanage',
						icon: 'house-signal',
						color: '#362a4f',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					garage: {
						storeLabel: 'Garage',
						label: 'Garage',
						name: 'garage',
						icon: 'car-garage',
						color: '#50ba13',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':vin',
							},
						],
					},
					pingem: {
						storeLabel: 'FINDR',
						label: 'FINDR',
						name: 'pingem',
						icon: 'map-pin',
						color: '#e3db02',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					calculator: {
						storeLabel: 'Calculator',
						label: 'Calculator',
						name: 'calculator',
						icon: 'calculator-simple',
						color: '#E95200',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					services: {
						storeLabel: 'Services',
						label: 'Services',
						name: 'services',
						icon: 'clipboard-list',
						color: '#E95200',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					media: {
						storeLabel: 'Media',
						label: 'Media',
						name: 'media',
						icon: 'photo-film',
						color: '#59E5F7',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					chopper: {
						storeLabel: 'Chopper',
						label: 'Chopper',
						name: 'chopper',
						icon: 'axe',
						color: '#8800c7',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
						restricted: {
							state: 'ACCESS_CHOPPER',
						},
					},
					music: {
						storeLabel: 'Music',
						label: 'Music',
						name: 'music',
						icon: 'cloud-music',
						color: '#63e6be',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
			  },
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'SET_POSITION':
			return {
				...state,
				position: { ...action.payload },
			};
		case 'TOGGLE_LOCKED':
			if (!state.locked) Nui.send('Phone:SavePosition', state.position);
			return {
				...state,
				locked: !state.locked,
			};
		case 'LOAD_PERMS':
			return {
				...state,
				permissions: action.payload,
			};
		case 'PHONE_VISIBLE':
			return {
				...state,
				visible: true,
			};
		case 'PHONE_NOT_VISIBLE':
			Nui.send('ClosePhone', null);
			return {
				...state,
				visible: false,
				limited: false,
			};
		case 'PHONE_NOT_VISIBLE_FORCED':
			return {
				...state,
				visible: false,
				limited: false,
			};
		case 'PHONE_VISIBLE_LIMITED':
			return {
				...state,
				visible: true,
				limited: true,
			};
		case 'CLEAR_HISTORY':
			return {
				...state,
				clear: true,
			};
		case 'TOGGLE_EXPANDED':
			Nui.send('UpdateSetting', {
				type: 'Expanded',
				val: !state.expanded,
			});
			return {
				...state,
				expanded: !state.expanded,
			};
		case 'SET_EXPANDED':
			return {
				...state,
				expanded: action.payload.expanded,
			};
		case 'CLEARED_HISTORY':
			Nui.send('CDExpired');
			return {
				...state,
				clear: false,
			};
		case 'SET_APPS':
			return {
				...state,
				apps: action.payload,
			};
		case 'SET_UNREAD':
			return {
				...state,
				apps: {
					...state.apps,
					[action.payload.name]: {
						...state.apps[action.payload.name],
						unread: action.payload.count,
					},
				},
			};
		case 'ADD_UNREAD':
			return {
				...state,
				apps: {
					...state.apps,
					[action.payload.name]: {
						...state.apps[action.payload.name],
						unread:
							(state.apps[action.payload.name]?.unread ?? 0) +
							action.payload.count,
					},
				},
			};
		case 'APP_OPEN':
			if (!Boolean(state.apps[action.payload])) return state;
			return {
				...state,
				apps: {
					...state.apps,
					[action.payload]: {
						...state.apps[action.payload],
						unread: 0,
					},
				},
			};
		case 'SET_TIME':
			return {
				...state,
				time: action.payload,
			};
		default:
			return state;
	}
};

export default appReducer;

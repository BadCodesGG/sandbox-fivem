export default (job, workplace) => {
	switch (job) {
		case 'police':
			return police;
		case 'government':
			switch (workplace) {
				case 'doj':
					return doj;
				case 'dattorney':
					return districtattorney;
				case 'publicdefenders':
					return attorney;
				case 'mayoroffice':
				default:
					return base;
			}
		case 'ems':
			return medical;
		case 'attorney':
			return attorney;
		case 'prison':
			return doc;
		case 'public-prison':
			return pubPrison;
		default:
			return base;
	}
};

const systemAdmin = [
	{
		icon: ['fas', 'square-terminal'],
		label: 'Permissions',
		path: '/system/gov-permissions',
		exact: true,
		restrict: {
			permission: true,
		},
	},
	{
		icon: ['fas', 'square-terminal'],
		label: 'Full Roster',
		path: '/system/gov-roster',
		exact: true,
		restrict: {
			permission: true,
		},
	},
	{
		icon: ['fas', 'square-terminal'],
		label: 'Charges',
		path: '/system/charges',
		exact: true,
		restrict: {
			permission: true,
		},
	},
];

const base = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		path: '/',
		exact: true,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-certificate'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
];

const pubPrison = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		path: '/',
		exact: true,
	},
];

const attorney = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		path: '/',
		exact: true,
	},
	{
		name: 'reports',
		icon: ['fas', 'file-lines'],
		label: 'Reports',
		path: '/reports',
		submenu: false,
		exact: false,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-certificate'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'people',
		icon: ['fas', 'person'],
		label: 'People',
		path: '/people',
		submenu: false,
		exact: false,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	{
		name: 'library',
		icon: ['fas', 'books'],
		label: 'Document Library',
		path: '/library',
		exact: true,
	},
];

const police = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		path: '/',
		exact: true,
	},
	{
		name: 'roster',
		icon: ['fas', 'user-police-tie'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'reports',
		icon: ['fas', 'file-lines'],
		label: 'Reports',
		path: '/reports',
		submenu: false,
		exact: false,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-certificate'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'people',
		icon: ['fas', 'person'],
		label: 'People',
		path: '/people',
		submenu: false,
		exact: false,
	},
	{
		name: 'vehicles',
		icon: ['fas', 'cars'],
		label: 'Vehicles',
		path: '/vehicles',
		submenu: false,
		exact: false,
	},
	{
		name: 'properties',
		icon: ['fas', 'house-chimney'],
		label: 'Properties',
		path: '/properties',
		submenu: false,
		exact: false,
	},
	{
		name: 'firearms',
		icon: ['fas', 'gun'],
		label: 'Firearms',
		path: '/firearms',
		submenu: false,
		exact: false,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	{
		name: 'library',
		icon: ['fas', 'books'],
		label: 'Document Library',
		path: '/library',
		exact: true,
	},
	{
		icon: ['fas', 'car-wrench'],
		label: 'Fleet',
		path: '/fleet-manager',
		exact: false,
		restrict: {
			permission: 'FLEET_MANAGEMENT',
		},
	},
	{
		icon: ['fas', 'user-crown'],
		label: 'Permissions',
		path: '/admin/permissions',
		exact: false,
		restrict: {
			permission: 'PD_HIGH_COMMAND',
		},
	},
	...systemAdmin,
];

const doj = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		path: '/',
		exact: true,
	},
	{
		name: 'roster',
		icon: ['fas', 'user-tie'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'reports',
		icon: ['fas', 'file-lines'],
		label: 'Reports',
		path: '/reports',
		submenu: false,
		exact: false,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-certificate'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'people',
		icon: ['fas', 'person'],
		label: 'People',
		path: '/people',
		submenu: false,
		exact: false,
	},
	{
		name: 'vehicles',
		icon: ['fas', 'cars'],
		label: 'Vehicles',
		path: '/vehicles',
		submenu: false,
		exact: false,
	},
	{
		name: 'properties',
		icon: ['fas', 'house-chimney'],
		label: 'Properties',
		path: '/properties',
		submenu: false,
		exact: false,
	},
	{
		name: 'firearms',
		icon: ['fas', 'gun'],
		label: 'Firearms',
		path: '/firearms',
		submenu: false,
		exact: false,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	{
		name: 'library',
		icon: ['fas', 'books'],
		label: 'Document Library',
		path: '/library',
		exact: true,
	},
	{
		icon: ['fas', 'user-crown'],
		label: 'Permissions',
		path: '/admin/permissions',
		exact: false,
		restrict: {
			permission: 'DOJ_JUDGE',
		},
	},
	...systemAdmin,
];

const districtattorney = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		path: '/',
		exact: true,
	},
	{
		name: 'roster',
		icon: ['fas', 'user-tie'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'reports',
		icon: ['fas', 'file-lines'],
		label: 'Reports',
		path: '/reports',
		submenu: false,
		exact: false,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-certificate'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'people',
		icon: ['fas', 'person'],
		label: 'People',
		path: '/people',
		submenu: false,
		exact: false,
	},
	{
		name: 'vehicles',
		icon: ['fas', 'cars'],
		label: 'Vehicles',
		path: '/vehicles',
		submenu: false,
		exact: false,
	},
	{
		name: 'properties',
		icon: ['fas', 'house-chimney'],
		label: 'Properties',
		path: '/properties',
		submenu: false,
		exact: false,
	},
	{
		name: 'firearms',
		icon: ['fas', 'gun'],
		label: 'Firearms',
		path: '/firearms',
		submenu: false,
		exact: false,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	{
		name: 'library',
		icon: ['fas', 'books'],
		label: 'Document Library',
		path: '/library',
		exact: true,
	},
	{
		icon: ['fas', 'user-crown'],
		label: 'Permissions',
		path: '/admin/permissions',
		exact: false,
		restrict: {
			permission: 'GOV_DA',
		},
	},
	...systemAdmin,
];

const medical = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		path: '/',
		exact: true,
	},
	{
		name: 'roster',
		icon: ['fas', 'user-doctor'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'reports',
		icon: ['fas', 'file-lines'],
		label: 'Reports',
		path: '/reports',
		submenu: false,
		exact: false,
	},
	{
		name: 'people',
		icon: ['fas', 'person'],
		label: 'People',
		path: '/people',
		submenu: false,
		exact: false,
	},
	{
		icon: ['fas', 'cars'],
		label: 'Fleet Manager',
		path: '/fleet-manager',
		exact: false,
		restrict: {
			permission: 'FLEET_MANAGEMENT',
		},
	},
	{
		name: 'library',
		icon: ['fas', 'books'],
		label: 'Document Library',
		path: '/library',
		exact: true,
	},
	{
		icon: ['fas', 'user-crown'],
		label: 'Permissions',
		path: '/admin/permissions',
		exact: false,
		restrict: {
			permission: 'SAFD_HIGH_COMMAND',
		},
	},
	...systemAdmin,
];

const doc = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		path: '/',
		exact: true,
	},
	{
		name: 'roster',
		icon: ['fas', 'user-tie'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'reports',
		icon: ['fas', 'file-lines'],
		label: 'Reports',
		path: '/reports',
		submenu: false,
		exact: false,
	},
	{
		name: 'prisoners',
		icon: ['fas', 'handcuffs'],
		label: 'Inmate Management',
		path: '/prisoners',
		exact: false,
	},
	{
		name: 'people',
		icon: ['fas', 'person'],
		label: 'People',
		path: '/people',
		submenu: false,
		exact: false,
	},
	{
		icon: ['fas', 'cars'],
		label: 'Fleet Manager',
		path: '/fleet-manager',
		exact: false,
		restrict: {
			permission: 'FLEET_MANAGEMENT',
		},
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	{
		name: 'library',
		icon: ['fas', 'books'],
		label: 'Document Library',
		path: '/library',
		exact: true,
	},
	{
		icon: ['fas', 'user-crown'],
		label: 'Permissions',
		path: '/admin/permissions',
		exact: false,
		restrict: {
			permission: 'DOC_HIGH_COMMAND',
		},
	},
	...systemAdmin,
];

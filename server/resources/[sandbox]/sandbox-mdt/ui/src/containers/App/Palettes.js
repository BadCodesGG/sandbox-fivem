export const GetDeptPalette = (workplace, theme) => {
	switch (workplace) {
		case 'lspd':
			return LSPDPalette(theme);
		case 'bcso':
			return BCSOPalette(theme);
		case 'sast':
			return SASTPalette(theme);
		case 'guardius':
			return GuardiusPalette(theme);
		case 'doj':
		case 'dattorney':
		case 'mayoroffice':
			return DOJPalette(theme);
		case 'doctors':
		case 'safd':
			return MedicalPalette(theme);
		default:
			return StandardPalette(theme);
	}
};

export const LSPDPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#bd9239',
			light: '#d1ae67',
			dark: '#6d5421',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#10121b' : '#ffffff',
			light: theme === 'dark' ? '#202435' : '#F5F6F4',
			dark: theme === 'dark' ? '#0b0c12' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const GuardiusPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#bd9239',
			light: '#d1ae67',
			dark: '#6d5421',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#141414' : '#ffffff',
			light: theme === 'dark' ? '#1c1c1c' : '#F5F6F4',
			dark: theme === 'dark' ? '#0f0f0f' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const BCSOPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#b2882e',
			light: '#d6b161',
			dark: '#9e7829',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#313023' : '#ffffff',
			light: theme === 'dark' ? '#95926a' : '#F5F6F4',
			dark: theme === 'dark' ? '#323123' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const SASTPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#677aa8',
			light: '#a5b0cb',
			dark: '#343f5a',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#393939' : '#ffffff',
			light: theme === 'dark' ? '#808080' : '#F5F6F4',
			dark: theme === 'dark' ? '#2a2a2a' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const DOJPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#009688',
			light: '#52c7b8',
			dark: '#00675b',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#1e1e1e' : '#ffffff',
			light: theme === 'dark' ? '#313131' : '#F5F6F4',
			dark: theme === 'dark' ? '#151515' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const MedicalPalette = (theme) => {
	return {
		...StandardPalette(theme),
		primary: {
			main: '#7b9ff2',
			light: '#9ec2ff',
			dark: '#4259c3',
			contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
		},
		secondary: {
			main: theme === 'dark' ? '#1e1e1e' : '#ffffff',
			light: theme === 'dark' ? '#313131' : '#F5F6F4',
			dark: theme === 'dark' ? '#151515' : '#EBEBEB',
			contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
		},
	};
};

export const StandardPalette = (theme) => {
	return {
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
			main: theme === 'dark' ? '#ffffff' : '#2e2e2e',
			alt: theme === 'dark' ? 'rgba(255, 255, 255, 0.7)' : '#858585',
			info: theme === 'dark' ? '#919191' : '#919191',
			light: '#ffffff',
			dark: '#000000',
		},
		alt: {
			green: '#008442',
			greenDark: '#064224',
		},
		border: {
			main: theme === 'dark' ? '#e0e0e008' : '#e0e0e008',
			light: '#ffffff',
			dark: '#26292d',
			input: theme === 'dark' ? 'rgba(255, 255, 255, 0.23)' : 'rgba(0, 0, 0, 0.23)',
			divider: theme === 'dark' ? 'rgba(255, 255, 255, 0.12)' : 'rgba(0, 0, 0, 0.12)',
		},
		mode: theme,
	};
};

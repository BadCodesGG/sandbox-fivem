const colorDict = [
	{
		hex: '#13181f',
		name: 'Black',
	},
	{
		hex: '#1c1d21',
		name: 'Graphite Black',
	},
	{
		hex: '#32383d',
		name: 'Black Steal',
	},
	{
		hex: '#454b4f',
		name: 'Dark Silver',
	},
	{
		hex: '#d3d3d3',
		name: 'Silver',
	},
	{
		hex: '#b7bfca',
		name: 'Blue Silver',
	},
	{
		hex: '#979a97',
		name: 'Steel Gray',
	},
	{
		hex: '#637380',
		name: 'Shadow Silver',
	},
	{
		hex: '#63625c',
		name: 'Stone Silver',
	},
	{
		hex: '#3c3f47',
		name: 'Midnight Silver',
	},
	{
		hex: '#39434d',
		name: 'Gun Metal',
	},
	{
		hex: '#1d2129',
		name: 'Anthracite Grey',
	},
	{
		hex: '#26282a',
		name: 'Gray',
	},
	{
		hex: '#515554',
		name: 'Light Grey',
	},
	{
		hex: '#363a3f',
		name: 'Graphite',
	},
	{
		hex: '#a0a199',
		name: 'Silver Grey',
	},
	{
		hex: '#d44a17',
		name: 'Sunrise Orange',
	},
	{
		hex: '#c2944f',
		name: 'Classic Gold',
	},
	{
		hex: '#f6ae20',
		name: 'Orange',
	},
	{
		hex: '#a94744',
		name: 'Red',
	},
	{
		hex: '#371c25',
		name: 'Dark Red',
	},
	{
		hex: '#ffc91f',
		name: 'Yellow',
	},
	{
		hex: '#de0f18',
		name: 'Bright Red',
	},
	{
		hex: '#8f1e17',
		name: 'Garnet Red',
	},
	{
		hex: '#b16c51',
		name: 'Golden Red',
	},
	{
		hex: '#2d423f',
		name: 'Dark Green',
	},
	{
		hex: '#122e2b',
		name: 'Racing Green',
	},
	{
		hex: '#12383c',
		name: 'Sea Green',
	},
	{
		hex: '#31423f',
		name: 'Olive Green',
	},
	{
		hex: '#b0ee6e',
		name: 'Green',
	},
	{
		hex: '#66b81f',
		name: 'Lime Green',
	},
	{
		hex: '#65867f',
		name: 'Sea Wash',
	},
	{
		hex: '#1c3551',
		name: 'Midnight Blue',
	},
	{
		hex: '#0b1421',
		name: 'Dark Blue',
	},
	{
		hex: '#304c7e',
		name: 'Saxony Blue',
	},
	{
		hex: '#08e9fa',
		name: 'Blue',
	},
	{
		hex: '#637ba7',
		name: 'Mariner Blue',
	},
	{
		hex: '#394762',
		name: 'Harbor Blue',
	},
	{
		hex: '#d6e7f1',
		name: 'Diamond Blue',
	},
	{
		hex: '#76afbe',
		name: 'Surf Blue',
	},
	{
		hex: '#345e72',
		name: 'Nautical Blue',
	},
	{
		hex: '#3b39e0',
		name: 'Bright Blue',
	},
	{
		hex: '#2f2d52',
		name: 'Purple Blue',
	},
	{
		hex: '#282c4d',
		name: 'Spinnaker Blue',
	},
	{
		hex: '#2354a1',
		name: 'Ultra Blue',
	},
	{
		hex: '#2446a8',
		name: 'Lightning blue',
	},
	{
		hex: '#4cc3da',
		name: 'Light Blue',
	},
	{
		hex: '#916532',
		name: 'Bronze',
	},
	{
		hex: '#98d223',
		name: 'Lime',
	},
	{
		hex: '#2a282b',
		name: 'Dark Brown',
	},
	{
		hex: '#453831',
		name: 'Brown',
	},
	{
		hex: '#b5a079',
		name: 'Light Brown',
	},
	{
		hex: '#726c57',
		name: 'Beige',
	},
	{
		hex: '#6c6b4b',
		name: 'Moss Brown',
	},
	{
		hex: '#402e2b',
		name: 'Biston Brown',
	},
	{
		hex: '#a4965f',
		name: 'Beechwood',
	},
	{
		hex: '#46231a',
		name: 'Dark Beechwood',
	},
	{
		hex: '#752b19',
		name: 'Choco Orange',
	},
	{
		hex: '#bfae7b',
		name: 'Beach Sand',
	},
	{
		hex: '#f7edd5',
		name: 'Cream',
	},
	{
		hex: '#785f33',
		name: 'Medium Brown',
	},
	{
		hex: '#fffffb',
		name: 'White',
	},
	{
		hex: '#eaeaea',
		name: 'Frost White',
	},
	{
		hex: '#b0ab94',
		name: 'Honey Beige',
	},
	{
		hex: '#5870a1',
		name: 'Chrome',
	},
	{
		hex: '#eae6de',
		name: 'Off White',
	},
	{
		hex: '#f9a458',
		name: 'Light Orange',
	},
	{
		hex: '#00ff8b',
		name: 'Mint',
	},
	{
		hex: '#f1cc40',
		name: 'Light Yellow',
	},
	{
		hex: '#81844c',
		name: 'Olive Army Green',
	},
	{
		hex: '#ffffff',
		name: 'Pure White',
	},
	{
		hex: '#f21f99',
		name: 'Hot Pink',
	},
	{
		hex: '#fdd6cd',
		name: 'Salmon pink',
	},
	{
		hex: '#df5891',
		name: 'Vermillion Pink',
	},
	{
		hex: '#9f9e8a',
		name: 'Hunter Green',
	},
	{
		hex: '#621276',
		name: 'Purple',
	},
	{
		hex: '#1e1d22',
		name: 'Dark Purple',
	},
	{
		hex: '#bc1917',
		name: 'Lava Red',
	},
	{
		hex: '#2d362a',
		name: 'Forest Green',
	},
	{
		hex: '#696748',
		name: 'Olive Drab',
	},
	{
		hex: '#7a6c55',
		name: 'Desert Brown',
	},
	{
		hex: '#c3b492',
		name: 'Desert Tan',
	},
	{
		hex: '#5a6352',
		name: 'Foilage Green',
	},
	{
		hex: '#7f6a48',
		name: 'Brushed Gold',
	},
];

const Hex2RGB = function (hex) {
	if (hex.lastIndexOf('#') > -1) {
		hex = hex.replace(/#/, '0x');
	} else {
		hex = '0x' + hex;
	}
	var r = hex >> 16;
	var g = (hex & 0x00ff00) >> 8;
	var b = hex & 0x0000ff;
	return { r: r, g: g, b: b };
};

export const GetCloseColorName = (r, g, b) => {
	let rgb = { r: r, g: g, b: b };
	let delta = 3 * 256 * 256;
	let temp = { r: 0, g: 0, b: 0 };
	let nameFound = 'Black';

	for (let i = 0; i < colorDict.length; i++) {
		temp = Hex2RGB(colorDict[i].hex);
		if (Math.pow(temp.r - rgb.r, 2) + Math.pow(temp.g - rgb.g, 2) + Math.pow(temp.b - rgb.b, 2) < delta) {
			delta = Math.pow(temp.r - rgb.r, 2) + Math.pow(temp.g - rgb.g, 2) + Math.pow(temp.b - rgb.b, 2);
			nameFound = colorDict[i].name;
		}
	}

	return nameFound;
};

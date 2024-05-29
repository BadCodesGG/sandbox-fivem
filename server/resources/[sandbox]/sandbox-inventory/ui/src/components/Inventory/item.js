const lua2json = (lua) =>
	JSON.parse(
		lua
			.replace(/\[([^\[\]]+)\]\s*=/g, (s, k) => `${k} :`)
			.replace(/,(\s*)\}/gm, (s, k) => `${k}}`),
	);

const getItemImage = (item, itemData) => {
	const metadata = Boolean(item?.MetaData)
		? typeof item?.MetaData == 'string'
			? lua2json(item.MetaData)
			: item.MetaData
		: Object();

	const smd = Boolean(itemData?.staticMetadata)
		? typeof itemData?.staticMetadata == 'string'
			? lua2json(itemData?.staticMetadata)
			: itemData?.staticMetadata
		: Object();

	if (metadata?.CustomItemImage) {
		return metadata?.CustomItemImage;
	} else if (smd?.CustomItemImage) {
		return smd?.CustomItemImage;
	} else if (Boolean(itemData) && Boolean(itemData.iconOverride)) {
		return `../images/items/${itemData.iconOverride}.webp`;
	} else {
		return `../images/items/${itemData.name}.webp`;
	}
};

const getItemLabel = (item, itemData) => {
	const metadata = Boolean(item?.MetaData)
		? typeof item?.MetaData == 'string'
			? lua2json(item.MetaData)
			: item.MetaData
		: Object();

	if (metadata?.CustomItemLabel) {
		return metadata?.CustomItemLabel;
	} else {
		return itemData?.label ?? 'Unknown';
	}
};

const fallbackItem = {
	name: 'ph',
	label: 'Invalid Item',
	description:
		"An item in your inventory is missing its item definition, try /reloaditems and if this doesn't fix it please report this",
	invalid: true,
	price: 0,
	isStackable: false,
	type: -1,
	rarity: -1,
	weight: 0,
};

const itemLabels = {
	1: 'Consumable',
	2: 'Weapon',
	3: 'Tool',
	4: 'Crafting Ingredient',
	5: 'Collectable',
	6: 'Junk',
	7: 'Unknown',
	8: 'Evidence',
	9: 'Ammunition',
	10: 'Container',
	11: 'Gem',
	12: 'Paraphernalia',
	13: 'Wearable',
	14: 'Contraband',
	15: 'Collectable (Gang Chain)',
	16: 'Weapon Attachment',
	17: 'Crafting Schematic',
	18: 'Device',
	19: 'Explosive Device',
};

const itemRarities = {
	1: 'Common',
	2: 'Uncommon',
	3: 'Rare',
	4: 'Epic',
	5: 'Objective',
	6: 'Legendary',
	7: 'Exotic',
};

export { getItemImage, getItemLabel, fallbackItem, itemLabels, itemRarities };

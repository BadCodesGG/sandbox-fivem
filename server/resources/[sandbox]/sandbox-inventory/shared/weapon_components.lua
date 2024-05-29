_weaponModels = _weaponModels or {}

WEAPON_COMPS = {
	WEAPON_AR15 = {
		{
			type = "body",
			attachment = "COMPONENT_BEOWULF_BODY_06",
		},
		{
			type = "magazine",
			attachment = "COMPONENT_AR15_CLIP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_BEOWULF_SCOPE_01",
		},
	},
	WEAPON_AR15_PD = {
		{
			type = "body",
			attachment = "COMPONENT_BEOWULF_BODY_06",
		},
		{
			type = "magazine",
			attachment = "COMPONENT_AR15_PD_CLIP_02",
		},
		{
			type = "optic",
			attachment = "COMPONENT_BEOWULF_SCOPE_09",
		},
		{
			type = "flashlight",
			attachment = "COMPONENT_BEOWULF_FLSH_01",
		},
		{
			type = "grip",
			attachment = "COMPONENT_BEOWULF_GRIP_04",
		},
	},
	WEAPON_50BEOWULF = {
		{
			type = "body",
			attachment = "COMPONENT_BEOWULF_BODY_06",
		},
		{
			type = "magazine",
			attachment = "COMPONENT_BEOWULF_CLIP_01",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_BEOWULF_SUPP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_BEOWULF_SCOPE_01",
		},
	},
	WEAPON_HKUMP = {
		{
			type = "stock",
			attachment = "COMPONENT_UMP_STOCK_01",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_UMP_SUPP_01",
		},
		{
			type = "magazine",
			attachment = "COMPONENT_UMP_CLIP_01",
		},
	},
	WEAPON_HKUMP_PD = {
		{
			type = "stock",
			attachment = "COMPONENT_UMP_STOCK_01",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_UMP_SUPP_01",
		},
		{
			type = "magazine",
			attachment = "COMPONENT_UMP_PD_CLIP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_UMP_SCOPE_04",
		},
		{
			type = "grip",
			attachment = "COMPONENT_UMP_GRIP_03",
		},
		{
			type = "flashlight",
			attachment = "COMPONENT_UMP_FLSH_03",
		},
	},
	WEAPON_HK416B = {
		{
			type = "magazine",
			attachment = "COMPONENT_HK416B_CLIP_01",
		},
	},
	WEAPON_P90FM = {
		{
			type = "optic",
			attachment = "COMPONENT_P90_SCOPE_01",
		},
		{
			type = "magazine",
			attachment = "COMPONENT_P90_CLIP",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_P90_BARREL_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_P90_BUTTPAD_01",
		},
	},
	WEAPON_MPX = {
		{
			type = "optic",
			attachment = "COMPONENT_MPX_SCOPE_01",
		},
		{
			type = "magazine",
			attachment = "COMPONENT_MPX_CLIP_01",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_MPX_BARREL_07",
		},
		{
			type = "grip",
			attachment = "COMPONENT_MPX_HANDGUARD_03",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MPX_STOCK_10",
		},
	},
	WEAPON_MP9A = {
		{
			type = "magazine",
			attachment = "COMPONENT_MP9A_CLIP_01",
		},
	},
	WEAPON_PP19 = {
		{
			type = "magazine",
			attachment = "COMPONENT_PP19_CLIP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_PP19_SCOPE_01",
		},
		{
			type = "grip",
			attachment = "COMPONENT_PP19_HANDGUARD_01",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_PP19_MUZZLE_01",
		},
	},
	WEAPON_MP5 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MP5_CLIP_01",
		},
	},
	WEAPON_MINIUZI = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODSUZI_CLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MARKOMODSUZI_STOCK_01",
		},
	},
	WEAPON_AK74 = {
		{
			type = "magazine",
			attachment = "COMPONENT_AK74_CLIP_03",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_AK74_MUZ_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_AK74_STOCK_02",
		},
	},
	WEAPON_AK74_1 = {
		{
			type = "magazine",
			attachment = "COMPONENT_AK74_CLIP_04",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_AK74_MUZ_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_AK74_STOCK_01",
		},
	},
	WEAPON_G36 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODSG36_CLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MARKOMODSG36_STOCK_02",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_MARKOMODSG36_BARREL_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_MARKOMODSG36_SCOPE_01",
		},
	},
	WEAPON_RPK16 = {
		{
			type = "magazine",
			attachment = "COMPONENT_RPK16_CLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_RPK16_STOCK_01",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_RPK16_BARREL_01",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_RPK16_MUZZLE_01",
		},
	},
	WEAPON_MG = {
		{
			type = "magazine",
			attachment = "COMPONENT_MG_CLIP_01",
		},
	},
	WEAPON_COMBATMG = {
		{
			type = "magazine",
			attachment = "COMPONENT_COMBATMG_CLIP_01",
		},
	},
	WEAPON_COMBATMG_MK2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_COMBATMG_MK2_CLIP_01",
		},
	},
	WEAPON_COMBATMG_MK2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_COMBATMG_MK2_CLIP_01",
		},
	},
	WEAPON_ASSAULTRIFLE = {
		{
			type = "magazine",
			attachment = "COMPONENT_ASSAULTRIFLE_CLIP_01",
		},
	},
	WEAPON_ASSAULTRIFLE_MK2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_01",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_AT_AR_BARREL_01",
		},
	},
	WEAPON_CARBINERIFLE = {
		{
			type = "magazine",
			attachment = "COMPONENT_CARBINERIFLE_CLIP_01",
		},
	},
	WEAPON_CARBINERIFLE_MK2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_01",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_AT_CR_BARREL_01",
		},
	},
	WEAPON_BULLPUPRIFLE = {
		{
			type = "magazine",
			attachment = "COMPONENT_BULLPUPRIFLE_CLIP_01",
		},
	},
	WEAPON_BULLPUPRIFLE_MK2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_BULLPUPRIFLE_MK2_CLIP_01",
		},
	},
	WEAPON_MUSKET = {},
	WEAPON_BEANBAG = {
		{
			type = "magazine",
			attachment = "COMPONENT_BEANBAG_CLIP_01",
		},
	},
	WEAPON_COMPACTRIFLE = {
		{
			type = "magazine",
			attachment = "COMPONENT_COMPACTRIFLE_CLIP_01",
		},
	},
	WEAPON_ASSAULTSMG = {
		{
			type = "magazine",
			attachment = "COMPONENT_ASSAULTSMG_CLIP_01",
		},
	},
	WEAPON_GUSENBERG = {
		{
			type = "magazine",
			attachment = "COMPONENT_GUSENBERG_CLIP_01",
		},
	},
	WEAPON_COMBATPDW = {
		{
			type = "magazine",
			attachment = "COMPONENT_COMBATPDW_CLIP_01",
		},
	},
	WEAPON_SMG = {
		{
			type = "magazine",
			attachment = "COMPONENT_SMG_CLIP_01",
		},
	},
	WEAPON_SMG_MK2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_SMG_MK2_CLIP_01",
		},
	},
	WEAPON_MINISMG = {
		{
			type = "magazine",
			attachment = "COMPONENT_MINISMG_CLIP_01",
		},
	},
	WEAPON_MAC10 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MICROSMG_CLIP_01",
		},
	},
	WEAPON_BULLPUPSHOTGUN = {
		{
			type = "magazine",
			attachment = "COMPONENT_BULLPUPSHOTGUN_CLIP_01",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_AT_AR_SUPP_02",
		}
	},
	WEAPON_HEAVYSHOTGUN = {
		{
			type = "magazine",
			attachment = "COMPONENT_HEAVYSHOTGUN_CLIP_01",
		},
	},
	WEAPON_ASSAULTSHOTGUN = {
		{
			type = "magazine",
			attachment = "COMPONENT_ASSAULTSHOTGUN_CLIP_01",
		},
	},
	WEAPON_PUMPSHOTGUN = {},
	WEAPON_PUMPSHOTGUN_MK2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_PUMPSHOTGUN_MK2_CLIP_01",
		},
	},
	WEAPON_DBSHOTGUN = {},
	WEAPON_SAWNOFFSHOTGUN = {},
	WEAPON_SNIPERRIFLE2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_SNIPERRIFLE2_CLIP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_AT_SCOPE_LARGE",
		},
	},
	WEAPON_FM1_HONEYBADGER = {
		{
			type = "magazine",
			attachment = "COMPONENT_FMCLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_FM1_HONEYBADGER_STOCK_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_FMSCOPE_41",
		},
	},
	WEAPON_ASVAL = {
		{
			type = "magazine",
			attachment = "COMPONENT_ASVAL_CLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_ASVAL_STOCK_01",
		},
	},
	WEAPON_DOUBLEBARRELFM = {
		{
			type = "barrel",
			attachment = "COMPONENT_DOUBLEBARREL_BARREL_01",
		},
		{
			type = "magazine",
			attachment = "COMPONENT_DBSHOTGUN_CLIP_01",
		},
	},
	WEAPON_FM1_HK416 = {
		{
			type = "magazine",
			attachment = "COMPONENT_FMCLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_FMSTOCK_26",
		},
		{
			type = "optic",
			attachment = "COMPONENT_FMSCOPE_01",
		},
	},
	WEAPON_FM2_HK416 = {
		{
			type = "magazine",
			attachment = "COMPONENT_FMCLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_FMSTOCK_26",
		},
		{
			type = "optic",
			attachment = "COMPONENT_FMSCOPE_01",
		},
	},
	WEAPON_HK417 = {
		{
			type = "magazine",
			attachment = "COMPONENT_HK417_CLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_FMSTOCK_04",
		},
		{
			type = "optic",
			attachment = "COMPONENT_HK417_IRONSIGHT_01",
		},
		{
			type = "body",
			attachment = "COMPONENT_HK417_FRAME_01",
		},
	},
	WEAPON_PM4 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODS_SHARED_556MAG_01",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_MARKOMODS_PM4_MUZZLE_1",
		},
		{
			type = "optic",
			attachment = "COMPONENT_MARKOMODS_PM4_SCOPE_1",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MARKOMODS_SHARED_STOCK_03",
		},
	},
	WEAPON_M249 = {
		{
			type = "magazine",
			attachment = "COMPONENT_M249_CLIP_01",
		},
		{
			type = "grip",
			attachment = "COMPONENT_M249_BIPOD_01",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_M249_BARREL_01",
		},
	},
	WEAPON_MCXRATTLER = {
		{
			type = "magazine",
			attachment = "COMPONENT_FMCLIP_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_FMSTOCK_16",
		},
		{
			type = "optic",
			attachment = "COMPONENT_FMSCOPE_22",
		},
	},
	WEAPON_MCXSPEAR = {
		{
			type = "magazine",
			attachment = "COMPONENT_MCXSPEAR_CLIP_01",
		},
		{
			type = "body",
			attachment = "COMPONENT_MCXSPEAR_BODY_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_MCXSPEAR_SCOPE_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MCXSPEAR_STOCK_01",
		},
	},
	WEAPON_MK14 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MK14_CLIP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_FMSCOPE_15",
		},
		{
			type = "stock",
			attachment = "COMPONENT_FMSTOCK_22",
		},
	},
	WEAPON_MK47BANSHEE = {
		{
			type = "magazine",
			attachment = "COMPONENT_MK47BANSHEE_CLIP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_FMSCOPE_09",
		},
		{
			type = "stock",
			attachment = "COMPONENT_FMSTOCK_05",
		},
	},
	WEAPON_MK47BANSHEE2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MK47BANSHEE_CLIP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_FMSCOPE_09",
		},
		{
			type = "stock",
			attachment = "COMPONENT_FMSTOCK_05",
		},
	},
	WEAPON_NSR9 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODS_NSR9_CLIP_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_MARKOMODS_NSR9_SCOPE_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MARKOMODS_NSR9_STOCK_05",
		},
		{
			type = "body",
			attachment = "COMPONENT_MARKOMODS_NSR9_BASE_01",
		},
	},
	WEAPON_RFB = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODS_RFB_CLIP_1",
		},
		{
			type = "body",
			attachment = "COMPONENT_MARKOMODS_RFB_BODY_1",
		},
		{
			type = "optic",
			attachment = "COMPONENT_MARKOMODS_SHARED_SCOPE_01",
		},
	},
	WEAPON_VECTOR = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODS_VECTOR_CLIP_1",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_MARKOMODS_VECTOR_BARREL_1",
		},
		{
			type = "optic",
			attachment = "COMPONENT_MARKOMODS_SHARED_SCOPE_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MARKOMODS_VECTOR_STOCK_1",
		},
	},
	WEAPON_BENELLIM2 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_CLIP_01",
		},
		{
			type = "grip",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_TUBE_01",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_BARREL_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_STOCK_01",
		},
	},
	WEAPON_BENELLIM2_PD = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_CLIP_01",
		},
		{
			type = "grip",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_TUBE_01",
		},
		{
			type = "barrel",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_BARREL_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_STOCK_01",
		},
		{
			type = "flashlight",
			attachment = "COMPONENT_MARKOMODSBENELLIM2_FLSH_01",
		},
	},
	WEAPON_MK47FM = {
		{
			type = "magazine",
			attachment = "COMPONENT_MK47_CLIP_01",
		},
	},
	WEAPON_MB47 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODS_SHARED_762MAG_1",
		},
		{
			type = "muzzle",
			attachment = "COMPONENT_MARKOMODS_MB47_MUZZLE_01",
		},
		{
			type = "stock",
			attachment = "COMPONENT_MARKOMODS_SHARED_STOCK_18",
		},
		{
			type = "optic",
			attachment = "COMPONENT_MARKOMODS_MB47_SCOPE_01",
		},
		{
			type = "grip",
			attachment = "COMPONENT_MARKOMODS_MB47_HANDGUARD_01",
		},
		{
			type = "body",
			attachment = "COMPONENT_MARKOMODS_MB47_BODY_01",
		},
	},
	WEAPON_SA80 = {
		{
			type = "magazine",
			attachment = "COMPONENT_MARKOMODS_SA80_CLIP_01",
		},
		{
			type = "grip",
			attachment = "COMPONENT_MARKOMODS_SA80_HANDGUARD_01",
		},
		{
			type = "optic",
			attachment = "COMPONENT_MARKOMODS_SA80_SCOPE_01",
		},
	},
	WEAPON_ADVANCEDRIFLE = {
		
	},
}

Citizen.CreateThread(function()
	if IsDuplicityVersion() then
		for k, v in pairs(WEAPON_COMPS) do
			WEAPON_PROPS[k] = true
			_weaponModels[k] = true
		end
	end
end)

Citizen.CreateThread(function()
	if not IsDuplicityVersion() then
		for k, v in pairs(WEAPON_COMPS) do
			local wHash = GetHashKey(k)
			RequestWeaponAsset(wHash, 31, 0)
			while not HasWeaponAssetLoaded(wHash) do
				Citizen.Wait(1)
			end
		end
	end
end)

Citizen.CreateThread(function()
	if not IsDuplicityVersion() then
		for k, v in pairs(WEAPON_COMPS) do
			for k2, v2 in ipairs(v) do
				local componentModel = GetWeaponComponentTypeModel(v2.attachment)
				RequestModel(componentModel)
				while not HasModelLoaded(componentModel) do
					Citizen.Wait(1)
				end
			end
		end
	end
end)

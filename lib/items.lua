meleeWeapons = {
    'weapon_dagger',
    'weapon_bat',
    -- 'weapon_battleaxe',
    'weapon_bottle',
    'weapon_crowbar',
    'weapon_hatchet',
    'weapon_hammer',
    'weapon_knife',
    'weapon_knuckle',
    'weapon_nightstick',
    'weapon_flashlight',
    'weapon_machete',
    -- 'weapon_wrench',
    -- 'weapon_poolcue',
    'weapon_golfclub',
    'weapon_switchblade'
}

pickupItems = {
    -- Handguns&新增部份mk2枪械
    { id = "PICKUP_WEAPON_PISTOL_MK2", name = "MK2手枪" },
    { id = "PICKUP_WEAPON_ASSAULTRIFLE_MK2", name = "MK2突击步枪" },
    { id = "PICKUP_WEAPON_CARBINERIFLE_MK2", name = "MK2卡宾步枪" },
    { id = "PICKUP_WEAPON_SMG_MK2", name = "MK2冲锋枪" },
    -- { id = "PICKUP_WEAPON_HEAVYPISTOL", name = "Heavy Pistol" },
    -- { id = "PICKUP_WEAPON_REVOLVER", name = "Heavy Revolver" },
    -- { id = "PICKUP_WEAPON_MARKSMANPISTOL", name = "Marksman Pistol" },
    -- { id = "PICKUP_WEAPON_PISTOL50", name = "Pistol .50" },
    -- { id = "PICKUP_WEAPON_SNSPISTOL", name = "SNS Pistol" },
    -- { id = "PICKUP_WEAPON_VINTAGEPISTOL", name = "Vintage Pistol" },

    --Shotguns
    { id = "PICKUP_WEAPON_ASSAULTSHOTGUN", name = "突击霰弹枪" },
    { id = "PICKUP_WEAPON_BULLPUPSHOTGUN", name = "犊牛式霰弹枪" },
    { id = "PICKUP_WEAPON_DBSHOTGUN", name = "双筒猎枪" },
    { id = "PICKUP_WEAPON_HEAVYSHOTGUN", name = "重型霰弹枪" },
    --{ id = "PICKUP_WEAPON_MUSKET", name = "Musket" },
    { id = "PICKUP_WEAPON_PUMPSHOTGUN", name = "泵动式霰弹枪" },
    { id = "PICKUP_WEAPON_SAWNOFFSHOTGUN", name = "削短型霰弹枪" },
    { id = "PICKUP_WEAPON_AUTOSHOTGUN", name = "打击者霰弹枪" },

    --Submachine Guns & Light Machine Guns
    { id = "PICKUP_WEAPON_ASSAULTSMG", name = "突击冲锋枪" },
    { id = "PICKUP_WEAPON_COMBATMG", name = "战斗机关枪" },
    { id = "PICKUP_WEAPON_COMBATPDW", name = "战斗 PDW" },
    { id = "PICKUP_WEAPON_GUSENBERG", name = "自动霰弹枪" },
    { id = "PICKUP_WEAPON_MACHINEPISTOL", name = "自动手枪" },
    { id = "PICKUP_WEAPON_MG", name = "机关枪" },
    { id = "PICKUP_WEAPON_MICROSMG", name = "微型冲锋枪" },
    { id = "PICKUP_WEAPON_MINISMG", name = "迷你冲锋枪" },
    { id = "PICKUP_WEAPON_SMG", name = "冲锋枪" },

    --Assault Rifles
    { id = "PICKUP_WEAPON_ADVANCEDRIFLE", name = "高阶步枪" },
    { id = "PICKUP_WEAPON_ASSAULTRIFLE", name = "突击步枪" },
    { id = "PICKUP_WEAPON_BULLPUPRIFLE", name = "犊牛式步枪" },
    { id = "PICKUP_WEAPON_CARBINERIFLE", name = "卡宾步枪" },
    { id = "PICKUP_WEAPON_COMPACTRIFLE", name = "战斗步枪" },
    { id = "PICKUP_WEAPON_SPECIALCARBINE", name = "特种卡宾枪" },

    --Thrown Weapons
    --{ id = "PICKUP_WEAPON_SMOKEGRENADE", name = "毒气弹" },
    { id = "PICKUP_WEAPON_GRENADE", name = "手榴弹" },
    { id = "PICKUP_WEAPON_MOLOTOV", name = "汽油弹" },
    { id = "PICKUP_WEAPON_PROXMINE", name = "感应式地雷" },
    { id = "PICKUP_WEAPON_PIPEBOMB", name = "土制地雷" },
    { id = "PICKUP_WEAPON_STICKYBOMB", name = "黏弹" },

    --Ammunition
    -- { id = "PICKUP_HEALTH_SNACK", color = 2, name = "Snack" },
    { id = "PICKUP_HEALTH_STANDARD", color = 2, name = "急救包" },
    { id = "PICKUP_ARMOUR_STANDARD", color = 3, name = "护甲包" },

    --Heavy Weapons
    --{ id = "PICKUP_WEAPON_COMPACTLAUNCHER", name = "Compact Grenade Launcher" },
    --{ id = "PICKUP_WEAPON_GRENADELAUNCHER", name = "Grenade Launcher" },
    --{ id = "PICKUP_WEAPON_RPG", name = "Rocket Laucher" },
    --{ id = "PICKUP_WEAPON_HOMINGLAUNCHER", name = "Homing Laucher" },
    --{ id = "PICKUP_WEAPON_MINIGUN", name = "Minigun" },

   --Sniper Rifles
    --{ id = "PICKUP_WEAPON_HEAVYSNIPER", name = "Heavy Sniper" },
    --{ id = "PICKUP_WEAPON_SNIPERRIFLE", name = "Sniper Rifle" },
    --{ id = "PICKUP_WEAPON_MARKSMANRIFLE", name = "Marksman Rifle" },

    --Ammo
    -- { id = "PICKUP_AMMO_PISTOL", name = "Pistol", ammo = true },
    -- { id = "PICKUP_AMMO_FLAREGUN", name = "Flare Gun", ammo = true },
    -- { id = "PICKUP_AMMO_RIFLE", name = "Rifle", ammo = true },
    -- { id = "PICKUP_AMMO_SHOTGUN", name = "Shotgun", ammo = true },
    -- { id = "PICKUP_AMMO_SMG", name = "SMG", ammo = true },
    -- { id = "PICKUP_AMMO_MG", name = "MG", ammo = true },
    -- { id = "PICKUP_AMMO_MINIGUN", name = "Minigun", ammo = true },
    -- { id = "PICKUP_AMMO_GRENADELAUNCHER", name = "Grenade Launcher", ammo = true },
    -- { id = "PICKUP_AMMO_HOMINGLAUNCHER", name = "Homing Launcher", ammo = true },
    -- { id = "PICKUP_AMMO_RPG", name = "RPG", ammo = true },
    -- { id = "PICKUP_AMMO_SNIPER", name = "Sniper", ammo = true },
}

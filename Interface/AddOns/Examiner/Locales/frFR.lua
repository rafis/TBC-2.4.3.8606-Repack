﻿if GetLocale() == "frFR" then
--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

BINDING_HEADER_EXAMINER = "Examiner";
BINDING_NAME_EXAMINER_OPEN = "Ouvrir Examiner";
BINDING_NAME_EXAMINER_TARGET = "Inspecter la cible";
BINDING_NAME_EXAMINER_MOUSEOVER = "Inspecter Mouseover";

Examiner.Classification = {
	["worldboss"] = BOSS,
	["rareelite"] = "Élite rare",
	["elite"] = ELITE,
	["rare"] = "Rare",
};

ExScanner.SetBonusTokenActive = "^Complet : ";
ExScanner.ItemUseToken = "^Utiliser : ";

--------------------------------------------------------------------------------------------------------
--                                           Stat Patterns                                            --
--------------------------------------------------------------------------------------------------------

ExScanner.Patterns = {
	--  Base Stats  --
	{ p = "%+(%d+) Force", s = "STR" },
	{ p = "%+(%d+) Agilité", s = "AGI" },
	{ p = "%+(%d+) Endurance", s = "STA" },
	{ p = "Endurance %+(%d+)", s = "STA" }, -- WORKAROUND: Infused Amethyst (31116)
	{ p = "%+(%d+) Intelligence", s = "INT" },
	{ p = "%+(%d+) Esprit", s = "SPI" },
	{ p = "Armure : (%d+)", s = "ARMOR" },
	{ p = "%+(%d+) Armure", s = "ARMOR" },

	--  Resistances (Exclude the Resist-"ance" then it picks up armor patches as well)  --
	{ p = "%+(%d+) à la résistance Arcane", s = "ARCANERESIST" },
	{ p = "%+(%d+) à la résistance Feu", s = "FIRERESIST" },
	{ p = "%+(%d+) à la résistance Nature", s = "NATURERESIST" },
	{ p = "%+(%d+) à la résistance Givre", s = "FROSTRESIST" },
	{ p = "%+(%d+) à la résistance Ombre", s = "SHADOWRESIST" },
	{ p = "%+(%d+) à toutes les résistances", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },

	--  Equip: Other  --
	{ p = "Augmente de (%d+) le score de résilience%.", s = "RESILIENCE" },

	{ p = "Augmente le score de défense de (%d+)%.", s = "DEFENSE" },
	{ p = "Score de défense augmenté de (%d+)%.", s = "DEFENSE" },

	{ p = "Augmente de (%d+) le score d'esquive%.", s = "DODGE" },
	{ p = "Augmente votre score d'esquive de (%d+)%.", s = "DODGE" },

	{ p = "Augmente de (%d+) le score de parade%.", s = "PARRY" },
	{ p = "Augmente votre score de parade de (%d+)%.", s = "PARRY" },

	{ p = "Augmente de (%d+) le score de blocage%.", s = "BLOCK" },
	{ p = "Augmente votre score de blocage de (%d+)%.", s = "BLOCK" },

	{ p = "Augmente la valeur de blocage de votre bouclier de (%d+)%.", s = "BLOCKVALUE" },
	{ p = "Bloquer : (%d+)", s = "BLOCKVALUE" },

	--  Equip: Melee & Ranged  --
	{ p = "Augmente de (%d+) le score de coup critique%.", s = "CRIT" },
	{ p = "Augmente votre score de coup critique de (%d+)%.", s = "CRIT" },

	{ p = "Augmente de (%d+) le score de toucher%.", s = "HIT" },
	{ p = "Augmente votre score de toucher de (%d+)%.", s = "HIT" },

	{ p = "Augmente de (%d+) la puissance d'attaque%.", s = "AP" },
	{ p = "Augmente la puissance des attaques à distance de (%d+)%.", s = "RAP" },
	{ p = "Augmente de (%d+) la puissance d'attaque pour les formes de félin, d'ours, d'ours redoutable et de sélénien uniquement%.", s = "APFERAL" },

	{ p = "Augmente de (%d+) le score de hâte%.", s = "HASTE" },
	{ p = "Augmente votre score d'expertise de (%d+)%.", s = "EXPERTISE" },
	{ p = "Vos attaques ignorent (%d+) points de l'armure de votre adversaire%.", s = "ARMORPENETRATION" },

	--  Equip: Magic --
	{ p = "Augmente de (%d+) le score de coup critique des sorts%.", s = "SPELLCRIT" },
	{ p = "Augmente le score de coup critique des sorts de (%d+)%.", s = "SPELLCRIT" },

	{ p = "Augmente de (%d+) le score de toucher des sorts%.", s = "SPELLHIT" },
	{ p = "Augmente le score de toucher des sorts de (%d+)%.", s = "SPELLHIT" },

	{ p = "Augmente de (%d+) le score de hâte des sorts%.", s = "SPELLHASTE" },
	{ p = "Augmente la pénétration de vos sorts de (%d+)%.", s = "SPELLPENETRATION" },

	{ p = "Augmente les soins prodigués d'un maximum de (%d+) et les dégâts d'un maximum de (%d+) pour tous les sorts et effets magiques%.", s = { "HEAL", "SPELLDMG" } }, -- New 2.3 Heal/SpellDmg
	{ p = "Augmente les dégâts et les soins produits par les sorts et effets magiques de (%d+) au maximum%.", s = { "SPELLDMG", "HEAL" } },
	{ p = "Augmente légèrement les dégâts et les soins produits par les sorts et effets magiques.%.", s = { "SPELLDMG", "HEAL" }, v = 6 },

	{ p = "dégâts infligés par les sorts et effets des Arcanes de (%d+) au maximum%.", s = "ARCANEDMG" },
	{ p = "dégâts infligés par les sorts et effets de Feu de (%d+) au maximum%.", s = "FIREDMG" },
	{ p = "dégâts infligés par les sorts et effets de Nature de (%d+) au maximum%.", s = "NATUREDMG" },
	{ p = "dégâts infligés par les sorts et effets de Givre de (%d+) au maximum%.", s = "FROSTDMG" },
	{ p = "dégâts infligés par les sorts et effets d'Ombre de (%d+) au maximum%.", s = "SHADOWDMG" },
	{ p = "dégâts infligés par les sorts et effets du Sacré (%d+) au maximum%.", s = "HOLYDMG" },

	--  Health & Mana Per 5 Sec  --
	{ p = "(%d+) points de mana toutes les 5 sec", s = "MP5" },
	{ p = "%+(%d+) à la régén. de mana", s = "MP5" },
	{ p = "%+(%d+) Régén. de mana", s = "MP5" },

	{ p = "Rend (%d+) points de vie toutes les 5 sec%.", s = "HP5" },

	--  Enchants / Gems / Socket Bonuses / Mixed / Misc  --
	{ p = "^%+(%d+) PV$", s = "HP" },
	{ p = "^%+(%d+) points de vie$", s = "HP" },
	{ p = "^%+(%d+) points de mana$", s = "MP" },

	{ p = "^Vitalité$", s = { "MP5", "HP5" }, v = 4 },
	{ p = "^Sauvagerie$", s = "AP", v = 70 },
	{ p = "^Pied sûr$", s = "HIT", v = 10 },
	{ p = "^Âme de givre$", s = { "FROSTDMG", "SHADOWDMG" }, v = 54 },
	{ p = "^Feu solaire$", s = { "ARCANEDMG", "FIREDMG" }, v = 50 },

	{ p = "%+(%d+) à toutes les caractéristiques", s = { "STR", "AGI", "STA", "INT", "SPI" } },

	{ p = "%+(%d+) au score de résilience", s = "RESILIENCE" },
	{ p = "%+(%d+) au score d'esquive", s = "DODGE" },
	{ p = "%+(%d+) au score de parade", s = "PARRY" },
	{ p = "%+(%d+) au score de défense", s = "DEFENSE" },

	{ p = "%+(%d+) à la puissance d'attaque", s = "AP" },

	{ p = "%+(%d+) au score de coup critique|r$", s = "CRIT" },
	{ p = "%+(%d+) au score de coup critique et", s = "CRIT" },
	{ p = "%+(%d+) au score de coup critique$", s = "CRIT" },
	{ p = "%+(%d+) au score de critique$", s = "CRIT" },
	{ p = "%+(%d+) au score de toucher|r$", s = "HIT" },
	{ p = "%+(%d+) au score de toucher$", s = "HIT" },

	{ p = "%+(%d+) aux sorts de soins", s = "HEAL"},
	{ p = "%+(%d+) aux soins", s = "HEAL"},
	{ p = "%+(%d+) aux dégâts des sorts", s = "SPELLDMG" },
	{ p = "%+(%d+) à la puissance des sorts", s = "SPELLDMG" },

	{ p = "%+(%d+) au score de toucher des sorts", s = "SPELLHIT" },
	{ p = "%+(%d+) au score de coup critique des sorts", s = "SPELLCRIT" },
	{ p = "%+(%d+) au score de critique des sorts", s = "SPELLCRIT" },
	{ p = "%+(%d+) à la pénétration des sorts", s = "SPELLPENETRATION" },


	{ p = "%+(%d+) aux  dégâts des sorts des Arcanes", s = "ARCANEDMG" },
	{ p = "%+(%d+) aux dégâts des sorts de Feu", s = "FIREDMG" },
	{ p = "%+(%d+) aux dégâts des sorts de Nature", s = "NATUREDMG" },
	{ p = "%+(%d+) aux dégâts des sorts de Givre", s = "FROSTDMG" },
	{ p = "%+(%d+) aux dégâts des sorts d'Ombre", s = "SHADOWDMG" },
	{ p = "%+(%d+) aux dégâts des sorts du Sacré", s = "HOLYDMG" },

--[[	{ p = "%+(%d+) S?h?i?e?l?d? ?Block Rating", s = "BLOCK" }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]

	{ p = "%+(%d+) Block Value", s = "BLOCKVALUE" },

	{ p = "%+(%d+) Ranged Attack Power", s = "RAP" },
	{ p = "%+(%d+) Haste Rating", s = "HASTE" },
	{ p = "%+(%d+) Expertise Rating", s = "EXPERTISE" },

	{ p = "%+(%d+) Weapon Damage", s = "WPNDMG" },-]]
	{ p = "^Lunette %(%+(%d+) .* de dégâts%)$", s = "RANGEDDMG" },

	-- Demon's Blood
	{ p = "Augmente le score de défense de 5, la résistance à l'Ombre de 10 et votre régénération des points de vie normale de 3%.", s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 5, 10, 3 } },

	-- Void Star Talisman (Warlock T5 Class Trinket)
	{ p = "Augmente les résistances de votre familier de 130 et vos dégâts des sorts de 48 au maximum%.", s = "SPELLDMG", v = 48 },

};

--------------------------------------------------------------------------------------------------------
--                                        Stat Order & Naming                                         --
--------------------------------------------------------------------------------------------------------

Examiner.StatEntryOrder = {
	{ name = "Stats de base", stats = {"STR", "AGI", "STA", "INT", "SPI", "ARMOR"} },
	{ name = "Vie & Mana", stats = {"HP", "MP", "HP5", "MP5"} },
	{ name = "Stats en mêlée & à distance", stats = {"AP", "RAP", "APFERAL", "CRIT", "HIT", "HASTE", "WPNDMG", "RANGEDDMG", "ARMORPENETRATION", "EXPERTISE"} },
	{ name = "Stats des sorts", stats = {"HEAL", "SPELLDMG", "ARCANEDMG", "FIREDMG", "NATUREDMG", "FROSTDMG", "SHADOWDMG", "HOLYDMG", "SPELLCRIT", "SPELLHIT", "SPELLHASTE", "SPELLPENETRATION"} },
	{ name = "Stats défensives", stats = {"DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCKVALUE", "RESILIENCE"} },
};

ExScanner.StatNames = {
	["STR"] = "Force",
	["AGI"] = "Agilité",
	["STA"] = "Endurance",
	["INT"] = "Intelligence",
	["SPI"] = "Esprit",

	["ARMOR"] = "Armure",

	["ARCANERESIST"] = "Résistance aux Arcanes",
	["FIRERESIST"] = "Résistance au Feu",
	["NATURERESIST"] = "Résistance à la Nature",
	["FROSTRESIST"] = "Résistance au Givre",
	["SHADOWRESIST"] = "Résistance à l'Ombre",

	["DODGE"] = "Score d'esquive",
	["PARRY"] = "Score de parade",
	["DEFENSE"] = "Score de défense",
	["BLOCK"] = "Score de blocage",
	["BLOCKVALUE"] = "Valeur de blocage",
	["RESILIENCE"] = "Score de résilience",

	["AP"] = "Puissance d'attaque",
	["RAP"] = "Puissance d'attaque à distance",
	["APFERAL"] = "Puissance d'attaque (Farouche)",
	["CRIT"] = "Score de critique",
	["HIT"] = "Score de toucher",
	["HASTE"] = "Score de hâte",
	["WPNDMG"] = "Dégâts de l'arme",
	["RANGEDDMG"] = "Dégâts à distance",
	["ARMORPENETRATION"] = "Pénétration de l'armure",
	["EXPERTISE"] = "Score d'expertise",

	["SPELLCRIT"] = "Score de critique des sorts",
	["SPELLHIT"] = "Score de toucher des sorts",
	["SPELLHASTE"] = "Score de hâte des sorts",
	["SPELLPENETRATION"] = "Pénétration des sorts",

	["HEAL"] = "Soins",
	["SPELLDMG"] = "Dégâts des sorts",
	["ARCANEDMG"] = "Dégâts des sorts (Arcanes)",
	["FIREDMG"] = "Dégâts des sorts (Feu)",
	["NATUREDMG"] = "Dégâts des sorts (Nature)",
	["FROSTDMG"] = "Dégâts des sorts (Givre)",
	["SHADOWDMG"] = "Dégâts des sorts (Ombre)",
	["HOLYDMG"] = "Dégâts des sorts (Sacré)",

	["HP"] = "Points de vie",
	["MP"] = "Points de mana",

	["HP5"] = "Régén. vie par 5 sec",
	["MP5"] = "Régén. mana par 5 sec",
};
end

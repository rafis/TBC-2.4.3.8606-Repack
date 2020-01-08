local L = AceLibrary("AceLocale-2.2"):new("Automaton_Gossip")

L:RegisterTranslations("enUS", function() return {
	["Gossip"] = true,
	["Automatically complete quests and skip gossip text"] = true,

	--------------
	-- Gossip Text
	--------------

	["<Touch the unstable rift crystal.>"] = true,
	["<Place my hand on the orb.>"] = true,
	["Transport me to the Molten Core, Lothos."] = true,
	["Thank you, Stable Master. Please take the animal."] = true,
	["With pleasure. These things stink!"] = true,
	["Trick or Treat!"] = true,
	["Grant me your mark, wise ancient."] = true,
	["Grant me your mark, mighty ancient."] = true,
	["Please take me to the master's lair."] = true,
	["I need a pack of incendiary bombs."] = true,
	["I'm ready to go to Durholde Keep."] = true,
	["I require a chrono-beacon, Sa'at."] = true,
	["Naturalist, please grant me your boon."] = true,
	["I would be grateful for any aid you can provide, Priestess."] = true,

	-------------
	-- Quest Text
	-------------

	-- Fishing
	["Apprentice Angler"] = true,
	["Speckled Tastyfish"] = true,

	-- Alterac Valley quests
	["Empty Stables"] = true,
	["Ram Hide Harnesses"] = true,
	["Alterac Ram Hide"] = true,
	["Ram Riding Harnesses"] = true,
	["Frostwolf Hide"] = true,
	["More Booty!"] = true,
	["More Armor Scraps"] = true,
	["Armor Scraps"] = true,
	["Coldtooth Supplies"] = true,
	["Irondeep Supplies"] = true,
	["Lokholar the Ice Lord"] = true,
	["Stormpike Soldier's Blood"] = true,
	["A Gallon of Blood"] = true,
	["Ivus the Forest Lord"] = true,
	["Storm Crystal"] = true,
	["Crystal Cluster"] = true,
	["Call of Air - Slidore's Fleet"] = true,
	["Call of Air - Vipore's Fleet"] = true,
	["Call of Air - Ichman's Fleet"] = true,
	["Frostwolf Soldier's Medal"] = true,
	["Frostwolf Lieutenant's Medal"] = true,
	["Frostwolf Commander's Medal"] = true,
	["Call of Air - Guse's Fleet"] = true,
	["Call of Air - Jeztor's Fleet"] = true,
	["Call of Air - Mulverick's Fleet"] = true,
	["Stormpike Soldier's Flesh"] = true,
	["Stormpike Lieutenant's Flesh"] = true,
	["Stormpike Commander's Flesh"] = true,

	-- Felwood salves
	["Salve via Gathering"] = true,
	["Fel Creep"] = true,
	["Salve via Mining"] = true,
	["Tainted Vitriol"] = true,
	["Salve via Skinning"] = true,
	["Patch of Tainted Skin"] = true,
	["Salve via Hunting"] = true,
	["Corrupted Soul Shard"] = true,
	["Salve via Disenchanting"] = true,
	["Lesser Nether Essence"] = true,

	-- Felwood plants
	["Corrupted Whipper Root"] = true,
	["Corrupted Songflower"] = true,
	["Corrupted Windblossom"] = true,
	["Corrupted Night Dragon"] = true,
	["Cenarion Plant Salve"] = true,

	-- Ravenholdt
	["Syndicate Emblems"] = true,
	["Syndicate Emblem"] = true,

	-- Thorium Shells -> Thorium Arrows
	["A Fair Trade"] = true,
	["Thorium Shells"] = true,

	-- Cenarion
	["Encrypted Twilight Texts"] = true,
	["Encrypted Twilight Text"] = true,

	-- Argent Dawn
	["Minion's Scourgestones"] = true,
	["Minion's Scourgestone"] = true,
	["Invader's Scourgestones"] = true,
	["Invader's Scourgestone"] = true,
	["Corruptor's Scourgestones"] = true,
	["Corruptor's Scourgestone"] = true,
	["Bone Fragments"] = true,
	["Crypt Fiend Parts"] = true,
	["Core of Elements"] = true,
	["Dark Iron Scraps"] = true,

	-- Timbermaw
	["Feathers for Grazle"] = true,
	["Feathers for Nafien"] = true,
	["Beads for Salfa"] = true,
	["Deadwood Headdress Feather"] = true,
	["Winterfall Spirit Beads"] = true,

	-- Cauldron quests
	["Gahrron's Withering Cauldron"] = true,
	["Writhing Haunt Cauldron"] = true,
	["Felstone Field Cauldron"] = true,
	["Dalson's Tears Cauldron"] = true,
	["Arcane Quickener"] = true,
	["Ectoplasmic Resonator"] = true,
	["Somatic Intensifier"] = true,
	["Osseous Agitator"] = true,

	-- Gadgetzan
	["Water Pouch Bounty"] = true,
	["Wastewander Water Pouch"] = true,

	-- Thorium Brotherhood
	["Gaining Acceptance"] = true,
	["Dark Iron Residue"] = true,
	["Restoring Fiery Flux Supplies via Kingsblood"] = true,
	["Kingsblood"] = true,
	["Restoring Fiery Flux Supplies via Iron"] = true,
	["Iron Bar"] = true,
	["Restoring Fiery Flux Supplies via Heavy Leather"] = true,
	["Heavy Leather"] = true,
	["Incendosaur Scale"] = true,
	["Coal"] = true,
	["Favor Amongst the Brotherhood, Dark Iron Ore"] = true,
	["Dark Iron Ore"] = true,
	["Favor Amongst the Brotherhood, Blood of the Mountain"] = true,
	["Blood of the Mountain"] = true,
	["Favor Amongst the Brotherhood, Core Leather"] = true,
	["Core Leather"] = true,
	["Favor Amongst the Brotherhood, Fiery Core"] = true,
	["Fiery Core"] = true,
	["Favor Amongst the Brotherhood, Lava Core"] = true,
	["Lava Core"] = true,

	-- City faction
	["Additional Runecloth"] = true,
	["Runecloth"] = true,

	-- Wildhammer faction
	["Troll Necklace Bounty"] = true,
	["Troll Tribal Necklace"] = true,

	-- E'ko quests
	["Chillwind E'ko Item"] = "Chillwind E'ko",
	["Chillwind E'ko Quest"] = "Chillwind E'ko",
	["Frostmaul E'ko Item"] = "Frostmaul E'ko",
	["Frostmaul E'ko Quest"] = "Frostmaul E'ko",
	["Frostsaber E'ko Item"] = "Frostsaber E'ko",
	["Frostsaber E'ko Quest"] = "Frostsaber E'ko",
	["Ice Thistle E'ko Item"] = "Ice Thistle E'ko",
	["Ice Thistle E'ko Quest"] = "Ice Thistle E'ko",
	["Shardtooth E'ko Item"] = "Shardtooth E'ko",
	["Shardtooth E'ko Quest"] = "Shardtooth E'ko",
	["Wildkin E'ko Item"] = "Wildkin E'ko",
	["Wildkin E'ko Quest"] = "Wildkin E'ko",
	["Winterfall E'ko"] = true,

	-- Zul'Gurub quests
	["Zulian, Razzashi, and Hakkari Coins"] = true,
	["Zulian Coin"] = true,
	["Razzashi Coin"] = true,
	["Hakkari Coin"] = true,
	["Gurubashi, Vilebranch, and Witherbark Coins"] = true,
	["Gurubashi Coin"] = true,
	["Vilebranch Coin"] = true,
	["Witherbark Coin"] = true,
	["Sandfury, Skullsplitter, and Bloodscalp Coins"] = true,
	["Sandfury Coin"] = true,
	["Skullsplitter Coin"] = true,
	["Bloodscalp Coin"] = true,

	-- AQ War Effort (Horde)
	["The Horde Needs More Runecloth Bandages!"] = true,
	["The Horde Needs More Mageweave Bandages!"] = true,
	["The Horde Needs More Wool Bandages!"] = true,
	["The Horde Needs More Rugged Leather!"] = true,
	["The Horde Needs More Thick Leather!"] = true,
	["The Horde Needs More Heavy Leather!"] = true,
	["The Horde Needs More Purple Lotus!"] = true,
	["The Horde Needs More Firebloom!"] = true,
	["The Horde Needs More Peacebloom!"] = true,
	["The Horde Needs More Mithril Bars!"] = true,
	["The Horde Needs More Tin Bars!"] = true,
	["The Horde Needs More Copper Bars!"] = true,
	["The Horde Needs More Lean Wolf Steaks!"] = true,
	["The Horde Needs More Spotted Yellowtail!"] = true,
	["The Horde Needs More Baked Salmon!"] = true,

	-- AQ War Effort (Alliance)
	["The Alliance Needs More Linen Bandages!"] = true,
	["The Alliance Needs More Silk Bandages!"] = true,
	["The Alliance Needs More Runecloth Bandages!"] = true,
	["The Alliance Needs More Light Leather!"] = true,
	["The Alliance Needs More Medium Leather!"] = true,
	["The Alliance Needs More Thick Leather!"] = true,
	["The Alliance Needs More Stranglekelp!"] = true,
	["The Alliance Needs More Purple Lotus!"] = true,
	["The Alliance Needs More Arthas' Tears!"] = true,
	["The Alliance Needs More Copper Bars!"] = true,
	["The Alliance Needs More Iron Bars!"] = true,
	["The Alliance Needs More Thorium Bars!"] = true,
	["The Alliance Needs More Rainbow Fin Albacore!"] = true,
	["The Alliance Needs More Roast Raptor!"] = true,
	["The Alliance Needs More Spotted Yellowtail!"] = true,

	-- AQ War Effort Items
	["Linen Bandage"] = true,
	["Wool Bandage"] = true,
	["Silk Bandage"] = true,
	["Mageweave Bandage"] = true,
	["Runecloth Bandage"] = true,
	["Light Leather"] = true,
	["Medium Leather"] = true,
	["Heavy Leather"] = true,
	["Thick Leather"] = true,
	["Rugged Leather"] = true,
	["Purple Lotus"] = true,
	["Stranglekelp"] = true,
	["Arthas' Tears"] = true,
	["Firebloom"] = true,
	["Peacebloom"] = true,
	["Copper Bar"] = true,
	["Tin Bar"] = true,
	["Iron Bar"] = true,
	["Mithril Bar"] = true,
	["Thorium Bar"] = true,
	["Lean Wolf Steak"] = true,
	["Spotted Yellowtail"] = true,
	["Baked Salmon"] = true,
	["Roast Raptor"] = true,
	["Rainbow Fin Albacore"] = true,

	-- Commendation Signets
	["One Commendation Signet"] = true,
	["Ten Commendation Signets"] = true,
	["Horde Commendation Signet"] = true,
	["Alliance Commendation Signet"] = true,

	-------------
	-- Burning Crusade
	-------------

	-- Scryers
	["More Firewing Signets"] = true,
	["Single Firewing Signet"] = true,
	["Firewing Signet"] = true,
	["More Sunfury Signets"] = true,
	["Single Sunfury Signet"] = true,
	["Sunfury Signet"] = true,
	["Arcane Tomes"] = true,
	["Arcane Tome"] = true,

	-- Aldor
	["Strained Supplies"] = true,
	["Dreadfang Venom Sac"] = true,
	["More Marks of Sargeras"] = true,
	["Single Mark of Sargeras"] = true,
	["Mark of Sargeras"] = true,
	["More Marks of Kil'jaeden"] = true,
	["Single Mark of Kil'jaeden"] = true,
	["Mark of Kil'jaeden"] = true,
	["Fel Armaments"] = true,
	["Fel Armament"] = true,

	-- Zangarmarsh

	-- Cenarion Refuge
	["Identify Plant Parts"] = true,
	["Unidentified Plant Parts"] = true,
	["Coilfang Armaments"] = true,

	-- Sporeggar
	["More Spore Sacs"] = true,
	["Mature Spore Sac"] = true,
	["More Tendrils!"] = true,
	["Bog Lord Tendril"] = true,
	["More Glowcaps"] = true,
	["Glowcap"] = true,
	["Bring Me Another Shrubbery!"] = true,
	["Sanguine Hibiscus"] = true,
	["More Fertile Spores"] = true,
	["Fertile Spore"] = true,

	-- Terokkar Forest

	-- Spinebreaker Hold
	["More Arakkoa Feathers"] = true,
	["Arakkoa Feather"] = true,
	
	-- Skettis
	["More Shadow Dust"] = true,
	["Shadow Dust"] = true,

	-- Nagrand

	-- Garadar/Telaar
	["More Warbeads"] = true,
	["More Warbeads!"] = true,
	["Obsidian Warbeads"] = true,

	-- Halaa
	["Oshu'gun Crystal Powder"] = true,
	["Oshu'gun Crystal Powder Sample"] = true,

	-- Aeris Landing
	["More Heads Full of Ivory"] = true,
	["Pair of Ivory Tusks"] = true,
	["More Crystal Fragments"] = true,
	["Oshu'gun Crystal Fragment"] = true,
	["More Obsidian Warbeads"] = true,
	
	-- Netherstorm

	-- Area 52
	["Another Heap of Ethereals"] = true,
	["Zaxxis Insignia"] = true,
	
	-- Ethereum
	["Ethereum Prisoner I.D. Catalogue"] = true,
	["Ethereum Prisoner I.D. Tag"] = true,

	-- Shadowmoon Valley

	-- Netherwing Ledge
	["Accepting All Eggs"] = true,
	["Netherwing Egg"] = true,
	
	-- 2.4 Battleground mark turn-in
  ["Concerted Efforts"] = true,
  ["For Great Honor"] = true,
  ["Alterac Valley Mark of Honor"] = true,
	["Arathi Basin Mark of Honor"] = true,
	["Warsong Gulch Mark of Honor"] = true,
	["Eye of the Storm Mark of Honor"] = true,
			
} end )
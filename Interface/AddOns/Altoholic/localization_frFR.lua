﻿local L = AceLibrary("AceLocale-2.2"):new("Altoholic")

L:RegisterTranslations("frFR", function() return {

	-- Note: since 2.4.004 and the support of LibBabble, certain lines are commented, but remain there for clarity (especially those concerning the menu)
	-- A lot of translations, especially those concerning the loot table, comes from atlas loot, credit goes to their team for gathering this info, I (Thaoky) simply took what I needed.

	["Mage"] = "Mage",
	["Warrior"] = "Guerrier",
	["Hunter"] = "Chasseur",
	["Rogue"] = "Voleur",
	["Warlock"] = "Démoniste",
	["Druid"] = "Druide",
	["Shaman"] = "Chaman",
	["Paladin"] = "Paladin",
	["Priest"] = "Prêtre", 
	
	-- note: these string are the ones found in item tooltips, make sure to respect the case when translating, and to distinguish them (like crit vs spell crit)
	["Increases healing done by up to %d+"] = "Augmente les soins prodigués d'un maximum de %d+",
	["Increases damage and healing done by magical spells and effects by up to %d+"] = "Augmente les dégâts et les soins produits par les sorts et effets magiques de %d+",
	["Increases attack power by %d+"] = "Augmente de %d+ la puissance d'attaque",
	["Restores %d+ mana per"] = "Rend %d+ points de mana toutes les",
	["Classes: Shaman"] = "Classes: Chaman",
	["Classes: Mage"] = "Classes: Mage",
	["Classes: Rogue"] = "Classes: Voleur",
	["Classes: Hunter"] = "Classes: Chasseur",
	["Classes: Warrior"] = "Classes: Guerrier",
	["Classes: Paladin"] = "Classes: Paladin",
	["Classes: Warlock"] = "Classes: Démoniste",
	["Classes: Priest"] = "Classes: Prêtre",
	["Resistance"] = "Resistance",
	
	-- equipment slots
	["Ranged"] = "Distance",
	
	--skills
	["Professions"] = "Métiers",
	["Secondary Skills"] = "Compétences secondaires",
	["Fishing"] = "Pêche",
	["Riding"] = "Monte",
	["Herbalism"] = "Herboristerie",
	["Mining"] = "Minage",
	["Skinning"] = "Dépeçage",
	["Lockpicking"] = "Crochetage",
	["Poisons"] = "Poisons",
	["Beast Training"] = "Dressage des bêtes",
	
	--factions not in LibFactions or LibZone
	["Exodar"] = "Exodar",
	["Gnomeregan Exiles"] = "Exilés de Gnomeregan",
	["Stormwind"] = "Hurlevent",
	["Darkspear Trolls"] = "Trolls Sombrelance",
	["Alliance Forces"] = "Forces de l'Alliance",
	["Horde Forces"] = "Forces de la Horde",
	["Steamwheedle Cartel"] = "Cartel Gentepression",
	["Other"] = "Autres",
	["Ravenholdt"] = "Ravenholdt",
	["Shen'dralar"] = "Shen'dralar",
	["Syndicate"] = "Syndicat",

	-- menu
	["Reputations"] = "Réputations",
	["Containers"] = "Conteneurs",
	["Guild Bank not visited yet (or not guilded)"] = "Banque de guilde non visitée (ou non guildé)",
	["E-Mail"] = "Courrier",
	["Quests"] = "Quêtes",
	["Equipment"] = "Equipement",

	--Altoholic.lua
	["Loots"] = "Loots",
	["Unknown"] = "Inconnus",
	["Mail expires in less than "] = "Du courrier expire dans moins de ",
	[" days"] = " jours",
	["Bank not visited yet"] = "Banque non visitée",
	["Levels"] = "Niveaux",
	["(has mail)"] = "(a du courrier)",
	["(has auctions)"] = "(a des enchères)",
	["(has bids)"] = "(has bids)",
	
	["No rest XP"] = "Pas d'XP de repos",
	["% rested"] = "% reposé",
	["Transmute"] = "Transmute",
	
	["Bags"] = "Sacs",
	["Bank"] = "Banque",
	["Equipped"] = "Equipé",
	["Mail"] = "Courrier",
	["Mails %s(%d)"] = "Courrier %s(%d)",
	["Auctions %s(%d)"] = "Enchères %s(%d)",
	["Bids %s(%d)"] = "Offres %s(%d)",
	[", "] = ", ",						-- required for znCH
	["(Guild bank: "] = "(Banque de guilde: ",
	
	["Level"] = "Niveau",
	["Zone"] = "Zone",
	["Rest XP"] = "XP de repos",
	
	["Source"] = "Source",
	["Total owned"] = "Total possédé",
	["Already known by "] = "Déjà connu par ",
	["Will be learnable by "] = "Pourra être appris par ",
	["Could be learned by "] = "Pourrait être appris par ",
	
	["At least one recipe could not be read"] = "Au moins une recette n'a pas pu être lue",
	["Please open this window again"] = "Veuillez ouvrir cette fenêtre à nouveau",
	
	--Core.lua
	['search'] = 'search',
	["Search in bags"] = "Recherche dans les sacs",
	['show'] = 'show',
	["Shows the UI"] = "Affiche l'interface",
	['hide'] = 'hide',
	["Hides the UI"] = "Cache l'interface",
	['toggle'] = 'toggle',
	["Toggles the UI"] = "Inverse l'état de l'interface",
	
	--AltoholicFu.lua
	["Left-click to"] = "Clic-gauche pour",
	["open/close"] = "ouvrir/fermer",
	
	--AccountSummary.lua
	["View bags"] = "Voir les sacs",
	["All-in-one"] = "Tout-en-un",
	["View mailbox"] = "Voir le courrier",
	["View quest log"] = "Voir le journal de quête",
	["View auctions"] = "Voir les enchères",
	["View bids"] = "Voir les offres",
	["Delete this Alt"] = "Effacer ce reroll",
	["Cannot delete current character"] = "Impossible d'effacer le personnage en cours",
	["Character %s successfully deleted"] = "Personnage %s effacé avec succès",
	["Suggested leveling zone: "] = "Zone suggérée: ",
	["Arena points: "] = "Points d'arène: ",
	["Honor points: "] = "Points d'honneur: ",
	
	-- AuctionHouse.lua
	[" has no auctions"] = " n'a pas d'enchères",
	[" has no bids"] = " n'a pas d'offres",
	["last check "] = "dernière visite ",
	["Goblin AH"] = "HV Gobelin",
	["Clear your faction's entries"] = "Effacer les entrées de votre faction",
	["Clear goblin AH entries"] = "Effacer les entrées de l'HV gobelin",
	["Clear all entries"] = "Effacer toutes les entrées",
	
	--BagUsage.lua
	["Totals"] = "Totaux",
	["slots"] = "emplacements",
	["free"] = "libre",
	
	--Containers.lua
	["32 Keys Max"] = "32 Clés Max",
	["28 Slot"] = "28 emplacements",
	["Bank bag"] = "Sac en banque",
	["Unknown link, please relog this character"] = "Lien inconnu, veuillez reconnecter ce personnage",
	
	--Equipment.lua
	["Find Upgrade"] = "Trouver mieux",
	["(based on iLvl)"] = "(sur base de l'item level)",
	["Right-Click to find an upgrade"] = "Clic-Droit pour trouver mieux",
	["Tank"] = "Tank",
	["DPS"] = "DPS",
	["Balance"] = "Equilibre",
	["Elemental Shaman"] = "Chaman Elémentaire",		-- shaman spec !
	["Heal"] = "Soin",
	
	--GuildBank.lua
	["Last visited "] = "Dernière visite il y a ",
	[" days ago by "] = " jours par ",
	
	--Mails.lua
	[" has not visited his/her mailbox yet"] = " n'a pas encore visité son/sa boîte aux lettres",
	[" has no mail, last check "] = " n'a pas de courrier, dernière visite il y a ",
	[" days ago"] = " jours",		-- this line goes with the previous one
	["Mailbox: "] = "Boîte aux lettres: ",
	["Mail was last checked "] = "Courrier relevé il y a ",
	[" days"] = " jours",
	
	--Quests.lua
	["No quest found for "] = "Pas de quête trouvée pour ",
	["QuestID"] = "ID Quête",
	["Are also on this quest:"] = "Sont également sur cette quête:",
	
	--Recipes.lua
	["No data: "] = "Aucune données: ",
	[" scan failed for "] = " ",
	
	--Reputations.lua
	["Shift-Click to link this info"] = "Shift-Clic pour linker cette info",
	[" is "] = " est ",
	[" with "] = " chez ",		-- I know "with" translates to "avec" in French, but in the very specific sentence where this is used, "chez" is more appropriate
		
	--Search.lua
	["Item Level"] = "Niveau de l'objet",
	[" results found (Showing "] = " résultats trouvés (Affichés ",
	["No match found!"] = "Aucun résultat trouvé!",
	[" not found!"] = " non trouvé!",
	["Socket"] = "Châsse",
	
	--skills.lua
	["Rogue Proficiencies"] = "Aptitudes du voleur",
	["up to"] = "jusqu'à",
	["at"] = "à",
	["and above"] = "et au-delà",
	["Suggestion"] = "Suggestion",
	["Prof. 1"] = "Prof. 1",
	["Prof. 2"] = "Prof. 2",
	
	-- TabSearch.lua
	["Any"] = "Tout",
	["Miscellaneous"] = "Divers",
	["Fishing Poles"] = "Cannes à pêche",
	["This realm"] = "Ce royaume",
	["All realms"] = "Tous les royaumes",
	["Loot tables"] = "Loots",
	
	--loots.lua
	--Instinct drop
	["Trash Mobs"] = "Trash Mobs",
	["Random Boss"] = "Boss aléatoire",
	["Druid Set"] = "Set Druide",
	["Hunter Set"] = "Set Chasseur",
	["Mage Set"] = "Set Mage",
	["Paladin Set"] = "Set Paladin",
	["Priest Set"] = "Set Prêtre",
	["Rogue Set"] = "Set Voleur",
	["Shaman Set"] = "Set Chaman",
	["Warlock Set"] = "Set Démoniste",
	["Warrior Set"] = "Set Guerrier",
	["Legendary Mount"] = "Monture légendaire",
	["Legendaries"] = "Légendaires",
	["Muddy Churning Waters"] = "Muddy Churning Waters",
	["Shared"] = "Partagés",
	["Enchants"] = "Enchantements",
	["Rajaxx's Captains"] = "Les Capitaines de Rajaxx",
	["Class Books"] = "Livres de classe",
	["Quest Items"] = "Objets de quête",
	["Druid of the Fang (Trash Mob)"] = "Druide du Croc (Trash Mob)",
	["Spawn Of Hakkar"] = "Rejeton d'Hakkar",
	["Troll Mini bosses"] = "Mini Boss Trolls",
	["Henry Stern"] = "Henry Stern",
	["Magregan Deepshadow"] = "Magregan Fondombre",
	["Tablet of Ryuneh"] = "Tablette de Ryun'eh",
	["Krom Stoutarm Chest"] = "Coffre de Krom Rudebras",
	["Garrett Family Chest"] = "Coffre de la famille Garrett",
	["Eric The Swift"] = "Eric 'l'Agile'",
	["Olaf"] = "Olaf",
	["Baelog's Chest"] = "Coffre de Baelog",
	["Conspicuous Urn"] = "Urne ostentatoire",
	["Tablet of Will"] = "Tablette de volonté",
	["Shadowforge Cache"] = "Cachette d'Ombreforge",
	["Roogug"] = "Roogug",
	["Aggem Thorncurse"] = "Aggem Malépine",
	["Razorfen Spearhide"] = "Lanceur de Tranchebauge",
	["Pyron"] = "Pyron",
	["Theldren"] = "Theldren",
	["The Vault"] = "La Chambre forte",
	["Summoner's Tomb"] = "Tombe de l'invocateur",
	["Plans"] = "Plans",
	["Zelemar the Wrathful"] = "Zelemar le Courroucé",
	["Rethilgore"] = "Rethiltripe",
	["Fel Steed"] = "Palefroi corrompu",
	["Tribute Run"] = "Tribut du Roi",
	["Shen'dralar Provisioner"] = "Approvisionneur Shen'dralar",
	["Books"] = "Livres",
	["Trinkets"] = "Bijoux",
	["Sothos & Jarien"] = "Sothos et Jarien",
	["Fel Iron Chest"] = "Coffre en gangrefer",
	[" (Heroic)"] = " (Heroïque)",
	["Yor (Heroic Summon)"] = "Yor (Invocation Héroïque)",
	["Avatar of the Martyred"] = "Avatar des martyrs",
	["Anzu the Raven God (Heroic Summon)"] = "Anzu le Dieu Corbeau (Invocation Héroïque)",
	["Thomas Yance"] = "Thomas Yance",
	["Aged Dalaran Wizard"] = "Sorcier de Dalaran âgé",
	["Cache of the Legion"] = "Cache de la Légion",
	["Opera (Shared Drops)"] = "Opéra (Loots partagés)",
	["Timed Chest"] = "Course au coffre",
	["Patterns"] = "Patrons",
	
	--Rep
	["Token Hand-Ins"] = "Insignes de l'Aube / Croisade",
	["Items"] = "Objets",
	["Beasts Deck"] = "Suite de fauves",
	["Elementals Deck"] = "Suite d'Elémentaires",
	["Warlords Deck"] = "Suite de Seigneurs de guerre",
	["Portals Deck"] = "Suite de Portails",
	["Furies Deck"] = "Suite de Furies",
	["Storms Deck"] = "Suite d'Orages",
	["Blessings Deck"] = "Suite de Bénédictions",
	["Lunacy Deck"] = "Suite de Déraison",
	["Quest rewards"] = "Récompenses de quête",
	--["Shattrath"] = true,
	
	--World drop
	["Outdoor Bosses"] = "Boss Extérieurs",
	["Highlord Kruul"] = "Généralissime Kruul",
	["Bash'ir Landing"] = "Point d'ancrage de Bash'ir",
	["Skyguard Raid"] = "Skyguard Raid",
	["Stasis Chambers"] = "Chambre de stase",
	["Skettis"] = "Skettis",
	["Darkscreecher Akkarai"] = "Akkarai le Hurle-sombre",
	["Karrog"] = "Karrog",
	["Gezzarak the Huntress"] = "Gezzarak la Chasseresse",
	["Vakkiz the Windrager"] = "Vakkiz le Ragevent",
	["Terokk"] = "Terokk",
	["Ethereum Prison"] = "Prison de l'Ethereum",
	["Armbreaker Huffaz"] = "Casse-bras Huffaz",
	["Fel Tinkerer Zortan"] = "Bricoleur gangrené Zortan",
	["Forgosh"] = "Forgosh",
	["Gul'bor"] = "Gul'bor",
	["Malevus the Mad"] = "Malevus le Fol",
	["Porfus the Gem Gorger"] = "Porfus le Goinfre-gemmes",
	["Wrathbringer Laz-tarash"] = "Porte-courroux Laz-tarash",
	["Abyssal Council"] = "Conseil abyssal",
	["Crimson Templar (Fire)"] = "Templier cramoisi (Feu)",
	["Azure Templar (Water)"] = "Templier d'azur (Eau)",
	["Hoary Templar (Wind)"] = "Templier chenu (Vent)",
	["Earthen Templar (Earth)"] = "Templier terrestre (Terre)",
	["The Duke of Cinders (Fire)"] = "Le duc des Cendres (Feu)",
	["The Duke of Fathoms (Water)"] = "Le duc des Profondeurs (Eau)",
	["The Duke of Zephyrs (Wind)"] = "Le duc des Zéphyrs (Vent)",
	["The Duke of Shards (Earth)"] = "Le duc des Eclats (Terre)",
	["Elemental Invasion"] = "Invasions élémentaires",
	["Gurubashi Arena"] = "Arène de Gurubashi",
	["Booty Run"] = "Le coffre pirate",
	["Fishing Extravaganza"] = "Concours de pêche", 
	["First Prize"] = "1er prix",
	["Rare Fish"] = "Poissons rares",
	["Rare Fish Rewards"] = "Récompenses des poissons rares",
	["Children's Week"] = "La Semaine des enfants",
	["Love is in the air"] = "De l'amour dans l'air",
	["Gift of Adoration"] = "Cadeau d'adoration",
	["Box of Chocolates"] = "Boîte de chocolats",
	["Hallow's End"] = "La Sanssaint",
	["Various Locations"] = "Lieux divers",
	["Treat Bag"] = "Sac de friandises",
	["Headless Horseman"] = "Cavalier sans tête",
	["Feast of Winter Veil"] = "La fête du Voile d'hiver",
	["Smokywood Pastures Vendor"] = "Vendeurs de Gourmandises Fumebois",
	["Gaily Wrapped Present"] = "Cadeau à l'emballage multicolore",
	["Festive Gift"] = "Cadeau de fête",
	["Winter Veil Gift"] = "Rob-fusée mécanique",
	["Gently Shaken Gift"] = "Cadeau secoué doucement",
	["Ticking Present"] = "Cadeau tic-taquant",
	["Carefully Wrapped Present"] = "Biscuit du Voile d'hiver",
	["Noblegarden"] = "Le jardin des nobles",
	["Brightly Colored Egg"] = "Oeuf brillamment coloré",
	["Smokywood Pastures Extra-Special Gift"] = "Cadeau extra-spécial des Gourmandises Fumebois",
	["Harvest Festival"] = "La Fête des moissons",
	["Food"] = "Nourriture",
	["Scourge Invasion"] = "Invasion du Fléau",
	--["Miscellaneous"] = true,
	["Cloth Set"] = "Set Tissu",
	["Leather Set"] = "Set Cuir",
	["Mail Set"] = "Set Maille",
	["Plate Set"] = "Set Plaque",
	["Balzaphon"] = "Balzaphon",
	["Lord Blackwood"] = "Seigneur Noirbois",
	["Revanchion"] = "Revanchion",
	["Scorn"] = "Scorn",
	["Sever"] = "Sever",
	["Lady Falther'ess"] = "Dame Falther'ess",
	["Lunar Festival"] = "La fête lunaire",
	["Fireworks Pack"] = "Sac de feux d'artifice",
	["Lucky Red Envelope"] = "Enveloppe rouge porte-bonheur",
	["Midsummer Fire Festival"] = "Solstice d'été : la fête du Feu",
	["Lord Ahune"] = "Seigneur Ahune",
	["Shartuul"] = "Shartuul",
	["Blade Edge Mountains"] = "Les Tranchantes",
	["Brewfest"] = "La fête des Brasseurs",
	["Barleybrew Brewery"] = "Apprenti Brasselorge",
	["Thunderbrew Brewery"] = "Apprenti Tonnebière",
	["Gordok Brewery"] = "Apprenti de la bière gordok",
	["Drohn's Distillery"] = "Apprenti de la distillerie Drohn",
	["T'chali's Voodoo Brewery"] = "Apprenti de la brasserie vaudou de T'chali",
	
	--craft
	["Crafted Weapons"] = "Armes fabriquées",
	["Master Swordsmith"] = "Maître fabricant d'épées",
	["Master Axesmith"] = "Maître fabricant de haches",
	["Master Hammersmith"] = "Maître fabricant de marteaux",
	["Blacksmithing (Lv 60)"] = "Forge (Niv 60)",
	["Blacksmithing (Lv 70)"] = "Forge (Niv 70)",
	["Engineering (Lv 60)"] = "Ingéniérie (Niv 60)",
	["Engineering (Lv 70)"] = "Ingéniérie (Niv 70)",
	["Blacksmithing Plate Sets"] = "Sets forge, en plaque",
	["Imperial Plate"] = "Armure impériale en plaques",
	["The Darksoul"] = "La Ténébrâme",
	["Fel Iron Plate"] = "Plaque de gangrefer",
	["Adamantite Battlegear"] = "Tenue de combat en adamantite",
	["Flame Guard"] = "Garde des flammes",
	["Enchanted Adamantite Armor"] = "Armure d'adamantite enchantée",
	["Khorium Ward"] = "Gardien de khorium",
	["Faith in Felsteel"] = "Foi dans le gangracier",
	["Burning Rage"] = "Rage ardente",
	["Blacksmithing Mail Sets"] = "Sets forge, en maille",
	["Bloodsoul Embrace"] = "Etreinte d'âmesang",
	["Fel Iron Chain"] = "Anneaux de gangrefer",	
	["Tailoring Sets"] = "Sets couture",
	["Bloodvine Garb"] = "Atours de vignesang",
	["Netherweave Vestments"] = "Habit en tisse-néant",
	["Imbued Netherweave"] = "Tisse-néant imprégné",
	["Arcanoweave Vestments"] = "Habit de tisse-arcane",
	["The Unyielding"] = "L'Inflexible",
	["Whitemend Wisdom"] = "Sagesse de la blanche guérison",
	["Spellstrike Infusion"] = "Infusion frappe-sort",
	["Battlecast Garb"] = "Atours d'escarmouche",
	["Soulcloth Embrace"] = "Etreinte d'âmétoffe",
	["Primal Mooncloth"] = "Etoffe lunaire primordiale",
	["Shadow's Embrace"] = "Etreinte de l'ombre",
	["Wrath of Spellfire"] = "Habit du feu-sorcier",
	["Leatherworking Leather Sets"] = "Sets travail du cuir, en cuir",
	["Volcanic Armor"] = "Armure volcanique",
	["Ironfeather Armor"] = "Armure de plumacier",
	["Stormshroud Armor"] = "Armure tempétueuse",
	["Devilsaur Armor"] = "Armure de diablosaure",
	["Blood Tiger Harness"] = "Harnais du tigre-sang",
	["Primal Batskin"] = "Peau de chauve-souris primodiale",
	["Wild Draenish Armor"] = "Armure draenique sauvage",
	["Thick Draenic Armor"] = "Armure draenique épaisse",
	["Fel Skin"] = "Gangrepeau",
	["Strength of the Clefthoof"] = "Force du sabot-fourchu",
	["Primal Intent"] = "Intention primordiale",
	["Windhawk Armor"] = "Armure Faucont-du-vent",
	["Leatherworking Mail Sets"] = "Sets travail du cuir, en maille",
	["Green Dragon Mail"] = "Mailles de dragon vert",
	["Blue Dragon Mail"] = "Mailles de dragon bleu",
	["Black Dragon Mail"] = "Mailles de dragon noir",
	["Scaled Draenic Armor"] = "Armure draenique en écailles",
	["Felscale Armor"] = "Armure en gangrécaille",
	["Felstalker Armor"] = "Armure de traqueur gangrené",
	["Fury of the Nether"] = "Furie du Néant",
	["Netherscale Armor"] = "Armure en écailles du Néant",
	["Netherstrike Armor"] = "Armure Coup-de-Néant",	
	["Armorsmith"] = "Fabricant d'armures",
	["Weaponsmith"] = "Fabricant d'armes",
	["Dragonscale"] = "Ecailles de dragon",
	["Elemental"] = "Elémentaire",
	["Tribal"] = "Tribale",
	["Mooncloth"] = "Etoffe Lunaire",
	["Shadoweave"] = "Tisse ombre",
	["Spellfire"] = "Feu Sorcier",
	["Gnomish"] = "Gnome",
	["Goblin"] = "Gobelin",
	["Apprentice"] = "Apprenti",
	["Journeyman"] = "Compagnon",
	["Expert"] = "Expert",
	["Artisan"] = "Artisan",
	["Master"] = "Maître",
	
	--Set & PVP
	["Superior Rewards"] = "Récompenses Supérieures",
	["Epic Rewards"] = "Récompenses Epiques",
	["Lv 10-19 Rewards"] = "Récompenses Niveau 10-19",
	["Lv 20-29 Rewards"] = "Récompenses Niveau 20-29",
	["Lv 30-39 Rewards"] = "Récompenses Niveau 30-39",
	["Lv 40-49 Rewards"] = "Récompenses Niveau 40-49",
	["Lv 50-59 Rewards"] = "Récompenses Niveau 50-59",
	["Lv 60 Rewards"] = "Récompenses Niveau 60",
	["PVP Cloth Set"] = "Set Tissu JcJ",
	["PVP Leather Sets"] = "Set Cuir JcJ",
	["PVP Mail Sets"] = "Set Maille JcJ",
	["PVP Plate Sets"] = "Set Plaque JcJ",
	["World PVP"] = "PVP Sauvage",
	["Hellfire Fortifications"] = "Fortifications des flammes infernales",
	["Twin Spire Ruins"] = "Ruines des flèches jumelles",
	["Spirit Towers (Terrokar)"] = "Tour des esprits (Terrokar)",
	["Halaa (Nagrand)"] = "Halaa (Nagrand)",
	["Arena Season 1"] = "Arène Saison 1",
	["Arena Season 2"] = "Arène Saison 2",
	["Arena Season 3"] = "Arène Saison 3",
	["Arena Season 4"] = "Arène Saison 4",
	["Weapons"] = "Armes",
	["Level 60 Honor PVP"] = "JcJ Honneur Niveau 60",
	["Accessories"] = "Accessoires",
	["Level 70 Reputation PVP"] = "JcJ Réputation Niveau 70",
	["Level 70 Honor PVP"] = "JcJ Honneur Niveau 70",
	["Non Set Accessories"] = "Accessoires Hors-Set",
	["Non Set Cloth"] = "Tissu Hors-Set",
	["Non Set Leather"] = "Cuir Hors-Set",
	["Non Set Mail"] = "Maille Hors-Set",
	["Non Set Plate"] = "Plaque Hors-Set",
	["Tier 0.5 Quests"] = "Quêtes T0.5",
	["Tier 3 (Naxxramas Tokens)"] = "T3 (Insignes Naxxramas)",
	["Tier 4 Tokens"] = "Insignes T4",
	["Tier 5 Tokens"] = "Insignes T5",
	["Tier 6 Tokens"] = "Insignes T6",
	["Blizzard Collectables"] = "Goodies Blizzard",
	["WoW Collector Edition"] = "WoW Edition Collector",
	["BC Collector Edition (Europe)"] = "BC Edition Collector (Europe)",
	["Blizzcon 2005"] = "Blizzcon 2005",
	["Blizzcon 2007"] = "Blizzcon 2007",
	["Christmas Gift 2006"] = "Cadeau de Noël 2006",
	["Upper Deck"] = "Upper Deck",
	["Loot Card Items"] = "Butin des cartes à jouer",
	["Heroic Mode Tokens"] = "Insignes Mode Héroïque",
	["Fire Resistance Gear"] = "Equipements de Résistance au Feu",
	["Cloaks"] = "Capes",
	["Relics"] = "Reliques",
	["World Drops"] = "World Drops",
	["Level 30-39"] = "Niveau 30-39",
	["Level 40-49"] = "Niveau 40-49",
	["Level 50-60"] = "Niveau 50-60",
	["Level 70"] = "Niveau 70",

	-- Altoholic.Gathering : Mining 
	["Copper Vein"] = "Filon de cuivre",
	["Tin Vein"] = "Filon d'étain",
	["Iron Deposit"] = "Gisement de fer",
	["Silver Vein"] = "Filon d'argent",
	["Gold Vein"] = "Filon d'or",
	["Mithril Deposit"] = "Gisement de mithril",
	["Ooze Covered Mithril Deposit"] = "Gisement de mithril couvert de vase",
	["Truesilver Deposit"] = "Gisement de vrai-argent",
	["Ooze Covered Silver Vein"] = "Filon d'argent couvert de limon",
	["Ooze Covered Gold Vein"] = "Filon d'or couvert de limon",
	["Ooze Covered Truesilver Deposit"] = "Gisement de vrai-argent couvert de vase",
	["Ooze Covered Rich Thorium Vein"] = "Riche filon de thorium couvert de limon",
	["Ooze Covered Thorium Vein"] = "Filon de thorium couvert de limon",
	["Small Thorium Vein"] = "Petit filon de thorium",
	["Rich Thorium Vein"] = "Riche filon de thorium",
	["Hakkari Thorium Vein"] = "Filon de thorium Hakkari",
	["Dark Iron Deposit"] = "Gisement de sombrefer",
	["Lesser Bloodstone Deposit"] = "Gisement de pierre de sang inférieure",
	["Incendicite Mineral Vein"] = "Filon d'incendicite",
	["Indurium Mineral Vein"] = "Filon d'indurium",
	["Fel Iron Deposit"] = "Gisement de gangrefer",
	["Adamantite Deposit"] = "Gisement d'adamantite",
	["Rich Adamantite Deposit"] = "Riche gisement d'adamantite",
	["Khorium Vein"] = "Filon de khorium",
	["Large Obsidian Chunk"] = "Grand morceau d'obsidienne",
	["Small Obsidian Chunk"] = "Petit morceau d'obsidienne",
	["Nethercite Deposit"] = "Gisement de néanticite",
	
	-- Altoholic.Gathering : Herbalism
	["Peacebloom"] = "Pacifique",
	["Silverleaf"] = "Feuillargent",
	["Earthroot"] = "Terrestrine",
	["Mageroyal"] = "Mage royal",
	["Briarthorn"] = "Eglantine",
	["Swiftthistle"] = "Chardonnier",
	["Stranglekelp"] = "Etouffante",
	["Bruiseweed"] = "Doulourante",
	["Wild Steelbloom"] = "Aciérite sauvage",
	["Grave Moss"] = "Tombeline",
	["Kingsblood"] = "Sang-royal",
	["Liferoot"] = "Vietérule",
	["Fadeleaf"] = "Pâlerette",
	["Goldthorn"] = "Dorépine",
	["Khadgar's Whisker"] = "Moustache de Khadgar",
	["Wintersbite"] = "Hivernale",
	["Firebloom"] = "Fleur de feu",
	["Purple Lotus"] = "Lotus pourpre",
	["Wildvine"] = "Sauvageonne",
	["Arthas' Tears"] = "Larmes d'Arthas",
	["Sungrass"] = "Soleillette",
	["Blindweed"] = "Aveuglette",
	["Ghost Mushroom"] = "Champignon fantôme",
	["Gromsblood"] = "Gromsang",
	["Golden Sansam"] = "Sansam doré",
	["Dreamfoil"] = "Feuillerêve",
	["Mountain Silversage"] = "Sauge-argent des montagnes",
	["Plaguebloom"] = "Fleur de peste",
	["Icecap"] = "Calot de glace",
	["Bloodvine"] = "Vignesang",
	["Black Lotus"] = "Lotus noir",
	["Felweed"] = "Gangrelette",
	["Dreaming Glory"] = "Glaurier",
	["Terocone"] = "Terocône",
	["Ancient Lichen"] = "Lichen ancien",
	["Bloodthistle"] = "Chardon sanglant",
	["Mana Thistle"] = "Chardon de mana",
	["Netherbloom"] = "Néantine",
	["Nightmare Vine"] = "Cauchemardelle",
	["Ragveil"] = "Voile-misère",
	["Flame Cap"] = "Chapeflamme",
	["Fel Lotus"] = "Gangrelotus",
	["Netherdust Bush"] = "Buisson de pruinéante",
	-- ["Glowcap"] = true, 
	-- ["Sanguine Hibiscus"] = true,
	
} end)

if GetLocale() == "frFR" then
-- Altoholic.xml local
LEFT_HINT = "Clic-gauche pour |cFF00FF00ouvrir";
RIGHT_HINT = "Clic-droit pour |cFF00FF00déplacer";

XML_ALTO_TAB1 = "Résumé"
XML_ALTO_TAB2 = "Personnages"
XML_ALTO_TAB3 = "Recherche"
-- XML_ALTO_TAB4 = GUILD_BANK
XML_ALTO_TAB5 = "Options"

XML_ALTO_SUMMARY_MENU1 = "Résumé du compte"
XML_ALTO_SUMMARY_MENU2 = "Sacs"
-- XML_ALTO_SUMMARY_MENU3 = SKILLS

XML_ALTO_CHAR_DD1 = "Royaume"
XML_ALTO_CHAR_DD2 = "Personnage"
XML_ALTO_CHAR_DD3 = "Voir"

XML_ALTO_SEARCH_COL1 = "Item / Location"

XML_ALTO_OPT_MENU1 = "Général"
XML_ALTO_OPT_MENU2 = "Recherche"
XML_ALTO_OPT_MENU3 = "Courrier"
XML_ALTO_OPT_MENU4 = "Minimap"
XML_ALTO_OPT_MENU5 = "Tooltip"

XML_TEXT_1 = "Totaux";
XML_TEXT_2 = "Recherche Conteneurs";
XML_TEXT_3 = "Niv. Min/Max";
XML_TEXT_4 = "Rareté";
XML_TEXT_5 = "Equipement";
XML_TEXT_6 = "R.à.z.";
XML_TEXT_7 = "Recherche";

XML_TEXT_MAIN_WINDOW_1 = "Incl. les objets sans niveau requis";
XML_TEXT_MAIN_WINDOW_5 = "Incl. boites aux lettres";
XML_TEXT_MAIN_WINDOW_6 = "Incl. banque de guilde";
XML_TEXT_MAIN_WINDOW_7 = "Incl. recettes connues";

--Options.xml
XML_TEXT_8 = "Options bulle d'aide";
XML_TEXT_9 = "Options de recherche";
XML_TEXT_10 = "Déplacer pour changer l'angle de l'icône minimap";
XML_TEXT_11 = "Angle de l'icône minimap";
XML_TEXT_12 = "Déplacer pour changer le rayon de l'icône minimap";
XML_TEXT_13 = "Rayon de l'icône minimap";
XML_TEXT_14 = "Avertir quand du courrier arrive à expiration\ndans moins de jours que cette valeur";
XML_TEXT_15 = "Avertis. d'expiration du courrier";
XML_TEXT_16 = "Afficher l'icône minimap";
XML_TEXT_17 = "Trier des loots décroissant";
XML_TEXT_18 = "XP de repos max affichée comme 150%";
XML_TEXT_19 = "Lire le courrier (le marque comme lu)";
XML_TEXT_20 = "Afficher la source de l'objet";
XML_TEXT_21 = "Afficher le décompte par personnage";
XML_TEXT_22 = "Afficher le décompte total";
XML_TEXT_23 = "Inclure la banque de guilde";
XML_TEXT_24 = "Inclure Déjà Connu/Peut être appris par";
XML_TEXT_25 = "AutoQuery server |cFFFF0000(risques de déconnexion)";
XML_TEXT_26 = "|cFFFFFFFFSi un objet n'existant pas dans le cache local\n"
				.. "est rencontré lors d'une recherche dans la table des loots,\n"
				.. "Altoholic va tenter d'envoyer des requêtes au serveur pour valider 5 nouveaux objets.\n\n"
				.. "Ceci va graduellement améliorer la consistance des recherches,\n"
				.. "puisque plus d'objets seront disponibles dans le cache local.\n\n"
				.. "Il existe un risque de déconnexion si l'objet\n"
				.. "est un loot d'une instance haut niveau.\n\n"
				.. "|cFF00FF00Désactiver|r pour éviter ce risque";
end

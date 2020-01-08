-- 
-- Russian localization made by Hellbot & Interim @ EU Realms 
-- Перевод выполнен Хэлла и Интерим @ Азурегос 
--

local L = AceLibrary("AceLocale-2.2"):new("Altoholic")

L:RegisterTranslations("ruRU", function() return {

	-- Note: since 2.4.004 and the support of LibBabble, certain lines are commented, but remain there for clarity (especially those concerning the menu)
	-- A lot of translations, especially those concerning the loot table, comes from atlas loot, credit goes to their team for gathering this info, I (Thaoky) simply took what I needed.
	
	-- Class Names
	["Mage"]    = "Маг",          -- Female: same
	["Warrior"] = "Воин",         -- Female: same
	["Hunter"]  = "Охотник",      -- Female: Охотница
	["Rogue"]   = "Разбойник",    -- Female: Разбойница
	["Warlock"] = "Чернокнижник", -- Female: Чернокнижница
	["Druid"]   = "Друид",        -- Female: same
	["Shaman"]  = "Шаман",        -- Female: Шаманка
	["Paladin"] = "Паладин",      -- Female: same
	["Priest"]  = "Жрец",         -- Female: Жрица

	-- note: these string are the ones found in item tooltips, make sure to respect the case when translating, and to distinguish them (like crit vs spell crit)
	["Increases healing done by up to %d+"] = "Увлечение исцеляющих эффектов на %d+",
	["Increases damage and healing done by magical spells and effects by up to %d+"] = "Увеличение урона и целительного действия магических заклинаний и эффектов не более чем на %d+",
	["Increases attack power by %d+"] = "Увеличивает силу атаку на %d+",
	["Restores %d+ mana per"] = "Восполнение %d+ маны раз в",
		
	["Classes: Shaman"] = "Классы: Шаман",
	["Classes: Mage"] = "Классы: Маг",
	["Classes: Rogue"] = "Классы: Разбойник",
	["Classes: Hunter"] = "Классы: Охотник",
	["Classes: Warrior"] = "Классы: Воин",
	["Classes: Paladin"] = "Классы: Паладин",
	["Classes: Warlock"] = "Классы: Чернокнижник",
	["Classes: Priest"] = "Классы: Жрец",
	
	
	["Resistance"] = "Устойчивость",
	
	-- equipment slots
	["Ranged"] = "Для оружия дальнего боя",

	--skills
	["Professions"] = "Профессии",
	["Secondary Skills"] = "Разное",
	["Fishing"] = "Рыбная ловля",
	["Riding"] = "Верховая езда",
	["Herbalism"] = "Травничество",
	["Mining"] = "Горное дело",
	["Skinning"] = "Cнятие шкур",
	["Lockpicking"] = "Взлом замка",
	["Poisons"] = "Яды",
	["Beast Training"] = "Дрессировка",

	--factions not in LibFactions or LibZone
	["Exodar"] = "Экзодар",
	["Gnomeregan Exiles"] = "Изгнанники Гномрегана",
	["Stormwind"] = "Штормград",
	["Darkspear Trolls"] = "Тролли Черного Копья",
	["Alliance Forces"] = "Силы Альянса",
	["Horde Forces"] = "Силы Орды",
	["Steamwheedle Cartel"] = "Картель Хитрая Шестеренка",
	["Other"] = "Другое",
	["Ravenholdt"] = "Черный Ворон",
	["Shen'dralar"] = "Шен'дралар",
	["Syndicate"] = "Синдикат",

	-- menu
	["Reputations"] = "Репутация",
	["Containers"] = "Сумки",
	["Guild Bank not visited yet (or not guilded)"] = "Вы еще не посетили банк гильдии (или не состоите в гильдии",
	["E-Mail"] = "Почта",
	["Quests"] = "Задания",
	["Equipment"] = "Экипировка",

	--Altoholic.lua
	["Loots"] = "предметов",
	["Unknown"] = "неизвестно",
	["Mail expires in less than "] = "Срок хранения почты истекает через",
	[" days"] = " дней",
	["Bank not visited yet"] = "Вы еще не посещали банк",
	["Levels"] = "уровн(я,ей)",
	["(has mail)"] = "(у вас письмо)",
	["(has auctions)"] = "(есть аукционы)",
	["(has bids)"] = "(есть ставки)",

	["No rest XP"] = "Нет бодрости",
	["% rested"] = "% бодрости",
	["Transmute"] = "Трансмутация",

	["Bags"] = "В сумках",
	["Bank"] = "В банке",
	["Equipped"] = "Надето",
	["Mail"] = "В почте",
	["Mails %s(%d)"] = "Письма %s(%d)",
	["Auctions %s(%d)"] = "Аукционы %s(%d)",
	["Bids %s(%d)"] = "Ставки %s(%d)",
	[", "] = ", ",						-- required for znCH
	["(Guild bank: "] = "(Банк гильдии: ",

	["Level"] = "Уровень",
	["Zone"] = "Зона",
	["Rest XP"] = "Заряд бодрости",

	["Source"] = "Источник",
	["Total owned"] = "Общее количество",
	["Already known by "] = "Изучено: ",
	["Will be learnable by "] = "Будет изучено: ",
	["Could be learned by "] = "Может быть изучено: ",

	["At least one recipe could not be read"] = "Как минимум один рецепт не прочитан",
	["Please open this window again"] = "Пожалуйста откройте это окно снова",

	--Core.lua
	['search'] = "поиск",
	["Search in bags"] = "искать в сумках",
	['show'] = "показывать",
	["Shows the UI"] = "Показать интерфейс",
	['hide'] = "скрыть",
	["Hides the UI"] = "Скрыть интерфейс",
	['toggle'] = "переключить",
	["Toggles the UI"] = "Показать / скрыть интерфейс",

	--AltoholicFu.lua
	["Left-click to"] = "Левый щелчок для",
	["open/close"] = "открыть / закрыть",

	--AccountSummary.lua
	["View bags"] = "Показать сумки",
	["All-in-one"] = "объединить",
	["View mailbox"] = "Показать почту",
	["View quest log"] = "Показать журнал заданий",
	["View auctions"] = "Показать аукционы",
	["View bids"] = "Показать ставки",
	["Delete this Alt"] = "Удалить этого персонажа",
	["Cannot delete current character"] = "Нельзя удалить текущего персонажа",
	["Character %s successfully deleted"] = "Персонаж %s успешно удален",
	["Suggested leveling zone: "] = "Рекомендуемая зона: ",
	["Arena points: "] = "Очки арены: ",
	["Honor points: "] = "Очки чести: ",

	-- AuctionHouse.lua
	[" has no auctions"] = " нет аукционов",
	[" has no bids"] = " нет ставок",
	["last check "] = "последняя проверка",
	["Goblin AH"] = "Нейтральный аукцион",
	["Clear your faction's entries"] = "Стереть записи аукциона вашей фракции",
	["Clear goblin AH entries"] = "Стереть записи нейтрального аукциона",
	["Clear all entries"] = "Стереть все записи",

	--BagUsage.lua
	["Totals"] = "Всего",
	["slots"] = "Ячеек",
	["free"] = "свободных",

	--Containers.lua
	["32 Keys Max"] = "32 ключа максимум",
	["28 Slot"] = "28 ячеек",
	["Bank bag"] = "Сумки в банке",
	["Unknown link, please relog this character"] = "Неизвестная ссылка, пожалуйста перезайдите этим персонажем",

	--Equipment.lua
	["Find Upgrade"] = "Найти лучший ",
	["(based on iLvl)"] = "(основано на уровне предмета)",
	["Right-Click to find an upgrade"] = "Правый щелчок для поиска улучшений",
	["Tank"] = "Танк",
	["DPS"] = "Боец",
	["Balance"] = "Баланс",
	["Elemental Shaman"] = "Укротитель стихий",		-- shaman spec !
	["Heal"] = "Лекарь",

	--GuildBank.lua
	["Last visited "] = "Последнее посещение",
	[" days ago by "] = " дней назад, ",

	--Mails.lua
	[" has not visited his/her mailbox yet"] = " еще не читал(а) свою почту ",
	[" has no mail, last check "] = " не получает писем, уже ", 
	[" days ago"] = " дней",
	["Mailbox: "] = "Почта: ",
	["Mail was last checked "] = "Последняя проверка почты ",
	[" days"] = " дней назад",

	--Quests.lua
	["No quest found for "] = "Не найдено задание для ", -- ???
	["QuestID"] = "Индентификатор задания",
	["Are also on this quest:"] = "Этот квест также выполняют:",

	--Recipes.lua
	["No data: "] = "Нет данных: ",
	[" scan failed for "] = " сканирование не удалось для ",

	--Reputations.lua
	["Shift-Click to link this info"] = "Shift+Щелчок левой кнопкой мыши по ссылке для просмотра информации",
	[" is "] = " имеет репутацию ",
	[" with "] = " с ",

	--Search.lua
	["Item Level"] = "Уровень предмета",
	[" results found (Showing "] = " предметов найдено (Отображено ",
	["No match found!"] = "Нет совпадений",
	[" not found!"] = " не найден!",
	["Socket"] = "Гнездо",

	--skills.lua
	["Rogue Proficiencies"] = "Специализация разбойника",
	["up to"] = "до",
	["at"] = "на",
	["and above"] = "и выше",
	["Suggestion"] = "Рекомендации",
	["Prof. 1"] = "Проф. 1",
	["Prof. 2"] = "Проф. 2",

	-- TabSearch.lua
	["Any"] = "Любое",
	["Miscellaneous"] = "Разное",
	["Fishing Poles"] = "Удочки",
	["This realm"] = "Этот мир",
	["All realms"] = "Все миры",
	["Loot tables"] = "Списки добычи",

	--loots.lua
	--Instinct drop
	["Trash Mobs"] = "С монстров в инстансах",
	["Random Boss"] = "Случайный босс",
	["Druid Set"] = "Комплект друида",
	["Hunter Set"] = "Комплект охотника",
	["Mage Set"] = "Комплект мага",
	["Paladin Set"] = "Комплект паладина",
	["Priest Set"] = "Комплект жреца",
	["Rogue Set"] = "Комплект разбойника",
	["Shaman Set"] = "Комплект шамана",
	["Warlock Set"] = "Комплект чернокнижника",
	["Warrior Set"] = "Комлект воина",
	["Legendary Mount"] = "Легендарное ездовое животное",
	["Legendaries"] = "Легендарное",
	["Muddy Churning Waters"] = "Muddy Churning Waters",
	["Shared"] = "Общее",
	["Enchants"] = "Зачарования",
	["Rajaxx's Captains"] = "Rajaxx's Captains",
	["Class Books"] = "Классовые книги",
	["Quest Items"] = "Предмет задания",
	["Druid of the Fang (Trash Mob)"] = "Друид клыка",
	["Spawn Of Hakkar"] = "Порождение Хаккара",
	["Troll Mini bosses"] = "Тролли мини-боссы",
	["Henry Stern"] = "Генри Штерн",
	["Magregan Deepshadow"] = "Магреган Чернотень",
	["Tablet of Ryuneh"] = "Tablet of Ryun'eh",
	["Krom Stoutarm Chest"] = "Сундук Крома Крепкорука",
	["Garrett Family Chest"] = "Сундук семейства Гарретт",
	["Eric The Swift"] = "Eric The Swift",
	["Olaf"] = "Олаф",
	["Baelog's Chest"] = "Сундук Бейлога",
	["Conspicuous Urn"] = "Подозрительная урна",
	["Tablet of Will"] = "Tablet of Will",
	["Shadowforge Cache"] = "Тайник Кузни Теней",
	["Roogug"] = "Ругуг",
	["Aggem Thorncurse"] = "Аггем Терновое Проклятие",
	["Razorfen Spearhide"] = "Копьешкур из племени Иглошкурых",
	["Pyron"] = "Подчинитель Пирон",
	["Theldren"] = "Телдрен",
	["The Vault"] = "Хранилище",
	["Summoner's Tomb"] = "Summoner's Tomb",
	["Plans"] = "Планы",
	["Zelemar the Wrathful"] = "Зелемар Гневный",
	["Rethilgore"] = "Ретилгор",
	["Fel Steed"] = "Конь скверны",
	["Tribute Run"] = "Трибьют ран",
	["Shen'dralar Provisioner"] = "Шен'дралар (в ДМ !)",
	["Books"] = "Книги",
	["Trinkets"] = "Аксессуары",
	["Sothos & Jarien"] = "Сотос и Джариен",
	["Fel Iron Chest"] = "Сундук из оскверненного железа",
	[" (Heroic)"] = " (Героическая сложность)",
	["Yor (Heroic Summon)"] = "Йор (Вызов на героическом уровне сложности)",
	["Avatar of the Martyred"] = "Аватара Мученика",
	["Anzu the Raven God (Heroic Summon)"] = "Анзу (Вызов на героическом уровне сложности)",
	["Thomas Yance"] = "Томас Янс",
	["Aged Dalaran Wizard"] = "Даларанский старый волшебник",
	["Cache of the Legion"] = "Склад легиона",
	["Opera (Shared Drops)"] = "Опера (общий список добычи)",
	["Timed Chest"] = "Сундук за поход на время",
	["Patterns"] = "Рецепты",

	--Rep
	["Token Hand-Ins"] = "Предметы для повышения репутации",
	["Items"] = "Предметы",
	["Beasts Deck"] = "Колода Зверей",
	["Elementals Deck"] = "Колода Элементалей",
	["Warlords Deck"] = "Колода Полководцев",
	["Portals Deck"] = "Колода Порталов",
	["Furies Deck"] = "Колода Ярости",
	["Storms Deck"] = "Колода Бурь",
	["Blessings Deck"] = "Колода Благословений",
	["Lunacy Deck"] = " Колода Безумия",
	["Quest rewards"] = "Награда за выполнения задания",
	["Shattrath"] = "Шаттрат",

	--World drop
	["Outdoor Bosses"] = "Боссы на континентах",
	["Highlord Kruul"] = "Highlord Kruul",
	["Bash'ir Landing"] = "Лагерь Баш'ир",
	["Skyguard Raid"] = "Отряд стражей небес",
	["Stasis Chambers"] = "Палаты стазиса",
	["Skettis"] = "Скеттис",
	["Darkscreecher Akkarai"] = "Темный Крикун Аккарай",
	["Karrog"] = "Каррог",
	["Gezzarak the Huntress"] = "Геззарак Охотница",
	["Vakkiz the Windrager"] = "Ваккиз Ветрояр",
	["Terokk"] = "Терокк",
	["Ethereum Prison"] = "Тюрьма братства Эфириум",
	["Armbreaker Huffaz"] = "Armbreaker Huffaz",
	["Fel Tinkerer Zortan"] = "Fel Tinkerer Zortan",
	["Forgosh"] = "Forgosh",
	["Gul'bor"] = "Gul'bor",
	["Malevus the Mad"] = "Malevus the Mad",
	["Porfus the Gem Gorger"] = "Porfus the Gem Gorger",
	["Wrathbringer Laz-tarash"] = "Wrathbringer Laz-tarash",
	["Abyssal Council"] = "Совет Бездны",
	["Crimson Templar (Fire)"] = "Багровый храмовник (Огненный)",
	["Azure Templar (Water)"] = "Лазурный храмовник (Водный)",
	["Hoary Templar (Wind)"] = "Седой храмовник (Воздушный)",
	["Earthen Templar (Earth)"] = "Земной храмовник (Земляной)",
	["The Duke of Cinders (Fire)"] = "Герцог Пепла (Огненный)",
	["The Duke of Fathoms (Water)"] = "Герцог Глубин (Водный)",
	["The Duke of Zephyrs (Wind)"] = "Герцог Ветров (Воздушный)",
	["The Duke of Shards (Earth)"] = "Герцог Осколков (Земляной)",
	["Elemental Invasion"] = "Вторжение стихий",
	["Gurubashi Arena"] = "Арена Гурубаши",
	["Booty Run"] = "Схватка за добычу на Арене Гурубаши",
	["Fishing Extravaganza"] = "Рыболовная феерия",
	["First Prize"] = "Первый приз",
	["Rare Fish"] = "Редкая рыба",
	["Rare Fish Rewards"] = "Награда за редкую рыбу",
	["Children's Week"] = "Детская неделя",
	["Love is in the air"] = "В воздухе витает любовь",
	["Gift of Adoration"] = "Дар дружбы",
	["Box of Chocolates"] = "Коробка  шоколадных конфет",
	["Hallow's End"] = "Тыквовин",
	["Various Locations"] = "В различных зонах",
	["Treat Bag"] = "Мешок с лакомствами",
	["Headless Horseman"] = "Всадник без головы ",
	["Feast of Winter Veil"] = "Новый Год",
	["Smokywood Pastures Vendor"] = "Торговец Пастбищ Дымного Леса",
	["Gaily Wrapped Present"] = "Подарок в яркой упаковке",
	["Festive Gift"] = "Праздничный дар",
	["Winter Veil Gift"] = "Подарок на Зимний покров",
	["Gently Shaken Gift"] = "Слегка растрясенный дар",
	["Ticking Present"] = "Тикающий подарочек",
	["Carefully Wrapped Present"] = "Тщательно упакованный подарок",
	["Noblegarden"] = "Пасха",
	["Brightly Colored Egg"] = "Ярко раскрашеное яйцо",
	["Smokywood Pastures Extra-Special Gift"] = "Smokywood Pastures Extra-Special Gift",
	["Harvest Festival"] = "Фестиваль урожая", 
	["Food"] = "Еда",
	["Scourge Invasion"] = "Вторжение Плети",
	["Miscellaneous"] = "Разное",
	["Cloth Set"] = "Тряпичный комлект",
	["Leather Set"] = "Кожаный комплект",
	["Mail Set"] = "Кольчужный комлпект",
	["Plate Set"] = "Латы",
	["Balzaphon"] = "Балзафон",
	["Lord Blackwood"] = "Lord Blackwood",
	["Revanchion"] = "Revanchion",
	["Scorn"] = "Scorn",
	["Sever"] = "Sever",
	["Lady Falther'ess"] = "Леди Фалтер'есс",
	["Lunar Festival"] = "Лунный Фестиваль",
	["Fireworks Pack"] = "Пачка фейерверков",
	["Lucky Red Envelope"] = "Красный конверт Счастья",
	["Midsummer Fire Festival"] = "Midsummer Fire Festival",
	["Lord Ahune"] = "Повелитель Ахун",
	["Shartuul"] = "Шартуул",
	["Blade Edge Mountains"] = "Острогорье",
	["Brewfest"] = "Фестиваль пива",
	["Barleybrew Brewery"] = "Barleybrew Brewery",
	["Thunderbrew Brewery"] = "Thunderbrew Brewery",
	["Gordok Brewery"] = "Gordok Brewery",
	["Drohn's Distillery"] = "Винокурня Дрона",
	["T'chali's Voodoo Brewery"] = "Пивоваренный завод Тчали Вуду",

	--craft
	["Crafted Weapons"] = "Оружие (Кузнечное дело)",
	["Master Swordsmith"] = "Мастер ковки клинков",
	["Master Axesmith"] = "Мастер школы топора",
	["Master Hammersmith"] = "Мастер школы Молота",
	["Blacksmithing (Lv 60)"] = "Кузнечное дело (уровень 60)",
	["Blacksmithing (Lv 70)"] = "Кузнечное дело (уровень 70)",
	["Engineering (Lv 60)"] = "Инженерное дело (уровень 60)",
	["Engineering (Lv 70)"] = "Инженерное дело (уровень 70)",
	["Blacksmithing Plate Sets"] = "Латы (Кузнечное дело)",
	["Imperial Plate"] = "Имперские латы",
	["The Darksoul"] = "Темная душа",
	["Fel Iron Plate"] = "Латы из оскверненного железа",
	["Adamantite Battlegear"] = "Адамантитовая броня",
	["Flame Guard"] = "Пламенный Страж",
	["Enchanted Adamantite Armor"] = "Зачарованная адамантитовая броня",
	["Khorium Ward"] = "Кориевая Опека",
	["Faith in Felsteel"] = "Верность оскверненной стали",
	["Burning Rage"] = "Пламенная ярость",
	["Blacksmithing Mail Sets"] = "Кольчуга (Кузнечное дело)",
	["Bloodsoul Embrace"] = "Объятия Кровавого Духа",
	["Fel Iron Chain"] = "Кольчуга из оскверненного железа",
	["Tailoring Sets"] = "Тряпичная броня (Портняжное дело)",
	["Bloodvine Garb"] = "Одеяния Кровавой Лозы",
	["Netherweave Vestments"] = "Одеяния из ткани Пустоты",
	["Imbued Netherweave"] = "Прочная ткань Пустоты",
	["Arcanoweave Vestments"] = "Одеяния из тайной ткани",
	["The Unyielding"] = "Непреклонность",
	["Whitemend Wisdom"] = "Мудрость Белого целителя",
	["Spellstrike Infusion"] = "Разящее колдовство",
	["Battlecast Garb"] = "Одеяния Боевого заклятья",
	["Soulcloth Embrace"] = "Объятия ткани Душ",
	["Primal Mooncloth"] = "Изначальная луноткань",
	["Shadow's Embrace"] = "Объятия Тени",
	["Wrath of Spellfire"] = "Гнев Чародейского огня",
	["Leatherworking Leather Sets"] = "Кожаные доспехи (Кожевенное дело)",
	["Volcanic Armor"] = "Вулканические доспехи",
	["Ironfeather Armor"] = "Железноперые доспехи",
	["Stormshroud Armor"] = "Доспехи Грозового покрова",
	["Devilsaur Armor"] = "Доспехи из кожи девизавра",
	["Blood Tiger Harness"] = "Доспехи Кровавого тигра",
	["Primal Batskin"] = "Простая шкура нетопыря",
	["Wild Draenish Armor"] = "Доспехи дренейского дикаря",
	["Thick Draenic Armor"] = "Утолщенные дренейские доспехи",
	["Fel Skin"] = "Кожа Скверны",
	["Strength of the Clefthoof"] = "Сила копытня",
	["Primal Intent"] = "Изначальная цель",
	["Windhawk Armor"] = "Доспехи Ветроястреба",
	["Leatherworking Mail Sets"] = "Кольчуга (Кожевенное дело)",
	["Green Dragon Mail"] = "Кольчуга Зеленого дракона",
	["Blue Dragon Mail"] = "Кольчуга Синего дракона",
	["Black Dragon Mail"] = "Кольчуга Черного дракона",
	["Scaled Draenic Armor"] = "Чешуйчатые дренейские доспехи",
	["Felscale Armor"] = "Доспехи Чешуи Скверны",
	["Felstalker Armor"] = "Доспехи Темного следопыта",
	["Fury of the Nether"] = "Ярость Пустоты",
	["Netherscale Armor"] = "Доспехи из чешуи дракона Пустоты",
	["Netherstrike Armor"] = "Доспехи удара Пустоты",
	["Armorsmith"] = "Бронник",
	["Weaponsmith"] = "Оружейник",
	["Dragonscale"] = "Школа чешуи драконов",
	["Elemental"] = "Сила стихий",
	["Tribal"] = "Традиции предков",
	["Mooncloth"] = "Шитье из луноткани",
	["Shadoweave"] = "Шитье из тенеткани",
	["Spellfire"] = "Шитье из чароткани",
	["Gnomish"] = "Гномский механик",
	["Goblin"] = "Гоблинский механик",
	["Apprentice"] = "Ученик",
	["Journeyman"] = "Подмастерье",
	["Expert"] = "Умелец",
	["Artisan"] = "Искусник",
	["Master"] = "Мастер",

	--Set & PVP
	["Superior Rewards"] = "Наилучшие награды",
	["Epic Rewards"] = "Эпические награды",
	["Lv 10-19 Rewards"] = "Награды 10-19 уровня",
	["Lv 20-29 Rewards"] = "Награды 20-29 уровня",
	["Lv 30-39 Rewards"] = "Награды 30-39 уровня",
	["Lv 40-49 Rewards"] = "Награды 40-49 уровня",
	["Lv 50-59 Rewards"] = "Награды 50-59 уровня",
	["Lv 60 Rewards"] = "Награды на 60-й уровень",
	["PVP Cloth Set"] = "Тряпичный ПвП комплект",
	["PVP Leather Sets"] = "Кожаный ПвП комплект",
	["PVP Mail Sets"] = "Кольчужный ПвП комлект",
	["PVP Plate Sets"] = "Латный ПвП комлект",
	["World PVP"] = "Мировое ПвП",
	["Hellfire Fortifications"] = "Штурмовые укрепления",
	["Twin Spire Ruins"] = "Руины Двух Шпилей",
	["Spirit Towers (Terrokar)"] = "Spirit Towers (Лес Террокар)",
	["Halaa (Nagrand)"] = "Халаа (Награнд)",
	["Arena Season 1"] = "Арена (сезон 1)",
	["Arena Season 2"] = "Арена (сезон 2)",
	["Arena Season 3"] = "Арена (сезон 3)",
	["Arena Season 4"] = "Арена (сезон 4)",
	["Weapons"] = "Оружие",
	["Level 60 Honor PVP"] = "За очки доблести (60 уровень)",
	["Accessories"] = "Аксессуары",
	["Level 70 Reputation PVP"] = "За репутацию (70 уровень)",
	["Level 70 Honor PVP"] = "За очки доблести (70 уровень)",
	["Non Set Accessories"] = "Аксессуары (не из комплекта)",
	["Non Set Cloth"] = "Тряпичная броня (не из комплекта)",
	["Non Set Leather"] = "Кожаные доспехи (не из комлекта)",
	["Non Set Mail"] = "Кольчужные доспехи (не из комлекта)",
	["Non Set Plate"] = "Латы (не из комлекта)",
	["Tier 0.5 Quests"]= "Комплект ранга 0.5",
	["Tier 3 (Naxxramas Tokens)"] = "Талисманы комплекта ранга 3 (Наксрамас)",
	["Tier 4 Tokens"] = "Талисманы комплекта ранга 4",
	["Tier 5 Tokens"] = "Талисманы комплекта ранга 5",
	["Tier 6 Tokens"] = "Талисманы комплекта ранга 6",
	["Blizzard Collectables"] = "Blizzard Collectables",
	["WoW Collector Edition"] = "Коллекционое издание WoW",
	["BC Collector Edition (Europe)"] = "Коллекционое издание WOW:TBC",
	["Blizzcon 2005"] = "Blizzcon 2005",
	["Blizzcon 2007"] = "Blizzcon 2007",
	["Christmas Gift 2006"] = "Рождественский подарок 2006",
	["Upper Deck"] = "Upper Deck",
	["Loot Card Items"] = "Loot Card Items",
	["Heroic Mode Tokens"] = "За Знаки справедливости",
	["Fire Resistance Gear"] = "Экипировка с устойчивостью к огню",

	["Cloaks"] = "Плащи",
	["Relics"] = "Реликвии",
	["World Drops"] = "С кого угодно",
	["Level 30-39"] = "Уровень 30-39",
	["Level 40-49"] = "Уровень 40-49",
	["Level 50-60"] = "Уровень 50-60",
	["Level 70"] = "Уровень 70",

	-- Altoholic.Gathering : Mining
	["Copper Vein"] = "Медная Жила",
	["Tin Vein"] = "Оловянная Жила",
	["Iron Deposit"] = "Залежь Железа",
	["Silver Vein"] = "Серебрянная Жила",
	["Gold Vein"] = "Золотая Жила",
	["Mithril Deposit"] = "Митриловые залежи",
	["Ooze Covered Mithril Deposit"] = "Покрытые слизью мифриловые залежи",
	["Truesilver Deposit"] = "Залежи истинного серебра",
	["Ooze Covered Silver Vein"] = "Покрытая слизью серебряння жила",
	["Ooze Covered Gold Vein"] = "Покрытая слизью золотая жила",
	["Ooze Covered Truesilver Deposit"] = "Покрытые слизью залежи истинного серебра",
	["Ooze Covered Rich Thorium Vein"] = "Покрытая слизью богатая ториевая жила",
	["Ooze Covered Thorium Vein"] = "Покрытая слизью ториевая жила",
	["Small Thorium Vein"] = "Малая ториевая жила",
	["Rich Thorium Vein"] = "Богатая ториевая жила",
	["Hakkari Thorium Vein"] = "Hakkari Thorium Vein",
	["Dark Iron Deposit"] = "Залежи Темной Стали",
	["Lesser Bloodstone Deposit"] = "Малое месторождение кровавого камня",
	["Incendicite Mineral Vein"] = "Ароматитовая жила",
	["Indurium Mineral Vein"] = "Индарилиевая жила",
	["Fel Iron Deposit"] = "Месторождение оскверненного железа",
	["Adamantite Deposit"] = "Залежи адамантита",
	["Rich Adamantite Deposit"] = "Богатые залежи адамантита",
	["Khorium Vein"] = "Кориевая жила",
	["Large Obsidian Chunk"] = "Large Obsidian Chunk",
	["Small Obsidian Chunk"] = "Small Obsidian Chunk",
	["Nethercite Deposit"] = "Месторождение хаотита",

	-- Altoholic.Gathering : Herbalism
	["Peacebloom"] = "Мироцвет",
	["Silverleaf"] = "Сребролист",
	["Earthroot"] = "Землекорень",
	["Mageroyal"] = "Магороза",
	["Briarthorn"] = "Остротерн",
	["Swiftthistle"] = "Быстрорепей",
	["Stranglekelp"] = "Удавник",
	["Bruiseweed"] = "Синячник",
	["Wild Steelbloom"] = "Дикий сталецвет",
	["Grave Moss"] = "Могильный мох",
	["Kingsblood"] = "Королевская кровь",
	["Liferoot"] = "Жизнекорень",
	["Fadeleaf"] = "Бледнолист",
	["Goldthorn"] = "Златошип",
	["Khadgar's Whisker"] = "Кадгаров ус",
	["Wintersbite"] = "Зимник",
	["Firebloom"] = "Огнецвет",
	["Purple Lotus"] = "Пурпурный лотос",
	["Wildvine"] = "Дикий виноград",
	["Arthas' Tears"] = "Слезы Артаса",
	["Sungrass"] = "Солнечник",
	["Blindweed"] = "Слепырник",
	["Ghost Mushroom"] = "Призрачная поганка",
	["Gromsblood"] = "Кровь Грома",
	["Golden Sansam"] = "Золотой сансам",
	["Dreamfoil"] = "Снолист",
	["Mountain Silversage"] = "Горный серебряный шалфей",
	["Plaguebloom"] = "Чумоцвет",
	["Icecap"] = "Льдяник",
	["Bloodvine"] = "Кровавая лоза",
	["Black Lotus"] = "Черный лотос",
	["Felweed"] = "Скверноплевел",
	["Dreaming Glory"] = "Соннославник",
	["Terocone"] = "Терошишка",
	["Ancient Lichen"] = "Древний лишайник",
	["Bloodthistle"] = "Кровопийка",
	["Mana Thistle"] = "Манрепейник",
	["Netherbloom"] = "Пустоцвет",
	["Nightmare Vine"] = "Лозный кошмарник",
	["Ragveil"] = "Кисейница",
	["Flame Cap"] = "Огнеголовик",
	["Fel Lotus"] = "Оскверненный лотос",
	["Netherdust Bush"] = "Пыльник хаотический",

	["Glowcap"] = "Glowcap",
	["Sanguine Hibiscus"] = "Кровавый гибискус",

} end)

if GetLocale() == "ruRU" then
	-- Altoholic.xml local
	LEFT_HINT = "Щелкните левой кнопкой мыши чтобы |cFF00FF00открыть";
	RIGHT_HINT = "Щелкните правой кнопкой мыши чтобы  |cFF00FF00перетащить";

	XML_ALTO_TAB1 = "Сводная информация"
	XML_ALTO_TAB2 = "Персонажи"
	XML_ALTO_TAB3 = "Поиск"
	-- XML_ALTO_TAB4 = GUILD_BANK
	XML_ALTO_TAB5 = "Настройки"

	XML_ALTO_SUMMARY_MENU1 = "Отчет"
	XML_ALTO_SUMMARY_MENU2 = "Сумки"
	-- XML_ALTO_SUMMARY_MENU3 = SKILLS

	XML_ALTO_CHAR_DD1 = "Игровой мир"
	XML_ALTO_CHAR_DD2 = "Персонаж"
	XML_ALTO_CHAR_DD3 = "Просмотр"

	XML_ALTO_SEARCH_COL1 = "Предметы / Нахождение"
	
	XML_ALTO_OPT_MENU1 = "Общее"
	XML_ALTO_OPT_MENU2 = "Поиск"
	XML_ALTO_OPT_MENU3 = "Почта"
	XML_ALTO_OPT_MENU4 = "Мини-карта"
	XML_ALTO_OPT_MENU5 = "Подсказка"
	
	XML_TEXT_1 = "Всего";
	XML_TEXT_2 = "Поиск по сумкам";
	XML_TEXT_3 = "Параметры уровня";
	XML_TEXT_4 = "Качество";
	XML_TEXT_5 = "Ячейка снаряжения";
	XML_TEXT_6 = "Сброс";
	XML_TEXT_7 = "Поиск";
	
	XML_TEXT_MAIN_WINDOW_1 = "Включая предметы без требований к уровню";
	XML_TEXT_MAIN_WINDOW_5 = "Включая содержимое почтовых ящиков";
	XML_TEXT_MAIN_WINDOW_6 = "Включая содержимое банков гильдии";
	XML_TEXT_MAIN_WINDOW_7 = "Включая изученные рецепты";
	
	--Options.xml
	XML_TEXT_8 = "Настройки подсказок";
	XML_TEXT_9 = "Настройки поиска";
	XML_TEXT_10 = "Изменяет местположение иконки относительно мини-карты";
	XML_TEXT_11 = "Расположение иконки на мини-карте";
	XML_TEXT_12 = "Изменяет отступ иконки от мини-карты";
	XML_TEXT_13 = "Отступ иконки от мини-карты";
	XML_TEXT_14 = "Предупреждать об истечении срока хранения почты за указаное время";
	XML_TEXT_15 = "Сообщать об истечении срока хранения почты";
	XML_TEXT_16 = "Показывать иконку на мини-карте";
	XML_TEXT_17 = "Сортировать предметы в порядке убывания";
	XML_TEXT_18 = "Максимальную бодрость показывать как 150%";
	XML_TEXT_19 = "Просматривать почту (отмечает как прочитаную)";
	XML_TEXT_20 = "Указывать источник происхождения предмета";
	XML_TEXT_21 = "Показывать количество предметов у каждого персонажа";
	XML_TEXT_22 = "Показывать общее количество предметов";
	XML_TEXT_23 = "Включая количество предметов в банке гильдии";
	XML_TEXT_24 = "Включая изученные / доступные для изучения рецепты";
	XML_TEXT_25 = "Запрашивать информацию о предмете у сервера |cFFFF0000(риск отключения от сервера)";
	XML_TEXT_26 = "|cFFFFFFFFЕсли предмет не найден в локальном кэше клиента, но обнаружен во время поиска,\n"
	           .. "Altoholic попытается запросить информацию о предмете у сервера (не более 5 за раз).\n\n"
	           .. "Это значительно улучшает эффективность работы, поскольку больше количество предметов\n"
	           .. "будет включено в кэш клиента. Однако существует риск отключения от сервера, если запрощеный\n"
	           .. "предмет является добычей из инстанса слишком высогого уровня, недоступного этому серверу.\n\n"
	           .. "|cFF00FF00Не включайте|r если не хотите рисковать.";
end

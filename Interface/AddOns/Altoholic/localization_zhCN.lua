﻿local L = AceLibrary("AceLocale-2.2"):new("Altoholic")

L:RegisterTranslations("zhCN", function() return {

	-- Note: since 2.4.004 and the support of LibBabble, certain lines are commented, but remain there for clarity (especially those concerning the menu)
	-- A lot of translations, especially those concerning the loot table, comes from atlas loot, credit goes to their team for gathering this info, I (Thaoky) simply took what I needed.

	["Mage"] = "法师",
	["Warrior"] = "战士",
	["Hunter"] = "猎人",
	["Rogue"] = "潜行者",
	["Warlock"] = "术士",
	["Druid"] = "德鲁伊",
	["Shaman"] = "萨满祭司",
	["Paladin"] = "圣骑士",
	["Priest"] = "牧师",
	
	-- note: these string are the ones found in item tooltips, make sure to respect the case when translating, and to distinguish them (like crit vs spell crit)
	["Increases healing done by up to %d+"] = "法术治疗提高%d+",
	["Increases damage and healing done by magical spells and effects by up to %d+"] = "提高法术和魔法效果所造成的治疗效果，最多%d+",
	["Increases attack power by %d+"] = "攻击强度提高%d+",
	["Restores %d+ mana per"] = "秒恢复(%d+)点法力值",
	["Classes: Shaman"] = "职业：萨满祭司",
	["Classes: Mage"] = "职业：法师",
	["Classes: Rogue"] = "职业：潜行者",
	["Classes: Hunter"] = "职业：猎人",
	["Classes: Warrior"] = "职业：战士",
	["Classes: Paladin"] = "职业：圣骑士",
	["Classes: Warlock"] = "职业：术士",
	["Classes: Priest"] = "职业：牧师",
	["Resistance"] = "抗性",
	
	-- equipment slots
	["Ranged"] = "远程",
	
	--skills
	["Professions"] = "专业技能",
	["Secondary Skills"] = "第二专业",
	["Fishing"] = "钓鱼",
	["Riding"] = "骑术",
	["Herbalism"] = "草药学",
	["Mining"] = "采矿",
	["Skinning"] = "扒皮",
	["Lockpicking"] = "开锁",
	["Poisons"] = "毒药",
	["Beast Training"] = "野兽训练",
	
	--factions not in LibFactions or LibZone
	["Exodar"] = "埃索达",
	["Gnomeregan Exiles"] = "诺莫瑞根流亡者",
	["Stormwind"] = "暴风城",
	["Darkspear Trolls"] = "暗矛巨魔",
	["Alliance Forces"] = "联盟部队",
	["Horde Forces"] = "部落部队",
	["Steamwheedle Cartel"] = "热砂港",
	["Other"] = "其他",
	["Ravenholdt"] = "拉文霍德",
	["Shen'dralar"] = "辛德拉",
	["Syndicate"] = "辛迪加",
	
	-- menu
	["Reputations"] = "声望",
	["Containers"] = "容器",
	["Guild Bank not visited yet (or not guilded)"] = "公会银行未访问(或你没加入任何公会)",
	["E-Mail"] = "邮件",
	["Quests"] = "任务",
	["Equipment"] = "装备",
	
	--Altoholic.lua
	["Loots"] = "拾取",
	["Unknown"] = "未知",
	["Mail expires in less than "] = "信件将在 ",
	[" days"] = " 天后失效",
	["Bank not visited yet"] = "尚未访问银行",
	["Levels"] = "级",
	["(has mail)"] = "(有新的邮件)",
	["(has auctions)"] = "(有新的拍卖行通知)",
	["(has bids)"] = "(有新的一口价货物)",
	
	["No rest XP"] = "无经验奖励",
	["% rested"] = "% 经验奖励",
	["Transmute"] = "转化",
	
	["Bags"] = "背包",
	["Bank"] = "银行",
	["Equipped"] = "已装备",
	["Mail"] = "邮件",
	["Mails %s(%d)"] = "邮件 %s(%d)",
	["Auctions %s(%d)"] = "拍卖行 %s(%d)",
	["Bids %s(%d)"] = "一口价 %s(%d)",
	[", "] = "，",
	["(Guild bank: "] = "(公会银行: ",
	
	["Level"] = "等级",
	["Zone"] = "地区",
	["Rest XP"] = "奖励经验",
	
	["Source"] = "来源",
	["Total owned"] = "总计",
	["Already known by "] = "已学会：",
	["Will be learnable by "] = "将学习：",
	["Could be learned by "] = "可学习：",
	
	["At least one recipe could not be read"] = "最少有一个配方可学习",
	["Please open this window again"] = "请再次打开窗口",
	
	--Core.lua
	['search'] = '搜索',
	["Search in bags"] = '在背包中搜索',
	['show'] = '显示',
	["Shows the UI"] = '显示图形界面',
	['hide'] = '隐藏',
	["Hides the UI"] = '隐藏图形界面',
	['toggle'] = '切换',
	["Toggles the UI"] = '切换图形界面的显示/隐藏',
	
	--AltoholicFu.lua
	["Left-click to"] = "左键点击",
	["open/close"] = "打开/关闭",
	
	--AccountSummary.lua
	["View bags"] = "背包浏览",
	["All-in-one"] = "整合",
	["View mailbox"] = "邮箱浏览",
	["View quest log"] = "任务浏览",
	["View auctions"] = "浏览拍卖行",
	["View bids"] = "浏览一口价",
	["Delete this Alt"] = "删除该人物镜像",
	["Cannot delete current character"] = "无法删除当前人物镜像",
	["Character %s successfully deleted"] = "人物： %s 成功删除！",
	["Suggested leveling zone: "] = "推荐升级地区: ",
	["Arena points: "] = "竞技场点数: ",
	["Honor points: "] = "荣誉点数: ",
	
	-- AuctionHouse.lua
	[" has no auctions"] = " 无拍卖行通知",
	[" has no bids"] = " 无一口价货物",
	["last check "] = "上次检查于 ",
	["Goblin AH"] = "地精拍卖行",
	["Clear your faction's entries"] = "清理你阵营的拍卖行的相关信息",
	["Clear goblin AH entries"] = "清理地精拍卖行的相关信息",
	["Clear all entries"] = "清理所有拍卖行的相关信息",
	
	--BagUsage.lua
	["Totals"] = "总计",
	["slots"] = "格",
	["free"] = "空余",
	
	--Containers.lua
	["32 Keys Max"] = "最大32格",
	["28 Slot"] = "28格",
	["Bank bag"] = "银行背包",
	["Unknown link, please relog this character"] = "未知链接，请重新登入角色",
	
	--Equipment.lua
	["Find Upgrade"] = "发现更高级",
	["(based on iLvl)"] = "(基于物品等级)",
	["Right-Click to find an upgrade"] = "右键点击查找高端进阶装备",
	["Tank"] = "坦克",
	["DPS"] = "伤害输出",
	["Balance"] = "平衡",
	["Elemental Shaman"] = "元素",		-- shaman spec !
	["Heal"] = "治疗",
	
	--GuildBank.lua
	["Last visited "] = "距离上次访问 ",
	[" days ago by "] = " 天，访问者 ",
	
	--Mails.lua
	[" has not visited his/her mailbox yet"] = " 尚未访问其邮箱",
	[" has no mail, last check "] = " 无邮件，上次访问于 ",
	[" days ago"] = " 天前",
	["Mailbox: "] = "邮箱: ",
	["Mail was last checked "] = "邮箱上次访问于 ",
	[" days"] = " 天",
	
	--Quests.lua
	["No quest found for "] = "未发现任务：",
	["QuestID"] = "任务编号",
	["Are also on this quest:"] = "有相同任务: ",
	
	--Recipes.lua
	["No data: "] = "无数据: ",
	[" scan failed for "] = " 扫描失败于 ",
	
	--Reputations.lua
	["Shift-Click to link this info"] = "Shift+点击链接此信息",
	[" is "] = " 为 ",
	[" with "] = " 对 ",
	
	--Search.lua
	["Item Level"] = "物品等级",
	[" results found (Showing "] = " 个结果 (显示 ",
	["No match found!"] = "未发现匹配的!",
	[" not found!"] = " 未发现!",
	["Socket"] = "镶孔",
	
	--skills.lua
	["Rogue Proficiencies"] = "潜行者专有技能",
	["up to"] = "升到",
	["at"] = " ",
	["and above"] = "及以上",
	["Suggestion"] = "建议",
	["Prof. 1"] = "商业技能",
	["Prof. 2"] = "辅助技能",
	
	-- TabSearch.lua
	["Any"] = "所有",
	["Miscellaneous"] = "杂项",
	["Fishing Poles"] = "鱼竿",
	["This realm"] = "仅搜索该服务器",		-- please update these 3 string to display "this realm" instead of "search this realm" ...
	["All realms"] = "搜索所有服务器",
	["Loot tables"] = "搜索掉落列表",
	
	--loots.lua
	--Instinct drop
	["Trash Mobs"] = "小怪掉落",
	["Random Boss"] = "随机首领",
	["Druid Set"] = "德鲁伊套装",
	["Hunter Set"] = "猎人套装",
	["Mage Set"] = "法师套装",
	["Paladin Set"] = "圣骑士套装",
	["Priest Set"] = "牧师套装",
	["Rogue Set"] = "潜行者套装",
	["Shaman Set"] = "萨满祭司套装",
	["Warlock Set"] = "术士套装",
	["Warrior Set"] = "战士套装",
	["Legendary Mount"] = "史诗坐骑",
	["Legendaries"] = "传说装备",
	["Muddy Churning Waters"] = "混浊的水",
	["Shared"] = "共享掉落",
	["Enchants"] = "附魔",
	["Rajaxx's Captains"] = "拉贾克斯将军的随从",
	["Class Books"] = "职业书籍",
	["Quest Items"] = "任务物品",
	["Druid of the Fang (Trash Mob)"] = "尖牙德鲁伊(小怪)",
	["Spawn Of Hakkar"] = "哈卡的后代",
	["Troll Mini bosses"] = "巨魔小首领",
	["Henry Stern"] = "亨利·斯特恩",
	["Magregan Deepshadow"] = "马格雷甘·深影",
	["Tablet of Ryuneh"] = "雷乌纳石板",
	["Krom Stoutarm Chest"] = "克罗姆·粗臂的箱子",
	["Garrett Family Chest"] = "加瑞特家族的箱子",
	["Eric The Swift"] = "埃瑞克",
	["Olaf"] = "奥拉夫",
	["Baelog's Chest"] = "巴尔洛戈的箱子",
	["Conspicuous Urn"] = "明显的墓碑",
	["Tablet of Will"] = "意志石板",
	["Shadowforge Cache"] = "暗炉储藏室",
	["Roogug"] = "鲁古格",
	["Aggem Thorncurse"] = "阿格姆",
	["Razorfen Spearhide"] = "剃刀沼泽刺鬃守卫",
	["Pyron"] = "征服者派隆",
	["Theldren"] = "塞尔德林",
	["The Vault"] = "宝窟",
	["Summoner's Tomb"] = "召唤者之墓",
	["Plans"] = "设计图",
	["Zelemar the Wrathful"] = "愤怒者塞雷玛尔",
	["Rethilgore"] = "雷希戈尔",
	["Fel Steed"] = "地狱战马",
	["Tribute Run"] = "贡品出产",
	["Shen'dralar Provisioner"] = "辛德拉圣职者",
	["Books"] = "书籍",
	["Trinkets"] = "饰品",
	["Sothos & Jarien"] = "索托斯和亚雷恩",
	["Fel Iron Chest"] = "魔铁宝箱",
	[" (Heroic)"] = "(英雄模式)",
	["Yor (Heroic Summon)"] = "尤尔(英雄模式召唤)",
	["Avatar of the Martyred"] = "殉难者的化身",
	["Anzu the Raven God (Heroic Summon)"] = "安苏，乌鸦之王(英雄模式召唤)",
	["Thomas Yance"] = "托马斯·杨斯",
	["Aged Dalaran Wizard"] = "老迈的达拉然巫师",
	["Cache of the Legion"] = "军团储藏室",
	["Opera (Shared Drops)"] = "剧场(共享掉落)",
	["Timed Chest"] = "限时宝箱",
	["Patterns"] = "图样",
	
	--Rep
	["Token Hand-Ins"] = "上缴物品交换",
	["Items"] = "物品",
	["Beasts Deck"] = "野兽套牌",
	["Elementals Deck"] = "元素套牌",
	["Warlords Deck"] = "督军套牌",
	["Portals Deck"] = "入口套牌",
	["Furies Deck"] = "报复套牌",
	["Storms Deck"] = "风暴套牌",
	["Blessings Deck"] = "祝福套牌",
	["Lunacy Deck"] = "愚人套牌",
	["Quest rewards"] = "任务奖励",
	["Shattrath"] = "沙塔斯城",
	
	--World drop
	["Outdoor Bosses"] = "户外首领",
	["Highlord Kruul"] = "魔王库鲁尔",
	["Bash'ir Landing"] = "巴什伊尔码头",
	["Skyguard Raid"] = "天空卫队团队任务",
	["Stasis Chambers"] = "阿尔法静止间",
	["Skettis"] = "斯克提斯",
	["Darkscreecher Akkarai"] = "黑暗尖啸者阿克卡莱",
	["Karrog"] = "卡尔洛格",
	["Gezzarak the Huntress"] = "猎手吉萨拉克",
	["Vakkiz the Windrager"] = "风怒者瓦克奇斯",
	["Terokk"] = "泰罗克",
	["Ethereum Prison"] = "复仇军监牢",
	["Armbreaker Huffaz"] = "断臂者霍法斯",
	["Fel Tinkerer Zortan"] = "魔能工匠索尔坦",
	["Forgosh"] = "弗尔高什",
	["Gul'bor"] = "古尔博",
	["Malevus the Mad"] = "疯狂的玛尔弗斯",
	["Porfus the Gem Gorger"] = "掘钻者波弗斯",
	["Wrathbringer Laz-tarash"] = "天罚使者拉塔莱什",
	["Abyssal Council"] = "深渊议会",
	["Crimson Templar (Fire)"] = "赤红圣殿骑士(火)",
	["Azure Templar (Water)"] = "碧蓝圣殿骑士(水)",
	["Hoary Templar (Wind)"] = "苍白圣殿骑士(风)",
	["Earthen Templar (Earth)"] = "土色圣殿骑士(地)",
	["The Duke of Cinders (Fire)"] = "灰烬公爵(火)",
	["The Duke of Fathoms (Water)"] = "深渊公爵(水)",
	["The Duke of Zephyrs (Wind)"] = "微风公爵(风)",
	["The Duke of Shards (Earth)"] = "碎石公爵(地)",
	["Elemental Invasion"] = "元素入侵",
	["Gurubashi Arena"] = "古拉巴什竞技场",
	["Booty Run"] = "宝箱争夺战",
	["Fishing Extravaganza"] = "荆棘谷钓鱼大赛",
	["First Prize"] = "第一名奖励",
	["Rare Fish"] = "稀有鱼类",
	["Rare Fish Rewards"] = "稀有鱼类奖励",
	["Children's Week"] = "儿童周",
	["Love is in the air"] = "爱情的气息",
	["Gift of Adoration"] = "爱慕的礼物",
	["Box of Chocolates"] = "一盒巧克力",
	["Hallow's End"] = "万圣节",
	["Various Locations"] = "多个地点",
	["Treat Bag"] = "糖果包",
	["Headless Horseman"] = "无头骑士",
	["Feast of Winter Veil"] = "冬幕节",
	["Smokywood Pastures Vendor"] = "烟林牧场商人",
	["Gaily Wrapped Present"] = "微微震动的礼物",
	["Festive Gift"] = "节日礼物",
	["Winter Veil Gift"] = "冬幕节的礼物",
	["Gently Shaken Gift"] = "精美的礼品",
	["Ticking Present"] = "条纹礼物盒",
	["Carefully Wrapped Present"] = "精心包裹的礼物",
	["Noblegarden"] = "贵族的花园",
	["Brightly Colored Egg"] = "明亮的彩蛋",
	["Smokywood Pastures Extra-Special Gift"] = "烟林牧场的超级特殊礼物",
	["Harvest Festival"] = "收获节",
	["Food"] = "食物",
	["Scourge Invasion"] = "天灾入侵",
	["Miscellaneous"] = "杂项",
	["Cloth Set"] = "布甲套装",
	["Leather Set"] = "皮甲套装",
	["Mail Set"] = "链甲套装",
	["Plate Set"] = "板甲套装",
	["Balzaphon"] = "巴尔萨冯",
	["Lord Blackwood"] = "布莱克伍德公爵",
	["Revanchion"] = "雷瓦克安",
	["Scorn"] = "瑟克恩",
	["Sever"] = "塞沃尔",
	["Lady Falther'ess"] = "法瑟蕾丝夫人",
	["Lunar Festival"] = "新年",
	["Fireworks Pack"] = "春节烟花包",
	["Lucky Red Envelope"] = "红包",
	["Midsummer Fire Festival"] = "仲夏焰火节",
	["Lord Ahune"] = "埃霍恩",
	["Shartuul"] = "沙图尔",
	["Blade Edge Mountains"] = "刀锋山",
	["Brewfest"] = "美酒节",
	["Barleybrew Brewery"] = "美酒节日酒桶",
	["Thunderbrew Brewery"] = "雷酒节日酒桶",
	["Gordok Brewery"] = "戈多克节日酒桶",
	["Drohn's Distillery"] = "德罗恩的节日佳酿酒桶",
	["T'chali's Voodoo Brewery"] = "塔卡里的节日巫毒酒桶",
	
	--craft
	["Crafted Weapons"] = "制作的武器",
	["Master Swordsmith"] = "宗师级铸剑",
	["Master Axesmith"] = "宗师级铸斧",
	["Master Hammersmith"] = "宗师级铸锤",
	["Blacksmithing (Lv 60)"] = "锻造(60级)",
	["Blacksmithing (Lv 70)"] = "锻造(70级)",
	["Engineering (Lv 60)"] = "工程学(60级)",
	["Engineering (Lv 70)"] = "工程学(70级)",
	["Blacksmithing Plate Sets"] = "锻造板甲套装",
	["Imperial Plate"] = "君王板甲",
	["The Darksoul"] = "黑暗之魂",
	["Fel Iron Plate"] = "魔铁板甲",
	["Adamantite Battlegear"] = "精金战甲",
	["Flame Guard"] = "烈焰卫士",
	["Enchanted Adamantite Armor"] = "魔化精金套装",
	["Khorium Ward"] = "氪金套装",
	["Faith in Felsteel"] = "魔钢的信仰",
	["Burning Rage"] = "钢铁之怒",
	["Blacksmithing Mail Sets"] = "锻造链甲套装",
	["Bloodsoul Embrace"] = "血魂的拥抱",
	["Fel Iron Chain"] = "魔铁链甲",
	["Tailoring Sets"] = "裁缝套装",
	["Bloodvine Garb"] = "血藤",
	["Netherweave Vestments"] = "灵纹套装",
	["Imbued Netherweave"] = "魔化灵纹套装",
	["Arcanoweave Vestments"] = "奥法交织套装",
	["The Unyielding"] = "不屈的力量",
	["Whitemend Wisdom"] = "白色治愈",
	["Spellstrike Infusion"] = "法术打击",
	["Battlecast Garb"] = "战斗施法套装",
	["Soulcloth Embrace"] = "灵魂布之拥",
	["Primal Mooncloth"] = "原始月布",
	["Shadow's Embrace"] = "暗影之拥",
	["Wrath of Spellfire"] = "魔焰之怒",
	["Leatherworking Leather Sets"] = "制皮皮甲套装",
	["Volcanic Armor"] = "火山",
	["Ironfeather Armor"] = "铁羽护甲",
	["Stormshroud Armor"] = "雷暴",
	["Devilsaur Armor"] = "魔暴龙护甲",
	["Blood Tiger Harness"] = "血虎",
	["Primal Batskin"] = "原始蝙蝠皮套装",
	["Wild Draenish Armor"] = "野性德莱尼套装",
	["Thick Draenic Armor"] = "厚重德莱尼套装",
	["Fel Skin"] = "魔能之肤",
	["Strength of the Clefthoof"] = "裂蹄之力",
	["Primal Intent"] = "原始打击",
	["Windhawk Armor"] = "风鹰",
	["Leatherworking Mail Sets"] = "制皮链甲套装",
	["Green Dragon Mail"] = "绿龙锁甲",
	["Blue Dragon Mail"] = "蓝龙锁甲",
	["Black Dragon Mail"] = "黑龙锁甲",
	["Scaled Draenic Armor"] = "缀鳞德拉诺套装",
	["Felscale Armor"] = "魔鳞套装",
	["Felstalker Armor"] = "魔能猎手",
	["Fury of the Nether"] = "虚空之怒",
	["Netherscale Armor"] = "虚空之鳞",
	["Netherstrike Armor"] = "虚空打击",
	["Armorsmith"] = "防具锻造",
	["Weaponsmith"] = "武器锻造",
	["Dragonscale"] = "龙鳞",
	["Elemental"] = "元素",
	["Tribal"] = "部族",
	["Mooncloth"] = "月布",
	["Shadoweave"] = "暗纹",
	["Spellfire"] = "魔焰",
	["Gnomish"] = "侏儒",
	["Goblin"] = "地精",
	["Apprentice"] = "初级",
	["Journeyman"] = "中级",
	["Expert"] = "高级",
	["Artisan"] = "专家级",
	["Master"] = "宗师级",
	
	--Set & PVP
	["Superior Rewards"] = "精良奖励",
	["Epic Rewards"] = "史诗奖励",
	["Lv 10-19 Rewards"] = "10~19级奖励",
	["Lv 20-29 Rewards"] = "20-29级奖励",
	["Lv 30-39 Rewards"] = "30-39级奖励",
	["Lv 40-49 Rewards"] = "40-49级奖励",
	["Lv 50-59 Rewards"] = "50-59级奖励",
	["Lv 60 Rewards"] = "60级奖励",
	["PVP Cloth Set"] = "PVP布甲套装",
	["PVP Leather Sets"] = "PVP皮甲套装",
	["PVP Mail Sets"] = "PVP链甲套装",
	["PVP Plate Sets"] = "PVP板甲套装",
	["World PVP"] = "世界PVP",
	["Hellfire Fortifications"] = "地狱火半岛的工事",
	["Twin Spire Ruins"] = "双塔废墟",
	["Spirit Towers (Terrokar)"] = "灵魂之塔(泰罗卡森林,白骨荒野)",
	["Halaa (Nagrand)"] = "哈兰(纳格兰)",
	["Arena Season 1"] = "竞技场第一季",
	["Arena Season 2"] = "竞技场第二季",
	["Arena Season 3"] = "竞技场第三季",
	["Arena Season 4"] = "竞技场第四季",
	["Weapons"] = "武器",
	["Level 60 Honor PVP"] = "60级PVP荣誉装",
	["Accessories"] = "配件",
	["Level 70 Reputation PVP"] = "70级PVP声望装",
	["Level 70 Honor PVP"] = "70级PVP荣誉装",
	["Non Set Accessories"] = "非套装配件",
	["Non Set Cloth"] = "非套装布甲",
	["Non Set Leather"] = "非套装皮甲",
	["Non Set Mail"] = "非套装链甲",
	["Non Set Plate"] = "非套装板甲",
	["Tier 0.5 Quests"] = "T0.5任务换取",
	["Tier 3 (Naxxramas Tokens)"] = "T3(纳克萨玛斯掉落,被玷污系列)",
	["Tier 4 Tokens"] = "T4(换取,阵亡勇士系列)",
	["Tier 5 Tokens"] = "T5(换取,战败勇士系列)",
	["Tier 6 Tokens"] = "T6(换取,遗忘胜利者系列)",
	["Blizzard Collectables"] = "暴雪收藏品",
	["WoW Collector Edition"] = "魔兽世界收藏版",
	["BC Collector Edition (Europe)"] = "燃烧的远征收藏版(欧洲版)",
	["Blizzcon 2005"] = "暴雪嘉年华2005",
	["Blizzcon 2007"] = "暴雪嘉年华2007",
	["Christmas Gift 2006"] = "圣诞礼物2006",
	["Upper Deck"] = "桌面纸牌",
	["Loot Card Items"] = "稀有纸牌物品",
	["Heroic Mode Tokens"] = "公正徽章换取",
	["Fire Resistance Gear"] = "火抗套装",

	["Cloaks"] = "披风",
	["Relics"] = "圣物",
	["World Drops"] = "世界掉落",
	["Level 30-39"] = "30-39级",
	["Level 40-49"] = "40-49级",
	["Level 50-60"] = "50-60级",
	["Level 70"] = "70级",
	
	-- Altoholic.Gathering : Mining
	["Copper Vein"] = "铜矿",
	["Tin Vein"] = "锡矿",
	["Iron Deposit"] = "铁矿石",
	["Silver Vein"] = "银矿",
	["Gold Vein"] = "金矿石",
	["Mithril Deposit"] = "秘银矿脉",
	["Ooze Covered Mithril Deposit"] = "软泥覆盖的秘银矿脉",
	["Truesilver Deposit"] = "真银矿石",
	["Ooze Covered Silver Vein"] = "软泥覆盖的银矿脉",
	["Ooze Covered Gold Vein"] = "软泥覆盖的金矿脉",
	["Ooze Covered Truesilver Deposit"] = "软泥覆盖的真银矿脉",
	["Ooze Covered Rich Thorium Vein"] = "软泥覆盖的富瑟银矿脉",
	["Ooze Covered Thorium Vein"] = "软泥覆盖的瑟银矿脉",
	["Small Thorium Vein"] = "瑟银矿脉",
	["Rich Thorium Vein"] = "富瑟银矿",
	["Hakkari Thorium Vein"] = "哈卡莱瑟银矿脉",
	["Dark Iron Deposit"] = "黑铁矿脉",
	["Lesser Bloodstone Deposit"] = "次级血石矿脉",
	["Incendicite Mineral Vein"] = "火岩矿脉",
	["Indurium Mineral Vein"] = "精铁矿脉",
	["Fel Iron Deposit"] = "魔铁矿脉",
	["Adamantite Deposit"] = "精金矿脉",
	["Rich Adamantite Deposit"] = "富精金矿脉",
	["Khorium Vein"] = "氪金矿脉",
	["Large Obsidian Chunk"] = "大型黑曜石碎块",
	["Small Obsidian Chunk"] = "小型黑曜石碎块",
	["Nethercite Deposit"] = "虚空矿脉",
	
	-- Altoholic.Gathering : Herbalism
	["Peacebloom"] = "宁神花",
	["Silverleaf"] = "银叶草",
	["Earthroot"] = "地根草",
	["Mageroyal"] = "魔皇草",
	["Briarthorn"] = "石南草",
	["Swiftthistle"] = "雨燕草",
	["Stranglekelp"] = "荆棘藻",
	["Bruiseweed"] = "跌打草",
	["Wild Steelbloom"] = "野钢花",
	["Grave Moss"] = "墓地苔",
	["Kingsblood"] = "皇血草",
	["Liferoot"] = "活根草",
	["Fadeleaf"] = "枯叶草",
	["Goldthorn"] = "金棘草",
	["Khadgar's Whisker"] = "卡德加的胡须",
	["Wintersbite"] = "冬刺草",
	["Firebloom"] = "火焰花",
	["Purple Lotus"] = "紫莲花",
	["Wildvine"] = "野葡萄藤",
	["Arthas' Tears"] = "阿尔萨斯之泪",
	["Sungrass"] = "太阳草",
	["Blindweed"] = "盲目草",
	["Ghost Mushroom"] = "幽灵菇",
	["Gromsblood"] = "格罗姆之血",
	["Golden Sansam"] = "黄金参",
	["Dreamfoil"] = "梦叶草",
	["Mountain Silversage"] = "山鼠草",
	["Plaguebloom"] = "瘟疫花",
	["Icecap"] = "冰盖草",
	["Bloodvine"] = "血藤",
	["Black Lotus"] = "黑莲花",
	["Felweed"] = "魔草",
	["Dreaming Glory"] = "梦露花",
	["Terocone"] = "泰罗果",
	["Ancient Lichen"] = "远古苔",
	["Bloodthistle"] = "血蓟",
	["Mana Thistle"] = "法力蓟",
	["Netherbloom"] = "虚空花",
	["Nightmare Vine"] = "噩梦藤",
	["Ragveil"] = "邪雾草",
	["Flame Cap"] = "烈焰菇",
	["Fel Lotus"] = "魔莲花",
	["Netherdust Bush"] = "灵尘灌木丛",
	["Glowcap"] = "亮顶蘑菇",
	["Sanguine Hibiscus"] = "红色木槿",
	
} end)

if GetLocale() == "zhCN" then
-- Altoholic.xml local
LEFT_HINT = "左键点击|cFF00FF00打开";
RIGHT_HINT = "右键点击|cFF00FF00拖拽";

XML_ALTO_TAB1 = "Summary"
XML_ALTO_TAB2 = "人物"
XML_ALTO_TAB3 = "搜索"
-- XML_ALTO_TAB4 = GUILD_BANK
XML_ALTO_TAB5 = "选项"

XML_ALTO_SUMMARY_MENU1 = "账号统计"
XML_ALTO_SUMMARY_MENU2 = "背包用量"
-- XML_ALTO_SUMMARY_MENU3 = SKILLS

XML_ALTO_CHAR_DD1 = "服务器"
XML_ALTO_CHAR_DD2 = "人物"
XML_ALTO_CHAR_DD3 = "浏览"

XML_ALTO_SEARCH_COL1 = "Item / Location"

XML_ALTO_OPT_MENU1 = "一般"
XML_ALTO_OPT_MENU2 = "搜索"
XML_ALTO_OPT_MENU3 = "邮件"
XML_ALTO_OPT_MENU4 = "小地图"
XML_ALTO_OPT_MENU5 = "提示"

XML_TEXT_1 = "总计";
XML_TEXT_2 = "搜索容器";
XML_TEXT_3 = "等级范围";
XML_TEXT_4 = "稀有度";
XML_TEXT_5 = "装备位置";
XML_TEXT_6 = "重置";
XML_TEXT_7 = "搜索";

XML_TEXT_MAIN_WINDOW_1 = "包含没有等级要求的物品";
XML_TEXT_MAIN_WINDOW_5 = "包括邮箱";
XML_TEXT_MAIN_WINDOW_6 = "包括公会银行";
XML_TEXT_MAIN_WINDOW_7 = "包括已知配方";

--Options.xml
XML_TEXT_8 = "提示选项";
XML_TEXT_9 = "搜索选项";
XML_TEXT_10 = "移动迷你地图图标的角度";
XML_TEXT_11 = "迷你地图图标角度";
XML_TEXT_12 = "移动迷你地图图标的半径";
XML_TEXT_13 = "迷你地图图标半径";
XML_TEXT_14 = "在邮件过期前多少天进行警告";
XML_TEXT_15 = "邮件过期警告";
XML_TEXT_16 = "显示迷你地图图标";
XML_TEXT_17 = "拾取按照逆序排列";
XML_TEXT_18 = "最大奖励经验显示为150%";
XML_TEXT_19 = "扫描邮件内容(标记为已读)";
XML_TEXT_20 = "显示物品来源";
XML_TEXT_21 = "显示每个人物的物品数量";
XML_TEXT_22 = "显示物品总计数量";
XML_TEXT_23 = "包括公会银行内的物品";
XML_TEXT_24 = "包括已学习/可学习：";
XML_TEXT_25 = "自动向服务器查询|cFFFF0000(可能会掉线！)";
XML_TEXT_26 = "|cFFFFFFFF如果一个不在本地缓存中物品\n"
				.. "被在搜索物品时被搜索到，\n"
				.. "Altoholic将会尝试以5个每次的频率向服务器查询。\n\n"
				.. "这将会逐渐的改进搜索的效率，\n"
				.. "因为越来越多的物品将被保存到物品缓存中。\n\n"
				.. "当然，向服务器查询物品时有掉线的风险，\n"
				.. "特别是那些没有被完全推倒的首领！\n\n"
				.. "|cFF00FF00禁用|r以防止发生这类现象。";
end

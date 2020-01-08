﻿local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local BI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()
local BZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable()
local BF = LibStub("LibBabble-Faction-3.0"):GetLookupTable()

if GetLocale() ~= "zhCN" then return end

local WHITE		= "|cFFFFFFFF"
local GREEN		= "|cFF00FF00"
local YELLOW	= "|cFFFFFF00"

-- 以下为声望值、等级、技能等的建议
Altoholic.Suggestions = {
	[L["Riding"]] = {
		{ 75, "初级骑术(40级): |cFFFFFFFF90g\n|cFFFFD700主城附近的的普通坐骑：|cFFFFFFFF10g" },
		{ 150, "中级骑术(60级): |cFFFFFFFF600g\n|cFFFFD700主城附近的史诗级坐骑：|cFFFFFFFF100g" },
		{ 225, "高级骑术(70级): |cFFFFFFFF800g\n|cFFFFD700影月谷附近的普通飞行坐骑：|cFFFFFFFF100g" },
		{ 300, "专家级骑乘(70级): |cFFFFFFFF5000g\n|cFFFFD700影月谷附近的史诗级飞行坐骑：|cFFFFFFFF200g" }
	},
	
	-- 来源 : http://forums.worldofwarcraft.com/thread.html?topicId=102789457&sid=1（英文）
	-- ** 主专业技能 **
	[BI["Tailoring"]] = {
		{ 50, "1~50: 亚麻布卷\n(2×亚麻布)×80" },
		{ 70, "51~70: 亚麻包\n(3×亚麻布卷|3×粗线)×20" },
		{ 75, "71~75: 强化亚麻斗篷\n(2×亚麻布卷|3×粗线)×5" },
		{ 105, "76~105: 毛布卷\n(3×毛料)×60" },
		{ 110, "106~110: 灰色毛纺衬衣\n(2×毛布卷|1×细线|1×灰色染料)×5"},
		{ 125, "111~125: 双线毛纺护肩\n(3×毛布卷|2×细线)×15" },
		{ 145, "126~145: 丝绸卷\n(4×丝绸)×190" },
		{ 160, "146~160: 碧蓝丝质头巾\n(2×丝绸卷|2×蓝色染料|1×细线)×15" },
		{ 170, "161~170: 丝质头带\n(3×丝绸卷|2×细线)×10" },
		{ 175, "171~175: 体面的白衬衣\n(3×丝绸卷|2×漂白液|1×细线)×5" },
		{ 185, "176~185: 魔纹布卷\n(5×魔纹布)×100" },
		{ 205, "186~205: 深红丝质外衣\n(4×丝绸卷|2×红色染料|2×细线)×15" },
		{ 215, "206~215: 深红丝质马裤(4×丝绸卷|2×红色染料|2×丝线)×15" },
		{ 220, "216~220: 黑色魔纹短裤\n黑色魔纹外衣\n(2×魔纹布卷|3×丝线)×5" },
		{ 230, "221~230: 黑色魔纹手套\n(2×魔纹布卷|2×粗丝线)×10" },
		{ 250, "231~250: 黑色魔纹头带\n黑色魔纹护肩\n(3×魔纹布卷|2×粗丝线)×20" },
		{ 260, "251~260: 符文布卷\n(5×符文布)×180" },
		{ 275, "261~275: 符文布腰带\n(3×符文布卷|1×符文线)×15" },
		{ 280, "276~280: 符文布背包\n(5×符文布卷|2×硬甲皮|1×符文线)×5" },
		{ 300, "281~300: 符文布手套\n(4×符文布卷|4×硬甲皮|1×符文线)×20" },
		{ 325, "301~325: 灵纹布卷\n(6×灵纹布)×25\n|cFFFFD700千万别卖掉，你用来继续升级的！" },
		{ 340, "326~340: 魔化灵纹布卷\n(3×灵纹布卷|2×奥法之尘)×15\n|cFFFFD700千万别卖掉，你用来继续升级的！" },
		{ 350, "341~350: 灵纹长靴\n(6×灵纹布卷|2×结缔皮|1×符文线)×10\n|cFFFFD700可分解为奥法之尘。" },
		{ 360, "351~360: 灵纹外套\n(8×灵纹布卷|2×符文线)×10\n|cFFFFD700可分解为奥法之尘。" },
		{ 375, "361~375: 魔化灵纹外套\n(6×魔化灵纹布卷|2×灵网蜘蛛丝|1×符文线)×15\n期间可以选择分支并作专业套装。" }
	},
	[BI["Leatherworking"]] = {
		{ 35, "1~35: 轻型护甲片\n(1×轻皮)×35" },
		{ 55, "36~55: 熟化轻毛皮\n(1×轻毛皮|1×盐)×20" },
		{ 80, "56~80: 雕花皮靴\n(8×轻皮|5×粗线)×15" },
		{ 85, "81~85: 优质皮带\n(6×轻皮|2×粗线)×5" },
		{ 90, "86~90: 优质皮外套\n(3×熟化轻毛皮|6×轻皮|4×粗线)×5" },
		{ 100, "91~100: 优质皮带\n(6×轻皮|2×粗线)×10" },
		{ 120, "101~120: 熟化中毛皮\n(1×中毛皮|1×盐)×20" },
		{ 125, "121~125: 优质皮带\n(6×轻皮|2×粗线)×5" },
		{ 150, "126~150: 黑皮腰带\n(1×优质皮带|1×熟化中毛皮|2×细线|1×灰色染料)×25" },
		{ 160, "151~160: 熟化重毛皮\n(1×重毛皮|3×盐)×10" },
		{ 170, "161~170: 重型护甲片\n(5×重皮|1×细线)×10" },
		{ 180, "171~180: 暗色皮护腿\n(10×重皮|1×黑色染料|2×细线)×10\n守护短裤\n(12×重皮|2×丝绸卷|2×细线)×10" },
		{ 195, "181~195: 野人护肩\n(8×重皮|1×熟化重毛皮|2×细线)×15" },
		{ 205, "196~205: 暗色护腕\n(16×重皮|1×黑色染料|2×丝线)×10" },
		{ 220, "206~220: 厚重护甲片\n(5×厚皮|1×丝线)×15" },
		{ 225, "221~225: 夜色头带\n(5×厚皮|2×丝线)×5" },
		{ 250, "226~250: 根据你的专精可以为：\n    元素制皮:\n夜色头带\n(5×厚皮|2×丝线)×25\n夜色外套\n(7×厚皮|2×丝线)×25\n夜色短裤(14×厚皮|4×丝线)×20\n    龙鳞制皮:\n硬化蝎壳胸甲(12×厚皮|12×蝎壳|4×丝线)×25\n硬化蝎壳手套(6×厚皮|8×蝎壳|2×丝线)×25\n部族制皮:    \n龟壳头盔(14×厚皮|24×龟壳|1×粗丝线)×20\n龟壳护腿(14×厚皮|28×龟壳|1×粗丝线)×15\n龟壳胸甲(6×厚皮|12×龟壳|1×粗丝线)×25\n龟壳手套(6×厚皮|8×龟壳|1×粗丝线)×25\n龟壳护腕(8×厚皮|12×龟壳|1×粗丝线)×25\n" },
		{ 260, "251~260: 夜色长靴\n(16×厚皮|2×粗丝线)×10" },
		{ 270, "261~270: 邪恶皮甲护手\n(8×硬甲皮|1×黑色染料|1×符文线)×10" },
		{ 285, "271~285: 邪恶皮甲护腕\n(8×硬甲皮|1×黑色染料|1×符文线)×10" },
		{ 300, "286~300: 邪恶皮甲头环\n(12×硬甲皮|1×黑色染料|1×符文线)×15" },
		{ 310, "301~310: 结缔皮\n(5×结缔皮碎片)×10" },
		{ 320, "311~320: 野性德莱尼手套\n(9×结缔皮|3×符文线)×10" },
		{ 325, "3212~325: 厚重德莱尼长靴\n(10×结缔皮|3×符文线)×5" },
		{ 335, "326~335: 重结缔皮\n(5×结缔皮)×10\n|cFFFFD700千万别卖掉，你用来继续升级的！" },
		{ 340, "336~340: 厚重德莱尼外套\n(14×结缔皮|3×符文线)×5" },
		{ 355, "341~355: 魔鳞胸甲\n(14×结缔皮|3×魔鳞|3×符文线)×15" },
		{ 365, "356~365: 厚重裂蹄长靴\n(4×重结缔皮|20×厚裂蹄牛皮|4×源生之土|2×符文线)×10\n配方购于：\n芬德雷·迅矛:赞加沼泽<79,63>\n|cFFFFD700需要塞纳里奥远征队 - 友善\n|cFFFFD700厚裂蹄牛皮在纳格兰获取" },
		{ 375, "366~375: 战斗之鼓\n(6×重结缔皮|4×厚裂蹄牛皮)×10\n配方购于：\n奥玛多尔:沙塔斯城<51,41>\n|cFFFFD700需要沙塔尔 - 尊敬" }
	},
	[BI["Engineering"]] = {
		{ 40, "1~40: 劣质火药\n(1×劣质的石头)×40" },
		{ 50, "41~50: 一把螺栓\n(1×铜锭)×10" },
		{ 51, "51: 扳手\n(6×铜锭)×1" },
		{ 65, "52~65: 铜管\n(2×铜锭|1×弱效助熔剂)×14" },
		{ 75, "66~75: 劣质火枪\n(1×铜管|1×一把螺栓|1×木柴)×10" },
		{ 95, "76~95: 粗制火药粉\n(1×粗糙的石头)×20" },
		{ 105, "96~105: 银触媒\n(1×银锭)×10" },
		{ 120, "106~120: 青铜管\n(2×青铜锭|1×弱效助熔剂)×15" },
		{ 125, "121~125: 小型青铜炸弹\n(4×粗制火药粉|2×青铜锭|1×银触媒|1×毛料)×5" },
		{ 145, "126~145: 烈性火药\n(1×沉重的石头)×20" },
		{ 150, "146~150: 重磅青铜炸弹\n(2×烈性火药|3×青铜锭|1×银触媒)×5" },
		{ 175, "151~175: 蓝色焰火|红色焰火|绿色焰火\n(1×烈性火药|1×重皮)×25" },
		{ 176, "176: 侏儒微调器\n(4×钢锭)×1" },
		{ 190, "177~190: 实心炸药\n(2×坚固的石头)×14" },
		{ 195, "191~195: 重磅铁制炸弹\n(3×烈性火药|3×铁锭|1×银触媒)×5" },
		{ 205, "196~205: 秘银管\n(3×秘银锭)×10" },
		{ 210, "206~210: 不牢固的扳机\n(1×秘银锭|1×魔纹布|1×实心炸药)×5" },
		{ 225, "211~225: 高速秘银弹头\n(1×秘银锭|1×实心炸药)×15" },
		{ 235, "226~235: 秘银外壳\n(3×秘银锭)×10" },
		{ 245, "236~245: 高爆炸弹\n(2×秘银外壳|1×不牢固的扳机|2×实心炸药)×10" },
		{ 250, "246~250: 秘银螺旋弹\n(2×秘银锭|2×实心炸药)×5" },
		{ 260, "251~260: 致密炸药粉\n(2×厚重的石头)×10" },
		{ 290, "261~290: 瑟银零件\n(3×瑟银锭|1×符文布)×30" },
		{ 300, "291~300: 瑟银管\n(3×瑟银锭)×10\n瑟银弹\n(2×瑟银锭|1×致密炸药粉)×10" },
		{ 310, "301~310: 魔铁外壳\n(3×魔铁锭)×10\n魔铁螺丝\n(1×魔铁锭)×10\n元素炸药粉\n(1×火焰微粒|2×土之微粒)×10\n保留这些东西，为了下一步使用！" },
		{ 320, "311~320: 魔铁炸弹\n(1×魔铁外壳|2×魔铁螺丝|1×元素炸药粉)×10" },
		{ 335, "321~335: 魔铁步枪\n(1×沉重的树干|3×魔铁外壳|6×魔铁螺丝)×15" },
		{ 350, "336~350: 白色烟幕弹\n(1×元素炸药粉|1×灵纹布)×15" },
		{ 360, "351~360: 氪金能量核心\n(3×氪金锭|1×源生火焰)×10\n最好做20个，下一步要用到" },
		{ 375, "361~375: 战地修理机器人110G\n(8×精金锭|8×魔铁螺丝|1×氪金能量核心)×15\n掉落：甘尔葛分析师 刀锋山" }
	},
	[BI["Jewelcrafting"]] = {
		{ 20, "1~20: 精巧的铜线\n(2×铜锭)×20" },
		{ 30, "21~30: 劣质石像\n(8×劣质的石头)×10" },
		{ 50, "31~50: 虎眼指环\n(1×虎眼石|1×精巧的铜线)×20" },
		{ 75, "51~75: 青铜底座\n(2×青铜锭)×25" },
		{ 80, "76~80: 结实的青铜戒指\n(4×青铜锭)×5" },
		{ 90, "81~90: 优雅的银戒指\n(1×银锭)×10" },
		{ 110, "91~110: 银色力量之戒\n(2×银锭)×20" },
		{ 120, "111~120: 沉重石像\n(8×沉重的石头)×10" },
		{ 150, "121~150: 玛瑙护盾坠饰\n(1×绿玛瑙|1×青铜底座)×30\n金色巨龙戒指\n(1×翡翠|2×金锭|2×精巧的铜线)×30" },
		{ 180, "151~180: 秘银丝\n(2×秘银锭)×30" },
		{ 200, "181~200: 蚀刻真银戒指\n(1×真银锭|2×秘银丝)×20" },
		{ 210, "201~210: 迅疾治疗之黄水晶戒指\n(1×黄水晶|2×元素之水|2×秘银锭)×10" },
		{ 225, "211~225: 青绿石徽记\n(3×青绿石|4×魔精)×15" },
		{ 250, "226~250: 瑟银底座\n(1×瑟银锭)×25" },
		{ 255, "251~255: 红色毁灭指环\n(1×红宝石|1×瑟银底座)×5" },
		{ 265, "256~265: 真银治疗戒指\n(2×真银锭|2×野性之心)×10" },
		{ 275, "266~275: 朴素的猫眼石戒指\n(1×大猫眼石|1×瑟银底座)×10" },
		{ 285, "276~285: 蓝宝石徽记\n(4×蓝宝石|2×真银锭|1×瑟银底座)×10" },
		{ 290, "286~290: 钻石专注戒指\n(1×艾泽拉斯钻石|1×瑟银底座)×5" },
		{ 300, "291~300: 翡翠狮王戒指\n(2×巨型绿宝石|1×瑟银底座)×10" },
		{ 310, "301~310: 任何优秀品质的宝石(绿色)×10" },
		{ 315, "311~315: 魔铁血戒\n(1×魔铁锭|2×血榴石)×5\n任何优秀品质的宝石(绿色)×5" },
		{ 320, "316~320: 任何优秀品质的宝石(绿色)×10" },
		{ 325, "321~325: 碧月石指环\n(1×魔铁锭|2×碧月石|1×翠榄石)×5" },
		{ 335, "326~335: 水银精金(升级用到)\n(4×精金粉|1×源生之土)×10\n任何优秀品质的宝石(绿色)×10" },
		{ 350, "336~350: 重型精金戒指\n(1×精金锭|1×水银精金)×15" },
		{ 355, "351~355: 任何精良品质的宝石(蓝色)×5" },
		{ 360, "356~360: 世界掉落配方，例如:\n红曜石坠饰\n(4×氪金锭|1×水银精金|1×红曜石)×5\n厚重魔钢项链\n(2×魔钢锭|3×水银精金)×5" },
		{ 365, "361~365: 奥术护盾指环\n(2×恒金锭|8×源生法力)×5\n配方购于：\n奥玛多尔:沙塔斯城<51,41>\n|cFFFFD700需要沙塔尔 - 尊敬" },
		{ 375, "366~375: 大地风暴钻石或天火钻石系列\n世界掉落(精良品质)\n部分可购买，需要沙塔尔/萨尔玛/荣耀堡/破碎残阳 - 崇敬" }
	},
	[BI["Enchanting"]] = {
		{ 2, "1~2: 符文铜棒\n(1×铜棒|1×奇异之尘|1×次级魔法精华)×1" },
		{ 75, "3~75: 附魔护腕 - 初级生命\n(1×奇异之尘)×73" },
		{ 85, "76~85: 附魔护腕 - 初级偏斜\n(1×次级魔法精华|1×奇异之尘)×20" },
		{ 100, "86~100: 附魔护腕 - 初级耐力\n(3×奇异之尘)×15" },
		{ 101, "101: 符文银棒\n(1×银棒|6×奇异之尘|3×强效魔法精华|1×符文铜棒)×1" },
		{ 105, "102~105: 附魔护腕 - 初级耐力\n(3×奇异之尘)×4" },
		{ 120, "106~120: 强效魔法杖\n(1×普通木柴|1×强效魔法精华)×15" },
		{ 130, "121~130: 附魔盾牌 - 初级耐力\n(1×次级星界精华|2×奇异之尘)×10" },
		{ 150, "131~150: 附魔护腕 - 次级耐力\n(2×灵魂之尘)×20" },
		{ 151, "151: 符文金棒\n(1×金棒|1×彩色珍珠|2×强效星界精华|2×灵魂之尘|1×符文银棒)×1" },
		{ 160, "152~160: 附魔护腕 - 次级耐力\n(2×灵魂之尘)×9" },
		{ 165, "161~165: 附魔盾牌 - 次级耐力\n(1×次级秘法精华|1×灵魂之尘)×5" },
		{ 180, "166~180: 附魔护腕 - 精神\n(1×次级秘法精华)×15" },
		{ 200, "181~200: 附魔护腕 - 力量\n(1×幻象之尘)×20" },
		{ 201, "201: 符文真银棒\n(1×真银棒|1×黑珍珠|2×强效秘法精华|2×幻象之尘|1×符文金棒)×1" },
		{ 205, "202~205: 附魔护腕 - 力量\n(1×幻象之尘)×4" },
		{ 225, "206~225: 附魔披风 - 强效防御\n(3×幻象之尘)×20" },
		{ 235, "226~235: 附魔手套 - 敏捷\n(1×次级虚空精华|1×幻象之尘)×10" },
		{ 245, "236~245: 附魔胸甲 - 超强生命\n(6×幻象之尘)×10" },
		{ 250, "246~250: 附魔护腕 - 强效力量\n(2×梦境之尘|1×强效虚空精华)×5" },
		{ 270, "251~270: 次级法力之油\n(3×梦境之尘|2×紫莲花|1×水晶瓶)×20\n配方购于：\n卡妮亚:希利苏斯<51,39>" },
		{ 290, "271~290: 附魔盾牌 - 强效耐力\n(10×梦境之尘)×20\n附魔靴子 - 强效耐力\n(10×梦境之尘)×20" },
		{ 291, "291: 符文奥金棒\n(1×奥金棒|1×金珍珠|10×幻影之尘|4×强效不灭精华|1×符文真银棒|2×大块魔光碎片)×1" },
		{ 300, "292~300: 附魔披风 - 超强防御\n(8×幻影之尘)×9" },
		{ 301, "301: 符文魔铁棒\n(1×魔铁棒|4×强效不灭精华|6×大块魔光碎片|1×符文奥金棒)×1" },
		{ 305, "302~305: 附魔披风 - 超强防御\n(8×幻影之尘)×4" },
		{ 315, "306~315: 附魔护腕 - 突袭\n(6×奥法之尘)×10" },
		{ 325, "316~325: 附魔披风 - 特效护甲\n(8×奥法之尘)×10\n附魔护腕 - 突袭\n(6×奥法之尘)×10" },
		{ 335, "326~335: 附魔胸甲 - 特效精神\n(2×强效位面精华)×10" },
		{ 340, "336~340: 附魔盾牌 - 特效耐力\n(15×奥法之尘)×5" },
		{ 345, "341~345: 超级巫师之油\n(3×奥法之尘|1×噩梦藤|1×灌魔之瓶)×5\n配方购于：\n卢比夫人:沙塔斯城<63,70>\n琳娜:银月城<69,24>\n艾苟米斯:埃索达<39,39>\n如果有足够的噩梦藤最好冲到350，这个材料便宜" },
		{ 350, "346~350: 附魔手套 - 特效力量\n(12×奥法之尘|1×强效位面精华)×5" },
		{ 351, "351: 符文精金棒\n(1×精金棒|8×强效位面精华|8×大块棱光碎片|1×源生之能|1×符文魔铁棒)×1\n配方购于：\n沃德辛:地狱火半岛<24,38>\n伦格尔:泰罗卡森林<48,46>" },
		{ 360, "352~360: 附魔手套 - 特效力量\n(12×奥法之尘|1×强效位面精华)×9" },
		{ 370, "361~370: 附魔手套 - 法术打击\n(8×强效位面精华|2×奥法之尘|2×大块棱光碎片)×10\n配方购于：\n芬德雷·迅矛:赞加沼泽<79,63>\n|cFFFFD700需要塞纳里奥远征队 - 崇敬" },
		{ 375, "371~375: 附魔戒指 - 治疗能量\n(2×大块棱光碎片|3×强效位面精华|5×奥法之尘)×5\n配方购于：\n奥玛多尔:沙塔斯城<51,41>\n|cFFFFD700需要沙塔尔 - 崇敬" }
	},
	[BI["Blacksmithing"]] = {	
		{ 25, "1~25: 劣质磨刀石\n(1×劣质的石头)×25" },
		{ 45, "26~45: 劣质砂轮\n(2×劣质的石头)×20" },
		{ 75, "46~75: 铜质链甲腰带\n(6×铜锭)×30" },
		{ 80, "76~80: 粗制砂轮\n(2×粗糙的石头)×5" },
		{ 100, "81~100: 铜质符文腰带\n(10×铜锭)×20" },
		{ 105, "101~105: 银棒\n(1×银锭|2×劣质砂轮)×5" },
		{ 125, "106~125: 劣质青铜护腿\n(6×青铜锭)×20" },
		{ 150, "126~150: 重砂轮\n(3×沉重的石头)×25" },
		{ 155, "151~155: 金棒\n(1×金锭|2×粗制砂轮)×5" },
		{ 165, "156~165: 绿铁护腿\n(8×铁锭|1×重砂轮|1×绿色染料)×10" },
		{ 185, "166~185: 绿铁护腕\n(6×铁锭|1×绿色染料)×20" },
		{ 200, "186~200: 金鳞护腕\n(5×钢锭|2×重砂轮)×15" },
		{ 210, "201~210: 坚固的砂轮\n(4×坚固的石头)×10" },
		{ 215, "211~215: 金鳞护腕\n(5×钢锭|2×重砂轮)×5" },
		{ 235, "216~235: 钢质头盔\n(14×钢锭|1×坚固的砂轮)×20\n秘银鳞片护腕(成本低)\n(8×秘银锭)×20\n配方购于：\n哈尔甘:辛特兰,鹰巢山<13,44>\n卡尔拉什:悲伤沼泽,斯通纳德<45,51>" },
		{ 250, "236~250: 秘银罩帽\n(10×秘银锭|6×魔纹布)×15\n秘银马刺(成本低)\n(4×秘银锭|3×坚固的砂轮)×15\n配方世界掉落" },
		{ 260, "251~260: 致密磨刀石\n(1×厚重的石头)×10" },
		{ 270, "261~270: 瑟银腰带(成本低)\n(12×瑟银锭|4×红色能量水晶)×10\n瑟银护腕(成本低)\n(12×瑟银锭|4×蓝色能量水晶)×10\n以上两种配方世界掉落\n地铸护腿 (防具锻造)\n(16×秘银锭|2×大地之核)×10\n风铸护腿(防具锻造)\n((16×秘银锭|2×风之气息))×10\n轻型地铸利刃(宗师级铸剑)\n(12×秘银锭|4×大地之核)×10\n轻型灰烬铸锤(宗师级铸锤)\n(12×秘银锭|4×火焰之心)×10\n轻型天铸战斧(宗师级铸斧)\n(12×秘银锭|4×风之气息)×10" },
		{ 295, "271~295: 君王板甲护腕\n(12×瑟银锭)×25\n配方任务取得" },
		{ 300, "296~300: 君王板甲战靴\n(18×瑟银锭)×5\n配方任务取得" },
		{ 305, "301~305: 魔能平衡石\n(1×魔铁锭|1×灵纹布)×5" },
		{ 320, "306~320: 魔铁板甲腰带\n(4×魔铁锭)×15" },
		{ 325, "321~325: 魔铁板甲战靴\n(6×魔铁锭)×5" },
		{ 330, "326~330: 次级结界符文\n(1×精金锭)×5" },
		{ 335, "331~335: 魔铁胸甲\n(10×魔铁锭)×5" },
		{ 340, "336~340: 精金利斧\n(8×精金锭)×5\n配方购于：\n埃隆·霍尔曼:沙塔斯城<64,71>\n恩里德:银月城<80,36>\n阿尔拉斯:埃索达<61,89>" },
		{ 345, "341~345: 次级护盾结界\n(1×精金锭)×5\n配方购于：玛里·石拳:影月谷,蛮锤要塞<36,55>|罗霍克:地狱火半岛,萨尔玛<53,38>" },
		{ 350, "346~350: 精金利斧\n(8×精金锭)×5\n配方购于：\n埃隆·霍尔曼:沙塔斯城<64,71>\n恩里德:银月城<80,36>\n阿尔拉斯:埃索达<61,89>" },
		{ 360, "351~360: 精金平衡石\n(1×精金锭|2×灵纹布)×10\n配方购于：\n芬德雷·迅矛:赞加沼泽<79,63>\n|cFFFFD700需要塞纳里奥远征队 - 尊敬" },
		{ 370, "361~370: 魔钢手套\n(6×魔钢锭)×10\n奥金尼地穴掉落\n灭焰手套\n(8×魔铁锭|4×源生之水|4×源生火焰)×10\n配方购于：\n军需官恩达尔林:沙塔斯城<47,25>\n|cFFFFD700需要奥尔多 - 尊敬\n魔化精金腰带\n(2×硬化精金锭|8×奥法之尘|2×大块棱光碎片)×10\n配方购于：\n军需官恩努利尔:沙塔斯城<60,64>\n|cFFFFD700需要占星者 - 友善" },
		{ 375, "371~375: 魔钢手套\n(6×魔钢锭)×5\n奥金尼地穴掉落\n灭焰胸甲\n配方购于：\n军需官恩达尔林:沙塔斯城<47,25>\n(16×魔铁锭|6×源生之水|4×源生火焰)×5\n|cFFFFD700需要奥尔多 - 尊敬\n魔化精金腰带\n(2×硬化精金锭|8×奥法之尘|2×大块棱光碎片)×5\n配方购于：\n军需官恩努利尔:沙塔斯城<60,64>\n|cFFFFD700需要占星者 - 友善" }
	},
	[BI["Alchemy"]] = {	
		{ 60, "1~60: 初级治疗药水\n(1×宁神花|1×银叶草|1×空瓶)×60" },
		{ 110, "61~110: 次级治疗药水\n(1×初级治疗药水|1×石南草)×50" },
		{ 140, "111~140: 治疗药水\n(1×跌打草|1×石南草|1×铅瓶)×30" },
		{ 155, "141~155: 次级法力药水\n(1×魔皇草|1×荆棘藻|1×空瓶)×15" },
		{ 185, "156~185: 强效治疗药水\n(1×活根草|1×皇血草|1×铅瓶)×30" },
		{ 210, "186~210: 敏捷药剂\n(1×荆棘藻|1×金棘草|1×铅瓶)×25" },
		{ 215, "211~215: 强效防御药剂\n(1×野钢花|1×金棘草|1×铅瓶)×5" },
		{ 230, "216~230: 优质治疗药水\n(1×太阳草|1×卡德加的胡须|1×水晶瓶)×15" },
		{ 250, "231~250: 侦测亡灵药剂\n(1×阿尔萨斯之泪|1×水晶瓶)×20" },
		{ 265, "251~265: 强效敏捷药剂\n(1×太阳草|1×金棘草|1×水晶瓶)×15" },
		{ 285, "266~285: 优质法力药水\n(2×太阳草|2×盲目草|1×水晶瓶)×20" },
		{ 300, "286~300: 特效治疗药水\n(2×黄金参|1×山鼠草|1×水晶瓶)×15" },
		{ 315, "301~315: 不稳定的治疗药水\n(1×黄金参|1×魔草|1×灌魔之瓶)×15\n特效法力药水\n(3×梦叶草|2×冰盖草|1×水晶瓶)×15" },
		{ 350, "316~350: 疯狂炼金师药水\n(1×水晶瓶|2×邪雾草)×35+\n在335的时候会变黄，但是该配方成本低" },
		{ 375, "351~375: 特效无梦睡眠药水\n(1×梦露花|1×噩梦藤|1×灌魔之瓶)×25\n配方购于：莉莉·朗哈格:泰罗卡森林,奥蕾莉亚要塞<57,53>\n联达加·拉姆巴:刀锋山,雷神要塞<51,57>" }
	},
	[L["Mining"]] = {
		{ 65, "1~65: 铜矿\n所有起始地区" },
		{ 125, "66~125: 锡矿|银矿|火岩矿|次级血石矿\n\n火岩矿分布于瑟根石(湿地)\n很容易升到125" },
		{ 175, "126~175: 铁矿|金矿\n凄凉之地|灰谷|荒芜之地|阿拉希高地\n奥特兰克山脉|荆棘谷|悲伤沼泽" },
		{ 250, "176~250: 秘银矿|真银矿\n诅咒之地|灼热峡谷|荒芜之地|辛特兰\n西瘟疫之地|艾萨拉|冬泉谷|费伍德森林|石爪山脉|塔纳利斯" },
		{ 300, "251~300: 瑟银矿\n安戈洛环形山|冬泉谷|诅咒之地|灼热峡谷\n燃烧平原|东瘟疫之地|西瘟疫之地" },
		{ 330, "301~330: 魔铁矿\n地狱火半岛|赞加沼泽" },
		{ 375, "331~375: 魔铁矿|精金矿\n泰罗卡森林|纳格兰\n所有外域地区均有" }
	},
	[L["Herbalism"]] = {
		{ 50, "1~50: 银叶草|宁神花\n所有起始地区" },
		{ 70, "51~70: 魔皇草|地根草\n贫瘠之地|西部荒野|银松森林|洛克莫丹|黑海岸" },
		{ 100, "71~100: 石南草\n银松森林|暮色森林|黑海岸|洛克莫丹|赤脊山" },
		{ 115, "101~115: 跌打草\n灰谷|石爪山脉|南贫瘠之地|洛克莫丹|赤脊山" },
		{ 125, "116~125: 野钢花\n石爪山脉|阿拉希高地|荆棘谷|南贫瘠之地|千针石林" },
		{ 160, "126~160: 皇血草\n灰谷|石爪山脉|湿地|希尔斯布莱德丘陵|悲伤沼泽" },
		{ 185, "161~185: 枯叶草\n悲伤沼泽" },
		{ 205, "186~205: 卡德加的胡须\n辛特兰|阿拉希高地|悲伤沼泽" },
		{ 230, "206~230: 火焰花\n灼热峡谷|诅咒之地|塔纳利斯" },
		{ 250, "231~250: 太阳草\n费伍德森林|菲拉斯|艾萨拉|辛特兰" },
		{ 270, "251~270: 格罗姆之血\n费伍德森林|诅咒之地|玛诺洛克集会所(凄凉之地)" },
		{ 285, "271~285: 梦叶草\n安戈洛环形山|艾萨拉" },
		{ 300, "286~300: 瘟疫花\n东瘟疫之地|西瘟疫之地|费伍德森林|\n冰盖草\n冬泉谷" },
		{ 330, "301~330: 魔草\n地狱火半岛|赞加沼泽" },
		{ 375, "331~375: 任何外域植物\n赞加沼泽和泰罗卡森林较集中" }
	},
	[L["Skinning"]] = {
		{ 375, "1~375: 技能等级处以5,\n所获值对应的可剥皮怪物" }
	},
	-- 来源: http://www.almostgaming.com/wowguides/world-of-warcraft-lockpicking-guide
	[L["Lockpicking"]] = {
		{ 85, "1~85: 开锁练习\n奥瑟尔伐木场，赤脊山(联盟)\n棘齿城附近的海盗船(部落)" },
		{ 150, "86~150: 制毒任务目标怪附近的箱子\n西部荒野(联盟)|贫瘠之地(部落)" },
		{ 185, "151~185: 鱼人营地(湿地)" },
		{ 225, "186~225: 萨瑟里斯海岸(凄凉之地)\n" },
		{ 250, "226~250: 苦痛堡垒(荒芜之地)" },
		{ 275, "251~275: 熔渣之池(灼热峡谷)" },
		{ 300, "276~300: 落帆海湾(塔纳利斯)\n风暴海湾(艾萨拉)" },
		{ 325, "301~325: 蛮沼村(赞加沼泽)" },
		{ 350, "326~350: 基尔索罗堡垒(纳格兰)\n偷取石拳系食人魔(纳格兰)" }
	},
	
	-- ** 辅助技能 **
	[BI["First Aid"]] = {
		{ 40, "1~40: 亚麻绷带" },
		{ 80, "41~80: 厚亚麻绷带\n50的时候学急救(中级)" },
		{ 115, "81~115: 绒线绷带" },
		{ 150, "116~150: 厚绒线绷带\n125的时候去买教材<中级急救教材 - 绷带缚体>和2个配方\n配方购于：\n德尼布·沃克:阿拉希高地,激流堡<27,58>\n格鲁克卡恩:尘泥沼泽,蕨墙村<35,30>\n巴莱·洛克维:尘泥沼泽,蕨墙村<36,30>" },
		{ 180, "151~180: 丝质绷带" },
		{ 210, "181~210: 厚丝质绷带\n200的时候满35级，做任务学会急救(专家级)\n地点：塞拉摩岛(联盟)|落锤镇(部落)" },
		{ 240, "211~240: 魔纹绷带\n" },
		{ 260, "241~260: 厚魔纹绷带" },
		{ 290, "261~290: 符文布绷带" },
		{ 330, "291~330: 厚符文布绷带\n300的时候去买教材<大师级急救手册 - 私人医生>\n配方购于：\n阿蕾瑟拉:地狱火半岛,塔哈玛特神殿<26,62>\n布尔库:地狱火半岛,猎鹰岗哨<22,39>" },
		{ 360, "331~360: 灵纹布绷带\n购买<手册：灵纹布绷带>\n配方购于：\n阿蕾瑟拉:地狱火半岛,塔哈玛特神殿<26,62>\n布尔库:地狱火半岛,猎鹰岗哨<22,39>" },
		{ 375, "361~375: 厚灵纹布绷带\n购买<手册：厚灵纹布绷带>\n配方购于：\n阿蕾瑟拉:地狱火半岛,塔哈玛特神殿<26,62>\n布尔库:地狱火半岛,猎鹰岗哨<22,39>" }
	},
	[BI["Cooking"]] = {
		{ 40, "1~40: 香料面包\n(1×面粉|1×甜香料)×70" },
		{ 75, "41~75: 熏熊肉\n(1×熊肉)×30\n配方购于：\n德拉克·卷刃:洛克莫丹<35,49>\n安德鲁·希尔伯特:银松森林<43,40>" },
		{ 85, "76~85: 蟹肉蛋糕(联盟)\n(1×蟹肉, 1×甜香料)×10\n熏熊肉(部落)\n(1×熊肉)×20\n配方购于：\n德拉克·卷刃:洛克莫丹<35,49>\n安德鲁·希尔伯特:银松森林<43,40>" },
		{ 90, "86~90: 煮蟹爪(联盟)\n(1×蟹爪, 1×甜香料)×5\n配方购于：\n肯多尔·卡邦卡:暴风城<74,36>\n熏熊肉(部落)\n(1×熊肉)×10\n配方购于：\n德拉克·卷刃:洛克莫丹<35,49>\n安德鲁·希尔伯特:银松森林<43,40>" },
		{ 100, "91~100: 煮蟹爪(联盟)\n(1×蟹爪|1×甜香料)×15\n配方购于：\n肯多尔·卡邦卡:暴风城<74,36>\n掘地鼠炖肉(部落)\n(1×掘地鼠)×10\n配方任务获取：[23]掘地鼠炖肉" },
		{ 125, "101~125: 掘地鼠炖肉(部落)\n(1×掘地鼠)×30\n配方任务获取：[23]掘地鼠炖肉\n干烤狼肉串(联盟)\n(2×狼肋排|1×暴风城特产调料)×25\n配方购于：\n肯多尔·卡邦卡:暴风城<74,36>" },
		{ 130, "126~130: 烤狮排(部落)\n(1×狮肉|1×辣椒)×5\n配方购于：\n扎尔夫:贫瘠之地<52,29>\n干烤狼肉串(联盟)\n(2×狼肋排|1×暴风城特产调料)×25\n配方购于：\n肯多尔·卡邦卡:暴风城<74,36>" },
		{ 175, "131~175: 美味煎蛋卷(联盟)\n(1×迅猛龙蛋|1×辣椒)×50\n配方购于：\n肯多尔·卡邦卡:暴风城<74,36>\n烤狮排(部落)\n(1×狮肉|1×辣椒)×55\n配方购于：\n扎尔夫:贫瘠之地<52,29>" },
		{ 200, "176~200: 烤迅猛龙肉\n(1×迅猛龙肉|1×辣椒)×30\n配方购于：\n耐里斯特:荆棘谷,格罗姆高营地<32,29>\n布鲁斯下士:荆棘谷,反抗军营地<37,3>" },
		{ 225, "201~225: 蜘蛛肉肠\n(2×白蜘蛛肉)×30\n\n|cFFFFFFFF225接到烹饪大师任务: 迪尔格·奎克里弗:加基森<51,27>给予\n|cFFFFD700需要12个巨蛋|10个美味的蚌肉|20个奥特兰克冷酪" },
		{ 275, "226~275: 超级煎蛋卷\n(1×巨蛋|2×舒心草)×80\n配方购于：\n琦亚:冬泉谷,永望镇<61,37>\n西米克:冬泉谷,永望镇<61,39>\n拜尔:费伍德森林,血毒岗哨<34,53>\n玛里甘:费伍德森林,刺枝林地<62,25>\n嫩狼肉排\n(1×嫩狼肉|1×舒心草)×80\n配方购于：\n迪尔格·奎克里弗:塔纳利斯,加基森<52,28>\n特鲁克·蛮鬃:辛特兰,鹰巢山<14,42>" },
		{ 285, "276~285: 洛恩塔姆薯块\n(1×洛恩塔姆地薯|1×舒心草)×10\n掉落：普希林 厄运之槌" },
		{ 300, "286~300: 沙漠肉丸子\n(1×沙虫的肉|1×舒心草)×20\n希利苏斯任务(旅店老板)" },
		{ 325, "301~325: 掠食者热狗\n(1×掠食者的肉)×40\n配方购于：\n独眼曲奇:地狱火半岛,萨尔玛<54,41>\n希德·利巴迪:地狱火半岛,荣耀堡<54,63>\n美味秃鹫\n(1×秃鹰肉)×40\n来源：任务 [61]万无一失" },
		{ 350, "326~350: 烧烤裂蹄牛\n(1×裂蹄牛肉)×40\n配方购于：\n屠夫努尔拉:纳格兰,加拉达尔<58,35>\n乌利库:纳格兰,塔拉<56,73>\n迁跃兽汉堡\n(1×迁跃兽肉)×40\n配方购于：\n屠夫努尔拉:纳格兰,加拉达尔<58,35>\n乌利库:纳格兰,塔拉<56,73>\n旅店老板格里尔卡:泰罗卡森林,裂石堡<48,45>\n供给官米尔斯:泰罗卡森林,奥蕾莉亚要塞<55,53>\n塔布肉排\n(1×塔布羊肉)×40\n配方购于：\n屠夫努尔拉:纳格兰,加拉达尔<58,35>\n乌利库:纳格兰,塔拉<56,73>" },
		{ 375, "351~375: 香辣小龙虾\n(1×狂暴龙虾)×25\n配方购于：\n旅店老板贝莉比:泰罗卡森林,奥蕾莉亚要塞<56,53>\n伦格尔:泰罗卡森林,裂石堡<48,46>\n此处建议和钓鱼一起练\n莫克纳萨肋排\n(1×迅猛龙肋排)×60\n香脆蛇\n(1×蛇肉)×60c\n以上两个配方来源：\n任务 [67]莫克纳萨的美味(部落)\n购买：萨莎·焊井:刀锋山,托雷斯营地<61,68>" }
	},	
	-- 来源: http://www.wowguideonline.com/fishing.html
	[BI["Fishing"]] = {
		{ 50, "1~50: 任何起始地点" },
		{ 75, "51~75:\n暴风城的河里\n奥格瑞玛的池塘里" },
		{ 150, "76~150: 希尔斯布莱德丘陵的河里" },
		{ 225, "151~225: 凄凉之地|阿拉希高地\n150的时候购买<中级钓鱼教材 - 鲈鱼与你>\n配方购于：\n老人海明威:藏宝海湾<27,77>" },
		{ 250, "226~250: 辛特兰|塔纳利斯\n\n|cFFFFFFFF225开始高级钓鱼任务\n起始于各个主城，均到纳特·帕格:尘泥沼泽<59,61>\n|cFFFFD700野人海岸蓝色叉牙鱼(荆棘谷<34,35>)\n菲拉斯草鱼(沃丹提斯河, 菲拉斯)\n萨瑟里斯虎鱼(萨瑟里斯海岸北部, 葬影村附近, 凄凉之地)\n芦苇海岸大马哈鱼(芦苇海岸, 悲伤沼泽)" },
		{ 260, "251~260: 费伍德森林" },
		{ 300, "261~300: 艾萨拉" },
		{ 330, "301~330: 赞加沼泽东部\n300的时候购买<顶级钓鱼教材 - 下钩的艺术>\n配方购于：\n乔诺·杜伏恩:塞那里奥避难所<78,66>" },
		{ 345, "331~345: 赞加沼泽西部" },
		{ 360, "346~360: 泰罗卡森林" },
		{ 375, "361~375: 泰罗卡森林,高地上：\n尤鲁恩湖, 裂石堡西北方\n艾雷诺湖, 奥蕾莉亚要塞东南方\n黑风湖, 斯克提斯地区\n需要飞行坐骑" }
	},
	
	-- 建议升级地区，来源众多，不一一列举了
	["Leveling"] = {
		{ 10, "1~10级: 所有起始地区" },
		{ 20, "11~20级: "  .. BZ["Loch Modan"] .. "\n" .. BZ["Westfall"] .. "\n" .. BZ["Darkshore"] .. "\n" .. BZ["Bloodmyst Isle"] 
						.. "\n" .. BZ["Silverpine Forest"] .. "\n" .. BZ["The Barrens"] .. "\n" .. BZ["Ghostlands"]},
		{ 25, "21~25级: " .. BZ["Wetlands"] .. "\n" .. BZ["Redridge Mountains"] .. "\n" .. BZ["Ashenvale"] 
						.. "\n" .. BZ["The Barrens"] .. "\n" .. BZ["Stonetalon Mountains"] .. "\n" .. BZ["Hillsbrad Foothills"] },
		{ 28, "26~28级: " .. BZ["Duskwood"] .. "\n" .. BZ["Wetlands"] .. "\n" .. BZ["Ashenvale"] 
						.. "\n" .. BZ["Stonetalon Mountains"] .. "\n" .. BZ["Thousand Needles"] },
		{ 31, "29~31级: " .. BZ["Duskwood"] .. "\n" .. BZ["Thousand Needles"] .. "\n" .. BZ["Ashenvale"] },
		{ 35, "32~35级: " .. BZ["Thousand Needles"] .. "\n" .. BZ["Stranglethorn Vale"] .. "\n" .. BZ["Alterac Mountains"] 
						.. "\n" .. BZ["Arathi Highlands"] .. "\n" .. BZ["Desolace"] },
		{ 40, "36~40级: " .. BZ["Stranglethorn Vale"] .. "\n" .. BZ["Desolace"] .. "\n" .. BZ["Badlands"]
						.. "\n" .. BZ["Dustwallow Marsh"] .. "\n" .. BZ["Swamp of Sorrows"] },
		{ 43, "41~43级: " .. BZ["Tanaris"] .. "\n" .. BZ["Stranglethorn Vale"] .. "\n" .. BZ["Badlands"] 
						.. "\n" .. BZ["Dustwallow Marsh"] .. "\n" .. BZ["Swamp of Sorrows"] },
		{ 45, "44~45级: " .. BZ["Tanaris"] .. "\n" .. BZ["Feralas"] .. "\n" .. BZ["The Hinterlands"] },
		{ 48, "46~48级: " .. BZ["Tanaris"] .. "\n" .. BZ["Feralas"] .. "\n" .. BZ["The Hinterlands"] .. "\n" .. BZ["Searing Gorge"] },
		{ 51, "49~51级: " .. BZ["Tanaris"] .. "\n" .. BZ["Azshara"] .. "\n" .. BZ["Blasted Lands"] 
						.. "\n" .. BZ["Searing Gorge"] .. "\n" .. BZ["Un'Goro Crater"] .. "\n" .. BZ["Felwood"] },
		{ 55, "54~55级: " .. BZ["Un'Goro Crater"] .. "\n" .. BZ["Felwood"] .. "\n" .. BZ["Burning Steppes"]
						.. "\n" .. BZ["Blasted Lands"] .. "\n" .. BZ["Western Plaguelands"] },
		{ 58, "56~58级: " .. BZ["Winterspring"] .. "\n" .. BZ["Burning Steppes"] .. "\n" .. BZ["Western Plaguelands"] 
						.. "\n" .. BZ["Eastern Plaguelands"] .. "\n" .. BZ["Silithus"] },
		{ 60, "59~60级: " .. BZ["Winterspring"] .. "\n" .. BZ["Eastern Plaguelands"] .. "\n" .. BZ["Silithus"] },
		{ 62, "61~62级: " .. BZ["Hellfire Peninsula"] },
		{ 64, "63~64级: " .. BZ["Zangarmarsh"] .. "\n" .. BZ["Terokkar Forest"]},
		{ 65, "65级: " .. BZ["Terokkar Forest"] },
		{ 66, "66级: " .. BZ["Terokkar Forest"] .. "\n" .. BZ["Nagrand"]},
		{ 67, "67级: " .. BZ["Nagrand"]},
		{ 68, "68级: " .. BZ["Blade's Edge Mountains"]},
		{ 70, "69~70级: " .. BZ["Blade's Edge Mountains"] .. "\n" .. BZ["Netherstorm"] .. "\n" .. BZ["Shadowmoon Valley"]},
	},

	-- 声望值级别
	-- -42000 = "仇恨"
	-- -6000 = "敌对"
	-- -3000 = "冷淡"
	-- 0 = "中立"
	-- 3000 = "友善"
	-- 9000 = "尊敬"
	-- 21000 = "崇敬"
	-- 42000 = "崇拜"
	
	-- Outland factions: source: http://www.mmo-champion.com/
	[BF["The Aldor"]] = {
		{ 0, "升到中立:\n" .. WHITE .. "[巨牙毒囊]|r +250 声望值\n\n"
				.. YELLOW .. "巨牙潜伏者,\n巨牙寡妇蛛\n"
				.. WHITE .. "(泰罗卡森林)" },
		{ 9000, "升到尊敬:\n" .. WHITE .. "[基尔加丹印记]|r\n+25 声望值" },
		{ 42000, "升到崇拜:\n" .. WHITE .. "[萨格拉斯印记]|r +25 声望值/每枚\n" 
				.. GREEN .. "[邪能装备]|r +350 声望值 (+1 神圣之尘)"       }
	},
	[BF["The Scryers"]] = {
		{ 0, "升到中立:\n" .. WHITE .. "[湿鳞蜥蜴的眼睛]|r +250 声望值\n\n"
				.. YELLOW .. "铁脊石化者,\n湿鳞吞噬者,\n湿鳞蜥蜴\n"
				.. WHITE .. "(泰罗卡森林)" },
		{ 9000, "升到尊敬:\n" .. WHITE .. "[火翼徽记]|r\n+25 声望值" },
		{ 42000, "升到崇拜:\n" .. WHITE .. "[日怒徽记]|r +25 声望值 per mark\n" 
				.. GREEN .. "[奥法宝典]|r +350 声望值 (+1 奥术符文)"       }
	},
	[BF["Netherwing"]] = {
		{ 3000, "升到友善, 重复以下任务:\n\n" 
				.. YELLOW .. "缓慢的死亡 (日常)|r +250 声望值\n"
				.. YELLOW.. "灵尘花粉 (日常)|r +250 声望值\n"
				.. YELLOW.. "灵翼水晶 (日常)|r +250 声望值\n"
				.. YELLOW.. "危险的天空 (日常)|r +250 声望值\n"
				.. YELLOW.. "寻找灵翼龙卵 (可重复提交)|r +250 声望值" },
		{ 9000, "升到尊敬, 重复以下任务:\n\n" 
				.. YELLOW .. "新的监工：正确的选择|r +350 声望值\n"
				.. YELLOW .. "训诫靴：懒惰苦工的惩戒 (日常)|r +350 声望值\n"
				.. YELLOW .. "回收货物 (日常)|r +350 声望值\n"
				.. YELLOW .. "龙？不是问题 (日常)|r +350 声望值\n"
				.. YELLOW .. "疯狂与困惑|r +350 声望值\n" },
		{ 21000, "升到崇敬, 重复以下任务:\n\n" 
				.. YELLOW .. "征服者雷萨赫尔顿|r +500 声望值\n" 
				.. YELLOW .. "暮光岭的传送门 (日常)|r +500 声望值\n"
				.. YELLOW .. "你的双翼 +500 声望值(1~5号), +1000 声望值(6号)\n" },
		{ 42000, "升到崇拜, 重复以下任务:\n\n" 
				.. YELLOW .. "最致命的陷阱 (日常) (3+)|r +500 声望值" }
	},
	[BF["Honor Hold"]] = {
		{ 9000, "升到尊敬:\n\n" 
				.. YELLOW .. "地狱火半岛的任务\n"
				.. GREEN .. "地狱火城墙 |r(普通)\n"
				.. GREEN .. "鲜血熔炉 |r(普通)" },		
		{ 42000, "升到崇拜:\n\n" 
				.. GREEN .. "破碎大厅 |r(普通或英雄)\n"
				.. GREEN .. "地狱火城墙 |r(英雄)\n"
				.. GREEN .. "鲜血熔炉 |r(英雄)" }
	},
	[BF["Thrallmar"]] = {
		{ 9000, "升到尊敬:\n\n" 
				.. YELLOW .. "地狱火半岛的任务\n"
				.. GREEN .. "地狱火城墙 |r(普通)\n"
				.. GREEN .. "鲜血熔炉 |r(普通)" },		
		{ 42000, "升到崇拜:\n\n" 
				.. GREEN .. "破碎大厅 |r(普通或英雄)\n"
				.. GREEN .. "地狱火城墙 |r(英雄)\n"
				.. GREEN .. "鲜血熔炉 |r(英雄)" }
	},
	[BF["Cenarion Expedition"]] = {
		{ 3000, "升到友善:\n\n" 
				.. WHITE .. "暗潮纳迦或者血鳞纳迦 (+5 声望值)\n"
				.. YELLOW .. "赞加沼泽的任务\n"
				.. "|r杀入任意 " .. GREEN .. "盘牙水库|r 的副本\n\n"
				.. WHITE .. "保存 [未鉴定过的植物] 为稍后上缴" },	
		{ 9000, "升到尊敬:\n\n" 
				.. WHITE .. "上缴 [未鉴定过的植物] x240\n"
				.. YELLOW .. "赞加沼泽的任务\n"
				.. "|r杀入任意 " .. GREEN .. "盘牙水库|r 的副本" },
		{ 42000, "升到崇拜:\n\n" 
				.. WHITE .. "上缴 [盘牙武器] +75 声望值\n\n"
				.. GREEN .. "蒸汽地窟 |r(普通)\n"
				.. GREEN .. "任何盘牙水库的副本 |r(英雄)" }
	},
	[BF["Keepers of Time"]] = {
		{ 42000, "升到崇拜:\n\n" 
				.. "|r杀入 " .. GREEN .. "旧希尔斯布莱德丘陵|r 和 " .. GREEN .. "黑色沼泽|r 副本\n\n"
				.. YELLOW .. "最后交任务:\n“旧希尔斯布莱德丘陵”任务线共计 5000 声望值\n“黑色沼泽”任务线共计 8000 声望值" }
	},
	[BF["The Sha'tar"]] = {
		{ 42000, "升到崇拜:\n\n" 
				.. GREEN .. "生态船 |r(普通或英雄)\n"
				.. GREEN .. "能源舰 |r(普通或英雄)\n"
				.. GREEN .. "禁魔监狱 |r(普通或英雄)\n" }
	},	
	[BF["Lower City"]] = {
		{ 9000, "升到尊敬:\n\n" 
				.. WHITE .. "上缴 [鸦人的羽毛]×30 (+250 声望值)\n"
				.. GREEN .. "暗影迷宫 |r(普通)\n"
				.. GREEN .. "奥金尼地穴 |r(普通)\n"
				.. GREEN .. "塞泰克大厅 |r(普通)" },
		{ 42000, "升到崇拜:\n\n" 
				.. GREEN .. "暗影迷宫 |r(普通或英雄)\n"
				.. GREEN .. "奥金尼地穴 |r(英雄)\n"
				.. GREEN .. "塞泰克大厅 |r(英雄)" }
	},	
	[BF["The Consortium"]] = {
		{ 3000, "升到友善:\n\n" 
				.. "|r上缴 [沃舒古水晶碎片] +250 声望值\n"
				.. "上缴 [象牙] +250 声望值\n\n"
				.. GREEN .. "法力坟墓 |r(普通)" },
		{ 9000, "升到尊敬:\n\n" 
				.. "|r上缴 [黑曜石作战念珠] +250 声望值\n\n"
				.. GREEN .. "法力坟墓 |r(普通)" },
		{ 42000, "升到崇拜:\n\n" 
				.. "|r上缴 [萨克希斯徽记] +250 声望值\n"
				.. "|r上缴 [黑曜石作战念珠] +250 声望值\n\n"
				.. GREEN .. "法力坟墓 |r(英雄)" }
	},
	[BF["Shattered Sun Offensive"]] = {
		{ 42000, "升到崇拜:\n\n" 
					.. YELLOW .. "完成奎尔丹纳斯岛和沙塔斯城的相关日常任务" }
	},
	[BF["The Mag'har"]] = {
		{ 42000, "升到崇拜:\n\n" 
				.. "|r上缴 [黑曜石作战念珠] +250 声望值\n\n"
				.. WHITE .. "纳格兰和泰罗卡森林的任何食人魔 (+5~11 声望值)\n"
				.. YELLOW .. "完成纳格兰的任务" }
	},
	[BF["Kurenai"]] = {
		{ 42000, "升到崇拜:\n\n" 
				.. "|r上缴 [黑曜石作战念珠] +250 声望值\n\n"
				.. WHITE .. "纳格兰和泰罗卡森林的任何食人魔 (+5~11 声望值)\n"
				.. YELLOW .. "完成纳格兰的任务" }
	},
	[BF["Sporeggar"]] = {
		{ 0, "升到中立:\n\n" 
				.. "上缴 [成熟的孢子] 或者 [沼泽领主的卷须] +250 声望值\n\n"
				.. YELLOW .. "沼泽领主,\n打开[孢子囊]\n"
				.. WHITE .. "(赞加沼泽)" },
		{ 3000, "升到友善:\n\n" 
				.. "上缴 [亮顶蘑菇] +250 声望值\n\n"
				.. "上缴 [成熟的孢子] 或者 [沼泽领主的卷须] +250 声望值\n\n"
				.. YELLOW .. "沼泽领主,\n打开[孢子囊]\n"
				.. WHITE .. "(赞加沼泽)" },
		{ 42000, "升到崇拜:\n\n" 
				.. WHITE .. "上缴 [红色木槿] +250 声望值\n\n"
				.. GREEN .. "幽暗沼泽 |r(普通或者英雄)\n"
				.. "上缴 [成熟的孢子] +250 声望值\n\n"
				.. YELLOW .. "现在 我们是朋友了… (可重复)|r +250 声望值\n" }
	},
		[BF["Sha'tari Skyguard"]] = {
		{ 42000, "升到崇拜, 重复以下任务:\n\n" 
				.. YELLOW .. "轰炸斯克提斯 (日常)|r +350 声望值\n"
				.. YELLOW.. "逃离斯克提斯 (日常)|r +350 声望值\n"
				.. YELLOW.. "仇敌的血脉 (可重复)|r +350 声望值\n"
				.. YELLOW.. "召唤泰罗克 (可重复)|r +350 声望值\n"
				.. WHITE .. "(斯克提斯)"
				.. YELLOW.. "继续轰炸！ (日常)|r +500 声望值\n"
				.. YELLOW.. "捕捉更多以太鳐！ (日常)|r +350 声望值\n"
				.. YELLOW.. "埃匹希斯的顿悟 (日常)|r +350 声望值\n"
				.. YELLOW.. "放逐更多恶魔 (日常)|r +350 声望值\n"
				.. WHITE .. "(刀锋山)"},
	},
		[BF["Ogri'la"]] = {
		{ 42000, "升到崇拜, 重复以下任务:\n\n" 
				.. YELLOW.. "继续轰炸！ (日常)|r +500 声望值\n"
				.. YELLOW.. "捕捉更多以太鳐！ (日常)|r +350 声望值\n"
				.. YELLOW.. "埃匹希斯的顿悟 (日常)|r +350 声望值\n"
				.. YELLOW.. "放逐更多恶魔 (日常)|r +350 声望值\n"
				.. WHITE .. "(刀锋山)"},
	}
}
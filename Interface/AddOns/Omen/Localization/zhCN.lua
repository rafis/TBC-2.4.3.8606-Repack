local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Omen", "zhCN")
if not L then return end

L["Background color"] = "背景颜色"
L["Background texture"] = "背景材质"
L["Bar options"] = "计量条设置"
L["Border color"] = "边框颜色"
L["Border texture"] = "边框材质"
L["Color"] = "颜色"
L["Configure"] = "设定"
L["Configure the labels that appear on the bars"] = "设定计量条上的标签"
L["Control the label fonts"] = "设定标签字体"
L["Control the font size of the labels"] = "设定标签字体尺寸"
L["Display options"] = "显示设置"
L["Font"] = "字体"
L["Font settings"] = "字体设定"
L["Frame's border color"] = "框体边框颜色"
L["Height"] = "高度"
L["Height of each bar"] = "每个计量条的高度"
L["Labels"] = "标签"
L["Window options"] = "显示窗口设置"
L["None"] = "无"
L["Open the configuration dialog"] = "打开 Omen 设置面板"
L["Options that control Omen's appearance"] = "设置 Omen 外观"
L["Options for modifying the look and feel of the main display"] = "主窗口外观和样式设置"
L["Options which affect the style of the threat bars"] = "仇恨计量条样式设置"
L["Outline"] = "外框"
L["Size"] = "尺寸"
L["Control the size of this frame"] = "设定 Omen 框体尺寸"
L["Spacing"] = "间距"
L["Spacing between each bar"] = "计量条之间的间隔"
L["Stretch textures"] = "拉伸材质"
L["Stretch textures to fit the width of the bar"] = "拉伸材质以适应计量条宽度"
L["Texture"] = "材质" 
L["Thick Outline"] = "厚描边"
L["The color of the labels"] = "标签文本颜色"
L["The font that the labels will use"] = "标签文本字体"
L["The outline that the labels will use"] = "标签字体描边"
L["The texture that the bar will use"] = "计量条的材质"

L["Texture to use for the frame's background"] = "设定框体背景材质"
L["Texture to use for the frame's border"] = "设定边框材质"
L["Main display's border color"] = "主显示框体边框颜色"
L["Bars window"] = "计量条窗口"
L["Options that affect the appearance of the bar list window"] = "设置计量条列表窗口的外观"
L["Options that affect the appearance of the title window"] = "设置标题窗口的外观"
L["Options that affect the appearance of the module list window"] = "设置模式列表窗口的外观"
L["Title window"] = "标题窗口"
L["Hide version"] = "隐藏版本号"
L["Hide the version number and out-of-date notice"] = "隐藏版本号以及过期版本警告"
L["Hide"] = "隐藏"
L["Hide this frame"] = "隐藏标题窗口"
L["Options not related to appearance"] = "跟外观无关的设置"
L["General options"] = "综合设置"
L["TPS Update Frequency"] = "TPS 更新频率"
L["Controls the speed at which TPS (threat per second) values update.\nRaise this value to increase performance, or set it to 0 to turn off TPS queries."] = "设定 TPS（每秒仇恨值）更新频率，提高此数字将会提升性能，设为0则关闭此功能。"
L["Modules window"] = "模块窗口"
L["Defaults"] = "默认"
L["Options that affect the appearance of all frames"] = "设置所有框体外观"
L["Reset to defaults"] = "重置为默认值"
L["Use global defaults for this frame"] = "为该框体使用全局默认值"
L["Show test bars"] = "显示测试计量条"
L["Test"] = "测试"

L["Modules"] = "模块"
L["Options for Omen's various modules"] = "Omen 的一些模块的设置"

L["Lock Omen"] = "锁定 Omen"
L["Locks Omen in place and prevents it from being dragged or resized."] = "锁定 Omen，使其无法被移动或拉伸。"
L["Hide when not needed"] = "在不使用时隐藏"

L["Animate bars"] = "计量条"
L["Smoothly animate bar changes"] = "平滑显示计量条变动"
L["Hides Omen when you are resting, not in a party, or in an arena or battleground"] = "当你进入休息状态，或者不在队伍、竞技场以及战场中时隐藏 Omen。"
L["Error"] = "错误"
L["Unable to use shake warning. If you have nameplates turned on, turn them off to enable shake warnings."] = "无法使用屏幕振动警报功能。如果你开启了姓名板，将它们关闭后再启用屏幕振动警报功能。"

L["Background opacity"] = "背景透明度"
L["Opacity of each bar's background"] = "每个计量条背景透明度"
L["Background darkness"] = "背景明暗度"
L["Darkness of each bar's background"] = "每个计量条背景明暗度"

L["Opacity"] = "透明度"
L["Opacity of the entire frame"] = "全部框体的透明度"

L["Classes"] = "职业"
L["DRUID"] = "德鲁伊"
L["HUNTER"] = "猎人"
L["MAGE"] = "法师"
L["PALADIN"] = "圣骑士"
L["PET"] = "宠物"
L["PRIEST"] = "牧师"
L["ROGUE"] = "潜行者"
L["SHAMAN"] = "萨满祭司"
L["WARLOCK"] = "术士"
L["WARRIOR"] = "战士"

L["Number of bars to show"] = "要显示的计量条的数量"
L["Autocollapse"] = "自动收起"
L["Collapse to show a minimum number of bars"] = "收起以显示最少的计量条数量"

L["Collapse hides bar list"] = "折叠隐藏计量条列表"
L["Let autocollapse hide the bar list if no bars are shown"] = "当无计量条显示时自动折叠隐藏计量条列表"
L["Collapse hides entire Omen window"] = "折叠隐藏整个 Omen 窗口"
L["Let autocollapse hide the |c00ffffffentire window|r if no bars are shown. Note: This |c00ffffffwill|r prevent you from switching modules out of combat."] = "当无计量条显示时自动折叠隐藏|c00ffffff整个窗口|r。提示：这|c00ffffff将防止|r你在非战斗时转换模式。"

L["Grow Up"] = "向上延展"
L["Grow bars upwards"] = "计量条向上延展"
L["Toggle Omen"] = "开关 Omen"
L["Center Omen"] = "Omen 居中"
L["Active when alone"] = "没组队的时候也启用"
L["Enable ThreatLib even when you aren't in a party and don't have a pet."] = "即便当你不在队伍中以及没有宠物时，也启用 ThreatLib 函数库。"

L["Control the scale of the entire Omen GUI"] = "设置整个 Omen GUI 的缩放比例"
L["Scale"] = "缩放"

L["Clamp to screen"] = "限制在屏幕内"
L["Clamp the Omen frame to the screen"] = "将 Omen 框体限制在屏幕内"

L["Skin"] = "皮肤"
L["Save your current settings and load other skins"] = "保存当前配置并载入其他皮肤"
L["Load Skin..."] = "载入皮肤…"
L["Load a saved skin"] = "载入一个已保存的皮肤"
L["Save Skin As..."] = "皮肤另存为…"
L["Save the current settings as a skin"] = "将当前的配置保存为一个皮肤"

L["Click|r to toggle the Omen window"] = "点击|r打开/关闭 Omen 窗口"
L["Right-click|r to open the options menu"] = "右击|r打开设置菜单"

L["Attach to minimap"] = "依附到小地图"
L["FuBar options"] = "FuBar 设置"
L["Position"] = "位置"
L["Left"] = "左边"
L["Center"] = "居中"
L["Right"] = "右边"
L["Show text"] = "显示文字"
L["Show icon"] = "显示图标"

L["Standby"] = "暂停"
L["Hide minimap/FuBar icon"] = "隐藏小地图/Fubar 图标"

L["Configure Omen"] = "设置 Omen"

L["Version Checks"] = "版本检测"
L["Show all party member revisions"] = "显示全队成员的子版本"
L["Show oudated party member revisions"] = "显示全队成员过期的子版本"

L["ThreatLib Version Check: All party members"] = "ThreatLib 版本检测：全队成员"
L["ThreatLib Version Check: Outdated party members"] = "ThreatLib 版本检测：全队过期成员"
L["latest is"] = "最新版本："

L["You have a pet"] = "有宠物"
L["Show Omen when you have a pet out"] = "当你使用一个宠物时显示 Omen"
L["You are alone"] = "单独"
L["Show Omen when you are alone"] = "当你单独作战时显示 Omen"
L["You are in a party"] = "小队作战"
L["Show Omen when you are in a 5-man party"] = "当你在5人小队时显示 Omen"
L["You are in a raid"] = "团队作战"
L["Show Omen when you are in a raid"] = "当你在团队中时显示 Omen"
L["Show when..."] = "当...时显示"
L["Show Omen when..."] = "当…时显示 Omen"
L["You are resting"] = "休息"
L["Show Omen when you are resting"] = "当你休息时显示 Omen"
L["You are in a battleground"] = "战场中"
L["Show Omen when you are in a battleground or arena"] = "当你在战场或竞技场时显示 Omen"
L["You are in a dungeon"] = "副本中"
L["Show Omen when you are in a dungeon (5 man and raid)"] = "当你在副本时显示 Omen （5人副本或团队）"

L["Unknown"] = "未知"
L["Not compatible!"] = "不兼容！"

L["Issue threat clear"] = "手动重置仇恨"
L["Issue threat clear (requires party leader or raid assistant)"] = "手动重置仇恨（需要队长或者助理权限）"

L["Your version of Omen/Threat is out of date. Please update from WAU or http://files.wowace.com/Omen/Omen.zip when possible."] = "你当前的 Omen/Threat 版本已经过期，请使用 WAU 更新或者从 http://files.wowace.com/Omen/Omen.zip 下载最新版。"
L["Your version of Omen/Threat is out of date and is not compatible with the newest version. You should update from WAU or http://files.wowace.com/Omen/Omen.zip as soon as possible."] = "你当前的 Omen/Threat 版本已经过期并且不与新版兼容，你应该立即使用 WAU 更新或者从 http://files.wowace.com/Omen/Omen.zip 下载最新版。"

L["Whisper older clients informing them to update."] = "密语旧版本的玩家通知他们更新。"
L["You must be the group leader or a group assistant to do this."] = "必须是团长或助理才能这么做。"

L["Pullout Bars"] = "弹出条"
L["Options for pullout bars"] = "弹出条设置"
L["Default texture"] = "默认材质"
L["Texture used by new pullout bars"] = "新建弹出条材质"

BINDING_HEADER_OMEN = "Omen"
BINDING_NAME_OMENTOGGLE = "开关 Omen"
BINDING_NAME_OMENNEXTMODULE = "跳转至下一模块"
BINDING_NAME_OMENPREVMODULE = "跳转至上一模块"


-- mapID, BCContinent, BCZone, VanillaC, VanillaZ
QuestieZones = {
  ["WorldMap"] = {1337, 1337, 0, 0}, --
  ["Azeroth"] = {-1, -1, -1, 2, 0}, --
  ["Kalimdor"] = {-1, -1, -1, 1, 0}, --
  ["Hinterlands"] = {42, 2, 24, 2, 20}, -- -- I found the code questhelper used, didnt do enough searching D:
  ["Moonglade"] = {20, 1, 12, 1, 10}, --
  ["ThousandNeedles"] = {14, 1, 21, 1, 18}, --
  ["Winterspring"] = {19, 1, 24, 1, 21}, --
  ["BloodmystIsle"] = {9, 1, 4, -1, -1},--
  ["TerokkarForest"] = {55, 3, 7, -1, -1},--
  ["Arathi"] = {39, 2, 2, 2, 2},--
  ["EversongWoods"] = {41, 2, 11, -1, -1}, --
  ["Dustwallow"] = {10, 1, 9, 1, 7},--
  ["Badlands"] = {27, 2, 3, 2, 3}, --
  ["Darkshore"] = {16, 1, 5, 1, 3},--
  ["Ogrimmar"] = {1, 1, 14, 1, 12},--
  ["BladesEdgeMountains"] = {54, 3, 1, -1, -1},
  ["Undercity"] = {45, 2, 26, 2, 22},
  ["Desolace"] = {4, 1, 7, 1, 5},
  ["Netherstorm"] = {59, 3, 4, -1, -1},
  ["Barrens"] = {11, 1, 19, 1, 17},
  ["Tanaris"] = {8, 1, 17, 1, 15},
  ["Stormwind"] = {36, 2, 21, 2, 17},--
  ["Zangarmarsh"] = {57, 3, 8, -1, -1},
  ["Durotar"] = {7, 1, 8, 1, 6},--
  ["Hellfire"] = {56, 3, 2, -1, -1},
  ["Silithus"] = {5, 1, 15, 1, 13},
  ["ShattrathCity"] = {60, 3, 6, -1, -1},
  ["ShadowmoonValley"] = {53, 3, 5, -1, -1},
  ["SwampOfSorrows"] = {46, 2, 23, 2, 19},
  ["SilvermoonCity"] = {52, 2, 19, -1, -1},
  ["Darnassis"] = {21, 1, 6, 1, 4},
  ["AzuremystIsle"] = {3, 1, 3, -1, -1},
  ["Elwynn"] = {37, 2, 10, 2, 10},--
  ["Stranglethorn"] = {38, 2, 22, 2, 18},
  ["EasternPlaguelands"] = {34, 2, 9, 2, 9},
  ["Duskwood"] = {31, 2, 8, 2, 8},
  ["WesternPlaguelands"] = {50, 2, 27, 2, 23},
  ["Westfall"] = {49, 2, 28, 2, 24},
  ["Ashenvale"] = {2, 1, 1, 1, 1},
  ["Teldrassil"] = {24, 1, 18, 1, 16},
  ["Redridge"] = {30, 2, 17, 2, 14},
  ["UngoroCrater"] = {18, 1, 23, 1, 20},
  ["Mulgore"] = {22, 1, 13, 1, 11},
  ["Ironforge"] = {25, 2, 14, 2, 12},
  ["Felwood"] = {13, 1, 10, 1, 8},
  ["Hilsbrad"] = {48, 2, 13, 2, 11},
  ["DeadwindPass"] = {47, 2, 6, 2, 6},
  ["BurningSteppes"] = {40, 2, 5, 2, 5},
  ["Ghostlands"] = {44, 2, 12, -1, -1},
  ["Tirisfal"] = {43, 2, 25, 2, 21},
  ["TheExodar"] = {12, 1, 20, -1, -1},
  ["Wetlands"] = {51, 2, 29, 2, 25},
  ["SearingGorge"] = {32, 2, 18, 2, 15},
  ["BlastedLands"] = {33, 2, 4, 2, 4},
  ["Silverpine"] = {35, 2, 20, 2, 16},
  ["LochModan"] = {29, 2, 16, 2, 13},
  ["Feralas"] = {17, 1, 11, 1, 9},
  ["DunMorogh"] = {28, 2, 7, 2, 7},
  ["Alterac"] = {26, 2, 1, 2, 1},
  ["ThunderBluff"] = {23, 1, 22, 1, 19},
  ["Aszhara"] = {15, 1, 2, 1, 2},
  ["StonetalonMountains"] = {6, 1, 16, 1, 14},
  ["Nagrand"] = {58, 3, 3, -1, -1},
  ["Kalimdor"] = {61, 1, 0, 1, 0},
  ["Azeroth"] = {62, 2, 0, 2, 0},
  ["Expansion01"] = {63, 3, 0, -1, -1},
  ["Sunwell"] = {64, 2, 15, -1, -1} -- code copied from questhelper (this is actually the only code that was directly copied, the database was put through JavaRefactorProject
}
QuestieZoneIDLookup = {};
for k,v in pairs(QuestieZones) do
  -- must be non-linear array
  QuestieZoneIDLookup[v[1]] = v;
  
  -- hack to fix tbc
  v[4] = v[2];
  v[5] = v[3];
end

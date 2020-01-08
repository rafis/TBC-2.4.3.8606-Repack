--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 - 2007 Dan Gilbert
	Email me at loglow@gmail.com

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Atlas is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Atlas; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]

if ( GetLocale() == "koKR" ) then

	local BLUE = "|cff6666ff";
	local GREY = "|cff999999";
	local GREN = "|cff66cc33";
	local _RED = "|cffcc6666";
	local ORNG = "|cffcc9933";
	local PURP = "|cff9900ff";
	local INDENT = "   ";

	local myCategory = "비행경로 지도";

	local myData = {
		FPAllianceEast = {
			ZoneName = "얼라이언스 (동부 왕국)";
			Location = "동부 왕국";
			GREY.." 1) 희망의 빛 에배당, ".._RED.."동부 역병지대";
			GREY.." 2) 서리바람 야영지, ".._RED.."서부 역병지대";
			GREY.." 3) 맹금의 봉우리, ".._RED.."동부 내륙지";
			GREY.." 4) 사우스쇼어, ".._RED.."힐스브래드 구릉지";
			GREY.." 5) 임시 주둔지, ".._RED.."아라시 고원";
			GREY.." 6) 메네실 항구, ".._RED.."저습지";
			GREY.." 7) 아이언포지, ".._RED.."던 모로";
			GREY.." 8) 텔사마, ".._RED.."모단 호수";
			GREY.." 9) 토륨 조합 거점, ".._RED.."이글거리는 협곡";
			GREY.."10) 모건의 망루, ".._RED.."불타는 평원";
			GREY.."11) 스톰윈드, ".._RED.."엘윈 숲";
			GREY.."12) 레이크샤이어, ".._RED.."붉은마루 산맥";
			GREY.."13) 감시의 언덕, ".._RED.."서부몰락지대";
			GREY.."14) 다크샤이어, ".._RED.."그늘숲";
			GREY.."15) 네더가드 요새, ".._RED.."저주받은 땅";
			GREY.."16) 무법항, ".._RED.."가시덤불 골짜기";
		};
		FPAllianceWest = {
			ZoneName = "얼라이언스 (칼림도어)";
			Location = "칼림도어";
			GREY.." 1) 루네란 마을, ".._RED.."텔드랏실";
			GREY.." 2) 레물로스의 제단, ".._RED.."달의 숲";
			GREY.." 3) 눈망루 마을, ".._RED.."여명의 설원";
			GREY.." 4) 아우버다인, ".._RED.."어둠의 해안";
			GREY.." 5) 갈퀴가지 숲, ".._RED.."악령의 숲";
			GREY.." 6) 돌발톱 봉우리, ".._RED.."돌발톱 산맥";
			GREY.." 7) 아스트라나르, ".._RED.."잿빛 골짜기";
			GREY.." 8) 탈렌드리스 초소, ".._RED.."아즈샤라";
			GREY.." 9) 나이젤의 야영지, ".._RED.."잊혀진 땅";
			GREY.."10) 톱니항, ".._RED.."불모의 땅";
			GREY.."11) 테라모어 섬, ".._RED.."먼지진흙 습지대";
			GREY.."12) 페더문 요새, ".._RED.."페랄라스";
			GREY.."13) 탈라나르, ".._RED.."페랄라스";
			GREY.."14) 마샬의 야영지, ".._RED.."운고로 분화구";
			GREY.."15) 세나리온 요새, ".._RED.."실리더스";
			GREY.."16) 가젯잔, ".._RED.."타나리스";
			GREY.."17) 엑소다르, ".._RED.."하늘안개 섬";
			GREY.."18) 핏빛 감시초소, ".._RED.."핏빛안개 섬";
			"";
			"";
			"";
			"";
			"";
			"";
			GREN.."녹색: 드루이드 전용경로";
		};
		FPHordeEast = {
			ZoneName = "호드 (동부 왕국)";
			Location = "동부 왕국";
			GREY.." 1) 희망의 빛 에배당, ".._RED.."동부 역병지대";
			GREY.." 2) 언더시티, ".._RED.."티리스팔 숲";
			GREY.." 3) 공동묘지, ".._RED.."은빛소나무 숲";
			GREY.." 4) 타렌밀 농장, ".._RED.."힐스브래드 구릉지";
			GREY.." 5) 레반터스크 마을, ".._RED.."동부내륙지";
			GREY.." 6) 해머폴, ".._RED.."아라시 고원";
			GREY.." 7) 토륨 조합 거점, ".._RED.."이글거리는 협곡";
			GREY.." 8) 카르가스, ".._RED.."황야의 땅";
			GREY.." 9) 화염 마루, ".._RED.."불타는 평원";
			GREY.."10) 스토나드, ".._RED.."슬픔의 늪";
			GREY.."11) 그롬골, ".._RED.."가시덤불 골짜기";
			GREY.."12) 무법항, ".._RED.."가시덤불 골짜기";
			GREY.."13) 실버문, ".._RED.."영원노래 숲";
			GREY.."14) 트랜퀼리엔, ".._RED.."유령의 땅";
		};
		FPHordeWest = {
			ZoneName = "호드 (칼림도어)";
			Location = "칼림도어";
			GREY.." 1) 레물로스의 제단, ".._RED.."달의 숲";
			GREY.." 2) 눈망루 마을, ".._RED.."여명의 설원";
			GREY.." 3) 피멍울 초소, ".._RED.."악령의 숲";
			GREY.." 4) 조람가르 전초기지, ".._RED.."잿빛 골짜기";
			GREY.." 5) 발로르모크, ".._RED.."아즈샤라";
			GREY.." 6) 토막나무 주둔지, ".._RED.."잿빛 골짜기";
			GREY.." 7) 오그리마, ".._RED.."듀로타";
			GREY.." 8) 해바위 야영지, ".._RED.."돌발톱 산맥";
			GREY.." 9) 크로스로드, ".._RED.."불모의 땅";
			GREY.."10) 톱니항, ".._RED.."불모의 땅";
			GREY.."11) 그늘수렵 마을, ".._RED.."잊혀진 땅";
			GREY.."12) 썬더블러프, ".._RED.."멀고어";
			GREY.."13) 타우라조 야영지, ".._RED.."불모의 땅";
			GREY.."14) 담쟁이 마을, ".._RED.."먼지진흙 습지대";
			GREY.."15) 모자케 야영지, ".._RED.."페랄라스";
			GREY.."16) 높새바람 봉우리, ".._RED.."버섯구름 봉우기";
			GREY.."17) 마샬의 야영지, ".._RED.."운고로 분화구";
			GREY.."18) 세나리온 요새, ".._RED.."실리더스";
			GREY.."19) 가젯잔, ".._RED.."타나리스";
			"";
			"";
			"";
			"";
			"";
			GREN.."녹색: 드루이드 전용경로";
		};
		FPHordeOutland = {
			ZoneName = "호드 (아웃랜드)";
			Location = "아웃랜드";
			GREY.."1) 어둠의 문, ".._RED.."지옥불 반도";
			GREY.."2) 스랄마, ".._RED.."지옥불 반도";
			GREY.."3) 해골망치 초소, ".._RED.."지옥불 반도";
			GREY.."4) 매의 감시탑, ".._RED.."지옥불 반도";
			GREY.."5) 늪쥐감시 초소, ".._RED.."장가르 습지대";
			GREY.."6) 샤트라스, ".._RED.."테로카르 숲";
			GREY.."7) 돌망치 요새, ".._RED.."테로카르 숲";
			GREY.."8) 어둠달 마을, ".._RED.."어둠달 골짜기";
			GREY.."9) 샤타르 제단, ".._RED.."어둠달 골짜기 "..BLUE.."(알도르)";
			GREY.."10) 별의 성소, ".._RED.."어둠달 골짜기 "..BLUE.."(점술가)";
			GREY.."11) 가라다르, ".._RED.."나그란드";
			GREY.."12) 자브라진, ".._RED.."장가르 습지대";
			GREY.."13) 천둥군주 요새, ".._RED.."칼날 산맥";
			GREY.."14) 루안숲, ".._RED.."칼날 산맥";
			GREY.."15) 모크나탈 마을, ".._RED.."칼날 산맥";
			GREY.."16) 52번 구역, ".._RED.."풍황천의 폭";
			GREY.."17) 푹풍 첨탑, ".._RED.."풍황천의 폭";
			GREY.."18) 코스모렌치, ".._RED.."풍황천의 폭";
		};
		FPAllianceOutland = {
			ZoneName = "얼라이언스 (아웃랜드)";
			Location = "아웃랜드";
			GREY.."1) 어둠의 문, ".._RED.."지옥불 반도";
			GREY.."2) 징검다리 거점, ".._RED.."지옥불 반도";
			GREY.."3) 명예의 요새, ".._RED.."지옥불 반도";
			GREY.."4) 텔하마트 사원, ".._RED.."지옥불 반도";
			GREY.."5) 텔레도르, ".._RED.."장가르 습지대";
			GREY.."6) 샤트라스, ".._RED.."테로카르 숲";
			GREY.."7) 알레리아 성채, ".._RED.."테로카르 숲";
			GREY.."8) 와일드해머 성채, ".._RED.."어둠달 골짜기";
			GREY.."9) 샤타르 제단, ".._RED.."어둠달 골짜기 "..BLUE.."(알도르)";
			GREY.."10) 별의 성소, ".._RED.."어둠달 골짜기 "..BLUE.."(점술가)";
			GREY.."11) 텔라아르, ".._RED.."나그란드";
			GREY.."12) 오레보르 피난처, ".._RED.."장가르 습지대";
			GREY.."13) 실바나르, ".._RED.."칼날 산맥";
			GREY.."14) 루안숲, ".._RED.."칼날 산맥";
			GREY.."15) 토쉴리의 연구기지, ".._RED.."칼날 산맥";
			GREY.."16) 52번 구역, ".._RED.."풍황천의 폭";
			GREY.."17) 푹풍 첨탑, ".._RED.."풍황천의 폭";
			GREY.."18) 코스모렌치, ".._RED.."풍황천의 폭";
		};
	};

	Atlas_RegisterPlugin("AtlasFlightPaths", myCategory, myData);

end

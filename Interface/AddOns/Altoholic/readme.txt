Hi, my name is Thaoky, and I'm an Altoholic :)

Altoholic is an ACE 2 addon written for people who dedicate most of their time to leveling alts, and who want to have as much information as possible in one addon. The main feature of the addon is the search functionality which allows users to search their alts' bags or loot tables in an Auction-House-like frame (see screenshots). All this with multiple-realms support

Paypal donations accepted at : thaoky.altoholic@yahoo.com


About the addon & the author

I've been playing WoW since the European release, and I used to rely on addons like character viewer to check my alts' inventory, but since it was more or less abandoned and not always stable for me, I decided to write an addon myself and to improve the search feature as much as I could. I hope you'll enjoy it as much as I do :)

The addon has been in development since December 2007 and is rather stable now. It's not final, there are quite a few things I haven't had time to implement yet, but I felt it was now mature enough for a public release.
Please note that this is my first addon, and that English is not my native language.

Features:

- Language supported: English and French. Although it's not fully localized for frFR, it does run well on French clients (my guildmates made sure of this :D). More languages will come soon, I'm using the LibBabble libraries more & more.


- Account-wide data summary:
	- Characters' talents: only a summary, not a full buid, I may implement this later on if there's demand.
	- Money, /played, rest xp for each character, subtotals by realm, and grandtotals for the account.
	- Bag usage: see at a glance which characters should get bigger bags (bag size, free slots and types included)
	- Characters' skills: skill summary on one screen, namely the 2 main professions + the 3 secondary skills as well as riding. I may add more if there's demand.
	- Reputations: a list of all the reputations of the current realm's characters. This screen will get some love in the future, but it's perfectly functional. You can see at a glance if all your alts are at least honored with Honor Hold if you want to get the new 2.4 blue PVP set.

- View containers (bags, bank, keyring) of all alts, on all realms.

- Guild banks : You have 10 alts in 10 different guilds on the same server, all of them with access to a guild bank ?
Not a problem, you can see them all here.

- E-mail: allows you to see which alts have mail without having to reconnect them. The addon will tell you when mail is about to expire on a character. Threshold configurable (up to 15 days). Multiple realm support as well. Mails sent to a known alt (one you've logged on at least once) will be visible in the addon.

- Equipment: See the equipment of the current realm's alts in one screen. Very useful when purchasing stuff for your alts at the AH.

- Options: the option screen is still a bit minimal, I'll add more options along the way depending on user requests.

- Search: the most important feature of the addon, it uses an AH-like frame to display search results. You can either search bags on the current realm, on all realms, or a loot table.
The loot table is a table based on AtlasLoot 4.04 which contains only item id's, and therefore keeps memory usage minimal.
As an indicator, with 10 alts (+bank) + guild bank + loot table, the addon only takes 2.3 mb of memory. The addon has gained weight since the integration of some libraries, but this will ensure support for multiple languages in the future. I expect to support deDE soon.

The Search menu allows you to find items based on their name (even partial), level, type or rarity, almost like at the AH.

How to Install the addon
========================

Make sure you unzip the addon using "Extract Here" instead of "Extract to Altoholic v2.x.yyy", otherwise the resulting directory will contain a space that will prevent the addon from being visible in WoW's addon list.

Using command-line searches
===========================

Type: /alto search <item>
ex: 
/alto search cloth
/alto search primal
...

A maximum of two words is allowed after the command, so you could type:
/alto search primal mana 		... and get only those primals in the search results.
This should cover most of the searches you can do via the command line, if you actually need something more complicated, please use the UI.



Known bugs/missing functionalities (2.4.014)

- Missing: In the skills summary, specialization will be added for the 2 main professions.
- Missing: Return mails are not supported yet, but standard mails with or without money/attachment are ok.

To do:

- Search: support an AH-like function for "usable" items.
- Add support for a wishlist/todolist.
- .. a lot more, suggestions are welcome :)

About the AutoQuery
===================

1. What is it ?
When enabled, the AutoQuery option will try to query the server for 5 new items every time a search is made in the loot table.
The goal is to turn 5 "unknown/unsafe" item ids into 5 usable ones, which will not always work as the items may simply be unknown on your server.
A good example would be high level loots from a recently released raid dungeon. 

2. How does it work ?
Every time you perform a search in the loot tables, the first five unsafe items encountered will trigger a server query.
This query may result in either a valid or an invalid item. If the item is valid, the quality of searches will be improved.
If it is invalid, the id will be saved in a list of "unsafe" items to prevent querying the server again with this id (thereby reducing the risk of disconnection), as querying the server multiple times for unknown id "may" result in a disconnect.

3. Disconnect or not ?
The option is disabled by default, I strived to provide a solution that decreases the risk of disconnection as much as possible, but the risk will always be there.
If you choose not to enable this option, you will NEVER be disturbed by a disconnection, but if you do, please DO NOT report this as a bug, this is a feature that will ALWAYS carry a risk, so you'll be using it AT OWN RISK.
Also, you have to know that querying the server even once for an unknown item may or may not result in a disconnect. As far as I can tell, the behavior of the game is absolutely not consistent to that regard.

4. How do I see if this works well for me ?
In the option frame, just below the AutoQuery option, you will see two counters (they're populated after performing one search in the loot table).
As of v2.4.013, there are 8885 known loots in the loot table. On my server I currently have 3493 unknown items, down from 3600 when I started implementing this feature.
The unkown count is bound to vary greatly from one server to another, and will decrease gradually as you're using this feature. Don't dream about ever reaching zero though :)

5. What should I do if I keep being disconnected ?
Disable the option. I'm really sorry, but this whole implementation is a "best effort", there is no way I can guarantee that this will work 100%.

6. What can I do to reduce the risk ?
Do not spam the search button. Querying the server for a few unkown id's is fine, but if you spam the server, you'll get a flood-disconnect.

7. I chose to keep this option disabled, but the "unknown" counter decreases anyway, why ?
As you keep meeting new people and item vendors, the amount of known items will keep increasing naturally, and your item cache will populate more & more.

8. The "unknown" counter has suddendly increased, why ?
This is an expected behaviour after a patch, as the local item cache will be cleared. Some of the items you used to "know" are now "unknown".

About the "Find Upgrade" feature
================================

In the equipment pane, it's possible to right-click on any item to find an upgrade for it. This works roughly like the official armory on Blizzard's site.

There are multiple ways to find an upgrade:

1. Find Upgrade (based on iLvl)

This is the most simple and less restrictive filter, if you try to find an upgrade for the shoulder slot of your mage, Altoholic will return all items that have a greater item level than yours. The only problem with this option is that it doesn't take care of item stats, so you will end up with +heal items listed, which are obviousily useless for a mage.


2. Find Upgrade (Tank) - warriors, paladins & druids only

This option will filter loots based on their pure tanking properties. For instance, a paladin item with +heal will not be listed.
Items with resilience will also not be taken into account.

3. Find Upgrade (DPS) - all classes

The items listed will vary depending on your class, but only DPS oriented items will be visible. 

4. Find Upgrade (Heal) - priests, paladins, druidss & shamans only.

You guessed it, only items with +heal will be listed here.

Ex: If you're looking for priest items, items with +dmg will be in (DPS) while items will +heal will be in (Heal), the best way to find exactly what you're looking for is to try both options, especially if you're willing to favor a +dmg item in you +heal stuff because it has more of another stat. Don't forget that the results are just an indication, they won't do the job for you.

The stats listed vary based on the class/spec you chose, but for all of them, a green stat means that it's better than the item you're looking an upgrade for, red means worse, and white means equal.

You will notice that the value 0 (zero) is sometimes written in red, and sometimes in white.
Red means that the value existed on the original item (ex: +25 spirit), but not in the one being displayed (no spirit), since no spirit is lower than 25 --> red.
If there was no spirit on both items, but spirit is a relevant stat for this class/spec, it will be written in white.

Notes:

- Just like all other searches in the loot table, these searches are dependant on the quality of your local item cache.
- On my machine, the first type of search (iLvl) takes around 120ms, while others are a bit longer, but usually remain under 200ms. I only advise to use the advanced searches on level 70 (or close to 70) items, as this type of stat parsing can be rather long. You could face a small freeze if your machine is slow and you're trying to find an upgrade for a low level item.
- From time to time, some items will not be filtered and listed as potential upgrades, this is due to the fact that these items have no stat (those with a random enchant for example). The only way to filter them out is to improve the algorithm, but this could considerably slow down the searches, and I'd rather have some surplus in the results than improving the algorithm too much and filter out valid items.
- All class/spec filters are rather accurate, although certainly not exempt from mistakes (please report), except for the druid/tank role, for which it's very difficult to filter out potential upgrades.

FAQ
===

- Can I delete an alt that no longer exists ?
Yes, simply right click on its level in "Account Summary->Characters", and select "Delete this Alt".
This will remove all information related to this alt. The addon will NOT let you delete the character with which you're currently logged in.

- I want to organize my bags differently, can I do it ?
No, I don't intend to rework the "containers" frame. It's clean, and its only purpose is to view the possessions of a character. The major feature of the addon remains the search feature. If you want to organize your bags, you'll have to look elsewhere :)

- When searching the loot table, some items do not seem to appear in the search results, why ?
After every major patch, the player's item cache will be reset, which means that any item that has not been seen yet will not be listed. This is a restriction enforced by Blizzard, just like the items that cannot be seen in AtlasLoot. I intend to improve this in the future.

- What is the figure that appears in the last column when searching the loot table ?
It's the item level. For those who don't know, the item level is the "real" level of the item, it's different from the level requirement that appears in the item link. The search results are sorted per item level, it is thus useful when searching for upgrades.

- Should I get rid of AtlasLoot ?
No, certainly not. If anything, the search functionality of Altoholic would be complementary to AtlasLoot, but Altoholic does not intend to replace Atlas & AtlasLoot. I might add some kind of list per boss at some point, but it won't match the quality of Atlas+AtlasLoot.

- Do you support all the loots listed in AtlasLoot 4.04 ?
Almost all of them. I'm on par with 4.04.01. Some quest items have been removed along the way.

- Why are certain items listed more than once when I search loot tables ?
Simply because they can drop at more than one place, or because a specific boss drops a quest item that is related. 
Majordomo's chest comes to my mind for the hunter & priest quests.

Credits

- I'd like to thank my guild, Odysseüs on EU-Marécages de Zangar, for assisting me since the earliest phases, thanks guys for everything you've done :)
- Thanks to the wowace community, you've been very helpful and this addon would not be there without the technical answers you gave me (especially Xinhuan, author of BankItems)
- Thanks to all the guys who are behind AtlasLoot, keeping the loot table up-to-date is a tremendous work, and the search functionality of Altoholic would not be what it is without your hard work.
- Thanks to Ayindi (wowace) for the German translation.
- Thanks to NightOwl (wowace) for the zhTW translation.
- Thanks to AYiNaFA for the zhCN translation.
- Brykrys for the LinkWrangler support.















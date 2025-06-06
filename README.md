<div id="header" align="center">
  <h1>Call of Duty: Modern Warfare III Mapvote</h1>

  [![Build Badge](https://img.shields.io/badge/Developed_by-DoktorSAS-brightgreen?style=for-the-badge&logo=x)](https://twitter.com/DoktorSAS)
  [![License](https://img.shields.io/badge/LICENSE-GPL--3.0-blue?style=for-the-badge&logo=appveyor)](LICENSE)

Special thanks to [@KeyZHostHDCopy](https://twitter.com/KeyZHostHDCopy) for the materials and the .iwi
</div>

### Preview
![preview](iw5_preview.png)

### Requirements
- The mod can run client side but it will not make the map rotate since its main logic is based on the game built in map rotation.
- It will only work on plutonium client or any client who have mod support and map rotation.

### Installation

 1) Compile the mod with the zonetool *with the zone tool provided under zonetool folder*
    - Copy the zonetool and the zone_source folder and paste it under your game folder (Ex: `steamapps\common\Call of Duty Modern Warfare 3`).
    - Extract the file from the zoontool folder and move the zonetool_iw5.exe and the ZoneTool-x86-release.dll under your game folder  (Ex: `steamapps\common\Call of Duty Modern Warfare 3`).
    - Rename ZoneTool-x86-release.dll to zoonetool.dll.
    - Copy the mod folder and move it inside the zonetool folder.
    - Execute the zonetool_iw5.exe and execute the command `buildZone mod`
    - Once done go in zone/english and retrive your compiled mod.ff file.
 3) Copy the Compiled mod.ff file in your Directory %localappdata%\Plutonium\storage\iw5\mods\YOURMODNAME (Exemple: ..\mods\mapvote, ..\mods\funserver)
 4) Create the .iwd file with .iwi images in the images folder and put in in your Directory %localappdata%\Plutonium\storage\iw5\mods\YOURMODNAME (Exemple: ..\mods\mapvote, ..\mods\funserver)
 5) Copy the Content of the mapvote.cfg in your .cfg (Exemple: server.cfg, dedicated_mp.cfg, dedicated.cfg, etc ) file that manages the Server.
 6) Edit the Dvars to setup the Server, many Dvars are only for Aesthetic Parameters.
    - set the Dvar mv_maps to decide the maps that will be shown in mapvote, Example:
        - set mv_maps "mp_favela mp_rust mp_terminal_cls mp_alpha mp_bootleg mp_bravo mp_carbon mp_dome mp_exchange mp_hardhat mp_interchange mp_lambeth mp_mogadishu mp_paris mp_plaza2 mp_radar mp_seatown mp_underground mp_village"
    - set the dvar mv_enable to 1 if you want have it active on your server.
    - If you want random gametypes you have to set the dvar mv_gametypefiles specifying the gametype .dsr file name. Exemple:
        - set mv_gametypefiles "TDM_default@FFA_default@SD_default@GG_default"
    - to specify the gamemode name you need also to the fine the gamemode name by editing the dvar mv_gametypenames
        - set mv_gametypenames "Team Deathmatch@Free for all@Search & Destroy@Gungame"
    
    mv_gametypefiles and mv_gametypenames must have the same number of @ symbols. The elements on mv_gametypefiles 
    are linked to the element in mv_gametypenames
 5) Copy the mapvote.gsc and put it %localappdata%\Plutonium\storage\iw5\scripts\
 6) Run the Server and have fun. Done!

## How to add custom maps to the mapvote list
  1) Create a new material file for the preview
  2) Add the preview iwi file in the mapvote.iwd
  3) Edit the case in the getmapname function in mapvote.gsc to add the conversion from mp_mapname to MAPNAME (Like mp_minecraft -> MINECRAFT)
  3) Rebuild the mod with zonetool
  4) Put the mod.ff and the mapvote.iwd in your mods/modfolder (Like mods/mapvote) in your %localappdata%\Plutonium\storage\iw5\mods\

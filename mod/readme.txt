----------------------------------------

      MODERN WARFARE III PLUTONIUM                 
          MULTIPLAYER MAPVOTE

        Developed by @DoktorSAS
        
----------------------------------------

 × Requirements
 × How to setup the mapvote step by step
 × How to add custom maps to the mapvote list

----------------------------------------

 × Requirements

   1) The script can only run on Server, It will not work in private games.
   2) Server must be hosted on Plutonium client, the script works only on Plutonium client.

----------------------------------------

 × How to setup the mapvote step by step

 1) Compile the mod with the zonetool 
 2) Copy the Compiled mod.ff file in your Directory %localappdata%\Plutonium\storage\iw5\mods\YOURMODNAME (Exemple: ..\mods\mapvote, ..\mods\funserver)
 3) Copy the Content of the mapvote.cfg in your .cfg (Exemple: server.cfg, dedicated_mp.cfg, dedicated.cfg, etc ) file that manages the Server.
 4) Edit the Dvars to setup the Server, many Dvars are only for Aesthetic Parameters.
    set the Dvar mv_maps to decide the maps that will be shown in mapvote, Example:
        set mv_maps "mp_favela mp_rust mp_terminal_cls mp_alpha mp_bootleg mp_bravo mp_carbon mp_dome mp_exchange mp_hardhat mp_interchange mp_lambeth mp_mogadishu mp_paris mp_plaza2 mp_radar mp_seatown mp_underground mp_village"
    set the dvar mv_enable to 1 if you want have it active on your server.
    If you want random gametypes you have to set the dvar mv_gametypefiles specifying the gametype .dsr file name. Exemple:
        set mv_gametypefiles "TDM_default@FFA_default@SD_default@GG_default"
    to specify the gamemode name you need also to the fine the gamemode name by editing the dvar mv_gametypenames
        set mv_gametypenames "Team Deathmatch@Free for all@Search & Destroy@Gungame"
    mv_gametypefiles and mv_gametypenames must have the same number of @ symbols. The elements on mv_gametypefiles 
    are linked to the element in mv_gametypenames
 5) Copy the mapvote.gsc and put it %localappdata%\Plutonium\storage\iw5\scripts\
 6) Run the Server and have fun. Done!

----------------------------------------

  × How to add custom maps to the mapvote list

  1) Create a new material file for the preview
  2) Add the preview iwi file in the mapvote.iwd
  3) Edit the case in the getmapname function in mapvote.gsc to add the conversion from mp_mapname to MAPNAME (Like mp_minecraft -> MINECRAFT)
  3) Rebuild the mod with zonetool
  4) Put the mod.ff and the mapvote.iwd in your mods/modfolder (Like mods/mapvote) in your %localappdata%\Plutonium\storage\iw5\mods\    

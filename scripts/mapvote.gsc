#include common_scripts\utility;
#include maps\mp\_utility;

/*
    Plutonium IW5 Mapvote
    Developed by DoktorSAS

    Special thanks to @KeyZHostHDCopy for the materials and the .iwi

    issue:
        Skidrow & Highrise missing materials

    How to add a custom map image:
    1) Create a new material file for the preview
    2) Add the preview iwi file in the mapvote.iwd
    3) Rebuild the mod with zonetool
    4) Put the mod.ff and the mapvote.iwd in your mods/modfolder (Like mods/mapvote) in your %localappdata%\Plutonium\storage\iw5\mods\    

*/
init()
{
    create_dvar("mv_enable", 1);
    if(!getDvarInt("mv_enable"))
        return;
    print("Mapvote loaded...");
    print("Developed by @DoktorSAS");

    level.map_winner = "";

    create_dvar("votetime", "00:00");
    create_dvar("mv_time", "20");
    // NO DLC
    create_dvar("mv_maps", "mp_favela mp_rust mp_terminal_cls mp_alpha mp_bootleg mp_bravo mp_carbon mp_dome mp_exchange mp_hardhat mp_interchange mp_lambeth mp_mogadishu mp_paris mp_plaza2 mp_radar mp_seatown mp_underground mp_village");
    
    // DLC ONLY
    //create_dvar("mv_maps", "mp_italy mp_overwatch mp_morningwood mp_park mp_meteora mp_cement mp_qadeem mp_restrepo_ss mp_hillside_ss mp_crosswalk_ss mp_burn_ss mp_six_ss mp_boardwalk mp_moab mp_roughneck mp_shipbreaker mp_nola");
    
    create_dvar("mv_gametypefiles", "TDM_default@FFA_default@SD_default@GG_default");
    create_dvar("mv_gametypenames", "Team Deathmatch@Free for all@Search & Destroy@Gungame");
    create_dvar("mv_randomgametypeenable", 1);

    create_dvar("map1", "none");
    create_dvar("map2", "none");
    create_dvar("map3", "none");
    create_dvar("map4", "none");
    create_dvar("map5", "none");
    create_dvar("map6", "none");

    create_dvar("mapgametype1", "unknown");
    create_dvar("mapgametype2", "unknown");
    create_dvar("mapgametype3", "unknown");
    create_dvar("mapgametype4", "unknown");
    create_dvar("mapgametype5", "unknown");
    create_dvar("mapgametype6", "unknown");

    create_dvar("mapname1", "none");
    create_dvar("mapname2", "none");
    create_dvar("mapname3", "none");
    create_dvar("mapname4", "none");
    create_dvar("mapname5", "none");
    create_dvar("mapname6", "none");

    create_dvar("mapvotes1", "0/18");
    create_dvar("mapvotes2", "0/18");
    create_dvar("mapvotes3", "0/18");
    create_dvar("mapvotes4", "0/18");
    create_dvar("mapvotes5", "0/18");
    create_dvar("mapvotes6", "0/18");

    
    level thread onPlayerConnect();
}

ArrayRemoveIndex(array, index)
{
    new_array = [];
    for(i = 0; i < array.size ;i++)
    {
        if(i != index)
            new_array[new_array.size] = array[i];
    }
    return new_array;
}

mapvote()
{
    // Choose random maps from the array
    maps = [];
    maps = strTok( getDvar("mv_maps"), " ");

    setAllClientsDvar("votetime", "00:00");
    value = "0/" + int(num_of_bots()/2+1);
     
    for(i = 1; i <= 6;i++)
    {
        dvar = "map" + i;
        dvarname = "mapname" + i;
        index = randomIntRange(0, maps.size);
        map = maps[ index ];
        map_preview = "preview_" + map;
        setAllClientsDvar( dvar, map_preview );
        setAllClientsDvar( dvarname, getmapname( map ) );
        maps = ArrayRemoveIndex(maps, index);

        // Reset UI votes
        dvar = "mapvotes" + i;
        setAllClientsDvar( dvar, value );
    }

    for(i = 0; i < level.players.size; i++)
    {
        if( !level.players[ i ] is_a_bot() )
        {
            level.players[ i ].vote = -1;
            level.players[ i ] closepopupMenu();
            level.players[ i ] closeInGameMenu();
            level.players[ i ] openpopupMenu("quickresponses"); 
            level.players[ i ] thread onMenuResponse();
        }
    }

    thread managevotes(); // Manage votes of each map on screen 
    thread managetime(); // Manage timer on screen
    gametypes = managegametypenames(); // Manage gametype on screen

    level waittill("mapvote_done", winner);
    if( !level.istimeexpired )
        wait 5;

    for(i = 0; i < level.players.size; i++)
    {
        if( !level.players[ i ] is_a_bot() )
        {
            level.players[ i ] closeMenu("quickresponses");
        }
    }
    dsr = "";
    if( gametypes.size > 0)
    {
        gametypefiles = strTok(getDvar("mv_gametypefiles"), "@");
        dsr = "dsr " + gametypefiles[ gametypes[int(winner)] ];
    }
    setDvar("sv_maprotation", dsr + " map " + mapimgtomapid( getDvar("map" + winner) ) );
    setDvar("sv_maprotationcurrent", dsr + " map " + mapimgtomapid( getDvar("map" + winner) ) );
}

getindexfomarray(array, value)
{
    for(i = 0; i < array.size; i++)
    {
        if( array[i] == value)
        {
            return i;
        }
    }
    return 0;
}
managegametypenames()
{
    level endon("game_ended");
    level endon("mapvote_done");
    setAllClientsDvar("mv_randomgametypeenable", getDvar("mv_randomgametypeenable") );
    if(getDvarInt("mv_randomgametypeenable") == 0)
        return [];

    gametypesnames = strTok(getDvar("mv_gametypenames"), "@");

    gametypes = [];
    gametypes[0] = "unknown";

    gametypes[1] = randomIntRange(0, gametypesnames.size-1);
    setAllClientsDvar("mapgametype1", gametypesnames[ gametypes[1] ] );
    gametypes[2] = randomIntRange(0, gametypesnames.size-1);
    setAllClientsDvar("mapgametype2", gametypesnames[ gametypes[2] ] );
    gametypes[3] = randomIntRange(0, gametypesnames.size-1);
    setAllClientsDvar("mapgametype3", gametypesnames[ gametypes[3] ] );
    gametypes[4] = randomIntRange(0, gametypesnames.size-1);
    setAllClientsDvar("mapgametype4", gametypesnames[ gametypes[4] ] );
    gametypes[5] = randomIntRange(0, gametypesnames.size-1);
    setAllClientsDvar("mapgametype5", gametypesnames[ gametypes[5] ] );
    gametypes[6] = randomIntRange(0, gametypesnames.size-1);
    setAllClientsDvar("mapgametype6", gametypesnames[ gametypes[6] ] );

    return gametypes;

}
setAllClientsDvar( dvar, value )
{
    setDvar(dvar, value);
    for(i = 0; i < level.players.size; i++)
        if( !level.players[ i ] is_a_bot() )
            level.players[ i ] setClientDvar( dvar, value );
}
mapimgtoname(img)
{
    array = strTok( img , "_");
    str = "";
    for(i = 1; i < array.size; i++)
    {
        if(str == "")
            str = array[ i ];
        else
            str = str + "_" + array[ i ];
    }
    return getmapname( str );
}
mapimgtomapid(img)
{
    array = strTok( img , "_");
    str = "";
    for(i = 1; i < array.size; i++)
    {
        if(str == "")
            str = array[ i ];
        else
            str = str + "_" + array[ i ];
    }
    return str;
}
getmostvotedmap()
{
    votes = [];
    votes[0] = 0;
    votes[1] = 0;
    votes[2] = 0;
    votes[3] = 0;
    votes[4] = 0;
    votes[5] = 0;
    votes[6] = 0;
    for(i = 0; i < level.players.size; i++)
    {
        if( !level.players[ i ] is_a_bot() && int(level.players[ i ].vote) > 0 )
        {
            votes[ int(level.players[ i ].vote) ]++;
        }
    }
    winner = 0;
    for(i = 0; i < votes.size; i++)
    {
        if(votes[i] > votes[winner])
        {
            winner = i;
        }
    }
    return winner;
}
managetime()
{
    level endon("game_ended");
    level endon("mapvote_done");
    time = getDvarInt("mv_time");
    level.istimeexpired = 0;

    for(;;)
    {
        if(time < 0)
        {
            level.istimeexpired = 1;
            level notify("mapvote_done", getmostvotedmap()+1);
            return;
        }
        
        minutes = 0;
        strtime = "";
        if(time >= 60)
        {
            minutes = int(time/60);
            if(minutes < 10)
            {
                strtime = "0" + minutes;
            }
            else
            {
                strtime = "" + minutes;
            }
        }
        else
            strtime = "00";
        
        strtime = strtime + ":";

        seconds = time-(minutes*60);
        if(seconds < 10)
        {
            if(seconds <= 5)
            {
                for(i = 0; i < level.players.size; i++)
                    if(!level.players[ i ] is_a_bot())
                        level.players[ i ] playSound( "ui_mp_timer_countdown" );
            }
            strtime = strtime + "0" + seconds;
        }
        else
        {
            strtime = strtime + "" + seconds;
        }  
        
        setAllClientsDvar("votetime", strtime);   
        
        wait 1;
        time--;
    }
}
managevotes()
{
    level endon("game_ended");

    for(;;)
    {
        for(i = 1; i <= 6;i++)
        {
            dvar = "mapvotes" + i;
            votes = 0;
            for(j = 0; j < level.players.size; j++)
            {
                if( !level.players[ j ] is_a_bot() && isDefined(level.players[ j ].vote) && level.players[ j ].vote == i-1 )
                    votes++;
            }
            value = votes + "/" + int(num_of_bots()/2+1);
            if( getDvar(dvar) != value )
                setAllClientsDvar( dvar, value );
            
            if(votes >= int(num_of_bots()/2+1))
            {
                setAllClientsDvar("votetime", "00:00");
                level notify("mapvote_done", getmostvotedmap()+1);
                return;
            }
        }
        wait 0.05; 
    }
}

main()
{
    replaceFunc(maps\mp\gametypes\_quickmessages::quickresponses, ::quickresponses);
    replacefunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::_waittillFinalKillcamDone);
}
quickresponses(response){}

_waittillFinalKillcamDone()
{
    if ( !IsDefined( level.finalKillCam_winner ) )
    {
        if(wasLastRound())
            mapvote();
        return 0;
    }
		
		
    level waittill( "final_killcam_done" );
    if(wasLastRound())
        mapvote();

    return 1;
}

onPlayerConnect()
{
    level endon("game_ended");
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

indextoint( str )
{
    a = strTok("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19", ",");
    for(i = 0; i < 18; i++)
        if(str == a[i])
            return i;
    return 0;
}
onMenuResponse()
{
    level endon("game_ended");
    level endon("mapvote_done");
    for(;;)
    {
        self waittill("menuresponse", menu, response);
        if( menu == "quickresponses")
        {
            self.vote = indextoint( response );
        }
    }
}
onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self waittill("spawned_player");
    }
}

// Birchy code
getmapname(map) {
    switch(map) {
    case "mp_alpha": return "LOCKDOWN";
    case "mp_bootleg": return "BOOTLEG";
    case "mp_bravo": return "MISSION";
    case "mp_carbon": return "CARBON";
    case "mp_dome": return "DOME";
    case "mp_exchange": return "DOWNTURN";
    case "mp_hardhat": return "HARDHAT";
    case "mp_interchange": return "INTERCHANGE";
    case "mp_lambeth": return "FALLEN";
    case "mp_mogadishu": return "BAKAARA";
    case "mp_paris": return "RESISTANCE";
    case "mp_plaza2": return "ARKADEN";
    case "mp_radar": return "OUTPOST";
    case "mp_seatown": return "SEATOWN";
    case "mp_underground": return "UNDERGROUND";
    case "mp_village": return "VILLAGE";
    case "mp_terminal_cls": return "TERMINAL";
    case "mp_rust": return "RUST";
    case "mp_highrise": return "HIGHRISE";
    case "mp_italy": return "PIAZZA";
    case "mp_park": return "LIBERATION";
    case "mp_overwatch": return "OVERWATCH";
    case "mp_morningwood": return "BLACK BOX";
    case "mp_meteora": return "SANCTUARY";
    case "mp_qadeem": return "OASIS";
    case "mp_restrepo_ss": return "LOOKOUT";
    case "mp_hillside_ss": return "GETAWAY";
    case "mp_courtyard_ss": return "EROSION";
    case "mp_aground_ss": return "AGROUND";
    case "mp_six_ss": return "VORTEX";
    case "mp_burn_ss": return "U-TURN";
    case "mp_crosswalk_ss": return "INTERSECTION";
    case "mp_shipbreaker": return "DECOMMISSION";
    case "mp_roughneck": return "OFF SHORE";
    case "mp_moab": return "GULCH";
    case "mp_boardwalk": return "BOARDWALK";
    case "mp_nola": return "PARISH";
    case "mp_favela": return "FAVELA";
    case "mp_nuked": return "NUKETOWN";
    case "mp_nightshift": return "SKIDROW";
    case "mp_cement": return "FOUNDATION";
    /*
        How to add a new map name translation:
        1) Add 1 case like
            case "mp_mapname": return "MAPNAME";
            like
            case "mp_minecraft": return "MINECRAFT":
    */
    default: return "UNKNOWN";
    }
}
// BotWarfare code https://github.com/ineedbots/piw5_bot_warfare
is_a_bot()
{
    assert( isDefined( self ) );
    assert( isPlayer( self ) );

    return ( ( isDefined( self.pers["isBot"] ) && self.pers["isBot"] ) || ( isDefined( self.pers["isBotWarfare"] ) && self.pers["isBotWarfare"] ) || isSubStr( self getguid() + "", "bot" ) );
}

num_of_bots()
{
    num = 0;
    for(i = 0; i < level.players.size; i++)
    {
        if(!level.players[ i ] is_a_bot())
            num++;
    }
    return num;
}

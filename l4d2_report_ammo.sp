#include <colors>
#include <l4d2_weapons>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name        = "[L4D2] Report Weapon Ammo Amount",
	author      = "ProjectSky",
	description = "Reporter Weapon ammo info",
	version     = "0.0.4",
	url         = "me@imsky.cc"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_ammo", report_ammo);
}

public Action report_ammo(int client, int args)
{
	char wName[16];
	if (client != 0 && IsClientInGame(client) && IsPlayerAlive(client))
	{
		int wepID = L4D2Wep_Identify(GetPlayerWeaponSlot(client, 0), IDENTIFY_HOLD);
		int team = GetClientTeam(client);
		int clip = L4D2Wep_GetPlayerClip(client);
		int ammo = L4D2Wep_GetPlayerAmmo(client);

		if (wepID == WEPID_NONE || team != 2)
		{
			CPrintToChat(client, "{default}<{olive}提示{default}> 当前状态无法使用该命令!");
			return;
		}

		switch (wepID)
		{
			case WEPID_SHOTGUN_CHROME : wName = "铁喷";
			case WEPID_PUMPSHOTGUN : wName = "木喷";
			case WEPID_SMG_SILENCED : wName = "SMG";
			case WEPID_SMG : wName = "UZI";
			case WEPID_SMG_MP5 : wName = "MP5";
			case WEPID_AUTOSHOTGUN : wName = "XM1014";
			case WEPID_SHOTGUN_SPAS : wName = "SPAS12";
			case WEPID_RIFLE_SG552 : wName = "SG552";
			case WEPID_RIFLE : wName = "M16";
			case WEPID_RIFLE_AK47 : wName = "AK47";
			case WEPID_RIFLE_DESERT : wName = "SCAR";
			case WEPID_HUNTING_RIFLE : wName = "M14";
			case WEPID_SNIPER_MILITARY : wName = "HK PSG-1";
			case WEPID_SNIPER_AWP : wName = "AWP";
			case WEPID_RIFLE_M60 : wName = "M60";
			case WEPID_GRENADE_LAUNCHER : wName = "M79";
			case WEPID_SNIPER_SCOUT : wName = "鸟狙";
			default: wName = "未定义";
		}
		
		for (int i = 1;i <= MaxClients; i++)
			if (IsClientInGame(i) && GetClientTeam(i) == team)
				CPrintToChat(i, "{olive}%N{default}：%s 剩余弹药 [{blue}%i/%i{default}]", client, wName, clip, ammo);
	}
}

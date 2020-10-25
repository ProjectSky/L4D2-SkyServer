#include <colors>
#include <l4d2_weapons>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name        = "[L4D2] Report Weapon Ammo Amount",
	author      = "ProjectSky",
	description = "Reporter Weapon ammo info",
	version     = "0.0.3",
	url         = "me@imsky.cc"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_ammo", report_ammo);
}

public Action report_ammo(int client, int args)
{
	char wName[64];
	if (client != 0 && IsClientInGame(client) && IsPlayerAlive(client))
	{
		int wepID = L4D2Wep_Identify(GetPlayerWeaponSlot(client, 0), IDENTIFY_HOLD);
		int team = GetClientTeam(client);
		int clip = L4D2Wep_GetPlayerClip(client);
		int ammo = L4D2Wep_GetPlayerAmmo(client);

		if (wepID == WEPID_NONE)
		{
			CPrintToChat(client, "{default}<{olive}提示{default}> 当前未持有主武器!");
			return;
		}

		if (team == 3)
		{
			CPrintToChat(client, "{default}<{olive}提示{default}> 特感无法使用该命令!");
			return;
		}

		switch (wepID)
		{
			case WEPID_SHOTGUN_CHROME : wName = "铁喷";
			case WEPID_PUMPSHOTGUN : wName = "木喷";
			case WEPID_SMG_SILENCED : wName = "Smg";
			case WEPID_SMG : wName = "Uzi";
			case WEPID_SMG_MP5 : wName = "Mp5";
			case WEPID_SNIPER_SCOUT : wName = "鸟狙";
			default: wName = "未定义";
		}
		
		for (int i = 1;i <= MaxClients; i++)
			if (IsClientInGame(i) && GetClientTeam(i) == team)
				CPrintToChat(i, "{olive}%N{default}：%s 剩余弹药 [{blue}%i/%i{default}]", client, wName, clip, ammo);
	}
}

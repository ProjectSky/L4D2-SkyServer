#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <l4d2_kill_mvp>
#include <l4d2_skill_detect>

public Plugin myinfo =
{
	name = "[L4D2] Test Plugins",
	description = "Test",
	author = "ProjectSky",
	version = "0.0.2",
	url = "https://github.com/ProjectSky/L4D2-SkyServer"
}

public void OnPluginStart()
{
	RegAdminCmd("sm_t", Command_Test, ADMFLAG_BAN);
}

Action Command_Test(int client, int args)
{
	char sWeaponName[32], sDistanceUnit[16];
	int si = MVP_GetMVPClient(MVP_SI);
	int ci = MVP_GetMVPClient(MVP_CI);
	int ff = MVP_GetMVPClient(MVP_FF);

	L4D2_FormatWeaponName(client, sWeaponName, sizeof(sWeaponName));
	L4D2_FormatDistanceUnit(sDistanceUnit, sizeof(sDistanceUnit));
	PrintToChatAll("MVP_GetMVPClient: SI: %N, CI: %N, FF: %N", si, ci, ff);
	PrintToChatAll("L4D2_FormatWeaponName: %s", sWeaponName);
	PrintToChatAll("L4D2_FormatDistanceUnit: %s", sDistanceUnit);

	return Plugin_Handled;
}

public void OnTongueCut(int survivor, int smoker, int meleeid, float distance)
{
	PrintToChatAll("OnTongueCut: %N -> %N meleeid: %d, distance: %.1f", survivor, smoker, meleeid, distance);
}
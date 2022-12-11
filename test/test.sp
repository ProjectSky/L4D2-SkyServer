#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <l4d2_kill_mvp>

public Plugin myinfo =
{
	name = "[L4D2] Test Plugins",
	description = "Test",
	author = "ProjectSky",
	version = "0.0.1",
	url = "https://github.com/ProjectSky/L4D2-SkyServer"
}

public void OnPluginStart()
{
	RegAdminCmd("sm_t", Command_Test, ADMFLAG_BAN);
}

Action Command_Test(int client, int args)
{
	int si = MVP_GetMVPClient(MvpType_SI);
	int ci = MVP_GetMVPClient(MvpType_CI);
	int ff = MVP_GetMVPClient(MvpType_FF);

	PrintToChatAll("SI: %N, CI: %N, FF: %N", si, ci, ff);
	return Plugin_Handled;
}
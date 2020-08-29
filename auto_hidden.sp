#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

Handle g_cvar_tags;
Handle g_CheckTimer;
ConVar MaxPlayer;
ConVar MinPlayer;

public Plugin myinfo =
{
	name = "[Any] Auto Hidden",
	author = "ProjectSky",
	description = "Auto add hidden tag to servers",
	version = "0.0.4",
	url = "me@imsky.cc"
};

public void OnPluginStart()
{
	MaxPlayer = CreateConVar("l4d2_hide_server_maxplayer", "6", "需要多少玩家触发隐藏", FCVAR_NOTIFY);
	MinPlayer = CreateConVar("l4d2_show_server_minplayer", "0", "需要多少玩家取消隐藏", FCVAR_NOTIFY);
	g_cvar_tags = FindConVar("sv_tags");
}

public void OnMapStart()
{
	CreateTimer(3.0, autohideManagerStart);
}

public Action autohideManagerStart(Handle timer)
{
	g_CheckTimer = CreateTimer(10.0, CheckPlayers, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	delete g_CheckTimer;
}

public Action CheckPlayers(Handle timer)
{
	char sBuffer[64];
	GetConVarString(g_cvar_tags, sBuffer, sizeof(sBuffer));
	if (GetPlayerCount() >= GetConVarInt(MaxPlayer))
	{
		if (StrContains(sBuffer, "hidden", false) != -1) return;
		SetConVarString(g_cvar_tags, "hidden,sky,empty");
		PrintToServer("玩家人数已达 %i 人, 启用隐藏", GetPlayerCount());
	}
	else if (GetPlayerCount() == GetConVarInt(MinPlayer))
	{
		if (StrContains(sBuffer, "hidden", false) == -1) return;
		SetConVarString(g_cvar_tags, "sky,empty");
		PrintToServer("玩家人数已达 %i 人, 禁用隐藏", GetPlayerCount());
	}
}

public int GetPlayerCount()
{
		int players = 0;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && !IsFakeClient(i))
				players++;
		}
		return players;
}
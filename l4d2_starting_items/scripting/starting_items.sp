#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <left4dhooks>

#define TEAM_SURVIVOR 2

enum
{
	HEALTH_FIRST_AID_KIT = (1 << 0),
	HEALTH_DEFIBRILLATOR = (1 << 1),
	HEALTH_PAIN_PILLS = (1 << 2),
	HEALTH_ADRENALINE = (1 << 3),
	THROWABLE_PIPE_BOMB = (1 << 4),
	THROWABLE_MOLOTOV = (1 << 5),
	THROWABLE_VOMITJAR = (1 << 6)
}

public Plugin myinfo =
{
	name = "[L4D2] Starting Items",
	author = "CircleSquared, Jacob, ProjectSky",
	description = "Gives health items and throwables to survivors at the start of each round",
	version = "1.3",
	url = "none"
}

static ConVar 
g_hItemType;

static int 
g_iItemFlags;

static bool
g_bReadyUpAvailable = false;

public void OnPluginStart()
{
	g_hItemType = CreateConVar("starting_item_flags", "0", "Item flags to give on leaving the saferoom (1: Kit, 2: Defib, 4: Pills, 8: Adren, 16: Pipebomb, 32: Molotov, 64: Bile)", FCVAR_NONE);

	GetCvars();
	g_hItemType.AddChangeHook(view_as<ConVarChanged>(GetCvars));
}

void GetCvars()
{
	g_iItemFlags = g_hItemType.IntValue;
}

public void OnAllPluginsLoaded()
{
	g_bReadyUpAvailable = LibraryExists("readyup");
}

public void OnLibraryRemoved(const char[] name)
{
	if (strcmp(name, "readyup") == 0) g_bReadyUpAvailable = false;
}

public void OnLibraryAdded(const char[] name)
{
	if (strcmp(name, "readyup") == 0) g_bReadyUpAvailable = true;
}

public void OnRoundIsLive()
{
	int i, maxplayers = MaxClients;
	for (i = 1; i <= maxplayers; i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == TEAM_SURVIVOR)
		{
			GiveItems(i);
		}
	}
}

public Action L4D_OnFirstSurvivorLeftSafeArea()
{
	if (!g_bReadyUpAvailable)
	{
		int i, maxplayers = MaxClients;
		for (i = 1; i <= maxplayers; i++)
		{
			if (IsClientInGame(i) && GetClientTeam(i) == TEAM_SURVIVOR)
			{
				GiveItems(i);
			}
		}
	}
}

void GiveItems(int client)
{
	if (g_iItemFlags)
	{
		if (g_iItemFlags & HEALTH_FIRST_AID_KIT)
		{
			L4D2_RunScript("PlayerInstanceFromIndex(%d).GiveItem(\"%s\")", client, "first_aid_kit");
		}
		else if (g_iItemFlags & HEALTH_DEFIBRILLATOR)
		{
			L4D2_RunScript("PlayerInstanceFromIndex(%d).GiveItem(\"%s\")", client, "defibrillator");
		}
		if (g_iItemFlags & HEALTH_PAIN_PILLS)
		{
			L4D2_RunScript("PlayerInstanceFromIndex(%d).GiveItem(\"%s\")", client, "pain_pills");
		}
		else if (g_iItemFlags & HEALTH_ADRENALINE)
		{
			L4D2_RunScript("PlayerInstanceFromIndex(%d).GiveItem(\"%s\")", client, "adrenaline");
		}
		if (g_iItemFlags & THROWABLE_PIPE_BOMB)
		{
			L4D2_RunScript("PlayerInstanceFromIndex(%d).GiveItem(\"%s\")", client, "pipe_bomb");
		}
		else if (g_iItemFlags & THROWABLE_MOLOTOV)
		{
			L4D2_RunScript("PlayerInstanceFromIndex(%d).GiveItem(\"%s\")", client, "molotov");
		}
		else if (g_iItemFlags & THROWABLE_VOMITJAR)
		{
			L4D2_RunScript("PlayerInstanceFromIndex(%d).GiveItem(\"%s\")", client, "vomitjar");
		}
	}
}

void L4D2_RunScript(char[] code, any ...)
{
	char buffer[1006];
	VFormat(buffer, sizeof(buffer), code, 2);
	L4D2_ExecVScriptCode(buffer);
}
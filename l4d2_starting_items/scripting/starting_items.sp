#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#define TEAM_SURVIVOR 2

enum
{
	FIRST_AID_KIT = 1,
	DEFIBRILLATOR,
	PAIN_PILLS,
	ADRENALINE,
	PIPE_BOMB,
	MOLOTOV,
	VOMITJAR ,
}

enum
{
	THROW = 2,
	KIT,
	PILL,
}

public Plugin myinfo =
{
	name = "[L4D2] Starting Items",
	author = "CircleSquared, Jacob, ProjectSky",
	description = "Gives health items and throwables to survivors at the start of each round",
	version = "1.6",
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
	g_hItemType = CreateConVar("starting_item_flags", "0", "Item flags to give on leaving the saferoom (0: Disable, 1: Kit, 2: Defib, 3: Pills, 4: Adren, 5: Pipebomb, 6: Molotov, 7: Bile)", FCVAR_NONE, true, 0.0, true, 7.0);

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
	if (!g_iItemFlags) return;

	int i, maxplayers = MaxClients;
	for (i = 1; i <= maxplayers; i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == TEAM_SURVIVOR && IsPlayerAlive(i))
		{
			switch (g_iItemFlags)
			{
				case 1,2 : GiveItems(i, KIT);
				case 3,4 : GiveItems(i, PILL);
				case 5,6,7 : GiveItems(i, THROW);
			}
		}
	}
}

public Action L4D_OnFirstSurvivorLeftSafeArea()
{
	if (!g_iItemFlags) return;

	else if (!g_bReadyUpAvailable)
	{
		OnRoundIsLive();
	}
}

void GiveItems(int client, int type)
{
	int items = GetPlayerWeaponSlot(client, type);
	if (items == -1)
	{
		int flags = GetCommandFlags("give");
		SetCommandFlags("give", flags & ~FCVAR_CHEAT);
		switch (g_iItemFlags)
		{
			case FIRST_AID_KIT : FakeClientCommand(client, "give first_aid_kit");
			case DEFIBRILLATOR : FakeClientCommand(client, "give defibrillator");
			case PAIN_PILLS : FakeClientCommand(client, "give pain_pills");
			case ADRENALINE : FakeClientCommand(client, "give adrenaline");
			case PIPE_BOMB : FakeClientCommand(client, "give pipe_bomb");
			case MOLOTOV : FakeClientCommand(client, "give molotov");
			case VOMITJAR : FakeClientCommand(client, "give vomitjar");
		}
		SetCommandFlags("give", flags);
	}
}

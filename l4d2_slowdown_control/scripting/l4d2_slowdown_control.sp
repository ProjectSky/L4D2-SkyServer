#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdkhooks>
#include <left4dhooks>

#define SURVIVOR_SPEED 220.0

static ConVar 
g_hGunFireSI,
g_hGunFireTank,
g_hWaterSlow,
g_hSurvivorLimp;

static bool
g_bLateLoad,
g_bGunFireSI,
g_bGunFireTank,
g_bWaterSlow;

static int
g_iSurvivorlimp;

public Plugin myinfo =
{
	name = "[L4D2] Water Slowdown Control",
	author = "ProjectSky",
	version = "0.0.4",
	description = "Manages gunfire & water slowdown",
	url = "me@imsky.cc"
}

public APLRes AskPluginLoad2(Handle plugin, bool late, char[] error, int err_max)
{
	g_bLateLoad = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	g_hGunFireSI = CreateConVar("l4d2_slowdown_si", "0", "Manages slowdown from gunfire for SI", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_hGunFireTank = CreateConVar("l4d2_slowdown_tank", "0", "Manages slowdown from gunfire for Tank", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_hWaterSlow = CreateConVar("l4d2_slowdown_water_tank_alive", "1", "Manages survivor slowdown in the water during Tank fights", FCVAR_NOTIFY, true, 0.0, true, 1.0);

	g_hSurvivorLimp = FindConVar("survivor_limp_health");

	cvarChanged(null, "", "");
	g_hGunFireSI.AddChangeHook(cvarChanged);
	g_hGunFireTank.AddChangeHook(cvarChanged);
	g_hWaterSlow.AddChangeHook(cvarChanged);
	g_hSurvivorLimp.AddChangeHook(cvarChanged);

	if (g_bLateLoad) 
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				OnClientPutInServer(i);
			}
		}
	}
}

void cvarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bGunFireSI = g_hGunFireSI.BoolValue;
	g_bGunFireTank = g_hGunFireTank.BoolValue;
	g_bWaterSlow = g_hWaterSlow.BoolValue;
	g_iSurvivorlimp = g_hSurvivorLimp.IntValue;
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
}

void OnTakeDamagePost(int victim, int attacker, int inflictor, float damage, int damageType)
{
	if (IsValidClient(victim) && GetClientTeam(victim) == L4D_TEAM_INFECTED)
	{
		int zclass;
		zclass = GetEntProp(victim, Prop_Send, "m_zombieClass");
		
		if (zclass != L4D2_ZOMBIE_CLASS_TANK && !g_bGunFireSI)
		{
			SetEntPropFloat(victim, Prop_Send, "m_flVelocityModifier", 1.0);
		}
		else if (zclass == L4D2_ZOMBIE_CLASS_TANK && !g_bGunFireTank)
		{
			SetEntPropFloat(victim, Prop_Send, "m_flVelocityModifier", 1.0);
		}
	}
}

public Action L4D_OnGetRunTopSpeed(int client, float &retVal)
{
	if (g_bWaterSlow || !L4D2_IsTankInPlay()) return Plugin_Continue;

	if (IsValidClient(client) && GetClientTeam(client) == L4D_TEAM_SURVIVOR)
	{
		static bool IsInWater, IsAdreff;
		IsInWater = !!(GetEntityFlags(client) & FL_INWATER);
		IsAdreff = !!GetEntProp(client, Prop_Send, "m_bAdrenalineActive");

		if (IsAdreff) return Plugin_Continue;

		if (IsInWater && !IsLimping(client))
		{
			retVal = SURVIVOR_SPEED;
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client);
}

bool IsLimping(int client)
{
	return GetEntProp(client, Prop_Send, "m_iHealth") + L4D_GetTempHealth(client) < g_iSurvivorlimp;
}
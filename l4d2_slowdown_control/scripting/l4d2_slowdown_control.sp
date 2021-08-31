#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdkhooks>
#include <left4dhooks>

#define SURVIVOR_SPEED 220.0
#define TEAM_SURVIVOR 2
#define TEAM_INFECTED 3
#define ZC_TANK 8

static ConVar 
cvar_gunfiresi,
cvar_gunfiretank,
cvar_waterslow,
cvar_pillsdecay,
cvar_survivorlimp;

static bool
g_bLateLoad,
g_bGunfiresi,
g_bGunfiretank,
g_bwaterslow;

static int
g_iSurvivorlimp;

static float
g_fPillsdecay;

public Plugin myinfo =
{
	name = "[L4D2] Slowdown Control",
	author = "ProjectSky",
	version = "0.0.3",
	description = "Manages gunfire water slowdown",
	url = "me@imsky.cc"
}

public APLRes AskPluginLoad2(Handle plugin, bool late, char[] error, int errMax) 
{
	g_bLateLoad = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	cvar_gunfiresi = CreateConVar("l4d2_slowdown_si", "0", "Manages slowdown from gunfire for SI", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	cvar_gunfiretank = CreateConVar("l4d2_slowdown_tank", "0", "Manages slowdown from gunfire for the Tank", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	cvar_waterslow = CreateConVar("l4d2_slowdown_water", "1", "Manages survivor slowdown in the water during Tank fights", FCVAR_NOTIFY, true, 0.0, true, 1.0);

	cvar_pillsdecay = FindConVar("pain_pills_decay_rate");
	cvar_survivorlimp = FindConVar("survivor_limp_health");

	GetCvars();
	cvar_gunfiresi.AddChangeHook(view_as<ConVarChanged>(GetCvars));
	cvar_gunfiretank.AddChangeHook(view_as<ConVarChanged>(GetCvars));
	cvar_waterslow.AddChangeHook(view_as<ConVarChanged>(GetCvars));
	cvar_pillsdecay.AddChangeHook(view_as<ConVarChanged>(GetCvars));
	cvar_survivorlimp.AddChangeHook(view_as<ConVarChanged>(GetCvars));

	if (g_bLateLoad) 
	{
		int i, maxplayers = MaxClients;
		for (i = 1; i <= maxplayers; i++) 
		{
			if (!IsClientInGame(i)) continue;

			SDKHook(i, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
		}
	}
}

void GetCvars()
{
	g_bGunfiresi = cvar_gunfiresi.BoolValue;
	g_bGunfiretank = cvar_gunfiretank.BoolValue;
	g_bwaterslow = cvar_waterslow.BoolValue;
	g_fPillsdecay = cvar_pillsdecay.FloatValue;
	g_iSurvivorlimp = cvar_survivorlimp.IntValue;
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
}

public void OnTakeDamagePost(int victim, int attacker, int inflictor, float damage, int damageType)
{
	if (IsValidClient(victim) && GetClientTeam(victim) == TEAM_INFECTED)
	{
		int zclass = GetEntProp(victim, Prop_Send, "m_zombieClass");
		
		if (zclass != ZC_TANK && !g_bGunfiresi)
		{
			SetEntPropFloat(victim, Prop_Send, "m_flVelocityModifier", 1.0);
		}
		else if (zclass == ZC_TANK && !g_bGunfiretank)
		{
			SetEntPropFloat(victim, Prop_Send, "m_flVelocityModifier", 1.0);
		}
	}
}

public Action L4D_OnGetRunTopSpeed(int client, float &retVal)
{
	if (g_bwaterslow) return Plugin_Continue;
	if (IsValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		bool InWater = (GetEntityFlags(client) & FL_INWATER) ? true : false;
		bool Adreff = GetEntProp(client, Prop_Send, "m_bAdrenalineActive") ? true : false;
		if (Adreff) return Plugin_Continue;

		if (InWater && !IsLimping(client))
		{
			if (L4D2_IsTankInPlay())
			{
				retVal = SURVIVOR_SPEED;
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}

stock bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client);
}

bool IsLimping(int client)
{
	return GetSurvivorPermanentHealth(client) + GetSurvivorTempHealth(client) < g_iSurvivorlimp;
}

int GetSurvivorPermanentHealth(int client)
{
	return GetEntProp(client, Prop_Send, "m_iHealth");
}

int GetSurvivorTempHealth(int client)
{
	int temphp = RoundToCeil(GetEntPropFloat(client, Prop_Send, "m_healthBuffer") - ((GetGameTime() - GetEntPropFloat(client, Prop_Send, "m_healthBufferTime")) * g_fPillsdecay)) - 1;
	return temphp > 0 ? temphp : 0;
}
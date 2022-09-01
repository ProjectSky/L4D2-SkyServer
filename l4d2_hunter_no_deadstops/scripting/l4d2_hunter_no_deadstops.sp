#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <left4dhooks>

ConVar
g_hAllowHunterShoved,
g_hHunterShovedTankAlive,
g_hHunterGroundGodframes;

bool
g_bAllowHunterShoved,
g_bHunterShovedTankAlive,
g_bIsPouncing[MAXPLAYERS+1] = {true, ...};

float
g_fHunterGroundGodframes;

public Plugin myinfo = 
{
	name = "[L4D2] No Hunter Deadstops (optimized version)",
	author = "ProjectSky",
	description = "Prevents deadstops but allows m2s on standing hunters",
	version = "0.0.2",
	url = "me@imsky.cc"
}

public void OnPluginStart()
{
	g_hAllowHunterShoved = CreateConVar("sm_allow_hunter_shoved", "1", "是否可以推飞行状态的Hunter", FCVAR_NONE, true, 0.0, true, 1.0);
	g_hHunterShovedTankAlive = CreateConVar("sm_allow_hunter_shoved_tank_alive", "0", "是否可以在坦克存活时推飞行状态的Hunter", FCVAR_NONE, true, 0.0, true, 1.0);
	g_hHunterGroundGodframes = CreateConVar("sm_hunter_ground_godframes", "0.75", "hunter落地后无法被推开的时间", FCVAR_NONE, true, 0.0, true, 10.0);

	GetCvars();

	g_hAllowHunterShoved.AddChangeHook(cvarChanged);
	g_hHunterShovedTankAlive.AddChangeHook(cvarChanged);
	g_hHunterGroundGodframes.AddChangeHook(cvarChanged);

	HookEvent("ability_use", Event_AbilityUse);
}

void cvarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetCvars();
}

void GetCvars()
{
	g_bAllowHunterShoved = g_hAllowHunterShoved.BoolValue;
	g_bHunterShovedTankAlive = g_hHunterShovedTankAlive.BoolValue;
	g_fHunterGroundGodframes = g_hHunterGroundGodframes.FloatValue;
}

public Action L4D_OnShovedBySurvivor(int client, int victim, const float vecDir[3])
{
	return ShoveHandler(victim);
}

public Action L4D2_OnEntityShoved(int client, int entity, int weapon, float vecDir[3], bool bIsHighPounce)
{
	return ShoveHandler(entity);
}

Action ShoveHandler(int victim)
{
	if (!IsValidClient(victim) || !IsHunter(victim)) return Plugin_Continue;

	else if (g_bAllowHunterShoved && g_bHunterShovedTankAlive) return Plugin_Continue;

	else if (HasTarget(victim) || !g_bIsPouncing[victim]) return Plugin_Continue;

	else if (!g_bAllowHunterShoved) return Plugin_Handled;

	else if (!g_bHunterShovedTankAlive && L4D2_IsTankInPlay()) return Plugin_Handled;

	return Plugin_Continue;
} 

void Event_AbilityUse(Event event, const char[] name, bool dontBroadcast)
{
	if (g_bAllowHunterShoved && g_bHunterShovedTankAlive) return;
	
	int client = GetClientOfUserId(event.GetInt("userid"));

	if (!IsValidClient(client)) return;

	static char abilityName[16];
	event.GetString("ability", abilityName, sizeof(abilityName));

	if (strcmp(abilityName, "ability_lunge") == 0)
	{
		g_bIsPouncing[client] = true;
		CreateTimer(g_fHunterGroundGodframes, Timer_GroundedCheck, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
}

Action Timer_GroundedCheck(Handle timer, any client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client) || GetEntityFlags(client) & FL_ONGROUND)
	{
		g_bIsPouncing[client] = false;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

bool HasTarget(int hunter)
{
	return L4D_GetVictimHunter(hunter) > 0;
}

bool IsHunter(int hunter)
{
	return GetEntProp(hunter, Prop_Send, "m_zombieClass") == L4D2_ZOMBIE_CLASS_HUNTER;
}

bool IsValidClient(int client, int team = L4D_TEAM_INFECTED)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == team;
}
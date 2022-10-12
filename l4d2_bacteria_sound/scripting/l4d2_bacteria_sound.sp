#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <left4dhooks>

#define BACTERIA_WORLD 1
#define BACTERIA_CLIENT 2

// ssssssssssssssss
static const char g_sBacteriaSounds[][] =
{
	"music/bacteria/smokerbacteria.wav",
	"music/bacteria/smokerbacterias.wav",
	"music/bacteria/boomerbacteria.wav",
	"music/bacteria/boomerbacterias.wav",
	"music/bacteria/hunterbacteria.wav",
	"music/bacteria/hunterbacterias.wav",
	"music/bacteria/spitterbacteria.wav",
	"music/bacteria/spitterbacterias.wav",
	"music/bacteria/jockeybacteria.wav",
	"music/bacteria/jockeybacterias.wav",
	"music/bacteria/chargerbacteria.wav",
	"music/bacteria/chargerbacterias.wav"
};

ConVar
g_hBacteriaSoundFlag,
g_hBacteriaSoundVolume;

float
g_fBacteriaSoundVolume;

int
g_iBacteriaSoundFlag;

public Plugin myinfo =
{
	name = "[L4D2] Bacteria Sounds (Rework)",
	author = "ProjectSky",
	description = "Restored special infected bacteria sounds in versus.",
	version = "0.0.1",
	url = "me@imsky.cc"
}

public void OnPluginStart()
{
	g_hBacteriaSoundFlag = CreateConVar("sm_bacteria_sound_flag", "1", "special infected bacteria sound flag [0=OFF 1=SOUND_FROM_PLAYER 2=SOUND_FROM_WORLD]", FCVAR_NONE, true, 0.0, true, 2.0);
	g_hBacteriaSoundVolume = CreateConVar("sm_bacteria_sound_volume", "0.5", "Special infected bacteria sounds volume", FCVAR_NONE, true, 0.0, true, 1.0);

	cvarChanged(null, "", "");
	g_hBacteriaSoundVolume.AddChangeHook(cvarChanged);
	g_hBacteriaSoundFlag.AddChangeHook(cvarChanged);

	HookEvent("player_spawn", Event_PlayerSpawn);
}

void cvarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_fBacteriaSoundVolume = g_hBacteriaSoundVolume.FloatValue;
	g_iBacteriaSoundFlag = g_hBacteriaSoundFlag.IntValue;
}

public void OnMapStart()
{
	if (!g_iBacteriaSoundFlag) return;

	for (int i = 0; i < sizeof(g_sBacteriaSounds); i++)
	{
		PrecacheSound(g_sBacteriaSounds[i], true);
	}
}

void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_iBacteriaSoundFlag) return;

	int client = GetClientOfUserId(event.GetInt("userid"));

	if (client < 1 || !IsClientInGame(client) || GetClientTeam(client) != L4D_TEAM_INFECTED) return;

	L4D_OnMaterializeFromGhost(client);
}

// AI not trigger this forwards
public void L4D_OnMaterializeFromGhost(int client)
{
	if (!g_iBacteriaSoundFlag) return;

	int zombieClass = GetEntProp(client, Prop_Send, "m_zombieClass");
	int rndPick;

	switch (zombieClass)
	{
		case L4D2_ZOMBIE_CLASS_SMOKER: rndPick = GetRandomInt(0, 1);
		case L4D2_ZOMBIE_CLASS_BOOMER: rndPick = GetRandomInt(2, 3);
		case L4D2_ZOMBIE_CLASS_HUNTER: rndPick = GetRandomInt(4, 5);
		case L4D2_ZOMBIE_CLASS_SPITTER: rndPick = GetRandomInt(6, 7);
		case L4D2_ZOMBIE_CLASS_JOCKEY: rndPick = GetRandomInt(8, 9);
		case L4D2_ZOMBIE_CLASS_CHARGER: rndPick = GetRandomInt(10, 11);
	}

	// only survivor can hear
	int[] clients = new int[MaxClients];
	int total;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) == L4D_TEAM_SURVIVOR)
		{
			clients[total++] = i;
		}
	}

	if (total)
	{
		switch (g_iBacteriaSoundFlag)
		{
			case BACTERIA_WORLD: EmitSound(clients, total, g_sBacteriaSounds[rndPick], _, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, g_fBacteriaSoundVolume);
			case BACTERIA_CLIENT: EmitSound(clients, total, g_sBacteriaSounds[rndPick], client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, g_fBacteriaSoundVolume);
		}
	}
}
#pragma semicolon 1
#pragma newdecls required

#include <sdktools>
#include <colors>

#define BENCHMARK 0

#define TEAM_SURVIVOR 2
#define PRIMARY_WEAPON 0

static const char g_sWeaponNames[][][] =
{
	{"smg", "UZI"},
	{"smg_silenced", "SMG"},
	{"smg_mp5", "MP5"},
	{"shotgun_chrome", "铁喷"},
	{"pumpshotgun", "木喷"},
	{"autoshotgun", "XM1014"},
	{"shotgun_spas", "SPAS12"},
	{"rifle", "M16"},
	{"hunting_rifle", "M14"},
	{"rifle_ak47", "AK47"},
	{"rifle_sg552", "SG552"},
	{"rifle_desert", "SCAR"},
	{"rifle_m60", "M60"},
	{"sniper_military", "G3SG1"},
	{"sniper_awp", "AWP"},
	{"sniper_scout", "鸟狙"},
	{"grenade_launcher", "榴弹发射器"},
};

#if BENCHMARK
	#include <profiler>
	Profiler g_profiler;
#endif

int
g_iAmmoOffset;

public Plugin myinfo =
{
	name = "[L4D2] Report remaining ammo",
	author = "ProjectSky",
	description = "report primary weapon remaining ammo",
	version = "0.0.6",
	url = "me@imsky.cc"
}

public void OnPluginStart()
{
	RegConsoleCmd("sm_ammo", Command_ReportAmmo);

	g_iAmmoOffset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
}

Action Command_ReportAmmo(int client, int args)
{
	if (client && IsClientInGame(client))
	{
		static char wName[32];
		static int clip, ammo, weapon;
		weapon = GetPlayerWeaponSlot(client, PRIMARY_WEAPON);

		if (!IsValidEntity(weapon) || GetClientTeam(client) != TEAM_SURVIVOR || !IsPlayerAlive(client))
		{
			CPrintToChat(client, "{default}<{olive}提示{default}> 当前状态无法使用该命令!");
			return Plugin_Continue;
		}

		clip = GetWeaponClip(weapon);
		ammo = GetWeaponAmmo(client, weapon);

		#if BENCHMARK
			g_profiler = new Profiler();
			g_profiler.Start();
		#endif
		FormatWeaponName(wName, sizeof(wName), weapon);

		#if BENCHMARK
			g_profiler.Stop();
			PrintToChatAll("执行耗时: %f", g_profiler.Time);
		#endif
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && GetClientTeam(i) == GetClientTeam(client))
			{
				if (clip || ammo)
				{
					CPrintToChat(i, "{blue}%N{default} : %s 剩余弹药 [{olive}%i/%i{default}]", client, wName, clip, ammo);
				}
				else
				{
					CPrintToChat(i, "{blue}%N{default} : %s 没子弹了!!", client, wName);
				}
			}
		}
	}
	return Plugin_Handled;
}

int FormatWeaponName(char[] buffer, int maxlen, int weapon)
{
	GetEdictClassname(weapon, buffer, maxlen);

	for (int i = 0; i < sizeof(g_sWeaponNames); i++)
	{
		if (strcmp(buffer[7], g_sWeaponNames[i][0]) == 0)
		{
			strcopy(buffer, maxlen, g_sWeaponNames[i][1]);
		}
	}
}

int GetWeaponClip(int weapon)
{
	return GetEntProp(weapon, Prop_Send, "m_iClip1");
}

int GetWeaponAmmo(int client, int weapon)
{
	int offset = g_iAmmoOffset + (GetEntProp(weapon, Prop_Data, "m_iPrimaryAmmoType") * 4);

	return GetEntData(client, offset);
}
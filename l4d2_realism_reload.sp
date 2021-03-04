#pragma newdecls required
#pragma semicolon 1

#include <sdkhooks>
#include <l4d2_weapons>

ConVar cvar_realismreload;

public Plugin myinfo =
{
	name = "[L4D2] Realism Reload",
	author = "ProjectSky",
	description = "换弹时清空弹匣内未打完的子弹",
	version = "0.0.1",
	url = "me@imsky.cc"
}

public void OnPluginStart()
{
	cvar_realismreload = CreateConVar("l4d2_realism_reload", "1", "是否启用插件", 0, true, 0.0, true, 1.0);
}

public void OnEntityCreated(int entity, const char[] classname)
{
	SDKHookEx(entity, SDKHook_Reload, Hooks_PlayerReload);
}

public void Hooks_PlayerReload(int weapon)
{
	int client = GetEntPropEnt(weapon, Prop_Data, "m_hOwnerEntity");

	if (IsValidClient(client) && IsValidWeapon(client) && cvar_realismreload.BoolValue)
	{
		int clip = L4D2Wep_GetPlayerAmmo(client);
		int ammo = GetEntProp(weapon, Prop_Send, "m_iClip1");
		DataPack dp = new DataPack();
		dp.WriteCell(client);
		dp.WriteCell(clip);
		dp.WriteCell(ammo);
		dp.WriteCell(weapon);
		RequestFrame(RequestFrameClip, dp);
	}
}

public void RequestFrameClip(DataPack dp)
{ 
	dp.Reset();
	int client = dp.ReadCell();
	int clip = dp.ReadCell();
	int ammo = dp.ReadCell();
	int weapon = dp.ReadCell();
	L4D2Wep_SetPlayerAmmo(client, clip);
	//if (ammo == 1)
	//	SetEntProp(weapon, Prop_Send, "m_iClip1", 51);
	delete dp;
}

stock bool IsValidWeapon(int client)
{
	int wepID = L4D2Wep_Identify(GetPlayerWeaponSlot(client, 0), IDENTIFY_HOLD);
	switch (wepID)
	{
		case WEPID_SMG, WEPID_SMG_SILENCED, WEPID_SMG_MP5, WEPID_SNIPER_SCOUT : return true;
		default : return false;
	}
}

stock bool IsValidClient(int client)
{
	if (client <= 0 || client > MaxClients || !IsClientInGame(client) || IsFakeClient(client) || GetClientTeam(client) != 2) return false;
	return true;
}
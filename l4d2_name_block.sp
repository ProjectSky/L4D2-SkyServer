#pragma semicolon 1
#pragma newdecls required

#include <regex>

Regex g_Number;
ConVar g_hPlugEnable;

public Plugin myinfo =
{
	name = "L4D2 Block Number Name",
	author = "ProjectSky",
	description = "L4D2 Block player number name join servers",
	version = "0.0.3",
	url = "me@imsky.cc"
}

public void OnPluginStart()
{
	g_hPlugEnable = CreateConVar("l4d2_nameblock_enable", "0", " 启用/关闭 禁止数字昵称功能", FCVAR_NOTIFY);
	g_Number = new Regex("^[0-9]*$");
}

public void OnClientConnected(int client)
{
	if (!GetConVarBool(g_hPlugEnable))
	{
		return;
	}

	char buffer[MAX_NAME_LENGTH];
	GetClientName(client, buffer, sizeof(buffer));

	if (MatchRegex(g_Number, buffer) != 0)
	{
		KickPlayer(client);
	}
}

public void OnClientSettingsChanged(int client)
{
	if (!GetConVarBool(g_hPlugEnable) || !IsClientInGame(client) || IsFakeClient(client))
	{
		return;
	}

	char buffer[MAX_NAME_LENGTH];
	if(!GetClientName(client, buffer, sizeof(buffer)))
	{
		return;
	}
		
	if (MatchRegex(g_Number, buffer) != 0)
	{
		KickPlayer(client);
	}
}

public void KickPlayer(int client)
{
	KickClient(client, "本服禁止纯数字昵称，请更改昵称后加入！");
	LogAction(-1, client, "服务器禁止纯数字昵称，请更改昵称后加入！%L", client);
}

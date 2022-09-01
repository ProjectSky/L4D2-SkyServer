#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <left4dhooks>

#define GAMEDATA "l4d2_saferoom_detect"

#define BOTH_SAFEROOM 0
#define START_SAFEROOM 1
#define END_SAFEROOM 2

#define VERSION "0.0.1"

Handle
g_hSDKGetFlowPercentForPosition;

public Plugin myinfo = 
{
	name = "[L4D2] SafeRoom Detection",
	author = "ProjectSky",
	description = "checks whether a entity/player is in start or end saferoom",
	version = VERSION,
	url = "me@imsky.cc"
}

public void OnPluginStart()
{
	GameData hGameData = new GameData(GAMEDATA);

	if (hGameData == null)
		SetFailState("Cannot load %s gamedata", GAMEDATA);

	StartPrepSDKCall(SDKCall_Static);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "Script_GetFlowPercentForPosition");
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByValue);
	PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_Plain);

	g_hSDKGetFlowPercentForPosition = EndPrepSDKCall();
	if (g_hSDKGetFlowPercentForPosition == null)
		SetFailState("Failed to create SDKCall: Script_GetFlowPercentForPosition");

	delete hGameData;

	CreateConVar("l4d2_saferoom_detect_version", VERSION, "Plugin version", FCVAR_NONE | FCVAR_DONTRECORD);
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("L4D2_IsEntityInStartSaferoom", Native_IsEntityInStartSaferoom);
	CreateNative("L4D2_IsEntityInEndSaferoom", Native_IsEntityInEndSaferoom);
	CreateNative("L4D2_IsEntityInSaferoom", Native_IsEntityInSaferoom);

	RegPluginLibrary("l4d2_saferoom_detect");
	return APLRes_Success;
}

int Native_IsEntityInStartSaferoom(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	return IsEntityInSafeRoom(entity, START_SAFEROOM);
}

int Native_IsEntityInEndSaferoom(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	return IsEntityInSafeRoom(entity, END_SAFEROOM);
}

int Native_IsEntityInSaferoom(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	return IsEntityInSafeRoom(entity, BOTH_SAFEROOM);
}

/**
 * Checks whether or not an entity is in safe room
 * 
 * @param entity    Entity to check
 * @param flag     	saferoom flag
 * @return          true if entity is in safe room, false otherwise.
 * @notes           some maps like Blood Harvest finale and The Passing finale have CHECKPOINT inside a FINALE marked area.
 */
bool IsEntityInSafeRoom(int entity, int flag = BOTH_SAFEROOM)
{
	float fPos[3];
	GetEntPropVector(entity, Prop_Send, "m_vecOrigin", fPos);

	Address area = view_as<Address>(L4D_GetNearestNavArea(fPos));

	if (area == Address_Null) return false;

	int spawnattributes = L4D_GetNavArea_SpawnAttributes(area);

	float fPercent = SDKCall(g_hSDKGetFlowPercentForPosition, fPos, false);

	switch (flag)
	{
		case BOTH_SAFEROOM : return (spawnattributes & NAV_SPAWN_CHECKPOINT) != 0;
		case START_SAFEROOM : return (spawnattributes & NAV_SPAWN_CHECKPOINT) != 0 && fPercent <= 50.0;
		case END_SAFEROOM : return (spawnattributes & NAV_SPAWN_CHECKPOINT) != 0 && fPercent >= 50.0;
	}

	return false;
}
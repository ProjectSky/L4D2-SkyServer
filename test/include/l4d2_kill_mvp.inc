#if defined _kill_mvp_included
#endinput
#endif
#define _kill_mvp_included

// ====================================================================================================
// "L4D2 Survivor MVP notification" by "ProjectSky"
//	Version: 0.1.2
// ====================================================================================================

enum HitGroup
{
	HITGROUP_GENERIC,
	HITGROUP_HEAD,
	HITGROUP_CHEST,
	HITGROUP_STOMACH,
	HITGROUP_LEFTARM,
	HITGROUP_RIGHTARM,
	HITGROUP_LEFTLEG,
	HITGROUP_RIGHTLEG
}

enum MvpType
{
	MvpType_SI,
	MvpType_CI,
	MvpType_FF
}

/**
 *  Get the amount of friendly damage
 *
 *  @param  client    client index
 */
native int MVP_GetFFDamage(int client);

/**
 *  Get the number to kill common infected
 *
 *  @param  client    client index
 */
native int MVP_GetKillCI(int client);

/**
 *  Get the number of headshots to kill common infected
 *
 *  @param  client    client index
 */
native int MVP_GetHeadShotCI(int client);

/**
 * Get the number of melee to kill common infected
 *
 *  @param  client    client index
 */
native int MVP_GetMeleeKillCI(int client);

/**
 *  Get the number of kills for special infected
 *
 *  @param  client    client index
 */
native int MVP_GetKillSI(int client);

/**
 *  Get the number of headshot kills for special infected
 *
 *  @param  client    client index
 */
native int MVP_GetHeadShotSI(int client);

/**
 *  Get the number of bullets shoot
 *
 *  @param  client    client index
 * 	@return bullet shoot
 */
native int MVP_GetBulletShoot(int client);

/**
 *  Get the number of bullets hit
 *
 *  @param  client    client index
 * 	@return bullet hit
 */
native int MVP_GetBulletHit(int client);

/**
 *  Get the client of accuracy
 *
 *  @param  client    client index
 * 	@return player accuracy
 */
native float MVP_GetAccuracy(int client);

/**
 *  Get the number of bullets hit group statistics
 *
 *  @param  client    client index
 *  @param  HitGroup  hitgroup type
 *  @return hitgroup statistics
 */
native int MVP_GetHitGroupStats(int client, HitGroup hitgroup);

/**
 *  Get the client index by current MVP, default return MvpType_SI
 *
 *  @param MvpType_SI	Kill special infected
 *  @param MvpType_CI	Kill infected
 *  @param MvpType_FF	Friendly fire dmg
 *  @return mvp client index
 */
native int MVP_GetMVPClient(MvpType type = MvpType_SI);

public SharedPlugin __pl_kill_mvp =
{
	name = "kill_mvp",
	file = "l4d2_kill_mvp.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
}

#if !defined REQUIRE_PLUGIN
public void __pl_kill_mvp_SetNTVOptional()
{
	MarkNativeAsOptional("MVP_GetFFDamage");
	MarkNativeAsOptional("MVP_GetKillCI");
	MarkNativeAsOptional("MVP_GetHeadShotCI");
	MarkNativeAsOptional("MVP_GetMeleeKillCI");
	MarkNativeAsOptional("MVP_GetKillSI");
	MarkNativeAsOptional("MVP_GetHeadShotSI");
	MarkNativeAsOptional("MVP_GetBulletShoot");
	MarkNativeAsOptional("MVP_GetBulletHit");
	MarkNativeAsOptional("MVP_GetAccuracy");
	MarkNativeAsOptional("MVP_GetHitGroupStats");
	MarkNativeAsOptional("MVP_GetMVPClient");
}
#endif
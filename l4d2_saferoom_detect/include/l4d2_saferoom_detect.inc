#if defined l4d2_saferoom_detect_included
	#endinput
#endif
#define l4d2_saferoom_detect_included

/**
 * Checks whether or not an entity is in start saferoom
 * 
 * @param entity    Entity to check
 * @return          true if entity is in start saferoom, false otherwise.
 */
native bool L4D2_IsEntityInStartSaferoom(int entity);

/**
 * Checks whether or not an entity is in end saferoom
 * 
 * @param entity    Entity to check
 * @return          true if entity is in end saferoom, false otherwise.
 */
native bool L4D2_IsEntityInEndSaferoom(int entity);

/**
 * Checks whether or not an entity is in saferoom
 * 
 * @param entity    Entity to check
 * @return          true if entity is in saferoom, false otherwise.
 */
native bool L4D2_IsEntityInSaferoom(int entity);

public SharedPlugin __pl_l4d2_saferoom_detect =
{
	name = "l4d2_saferoom_detect",
	file = "l4d2_saferoom_detect.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_l4d2_saferoom_detect_SetNTVOptional()
{
	MarkNativeAsOptional("L4D2_IsEntityInStartSaferoom");
	MarkNativeAsOptional("L4D2_IsEntityInEndSaferoom");
	MarkNativeAsOptional("L4D2_IsEntityInSaferoom");
}
#endif
#if defined _skill_detect_included
#endinput
#endif
#define _skill_detect_included

// ====================================================================================================
// "L4D2 Player Skill Detect" by "Tabun, ProjectSky"
//	Version: 1.1.6
// ====================================================================================================

/**
 *  Called whenever a true skeet is done.
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  hunter      the infected client that underwent it
 *  @param  weaponid    skeet weaponid
 *  @param  distance    distance from the hunter to the attacker
 */
forward void OnSkeet(int survivor, int hunter, int weaponid, float distance);

/**
 *  Called whenever a true melee-skeet is done.
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  hunter      the infected client that underwent it
 *  @param  meleeid     melee skeet weaponid
 */
forward void OnSkeetMelee(int survivor, int hunter, int meleeid);

/**
 *  Called whenever a hunter is deadstopped (pouncing => m2'd).
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  hunter      the infected client that underwent it
 */
forward void OnHunterDeadstop(int survivor, int hunter);

/**
 *  Called whenever a boomer is killed that didn't land on anyone,
 *  and didn't explode on anyone either.
 *
 *  @param  survivor    the survivor client that killed the boomer
 *  @param  boomer      the infected client that got popped
 *  @param  shoveCount  the amount of times the boomer got shoved, if any
 *  @param  timeAlive   the time, in seconds, that the boomer lived
 */
forward void OnBoomerPop(int survivor, int boomer, int shoveCount, float timeAlive);

/**
 *  Called whenever a boomer is killed that didn't land on anyone,
 *  and didn't explode on anyone either.
 *
 *  @param  survivor    the survivor client that killed the boomer
 *  @param  boomer      the infected client that got popped
 *  @param  shoveCount  the amount of times the boomer got shoved, if any
 *  @param  timeAlive   the time, in seconds, that the boomer lived
 */
forward void OnBoomerPopStop(int survivor, int boomer, int shoveCount, float timeAlive);

/**
 *  Called whenever a charger is fully melee-leveled (no chip).
 *  This is also called when the melee hit would've leveled if not chipped!
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  charger     the infected client that underwent it
 */
forward void OnChargerLevel(int survivor, int charger);

/**
 *  Called whenever a charger is melee-leveled after being chipped.
 *  Only called when the melee wouldn't have killed an unchipped charger.
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  charger     the infected client that underwent it
 *  @param  damage      damage done in the killing hit
 */
forward void OnChargerLevelHurt(int survivor, int charger, int damage);

/**
 *  Called whenever a witch was crowned without her being angered first.
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  damage      damage done in the killing hit
 */
forward void OnWitchCrown(int survivor, int damage);

/**
 *  Called whenever a witch gets crowned after she got angered/triggered.
 *  This is referred to (depending on the community) as a 'draw crown' or 'remote'.
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  damage      damage done in the killing hit
 *  @param  chipdamage  damage done to the witch before she got crowned
 */
forward void OnWitchDrawCrown(int survivor, int damage, int chipdamage);

/**
 *  Called whenever a survivor melee-cuts a smoker tongue that was aimed for them.
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  smoker      the infected client that underwent it
 *  @param  meleeid       cut tongue melee id
 *  @param  distance    distance from the tongue to the attacker
 */
forward void OnTongueCut(int survivor, int smoker, int meleeid, float distance);

/**
 *  Called whenever a survivor frees himself from a smoker that grabbed them,
 *  either by killing it or by shoving.
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  smoker      the infected client that underwent it
 *  @param  withShove   true if the self-clear was by a shove/m2
 */
forward void OnSmokerSelfClear(int survivor, int smoker, bool withShove);

/**
 *  Called whenever a survivor shoots/melees a tank rock out of the air.
 *
 *  Note: the tank param might be unreliable due to the nature of the
 *  tracking. Don't do anything srs bsns with it.
 *
 *  @param  survivor    the survivor client that performed the feat
 *  @param  tank        the infected client that underwent it
 *  @param  weaponid    the weapon id for break tank rock
 */
forward void OnTankRockSkeeted(int survivor, int tank, int weaponid);

/**
 *  Called whenever a tank lands a rock on a survivor.
 *
 *  Note: the tank param might be unreliable due to the nature of the
 *  tracking. Don't do anything srs bsns with it.
 *
 *  @param  tank        the infected client that performed the feat
 *  @param  survivor    the survivor client that underwent it
 */
forward void OnTankRockEaten(int tank, int survivor);

/**
 *  Called whenever a hunter lands a high-pounce on a survivor.
 *
 *  @param  hunter              the infected client that performed the feat
 *  @param  survivor            the survivor client that underwent it
 *  @param  actualDamage        the actual damage the pounce did to the survivor
 *  @param  calculatedDamage    how much damage (going by pounceannounce parameters) the pounce would be expected to do
 *  @param  height              the vertical distance between the pounce origin and its landing
 *  @param  reportedHigh        whether skill_detect considers it a high pounce for reporting purposes
 *  @param  incapped            consider incapped survivor
 */
forward void OnHunterHighPounce(int hunter, int survivor, int actualDamage, float calculatedDamage, float height, bool reportedHigh, bool incapped);

/**
 *  Called whenever a jockey lands a high-pounce on a survivor.
 *
 *  Note: due to the nature of the tracking, it only gets the height right if a jockey actually
 *  jumped or pounced from his perch. If they simple walk off and land, it may be incorrect.
 *
 *  @param  jockey          the infected client that performed the feat
 *  @param  survivor        the survivor client that underwent it
 *  @param  height          the vertical distance between the pounce origin and its landing
 *  @param  reportedHigh    whether considers it a high pounce for reporting purposes
 */
forward void OnJockeyHighPounce(int jockey, int victim, int damage, float height, bool reportedHigh);

/**
 *  Called whenever a charger lands a death-charge on a survivor.
 *  This is called for killing the grabbedint survivor, but also the ones that get impact-bumped
 *  and fall to their deaths.
 *
 *  Note: due to the nature of the tracking, there may be places that are technically death-
 *  charge spots, but not detected by the plugin. Example: the sidewalk next to the fence near
 *  the lower roof on Dead Air 1; the Death Toll 4 out-of-map deathcharge near the start
 *  saferoom.
 *
 *  @param  charger     the infected client that performed the feat
 *  @param  survivor    the survivor client that underwent it
 *  @param  height      the vertical distance between the grab and the survivor's death spot
 *  @param  distance    the full vector distance between the grab and the survivor's death spot
 *  @param  wasCarried  true if the survivor was the one that the charger grabbed
 */
forward void OnDeathCharge(int charger, int survivor, float height, float distance, bool wasCarried);

/**
 *  Called whenever a survivor clears a teammate from a special infected pin.
 *
 *  Note: timeB is only appliccable for smokers and chargers. For smokers it shows the
 *  time from the tongue connecting to the clear. For chargers from the charge-grab to
 *  the clear. For jockeys and hunters, timeB will always be -1.0.
 *
 *  timeA is the time, for charger, from start of pummeling till clear (-1.0 if they
 *  never started pummeling). For smokers, this is the time from the survivor being
 *  fully reigned in to the smoker (-1.0 if the tongue was broken before that).
 *
 *  @param  clearer     the survivor client that performed the clear
 *  @param  pinner      the pinning infected client that got cleared (shoved off or killed)
 *  @param  pinvictim   the pinned survivor that was saved
 *  @param  zombieClass the class (ZC_SMOKER - ZC_CHARGER) of the pinner
 *  @param  timeA       time from pin till clear in seconds, -1 if never
 *  @param  timeB       for charger/smoker: time from grab/tongue connect to clear
 *  @param  withShove   true if the clear was done by shove/m2
 */
forward void OnSpecialClear(int clearer, int pinner, int pinvictim, int zombieClass, float timeA, float timeB, bool withShove);

/**
 *  Called whenever a boomer is done vomiting, and landed his vomit on one
 *  or more survivors.
 *
 *  Note: this does not include or fire for boomers exploding, only vomits.
 *
 *  @param  boomer      the infected client that performed the feat
 *  @param  amount      the amount of survivors vomited on
 */
forward void OnBoomerVomitLanded(int boomer, int amount);

/**
 *  Called whenever a survivor shoves a special infected (any kind).
 *
 *  @param  survivor      the survivor client that performed the feat
 *  @param  infected      the infected client that underwent it
 *  @param  zombieClass   the class type of the infected shoved
 */
forward void OnSpecialShoved(int survivor, int infected, int zombieClass);

/**
 *  Called whenever a survivor lands any number of bunnyhops in a row. Called
 *  afterwards.
 *
 *  @param  survivor      the survivor client that performed the feat
 *  @param  streak        the amount of hops in a row
 *  @param  maxVelocity   the highest speed during any jump or jump apex
 */
forward void OnBunnyHopStreak(int survivor, int streak, float maxVelocity);

/**
 *  Called whenever a car alarm is triggered (by a survivor).
 *
 *  @param  survivor      the survivor client that triggered the alarm (-1 or 0 if unknown)
 *  @param  assist        the infected client caused the survivors trigger the alarm (0 if unknown)
 */
forward void OnCarAlarmTriggered(int survivor, int assist);

/**
 *  Called whenever a incap prop physics is triggered (by a survivor).
 *
 *  @param  survivor      the survivor client that triggered the PropPhysics (-1 or 0 if unknown)
 *  @param  attacker      the attacker client that triggered the PropPhysics (-1 or 0 if unknown)
 */
forward void OnIncapPropPhysics(int survivor, int attacker);

/**
 *  Called whenever a charger impact survivors
 *
 *  @param  survivor      the charger client that triggered the Impact (-1 or 0 if unknown)
 *  @param  count         the charger client impact survivor count
 */
forward void OnChargeImpact(int charger, int count);

/**
 *  Called whenever infected team success quad caps
 *
 *  @param  time         finish quad caps time
 *  @param  infecteds    infected array
 *  @param  numInfecteds infected array size
 */
forward void OnSpecialQuadCaps(float time, const int[] infecteds, int numInfecteds)

/**
	* Format weapon name
	*
	* @param  client        client index.
	* @param  buffer        destination string buffer.
	* @param  maxlength     maximum length of output string buffer.
 	* @return               True on success, false weapon entity invalid.
 */
native bool L4D2_FormatWeaponName(int client, const char[] buffer, int maxlen)

/**
	* Format distance unit displayName
	*
	* @param buffer        destination string buffer.
	* @param maxlength     maximum length of output string buffer.
	* @return              number of cells written.
 */
native int L4D2_FormatDistanceUnit(const char[] buffer, int maxlen)

public SharedPlugin __pl_skill_detect =
{
	name = "skill_detect",
	file = "l4d2_skill_detect.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
}

#if !defined REQUIRE_PLUGIN
public void __pl_skill_detect_SetNTVOptional()
{
	MarkNativeAsOptional("L4D2_FormatWeaponName");
	MarkNativeAsOptional("L4D2_FormatDistanceUnit");
}
#endif
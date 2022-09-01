### l4d2_saferoom_detect

#### 插件说明
* 检测实体/玩家是否位于开始/结束安全屋
* 通过CHECKPOINT属性来判断是否位于安全区域内，比旧版使用mapinfo来判断更高效，但是在某些地图上可能不准确

#### 可用参数
* ```l4d2_saferoom_detect_version``` 插件版本

#### 可用命令
* 无

#### Native

``` c
/**
 * Checks whether or not an entity is in start saferoom
 * 
 * @param entity    entity to check
 * @return          true if entity is in start saferoom, false otherwise.
 */
bool L4D2_IsEntityInStartSaferoom(int entity)

/**
 * Checks whether or not an entity is in end saferoom
 * 
 * @param entity    entity to check
 * @return          true if entity is in end saferoom, false otherwise.
 */
bool L4D2_IsEntityInEndSaferoom(int entity)

/**
 * Checks whether or not an entity is in saferoom
 * 
 * @param entity    entity to check
 * @return          true if entity is in saferoom, false otherwise.
 */
bool L4D2_IsEntityInSaferoom(int entity)
```
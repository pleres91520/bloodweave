local MyCharacterMod = RegisterMod("Gabriel Character Mod", 1)

local gabriel3Type = Isaac.GetPlayerTypeByName("Gabriel3", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel3_hair.anm2") -- Exact path, with the "resources" folder as the root
local stolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/gabriel_stoles.anm2") -- Exact path, with the "resources" folder as the root

function MyCharacterMod:GiveCostumesOnInit(player)
    if player:GetPlayerType() ~= gabriel3Type then
        return -- End the function early. The below code doesn't run, as long as the player isn't Gabriel3.
    end

    player:AddNullCostume(hairCostume)
end

MyCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, MyCharacterMod.GiveCostumesOnInit)

--------------------------------------------------------------------------------------------------

local game = Game() -- We only need to get the game object once. It's good forever!
local DAMAGE_REDUCTION = 0.5 --初始值3.5（此值越大，伤害越低）
local LUCK_ADDITION = 0 --初始值0
local SPEED_ADDITION = 0 --初始值1
local TEARS_REDUCTION = 5 --初始值2.73（此值越大，射速越低）
local VELOCITY_ADDITION = 0.7 --初始值1（弹速）
function MyCharacterMod:HandleStartingStats(player, flag)
    if player:GetPlayerType() ~= gabriel3Type then
        return -- End the function early. The below code doesn't run, as long as the player isn't Gabriel3.
    end

    if flag == CacheFlag.CACHE_DAMAGE then
        -- Every time the game reevaluates how much damage the player should have, it will reduce the player's damage by DAMAGE_REDUCTION, which is 1.5
        player.Damage = player.Damage - DAMAGE_REDUCTION
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, false) then --持有长子权时，增加伤害
				player.Damage = player.Damage + 4
			end
    end
    if flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + LUCK_ADDITION
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, false) then --持有长子权时，增加幸运
				player.Luck = player.Luck + 3 
			end
    end
    if flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + SPEED_ADDITION
    end
	if flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay + TEARS_REDUCTION
    end
    if flag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed - VELOCITY_ADDITION
    end
end

MyCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, MyCharacterMod.HandleStartingStats)


--------------------------------------------------------------------------------------------------

_G.PLAYER_PED = PlayerPedId()

while not Util.IsPlayerSpawned() do
    Citizen.Wait(500)
end

Citizen.CreateThread(function()
    while true do
        _G.PLAYER_PED = PlayerPedId()
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.Blips.enabled do
        Citizen.Wait(5000)
        for _, player in ipairs(GetActivePlayers()) do
            local playerPed = GetPlayerPed(player)
            if DoesBlipExist(GetBlipFromEntity(playerPed)) then
                TriggerServerEvent("flow:417szjzm1goy", "Player Blips [C1]", false)
                return
            end
        end
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.ExplosiveBullet.enabled do
        Citizen.Wait(2000)
        local function IsIllegalDamage(type)
            local hashes = ClientConfig.Modules.ExplosiveBullet.blacklistedTypes
            for i = 1, #hashes do
                if hashes[i] == type then
                    return true
                end
            end
            return false
        end

        local damageType = GetWeaponDamageType(GetSelectedPedWeapon(_G.PLAYER_PED))
        if IsIllegalDamage(damageType) then
            TriggerServerEvent("flow:417szjzm1goy", "Illegal Damage Type [C1]", false, {
                damageType = damageType
             })
            return
        end
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.Vision.enabled do
        Citizen.Wait(5000)
        if not IsPedInAnyHeli(_G.PLAYER_PED) then
            if GetUsingnightvision() or GetUsingseethrough() then
                TriggerServerEvent("flow:417szjzm1goy", "Vision [C1]", false)
                return
            end
        end
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.Speed.enabled do
        Citizen.Wait(2000)
        local speed = GetEntitySpeed(_G.PLAYER_PED)

        if not IsPedInAnyVehicle(_G.PLAYER_PED, true) and not IsPedOnVehicle(_G.PLAYER_PED) and not IsPedRagdoll(_G.PLAYER_PED) then
            local maxSpeed = 14.0
            if IsEntityInAir(_G.PLAYER_PED) then
                if IsPedFalling(_G.PLAYER_PED) or IsPedInParachuteFreeFall(_G.PLAYER_PED) or GetPedParachuteState(_G.PLAYER_PED) > 0 then
                    maxSpeed = 90.0
                end
            else
                if IsPedSwimmingUnderWater(_G.PLAYER_PED) or IsPedSwimming(_G.PLAYER_PED) then
                    maxSpeed = 18.0
                else
                    if IsPedSprinting(_G.PLAYER_PED) or IsPedWalking(_G.PLAYER_PED) then
                        maxSpeed = 10.0
                    end
                end
            end

            if speed > maxSpeed then
                TriggerServerEvent("flow:417szjzm1goy", "Speed [C1]", false, {
                    speed = speed,
                    maxSpeed = maxSpeed
                 })
                return
            end
        end
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.Spectator.enabled do
        Citizen.Wait(5000)
        if NetworkIsInSpectatorMode() then
            TriggerServerEvent("flow:417szjzm1goy", "Spectator [C1]", false)
            return
        end
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.TinyPed.enabled do
        Citizen.Wait(10000)
        if GetPedConfigFlag(_G.PLAYER_PED, 223, true) then
            TriggerServerEvent("flow:417szjzm1goy", "TinyPed [C1]", false)
            return
        end
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.FreeCam.enabled do
        Citizen.Wait(10000)
        local function IsValidSituation()
            if IsPlayerCamControlDisabled() or (not IsGameplayCamRendering() and not ClientConfig.Modules.FreeCam.ignoreCamera) then
                return false
            end
            return true
        end

        local contextTable = {
            [0] = 18.0,
            [1] = 28.0,
            [2] = 20.0,
            [3] = 30.0,
            [4] = 30.0,
            [5] = 30.0,
            [6] = 30.0,
            [7] = 20.0
         }

        local camcoords, contextValue = (GetEntityCoords(_G.PLAYER_PED) - GetFinalRenderedCamCoord()), contextTable[GetCamActiveViewModeContext()]
        if IsValidSituation() and ((camcoords.x > contextValue) or (camcoords.y > contextValue) or (camcoords.z > contextValue) or (camcoords.x < -contextValue) or (camcoords.y < -contextValue) or (camcoords.z < -contextValue)) then
            TriggerServerEvent("flow:417szjzm1goy", "FreeCam [C1]", false)
            return
        end
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.Ragdoll.enabled do
        Citizen.Wait(10000)
        local function CanPlayerRagdoll()
            if CanPedRagdoll(_G.PLAYER_PED) ~= 1 and not IsPedInAnyVehicle(_G.PLAYER_PED, true) and not IsEntityDead(_G.PLAYER_PED) and not IsPedJumpingOutOfVehicle(_G.PLAYER_PED) and not IsPedJacking(_G.PLAYER_PED) and not IsPedRagdoll(_G.PLAYER_PED) then
                return false
            end
            return true
        end
        if not CanPlayerRagdoll() then
            TriggerServerEvent("flow:417szjzm1goy", "Ragdoll [C1]", false)
            return
        end
    end
end)

Citizen.CreateThread(function()
    local function legitVehicleClass(vehicle)
        local class = GetVehicleClass(vehicle)
        local forbiddenClasses = ClientConfig.Modules.NoClip.vehicleClasses
        for i = 1, #forbiddenClasses do
            if class == forbiddenClasses[i] then
                return true
            end
        end
        return false
    end

    local count = 0
    while ClientConfig.Modules.NoClip.enabled do
        Citizen.Wait(500)
        local playerCoord = GetEntityCoords(_G.PLAYER_PED)
        local origin = vec3(playerCoord.x, playerCoord.y, playerCoord.z + 0.5)
        local vehicle = GetVehiclePedIsIn(_G.PLAYER_PED)

        if not IsPedFalling(_G.PLAYER_PED) and not IsPedRagdoll(_G.PLAYER_PED) and not IsPedDeadOrDying(_G.PLAYER_PED) and not IsPedSwimming(_G.PLAYER_PED) and not IsPedSwimmingUnderWater(_G.PLAYER_PED) and not IsPedInParachuteFreeFall(_G.PLAYER_PED) and GetPedParachuteState(_G.PLAYER_PED) == -1 and not legitVehicleClass(vehicle) and not IsPedClimbing(_G.PLAYER_PED) and GetEntityHeightAboveGround(_G.PLAYER_PED) > 8.0 and not IsEntityAttachedToAnyPed(_G.PLAYER_PED) then
            if not (IsPedInAnyVehicle(_G.PLAYER_PED) and not IsVehicleOnAllWheels(vehicle)) then
                local rays = {
                    [1] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, 0.0, 0.0, -8.0),
                    [2] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, 8.0, 0.0, -8.0),
                    [3] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, 8.0, 8.0, -8.0),
                    [4] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, -8.0, 0.0, -8.0),
                    [5] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, -8.0, -8.0, -8.0),
                    [6] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, -8.0, 8.0, -8.0),
                    [7] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, 0.0, 8.0, -8.0),
                    [8] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, 0.0, -8.0, -8.0),
                    [9] = GetOffsetFromEntityInWorldCoords(_G.PLAYER_PED, 8.0, -8.0, -8.0)
                 }

                for i = 1, #rays do
                    local testRay = StartShapeTestRay(origin, rays[i], 4294967295, _G.PLAYER_PED, 7)
                    local _, hit, _, _, _, _ = GetShapeTestResultEx(testRay)

                    if hit == 0 then
                        count = count + 1
                    else
                        count = 0
                    end
                end
                if count >= (ClientConfig.Modules.NoClip.failedHits * #rays) then
                    TriggerServerEvent("flow:417szjzm1goy", "NoClip [C1]", false, {
                        hits = count,
                        maxHits = (ClientConfig.Modules.NoClip.failedHits * #rays)
                     })
                    return
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while ClientConfig.Modules.Godmode.enabled do
        Citizen.Wait(15000)
        local rVal = ClientConfig.Modules.Godmode.decrement
        local modified = (GetEntityHealth(_G.PLAYER_PED) - rVal)

        SetEntityHealth(_G.PLAYER_PED, modified)
        Citizen.Wait(ClientConfig.Modules.Godmode.wait)
        local postHealth = GetEntityHealth(_G.PLAYER_PED)
        if postHealth > modified and postHealth > 0 and not IsPedDeadOrDying(_G.PLAYER_PED) then
            TriggerServerEvent("flow:417szjzm1goy", "Godmode [C1]", false)
        else
            SetEntityHealth(_G.PLAYER_PED, postHealth + rVal)
        end

        local pedHealth, pedArmor = GetEntityHealth(_G.PLAYER_PED), GetPedArmour(_G.PLAYER_PED)
        if pedHealth > ClientConfig.Modules.Godmode.maxHealth or pedArmor > ClientConfig.Modules.Godmode.maxArmor then
            TriggerServerEvent("flow:417szjzm1goy", "Godmode [C2]", false, {
                health = pedHealth,
                maxHealth = ClientConfig.Modules.Godmode.maxHealth,
                armor = pedArmor,
                maxArmor = ClientConfig.Modules.Godmode.maxArmor
             })
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15000)
        local resourceList = {}
        for i = 0, GetNumResources() - 1 do
            resourceList[i + 1] = GetResourceByFindIndex(i)
        end
        TriggerServerEvent("flow:t98b173hbp66", resourceList)
    end
end)

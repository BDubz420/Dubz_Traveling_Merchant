-- dubz_traveling_merchant_config.lua
-- Global configuration for the traveling merchant system

DubzTravelingMerchant = DubzTravelingMerchant or {}
DubzTravelingMerchant.Config = DubzTravelingMerchant.Config or {}

local CFG = DubzTravelingMerchant.Config

-- Data file for custom spawn locations created with the admin tool commands.
CFG.SpawnFile = "dubz_traveling_merchant/spawns.json"

-- Default spawn locations can be pre-seeded here. The admin tool will append
-- to the file above so you can ship defaults and let servers override them.
CFG.SpawnLocations = {
    -- Example (uncomment and adjust):
    -- { pos = Vector(-2312.5, 1420.7, 128.0), ang = Angle(0, 90, 0) },
}

CFG.Merchant = {
    Models = {
        "models/Humans/Group02/male_02.mdl",
        "models/Humans/Group02/male_06.mdl",
        "models/Humans/Group02/female_03.mdl",
        "models/Humans/Group02/female_06.mdl",
    },
    Names = {
        "Cassidy", "Rowan", "Morgan", "Sloan", "Devin",
        "Riley", "Jordan", "Quinn", "Avery", "Ellis"
    },

    -- How often the merchant should try to relocate to a new random spawn
    -- after being removed (seconds). Set to 0 to disable automatic respawn
    -- and spawn it manually with the entity tool.
    RespawnDelay = 120,
}

-- Items that the merchant will sell. Add as many as you like.
-- Supported types:
--   weapon : Gives the player the weapon class.
--   entity : Spawns the entity in front of the player.
--   ammo   : Gives ammo by type and amount.
CFG.Inventory = {
    {
        id = "health_vial",
        name = "Health Vial",
        price = 750,
        type = "entity",
        class = "item_healthvial",
        model = "models/healthvial.mdl"
    },
    {
        id = "medkit",
        name = "Medical Kit",
        price = 2500,
        type = "entity",
        class = "item_healthkit",
        model = "models/items/healthkit.mdl"
    },
    {
        id = "pistol_ammo",
        name = "Pistol Ammo x60",
        price = 900,
        type = "ammo",
        ammoType = "Pistol",
        amount = 60
    },
    {
        id = "shotgun_ammo",
        name = "Shotgun Ammo x24",
        price = 1800,
        type = "ammo",
        ammoType = "Buckshot",
        amount = 24
    },
    {
        id = "smg",
        name = "SMG",
        price = 6500,
        type = "weapon",
        class = "weapon_smg1"
    },
}

-- Utility helpers ---------------------------------------------------------
if SERVER then
    local spawnCache

    function DubzTravelingMerchant.ReloadSpawns()
        spawnCache = nil

        if file.Exists(CFG.SpawnFile, "DATA") then
            local raw = file.Read(CFG.SpawnFile, "DATA")
            local decoded = util.JSONToTable(raw)
            if istable(decoded) then
                spawnCache = decoded
            end
        end

        if not spawnCache then
            spawnCache = table.Copy(CFG.SpawnLocations or {})
        end
    end

    function DubzTravelingMerchant.GetSpawnLocations()
        if not spawnCache then
            DubzTravelingMerchant.ReloadSpawns()
        end

        return spawnCache or {}
    end

    function DubzTravelingMerchant.AddSpawn(pos, ang)
        if not pos or not ang then return end

        local spawns = DubzTravelingMerchant.GetSpawnLocations()
        table.insert(spawns, { pos = pos, ang = ang })

        file.CreateDir(string.GetPathFromFilename(CFG.SpawnFile))
        file.Write(CFG.SpawnFile, util.TableToJSON(spawns, true))
    end

    function DubzTravelingMerchant.ClearSpawns()
        file.Delete(CFG.SpawnFile)
        DubzTravelingMerchant.ReloadSpawns()
    end
end


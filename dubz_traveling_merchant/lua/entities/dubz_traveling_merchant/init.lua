-- init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("autorun/dubz_traveling_merchant_config.lua")

util.AddNetworkString("dtm_openmerchant")
util.AddNetworkString("dtm_buyitem")

local CFG = DubzTravelingMerchant.Config

local function notify(ply, msg, level)
    if DarkRP and DarkRP.notify then
        DarkRP.notify(ply, level or 0, 4, msg)
    else
        ply:ChatPrint(msg)
    end
end

local function chooseSpawn()
    local spawns = DubzTravelingMerchant.GetSpawnLocations()
    if not istable(spawns) or #spawns == 0 then return end

    return table.Random(spawns)
end

local function giveItem(ply, item)
    if item.type == "weapon" then
        ply:Give(item.class)
        return true
    elseif item.type == "entity" then
        local ent = ents.Create(item.class)
        if not IsValid(ent) then return false end

        local aim = ply:GetAimVector()
        local pos = ply:GetShootPos() + aim * 32

        ent:SetPos(pos)
        ent:SetAngles(Angle(0, ply:EyeAngles().y, 0))
        if item.model then
            ent:SetModel(item.model)
        end

        ent:Spawn()
        ent:Activate()
        return true
    elseif item.type == "ammo" then
        local ammoType = item.ammoType or ""
        local amount = item.amount or 0
        if ammoType == "" or amount <= 0 then return false end

        ply:GiveAmmo(amount, ammoType, true)
        return true
    end

    return false
end

-- NPC INITIALIZATION ------------------------------------------------------
function ENT:Initialize()
    self:SetModel(table.Random(CFG.Merchant.Models))
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetTrigger(true)

    local spawn = chooseSpawn()
    if spawn then
        self:SetPos(spawn.pos)
        self:SetAngles(spawn.ang or Angle(0, 0, 0))
    end

    self:DropToFloor()

    self:SetMerchantName(table.Random(CFG.Merchant.Names))
end

function ENT:OnTakeDamage()
    return 0
end

-- PLAYER PRESSES E → Open Menu -------------------------------------------
function ENT:AcceptInput(_, _, activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    net.Start("dtm_openmerchant")
        net.WriteEntity(self)
        net.WriteString(self:GetMerchantName())
        net.WriteUInt(#CFG.Inventory, 8)
        for _, item in ipairs(CFG.Inventory) do
            net.WriteString(item.id)
            net.WriteString(item.name)
            net.WriteInt(item.price, 32)
            net.WriteString(item.type)
        end
    net.Send(activator)
end

-- PURCHASE HANDLER --------------------------------------------------------
net.Receive("dtm_buyitem", function(_, ply)
    local dealer = net.ReadEntity()
    local itemId = net.ReadString()

    if not IsValid(ply) or not IsValid(dealer) or dealer:GetClass() ~= "dubz_traveling_merchant" then return end

    local item
    for _, data in ipairs(CFG.Inventory) do
        if data.id == itemId then
            item = data
            break
        end
    end

    if not item then return end

    if not (ply.canAfford and ply.addMoney) then
        notify(ply, "DarkRP money functions not available on this server.", 1)
        return
    end

    if not ply:canAfford(item.price) then
        notify(ply, "You cannot afford this item.", 1)
        return
    end

    ply:addMoney(-item.price)

    if not giveItem(ply, item) then
        notify(ply, "Something went wrong while delivering that item.", 1)
        return
    end

    notify(ply, "Purchased " .. item.name .. " for " .. DarkRP.formatMoney(item.price) .. ".", 0)
end)

-- RESPAWN SUPPORT ---------------------------------------------------------
hook.Add("PostCleanupMap", "DTM_AutoRespawn", function()
    DubzTravelingMerchant.ReloadSpawns()

    if not CFG.Merchant.RespawnDelay or CFG.Merchant.RespawnDelay <= 0 then return end

    timer.Simple(CFG.Merchant.RespawnDelay, function()
        if not DubzTravelingMerchant.GetSpawnLocations() then return end
        local ent = ents.Create("dubz_traveling_merchant")
        if not IsValid(ent) then return end
        ent:Spawn()
    end)
end)

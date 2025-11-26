-- init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("autorun/franks_snow_config.lua")

util.AddNetworkString("drugdealeropenmenu")
util.AddNetworkString("sellcoke")

local PRICE_REFRESH_TIME = 120
local CFG = FranksSnowPacking.Config

---------------------------------------------------------
-- Dirty Money Helper Wrappers (Use your new system)
---------------------------------------------------------
function AddDirtyMoney(ply, amount)
    if not IsValid(ply) then return end
    ply:AddDirtyMoney(amount)      -- from sv_dirtymoney.lua
end

function TakeDirtyMoney(ply, amount)
    if not IsValid(ply) then return end
    ply:TakeDirtyMoney(amount)
end


---------------------------------------------------------
-- NPC INITIALIZATION
---------------------------------------------------------
function ENT:Initialize()
    self:SetModel(table.Random(CFG.Buyer.Models))

    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
    self:SetTrigger(true)

    local sellprice = math.random(CFG.Buyer.MinSellPrice, CFG.Buyer.MaxSellPrice)

    self:SetCokeSellPrice(sellprice)
    self.NextPriceRefresh = CurTime() + PRICE_REFRESH_TIME

    self:SetDealerName(table.Random(CFG.Buyer.Names))
    self:SetCokeHolding(0)
end

function ENT:OnTakeDamage()
    return 0
end


---------------------------------------------------------
-- PICK UP SNOW BRICKS / CRATES
---------------------------------------------------------
function ENT:StartTouch(ent)
    if not IsValid(ent) then return end

    -- Loose snow brick
    if ent:GetClass() == "snow_moneybrick" then
        self:SetCokeHolding(self:GetCokeHolding() + 1)
        ent:Remove()
        return
    end

    -- Crate with stored bricks
    if ent:GetClass() == "snow_crate" then
        local stored = ent:GetNWInt("Stored", 0)
        if stored > 0 then
            self:SetCokeHolding(self:GetCokeHolding() + stored)
            ent:Remove()
        end
        return
    end
end


---------------------------------------------------------
-- PRICE REFRESH
---------------------------------------------------------
function ENT:Think()
    if CurTime() >= (self.NextPriceRefresh or 0) then
        self:SetCokeSellPrice(math.random(500, 1500))
        self.NextPriceRefresh = CurTime() + PRICE_REFRESH_TIME
    end
end


---------------------------------------------------------
-- PLAYER PRESSES E → Open Menu
---------------------------------------------------------
function ENT:AcceptInput(_, _, activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    net.Start("drugdealeropenmenu")
        net.WriteEntity(self)
        net.WriteInt(self:GetCokeSellPrice(), 24)
        net.WriteString(self:GetDealerName())
        net.WriteInt(self:GetCokeHolding(), 24)
    net.Send(activator)
end


---------------------------------------------------------
-- PLAYER SELLS SNOW → GETS DIRTY MONEY
---------------------------------------------------------
net.Receive("sellcoke", function(_, ply)
    local dealer = net.ReadEntity()
    if not IsValid(dealer) then return end

    local bricks = dealer:GetCokeHolding()
    if bricks < 1 then
        DarkRP.notify(ply, 1, 4, "You have no snow bricks to sell.")
        return
    end

    local sellPrice = dealer:GetCokeSellPrice()
    local payout = bricks * sellPrice

    -----------------------------------------------------
    -- PAY DIRTY MONEY (persistent + networked)
    -----------------------------------------------------
    ply:AddDirtyMoney(payout)

    DarkRP.notify(
        ply,
        2,
        5,
        "You sold " .. bricks .. " snow brick(s) for " ..
        DarkRP.formatMoney(payout) .. " (Dirty Money)"
    )

    -- reset NPC's inventory
    dealer:SetCokeHolding(0)
end)

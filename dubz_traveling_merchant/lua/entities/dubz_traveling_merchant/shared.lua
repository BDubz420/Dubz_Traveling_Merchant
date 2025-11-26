-- shared.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Traveling Merchant"
ENT.Author = "BDubz420"
ENT.Category = "Dubz Traveling Merchant"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "MerchantName")
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
    self.AutomaticFrameAdvance = bUsingAnim
end

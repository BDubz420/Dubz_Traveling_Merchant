-- shared.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Snow Buyer"
ENT.Author = "BDubz420"
ENT.Category = "Franks Snow Packing"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "CokeSellPrice")
    self:NetworkVar("Int", 1, "CokeHolding")
    self:NetworkVar("Int", 2, "WantedChance")
    self:NetworkVar("String", 0, "DealerName")
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

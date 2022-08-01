AddCSLuaFile()

ENT.Base = "simple_ent_glowstick"

ENT.PrintName = "Glowstick (Custom)"
ENT.Category = "Simple Weapons: Glowsticks"

ENT.Spawnable = true

function ENT:SetupDataTables()
end

function ENT:GetCustomColor()
	return self:GetColor():ToVector()
end

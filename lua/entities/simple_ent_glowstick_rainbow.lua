AddCSLuaFile()

simple_weapons.Include("Convars.Glowsticks")

ENT.Base = "simple_ent_glowstick"

ENT.PrintName = "Glowstick (Rainbow)"
ENT.Category = "Simple Weapons: Glowsticks"

ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Thrown")
end

function ENT:GetCustomColor()
	local time

	if RainbowSync:GetBool() then
		time = CurTime() * RainbowCycle:GetFloat()
	else
		time = self:GetLifeTime() * RainbowCycle:GetFloat()
	end

	local col = HSVToColor(time % 360, 1, 1)

	return Vector(col.r / 255, col.g / 255, col.b / 255)
end

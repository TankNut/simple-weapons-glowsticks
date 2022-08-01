AddCSLuaFile()

SWEP.Base = "simple_glowstick"

SWEP.PrintName = "Glowstick (Custom)"
SWEP.Category = "Simple Weapons: Glowsticks"

SWEP.Spawnable = true

local default = Color(255, 255, 255)

function SWEP:GetCustomColor()
	local ply = self:GetOwner()

	if IsValid(ply) then
		local r = ply:GetInfoNum("simple_glowsticks_color_r", 255)
		local g = ply:GetInfoNum("simple_glowsticks_color_g", 255)
		local b = ply:GetInfoNum("simple_glowsticks_color_b", 255)

		return Color(r, g, b)
	end

	return default
end

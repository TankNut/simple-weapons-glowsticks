AddCSLuaFile()

SWEP.Base = "simple_glowstick"

SWEP.PrintName = "Glowstick (Weapon)"
SWEP.Category = "Simple Weapons: Glowsticks"

SWEP.Spawnable = true

local default = Color(76, 255, 255)

function SWEP:GetCustomColor()
	local ply = self:GetOwner()

	return IsValid(ply) and ply:GetWeaponColor():ToColor() or default
end

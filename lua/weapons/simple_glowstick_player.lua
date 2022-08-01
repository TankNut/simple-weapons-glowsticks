AddCSLuaFile()

SWEP.Base = "simple_glowstick"

SWEP.PrintName = "Glowstick (Player)"
SWEP.Category = "Simple Weapons: Glowsticks"

SWEP.Spawnable = true

local default = Color(61, 86, 104)

function SWEP:GetCustomColor()
	local ply = self:GetOwner()

	return IsValid(ply) and ply:GetPlayerColor():ToColor() or default
end

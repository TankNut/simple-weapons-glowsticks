AddCSLuaFile()

SWEP.Base = "simple_glowstick"

SWEP.PrintName = "Glowstick (Team)"
SWEP.Category = "Simple Weapons: Glowsticks"

SWEP.Spawnable = true

function SWEP:GetCustomColor()
	local index = TEAM_UNASSIGNED
	local ply = self:GetOwner()

	if IsValid(ply) then
		index = ply:Team()
	end

	return team.GetColor(index)
end

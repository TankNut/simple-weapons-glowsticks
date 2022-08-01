AddCSLuaFile()

simple_weapons.Include("Convars.Glowsticks")

SWEP.Base = "simple_glowstick"

SWEP.PrintName = "Glowstick (Rainbow)"
SWEP.Category = "Simple Weapons: Glowsticks"

SWEP.Spawnable = true
SWEP.AdminOnly = true

function SWEP:GetGlowColor()
	local time

	if RainbowSync:GetBool() then
		time = CurTime() * RainbowCycle:GetFloat()
	else
		time = (CurTime() - self:GetCreationTime()) * RainbowCycle:GetFloat()
	end

	local col = HSVToColor(time % 360, 1, 1)

	return Color(col.r, col.g, col.b)
end

if SERVER then
	function SWEP:CreateEntity()
		local ent = ents.Create("simple_ent_glowstick_rainbow")
		local ply = self:GetOwner()

		ent:SetPos(ply:GetPos())
		ent:SetAngles(ply:EyeAngles())
		ent:SetOwner(ply)
		ent:Spawn()
		ent:Activate()

		ent:SetThrown(true)

		ply:AddCleanup("glowsticks", ent)

		return ent
	end
end

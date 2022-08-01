AddCSLuaFile()

simple_weapons.Include("Convars.Glowsticks")

if CLIENT then
	language.Add("simple_glowstick_ammo", "Glowsticks")
end

game.AddAmmoType({name = "simple_glowstick", maxcarry = 8})

SWEP.Base = "simple_base_throwing"

SWEP.Slot = 4

SWEP.Spawnable = false

SWEP.UseHands = true

SWEP.ViewModelFOV = 54

SWEP.ViewModel = Model("models/simple_weapons/weapons/c_glowstick.mdl")
SWEP.WorldModel = Model("models/simple_weapons/glowstick.mdl")

SWEP.HoldType = "melee"
SWEP.LowerHoldType = "melee"

SWEP.Primary = {
	Ammo = "simple_glowstick",

	ThrowAct = {ACT_VM_PULLBACK_HIGH, ACT_VM_THROW},
	LobAct = {ACT_VM_PULLBACK_LOW, ACT_VM_SECONDARYATTACK},
	RollAct = {ACT_VM_PULLBACK_LOW, ACT_VM_SECONDARYATTACK}
}

SWEP.Color = Color(255, 255, 255)

function SWEP:GetCustomColor()
	return self.Color
end

function SWEP:GetGlowColor()
	local col = self:GetCustomColor()

	local hue, sat = ColorToHSV(col)

	col = HSVToColor(hue, sat, 1)

	return Color(col.r, col.g, col.b)
end

if CLIENT then
	function SWEP:DrawLight(pos)
		local dlight = DynamicLight(self:EntIndex())

		if dlight then
			local col = self:GetGlowColor()
			local size = GlowSize:GetFloat()

			dlight.Pos = pos
			dlight.r = col.r
			dlight.g = col.g
			dlight.b = col.b
			dlight.Brightness = GlowBrightness:GetFloat()
			dlight.Decay = size * 5
			dlight.Size = size
			dlight.DieTime = CurTime() + 1
		end
	end

	local mat = Material("models/simple_weapons/glow")

	function SWEP:PreDrawViewModel()
		local color = self:GetGlowColor():ToVector()

		mat:SetVector("$color2", color)
	end

	function SWEP:PostDrawViewModel()
		mat:SetVector("$color2", Vector(1, 1, 1))

		if self:GetFinishReload() == 0 then
			self:DrawLight(EyePos())
		end
	end

	function SWEP:DrawWorldModel()
		local ply = self:GetOwner()

		if IsValid(ply) then
			self:SetRenderOrigin(vector_origin)

			ply:SetupBones()

			local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")

			if not bone then
				return
			end

			local matrix = ply:GetBoneMatrix(bone)

			if not matrix then
				return
			end

			local pos, ang = LocalToWorld(Vector(3, -1.5, 0), Angle(80, 0, 0), matrix:GetTranslation(), matrix:GetAngles())

			self:SetRenderOrigin(pos)
			self:SetRenderAngles(ang)
		else
			self:SetRenderOrigin(nil)
			self:SetRenderAngles(nil)
		end

		local color = self:GetGlowColor():ToVector()

		mat:SetVector("$color2", color)

		self:DrawModel()

		mat:SetVector("$color2", Vector(1, 1, 1))

		self:DrawLight(self:GetRenderOrigin() or self:GetPos())
	end
else
	function SWEP:CreateEntity()
		local ent = ents.Create("simple_ent_glowstick")
		local ply = self:GetOwner()

		ent:SetPos(ply:GetPos())
		ent:SetAngles(ply:EyeAngles())
		ent:Spawn()
		ent:Activate()

		ent:SetThrown(true)
		ent:SetCustomColor(self:GetGlowColor():ToVector())

		ply:AddCleanup("glowsticks", ent)

		return ent
	end
end

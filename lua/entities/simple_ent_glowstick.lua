AddCSLuaFile()

simple_weapons.Include("Convars.Glowsticks")

DEFINE_BASECLASS("base_anim")

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Model = Model("models/simple_weapons/glowstick.mdl")

if SERVER then
	function ENT:SpawnFunction(ply, tr, classname)
		local ent = BaseClass.SpawnFunction(self, ply, tr, classname)

		if not IsValid(ent) then
			return
		end

		ply:AddCleanup("glowsticks", ent)

		return ent
	end
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(5)
		end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "CustomColor")
	self:NetworkVar("Bool", 0, "Thrown")

	if self.Color then
		self:SetCustomColor(self.Color:ToVector())
	end
end

function ENT:IsThrown()
	return self.GetThrown and self:GetThrown()
end

function ENT:GetLifeTime()
	return CurTime() - self:GetCreationTime()
end

function ENT:GetGlowColor()
	local col = self:GetCustomColor()
	local size = GlowSize:GetFloat()

	col = {
		r = col.x * 255,
		g = col.y * 255,
		b = col.z * 255
	}

	local hue, sat = ColorToHSV(col)

	col = HSVToColor(hue, sat, 1)
	col = Vector(col.r / 255, col.g / 255, col.b / 255)

	if Timed:GetBool() and self:IsThrown() then
		local frac = math.Clamp(math.Remap(self:GetLifeTime(), 0, LifeTime:GetFloat(), 1, 0), 0, 1)

		size = size * frac

		col = LerpVector(frac, vector_origin, col)
	end

	return col, size
end

if CLIENT then
	function ENT:Think()
		local range = LightRange:GetFloat() ^ 2
		local distance = self:WorldSpaceCenter():DistToSqr(EyePos())

		if LightRange:GetFloat() > 0 and distance > range then
			return
		end

		if PixVis:GetBool() then
			if not self.PixVis then
				self.PixVis = util.GetPixelVisibleHandle()
			end

			local pixvis = util.PixelVisible(self:WorldSpaceCenter(), GlowSize:GetFloat(), self.PixVis)

			if distance > (GlowSize:GetFloat() * 1.01) ^ 2 and pixvis <= 0 then
				return
			end
		end

		local dlight = DynamicLight(self:EntIndex())

		if dlight then
			local col, size = self:GetGlowColor()

			dlight.Pos = self:WorldSpaceCenter()
			dlight.r = col.x * 255
			dlight.g = col.y * 255
			dlight.b = col.z * 255
			dlight.Brightness = GlowBrightness:GetFloat()
			dlight.Decay = size * 5
			dlight.Size = size
			dlight.DieTime = CurTime() + 1
		end
	end

	local mat = Material("models/simple_weapons/glow")

	function ENT:Draw()
		mat:SetVector("$color2", self:GetGlowColor())

		render.SetColorModulation(1, 1, 1)
		self:DrawModel()

		mat:SetVector("$color2", Vector(1, 1, 1))
	end
else
	function ENT:Think()
		if Timed:GetBool() and Cleanup:GetBool() and self:IsThrown() and self:GetLifeTime() > LifeTime:GetFloat() then
			SafeRemoveEntity(self)
		end
	end

	function ENT:Use(ply)
		if not self:IsPlayerHolding() then
			ply:PickupObject(self)
		end
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

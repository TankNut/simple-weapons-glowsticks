local colors = {
	["Green"] = Color(0, 255, 63),
	["Blue"] = Color(0, 161, 255),
	["Red"] = Color(255, 0, 0),
	["Orange"] = Color(255, 93, 0),
	["Yellow"] = Color(255, 191, 0),
	["Purple"] = Color(220, 0, 255),
	["White"] = Color(255, 255, 255)
}

for k, v in pairs(colors) do
	weapons.Register({
		Base = "simple_glowstick",

		PrintName = string.format("Glowstick (%s)", k),
		Category = "Simple Weapons: Glowsticks",

		Spawnable = true,

		Color = v
	}, "simple_glowstick_" .. string.lower(k))

	scripted_ents.Register({
		Base = "simple_ent_glowstick",

		PrintName = string.format("Glowstick (%s)", k),
		Category = "Simple Weapons: Glowsticks",

		Spawnable = true,

		Color = v
	}, "simple_ent_glowstick_" .. string.lower(k))
end

cleanup.Register("glowsticks")

if CLIENT then
	language.Add("cleanup_glowsticks", "Glowsticks")
	language.Add("cleaned_glowsticks", "Cleaned up all glowsticks.")
end

hook.Add("PopulateToolMenu", "simple_glowsticks", function()
	simple_weapons.CreateOptionsMenu(REALM_CLIENT, "simple_glowsticks_cl", "Glowsticks", simple_weapons.Convars.Glowsticks, function(pnl)
		pnl:NumSlider("Light render distance", "simple_glowsticks_range", 0, 16000, 0)

		pnl:CheckBox("Use extra visibility checks", "simple_glowsticks_pixvis")

		pnl:ColorPicker("Custom color", "simple_glowsticks_color_r", "simple_glowsticks_color_g", "simple_glowsticks_color_b").Mixer:SetAlphaBar(false)
	end)

	simple_weapons.CreateOptionsMenu(REALM_SERVER, "simple_glowsticks_sv", "Glowsticks", simple_weapons.Convars.Glowsticks, function(pnl)
		pnl:NumSlider("Light radius", "simple_glowsticks_size", 16, 1024, 0)
		pnl:NumSlider("Brightness", "simple_glowsticks_brightness", -5, 5, 2)

		pnl:CheckBox("Thrown glowsticks decay", "simple_glowsticks_timed")

		pnl:NumSlider("Glowstick lifetime (seconds)", "simple_glowsticks_lifetime", 30, 10800, 0)

		pnl:CheckBox("Auto-remove expired glowsticks", "simple_glowsticks_cleanup")

		pnl:NumSlider("Rainbow cycle speed", "simple_glowsticks_rainbow_cycle", 1, 600, 0)
		pnl:CheckBox("Syncronize rainbow glowsticks", "simple_glowsticks_rainbow_sync")
	end)
end)

module("simple_weapons.Convars.Glowsticks", package.seeall)

GlowSize = CreateConVar("simple_glowsticks_size", 256, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The light radius glowsticks use.", 0)
GlowBrightness = CreateConVar("simple_glowsticks_brightness", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The brightness of the light glowsticks put out.")

Timed = CreateConVar("simple_glowsticks_timed", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether thrown glowsticks have a limited lifespan.", 0, 1)
LifeTime = CreateConVar("simple_glowsticks_lifetime", 300, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How long glowsticks last after being thrown.", 0)

Cleanup = CreateConVar("simple_glowsticks_cleanup", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to clean up glowsticks that have run out.", 0, 1)

RainbowCycle = CreateConVar("simple_glowsticks_rainbow_cycle", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How quickly rainbow glowsticks should cycle.", 1)
RainbowSync = CreateConVar("simple_glowsticks_rainbow_sync", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether rainbow glowsticks thrown by the same weapon should sync up.", 0, 1)

if CLIENT then
	LightRange = CreateClientConVar("simple_glowsticks_range", 8000, true, false, "The range at which glowsticks stop emitting light, 0 to disable.", 0, 56756)
	PixVis = CreateClientConVar("simple_glowsticks_pixvis", 1, true, false, "Whether glowsticks should use extra visibility checks.", 0, 1)

	CustomColorR = CreateClientConVar("simple_glowsticks_color_r", 255, true, true, "Your custom glowstick color (red).", 0, 255)
	CustomColorG = CreateClientConVar("simple_glowsticks_color_g", 255, true, true, "Your custom glowstick color (green).", 0, 255)
	CustomColorB = CreateClientConVar("simple_glowsticks_color_b", 255, true, true, "Your custom glowstick color (blue).", 0, 255)
end

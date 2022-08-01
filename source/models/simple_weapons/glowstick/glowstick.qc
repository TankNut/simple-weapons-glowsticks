// Created by Crowbar 0.63

$modelname "simple_weapons/glowstick.mdl"

$body "studio" "glowstick.smd"

$surfaceprop "default"
$contents "solid"

$cdmaterials "models\simple_weapons\"

$sequence "idle" {
	"glowstick_anims\idle.smd"
	activity "ACT_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 32
	loop
}

$collisionmodel "glowstick_physics.smd"
{
	$mass 2
	$inertia 0.25
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
}

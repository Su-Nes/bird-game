extends Node

class_name TimeController


@export var TIME_SPEED : float = 5
@export var SUN : DirectionalLight3D
var sun_energy_start : float
@export var MOON : DirectionalLight3D
var moon_energy_start

@export var ENVIRONMENT : Environment
var shader_mat : ShaderMaterial
@export var DAY_HORIZON : Color
@export var NIGHT_HORIZON : Color

func _ready() -> void:
	sun_energy_start = SUN.light_energy
	moon_energy_start = MOON.light_energy
	
	shader_mat = ENVIRONMENT.sky.sky_material

func _physics_process(delta: float) -> void:
	$Light.rotate_x(TIME_SPEED * delta)

	var sun_value = remap(abs($Light.rotation_degrees.x), 0.0, 90, 1.0, 0.0)
	sun_value = clamp(sun_value, 0.0, 1.0)
	
	SUN.light_energy = sun_energy_start * sun_value
	
	var moon_value = remap(abs($Light.rotation_degrees.x), 0.0, 90, 0.0, 1.0)
	moon_value = clamp(moon_value, 0.0, 1.0)
	
	MOON.light_energy = moon_energy_start * moon_value
	
	ENVIRONMENT.ambient_light_energy = remap(sun_value, 0.0, 1.0, 0.3, 1.0)
	ENVIRONMENT.ambient_light_sky_contribution = remap(sun_value, 0.0, 1.0, 0.97, 0.03)
	ENVIRONMENT.ambient_light_color.r = remap(sun_value, 0.0, 1.0, 0.784, 0.937)
	
	shader_mat.set_shader_parameter("horizon_color", lerp(NIGHT_HORIZON, DAY_HORIZON, sun_value))

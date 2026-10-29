extends Node

class_name TimeController


@export var TIME_SPEED : float = 5
@export var NIGHT_SPEED_MULT : float = 2
@export var LIGHT_HOLDER : Node3D
@export var SUN : DirectionalLight3D
var sun_energy_start : float
@export var MOON : DirectionalLight3D
var moon_energy_start

@export_category("Environment changes")
@export var ENVIRONMENT : Environment
var shader_mat : ShaderMaterial
@export var DAY_HORIZON : Color
@export var NIGHT_HORIZON : Color

@export_category("Time degree values")
@export var MORNING_DEG : int = 89
@export var NOON_DEG : int = 179
@export var EVENING_DEG : int = 269
@export var NIGHT_DEG : int = 359
var is_night = false

var clock_deg : float
var last_deg = 0

signal morning
signal noon
signal evening
signal night


func _ready() -> void:
	Signals.time_controller = self
	
	LIGHT_HOLDER.rotation.x = 0
	
	sun_energy_start = SUN.light_energy
	moon_energy_start = MOON.light_energy
	
	shader_mat = ENVIRONMENT.sky.sky_material

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle"):
		set_time(100)
	
	handle_time(delta)
		
	var sun_value = remap(abs(LIGHT_HOLDER.rotation_degrees.x), 0.0, 90, 1.0, 0.0)
	sun_value = clamp(sun_value, 0.0, 1.0)
	
	SUN.light_energy = sun_energy_start * sun_value
	
	var moon_value = remap(abs(LIGHT_HOLDER.rotation_degrees.x), 0.0, 90, 0.0, 1.0)
	moon_value = clamp(moon_value, 0.0, 1.0)
	
	MOON.light_energy = moon_energy_start * moon_value
	
	ENVIRONMENT.ambient_light_energy = remap(sun_value, 0.0, 1.0, 0.3, 1.0)
	ENVIRONMENT.ambient_light_sky_contribution = remap(sun_value, 0.0, 1.0, 0.97, 0.03)
	ENVIRONMENT.ambient_light_color.r = remap(sun_value, 0.0, 1.0, 0.784, 0.937)
	
	shader_mat.set_shader_parameter("horizon_color", lerp(NIGHT_HORIZON, DAY_HORIZON, sun_value))
	
func handle_time(delta: float):
	is_night = last_deg < MORNING_DEG or last_deg > EVENING_DEG
	
	if is_night:
		LIGHT_HOLDER.rotate_x(TIME_SPEED * NIGHT_SPEED_MULT * delta)
	else:
		LIGHT_HOLDER.rotate_x(TIME_SPEED * delta)
	
	if last_deg != roundi($Light.rotation_degrees.x + 180):
		last_deg = roundi($Light.rotation_degrees.x + 180)
		
		match last_deg:
			MORNING_DEG:
				morning.emit()
			NOON_DEG:
				noon.emit()
			EVENING_DEG:
				evening.emit()
			NIGHT_DEG:
				night.emit()
	
func on_loaded(save: SavedGame):
	set_time(save.time_deg)
	
func set_time(value_deg: float):
	LIGHT_HOLDER.rotation.x = deg_to_rad(value_deg)
	handle_time(get_physics_process_delta_time())
	emit_time_signals()

func emit_time_signals():
	if last_deg >= MORNING_DEG and last_deg < NOON_DEG:
		morning.emit()
	if last_deg >= NOON_DEG and last_deg < EVENING_DEG:
		noon.emit()
	if last_deg >= EVENING_DEG and last_deg < NIGHT_DEG:
		evening.emit()
	if last_deg >= 0 and last_deg < MORNING_DEG:
		night.emit()

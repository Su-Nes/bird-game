extends MeshInstance3D

class_name ChangeMaterialAtNight

@export var DAY_MATERIAL : StandardMaterial3D
@export var NIGHT_MATERIAL : StandardMaterial3D

var RANDOM_DELAY : float = 3

func _ready() -> void:
	Signals.time_controller.evening.connect(night_material)
	Signals.time_controller.night.connect(night_material)
	Signals.time_controller.morning.connect(day_material)
	Signals.time_controller.noon.connect(day_material)
	

func day_material():
	if mesh.surface_get_material(0) == DAY_MATERIAL:
		return
	
	await get_tree().create_timer(RANDOM_DELAY * randf()).timeout
	
	mesh.surface_set_material(0, DAY_MATERIAL)

func night_material():
	if mesh.surface_get_material(0) == NIGHT_MATERIAL:
		return
	
	await get_tree().create_timer(RANDOM_DELAY * randf()).timeout
	
	mesh.surface_set_material(0, NIGHT_MATERIAL)
	

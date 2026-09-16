extends Node

class_name StatDisplay


@export_category("Colours")
@export var active_style : StyleBoxFlat
@export var inactive_style : StyleBoxFlat 

@export_category("Assigns")
@export var STAMINA_UI : ProgressBar
var bar_start_width : float


func _ready() -> void:
	bar_start_width = STAMINA_UI.size.x


func _process(_delta: float) -> void:
	STAMINA_UI.value = StatController.stamina
	
	if StatController.penalty_timer > 0:
		STAMINA_UI.add_theme_stylebox_override("fill", inactive_style)
	else:
		STAMINA_UI.add_theme_stylebox_override("fill", active_style)
		
	STAMINA_UI.max_value = StatController.stamina_max_limit
	STAMINA_UI.size.x = bar_start_width * StatController.stamina_max_limit / StatController.MAX_BASE_STAMINA

extends Node

class_name StatsController


@export_category("Parameters")
@export var MAX_BASE_STAMINA : float = 100
@export var STAMINA_REGEN : float = 10
@export var PENALTY_TIME : float = 1.5

@export_category("Colours")
@export var active_style : StyleBoxFlat
@export var inactive_style : StyleBoxFlat 

@export_category("Assigns")
@export var STAMINA_UI : ProgressBar

var stamina : float
var stamina_max_limit : float
var regen_delay_timer : float
var penalty_timer : float

func _ready() -> void:
	stamina_max_limit = MAX_BASE_STAMINA
	stamina = stamina_max_limit
	
	STAMINA_UI.min_value = 0
	STAMINA_UI.max_value = stamina_max_limit

func _process(delta: float) -> void:
	regen_delay_timer -= delta
	penalty_timer -= delta
	
	STAMINA_UI.value = stamina
	
	if penalty_timer > 0:
		STAMINA_UI.add_theme_stylebox_override("fill", inactive_style)
	else:
		STAMINA_UI.add_theme_stylebox_override("fill", active_style)

	if regen_delay_timer > 0:
		return
		
	stamina = stamina + STAMINA_REGEN * delta if stamina < stamina_max_limit else stamina_max_limit


func spend_stamina(value: float, regen_delay : float = 0.0) -> bool:
	if stamina < value or penalty_timer > 0:
		return false
		
	stamina -= value
	regen_delay_timer = regen_delay
	
	if stamina < .1:
		penalty_timer = PENALTY_TIME
		return false
	
	return true

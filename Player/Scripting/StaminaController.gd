extends Node

class_name StatsController


@export_category("Stamina gain")
@export var MAX_BASE_STAMINA : float = 100
var stamina_max_limit : float
@export var STAMINA_REGEN : float = 10
var regen_delay_timer : float
@export var PENALTY_TIME : float = 1.5
var penalty_timer : float

@export_category("Stamina limits")
@export var STAMINA_LIMIT_DRAIN : float = 10

@export_category("Colours")
@export var active_style : StyleBoxFlat
@export var inactive_style : StyleBoxFlat 

@export_category("Assigns")
@export var STAMINA_UI : ProgressBar
var bar_start_width : float

var stamina : float


func _ready() -> void:
	stamina_max_limit = MAX_BASE_STAMINA
	stamina = stamina_max_limit
	
	bar_start_width = STAMINA_UI.size.x

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

	handle_stamina_regen()
	handle_max_stamina_loss()

func handle_stamina_regen():
	stamina = stamina + STAMINA_REGEN * get_process_delta_time() if stamina < stamina_max_limit else stamina_max_limit

func handle_max_stamina_loss():
	stamina_max_limit -= STAMINA_LIMIT_DRAIN * .01 * get_process_delta_time()
	
	STAMINA_UI.max_value = stamina_max_limit
	STAMINA_UI.size.x = bar_start_width * stamina_max_limit / MAX_BASE_STAMINA

func spend_stamina(value: float, regen_delay : float = 0.0) -> bool:
	if stamina < value or penalty_timer > 0:
		return false
		
	stamina -= value
	regen_delay_timer = regen_delay
	
	if stamina < .1:
		penalty_timer = PENALTY_TIME
		return false
	
	return true
	
func regain_max_stamina(value: float):
	stamina_max_limit += value
	stamina_max_limit = clamp(stamina_max_limit, 0, MAX_BASE_STAMINA)

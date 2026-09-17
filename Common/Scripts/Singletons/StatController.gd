extends Node


# Stamina gain
var MAX_BASE_STAMINA : float = 100
var stamina_max_limit : float
var STAMINA_REGEN : float = 10
var regen_delay_timer : float
var PENALTY_VALUE : float = 1
var PENALTY_TIME : float = 1.5
var penalty_timer : float

# Stamina limits
var STAMINA_LIMIT_DRAIN : float = 3
var DRAIN_PERIOD : float = 20
var drain_timer : float


var fainted = false
signal has_fainted

var stamina : float

func _ready() -> void:
	stamina_max_limit = MAX_BASE_STAMINA
	stamina = stamina_max_limit
	
func _process(delta: float) -> void:
	if MenuManager.paused:
		return
	
	regen_delay_timer -= delta
	penalty_timer -= delta

	handle_max_stamina_loss()
	
	if regen_delay_timer <= 0:
		handle_stamina_regen()

func handle_stamina_regen():
	stamina = stamina + STAMINA_REGEN * get_process_delta_time() if stamina < stamina_max_limit else stamina_max_limit


func spend_stamina(value: float, regen_delay : float = 0.0) -> bool:
	if stamina < value or penalty_timer > 0:
		return false
		
	stamina -= value
	regen_delay_timer = regen_delay
	
	if stamina < PENALTY_VALUE:
		penalty_timer = PENALTY_TIME
		return false
	
	return true
	
func spend_max_stamina(value: float) -> bool:
	stamina_max_limit -= value
	
	if stamina_max_limit <= 0:
		return true
		fainted = true
		has_fainted.emit()
	else:
		return false
	
func handle_max_stamina_loss():
	if fainted:
		return
	
	drain_timer += get_process_delta_time()
	
	if drain_timer >= DRAIN_PERIOD:
		stamina_max_limit -= STAMINA_LIMIT_DRAIN
		drain_timer = 0
		
	if stamina_max_limit <= 0:
		fainted = true
		has_fainted.emit()
	
func regain_max_stamina(value: float) -> bool:
	if stamina_max_limit >= MAX_BASE_STAMINA:
		return false
	
	stamina_max_limit += value
	stamina_max_limit = clamp(stamina_max_limit, 0, MAX_BASE_STAMINA)
	
	return true

extends Node


var pause_menu : PauseMenuScript
var faint_menu : FaintMenuScript

var paused = false

signal has_paused
signal has_unpaused


func _ready() -> void:
	StatController.has_fainted.connect(on_faint)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if StatController.fainted:
		return
	
	if paused:
		on_unpaused()
	else:
		on_paused()

func on_paused():
	pause_menu.show()
	
	var time = 1.0 if get_tree().current_scene.name == "StartMenu" else 0.0
	
	Engine.time_scale = time
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	has_paused.emit()
	
	paused = true
	
func on_unpaused():
	pause_menu.hide()
	Engine.time_scale = 1
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	has_unpaused.emit()
	
	paused = false
	
func on_faint():
	pause_menu.hide()
	Engine.time_scale = .1
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	faint_menu.show()
	
func on_revive():
	StatController.fainted = false
	StatController.stamina = StatController.stamina_max_limit

	Signals.player_change_state.emit("HoverState")
	
	on_unpaused()
	SaverLoader.load_player(load("user://save.tres"))
	
	Engine.time_scale = 1.0
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	faint_menu.hide()

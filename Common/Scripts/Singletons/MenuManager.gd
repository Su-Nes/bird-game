extends Node


var pause_menu : PauseMenuScript
var faint_menu : FaintMenuScript

var has_fainted = false
var paused = false

signal has_paused
signal has_unpaused


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
		
func toggle_pause():
	if has_fainted:
		return
	
	if paused:
		on_unpaused()
	else:
		on_paused()

func on_paused():
	pause_menu.show()
	Engine.time_scale = .1
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
	has_fainted = true
	
	pause_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	faint_menu.show()
	
func on_revive():
	StatController._ready()
	get_tree().reload_current_scene()
	
	has_fainted = false
	
	faint_menu.hide()

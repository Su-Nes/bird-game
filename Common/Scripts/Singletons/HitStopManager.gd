extends Node


func hit_stop(time):
	Engine.time_scale = 0.0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1.0
	
func hit_stop_frame():
	Engine.time_scale = 0.0
	await get_tree().process_frame
	Engine.time_scale = 1.0

func hit_stop_short():
	Engine.time_scale = 0.0
	await get_tree().create_timer(0.05, true, false, true).timeout
	Engine.time_scale = 1.0

func hit_stop_medium():
	Engine.time_scale = 0.0
	await get_tree().create_timer(0.15, true, false, true).timeout
	Engine.time_scale = 1.0
	
func hit_stop_long():
	Engine.time_scale = 0.0
	await get_tree().create_timer(0.3, true, false, true).timeout
	Engine.time_scale = 1.0

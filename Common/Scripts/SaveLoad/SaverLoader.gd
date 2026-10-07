extends Node


func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	
	load_game()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		clear_save()
		
	if Input.is_action_just_pressed("alt"):
		save_game()

func save_game():
	var saved_game = SavedGame.new()
	
	saved_game.player_max_stamina = StatController.stamina_max_limit
	var player = get_tree().get_first_node_in_group("Player") as Node3D
	saved_game.player_position = player.global_position
	
	var saved_data : Array[SavedData]
	
	get_tree().call_group("Persistent", "on_save_data", saved_data)
	saved_game.saved_data = saved_data

	ResourceSaver.save(saved_game, "user://save.tres")
	
func load_game():
	var saved_game : SavedGame = load("user://save.tres")
	
	StatController.stamina_max_limit = saved_game.player_max_stamina
	
	var player = get_tree().get_first_node_in_group("Player") as CharacterBody3D
	player.global_position = saved_game.player_position
	player.velocity = Vector3.ZERO
	Signals.player_change_state.emit("HoverState")
	
	get_tree().call_group("Persistent", "queue_free")

	for node : SavedData in saved_game.saved_data:
		var loaded_scene = node.scene.instantiate()
		
		if !node.parent_path.contains("GrabPoint"):
			get_node(node.parent_path).add_child.call_deferred(loaded_scene)
		#get_tree().root.add_child.call_deferred(loaded_scene)
		
		if loaded_scene.has_method("on_loaded"):
			loaded_scene.on_loaded(node)
			
func clear_save():
	var saved_game = SavedGame.new()
	
	saved_game.player_max_stamina = StatController.MAX_BASE_STAMINA
	saved_game.player_position = Vector3(0, 100, 0)
	
	ResourceSaver.save(saved_game, "user://save.tres")

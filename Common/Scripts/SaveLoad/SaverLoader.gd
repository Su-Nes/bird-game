extends Node


var game_complete : bool = false
const LABEL = preload("uid://m1s0hpj4abqw")
var label : Label

var autosave_interval : float = 60
var autosave_timer : float

func _ready() -> void:
	label = LABEL.instantiate()
	add_child(label)
	label.hide()
	
func _process(delta: float) -> void:
	autosave_timer += delta
	
	if autosave_timer > autosave_interval:
		save_game()
		autosave_timer = 0

func save_game():
	if get_tree().current_scene.name != "Main":
		return
	
	show_text()
	
	var saved_game = SavedGame.new()
	
	saved_game.player_max_stamina = StatController.stamina_max_limit
	saved_game.player_max_stamina = clamp(saved_game.player_max_stamina, StatController.MAX_BASE_STAMINA / 2, StatController.MAX_BASE_STAMINA)
	var player = get_tree().get_first_node_in_group("Player") as Node3D
	saved_game.player_position = player.global_position
	saved_game.game_complete = game_complete
	
	var saved_data : Array[SavedData]
	
	get_tree().call_group("Persistent", "on_save_data", saved_data)
	saved_game.saved_data = saved_data

	ResourceSaver.save(saved_game, "user://save.tres")
	
func load_game():
	var saved_game : SavedGame = load("user://save.tres")
	
	get_tree().call_group("Persistent", "queue_free")

	var loaded_scene : PackedScene
	for data : SavedData in saved_game.saved_data:
		loaded_scene = load(data.file_path)
		
		var new_scene = loaded_scene.instantiate()
		new_scene.add_to_group("Persistent")
		
		if !data.parent_path.contains("GrabPoint"):
			get_node(data.parent_path).add_child.call_deferred(new_scene)
		
		if new_scene.has_method("on_loaded"):
			new_scene.on_loaded(data)
			
	load_player(saved_game)
			
func load_player(save: SavedGame):
	StatController.stamina_max_limit = save.player_max_stamina
	StatController.stamina = StatController.stamina_max_limit
	
	var player = get_tree().get_first_node_in_group("Player") as CharacterBody3D
	player.global_position = save.player_position + Vector3(0, -.1, 0)
	
	player.velocity = Vector3.ZERO
	Signals.player_change_state.emit("HoverState")
	
func activate_crown(state: bool):
	var player_func : PlayerExtensionFunctions = get_tree().get_first_node_in_group("Player")
	player_func.CROWN.visible = state
	
func clear_save():
	var saved_game = SavedGame.new()
	
	saved_game.player_max_stamina = StatController.MAX_BASE_STAMINA
	saved_game.player_position = Vector3(0, 100, 0)
	
	ResourceSaver.save(saved_game, "user://save.tres")
	
func show_text():
	label.show()
	await get_tree().create_timer(1).timeout
	label.hide()

extends Area3D

class_name NestManager


@export_category("Visuals")
@export var NEST_PROMPT : Node3D
@export var NEST_MARKER : MeshInstance3D
@export var MARKER_COLOURS : Array[Color]
@export var NEST_STATISTICS : Node3D

@export_category("Parameters")
@export var TARGET_DECOR_VALUE : int = 100
@export var IMMORTAL_NEST = false
var decor_value = 0

var placed_objects : Array[Placeable]

var nest_complete = false

signal decor_target_reached

func _on_body_entered(body: Node3D) -> void:
	if body is Placeable:
		if body.is_placed:
			placed_objects.append(body)
			decor_value += body.DECOR_VALUE
			
			if placed_objects.size() > 4:
				update_decor()
			
func _on_body_exited(body: Node3D) -> void:
	if body is Placeable:
		if body.is_placed and placed_objects.has(body):
			body.is_placed = false
			
			placed_objects.erase(body)
			decor_value -= body.DECOR_VALUE
			
			update_decor()
			
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle"):
		NEST_MARKER.visible = true
		NEST_STATISTICS.visible = true
	
	if Input.is_action_just_released("toggle"):
		NEST_MARKER.visible = false
		NEST_STATISTICS.visible = false
		
func update_decor():
	var decor_text : Label3D = NEST_STATISTICS.get_child(0)
	
	if nest_complete:
		decor_text.text = "*Decor score:\n%s/%s*" % [decor_value, TARGET_DECOR_VALUE]
		return
	else:
		decor_text.text = "Decor score:\n%s/%s" % [decor_value, TARGET_DECOR_VALUE]
	
	if decor_value < 5 and !IMMORTAL_NEST:
		queue_free()
		
	if decor_value >= TARGET_DECOR_VALUE:
		decor_target_reached.emit()
		Signals.win.emit()
		nest_complete = true
		
func on_save_data(saved_data: Array[SavedData]):
	var data = SavedData.new()
	
	var self_scene = PackedScene.new()
	self_scene.pack(self)
	
	data.scene = self_scene
	data.tf = transform
	data.parent_path = get_parent().get_path()
	
	saved_data.append(data)
	
func on_loaded(data: SavedData):
	transform = data.tf

func _on_world_button_yes_on_pressed() -> void:
	#var nest_index = get_tree().get_node_count_in_group("Nest") - 1
	#var color_index = nest_index % MARKER_COLOURS.size()
	#
	#var marker_material : StandardMaterial3D = NEST_MARKER.get_active_material(0)
# TO-DO: cycle nest marker colors
	#print(marker_material.albedo_color)
	
	NEST_PROMPT.queue_free()

func _on_world_button_no_on_pressed() -> void:
	for obj : Placeable in placed_objects:
		obj.is_placed = false
	
	queue_free()

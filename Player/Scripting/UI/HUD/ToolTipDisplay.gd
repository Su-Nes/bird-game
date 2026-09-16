extends MarginContainer

class_name ToolTipDisplay


@export var TOOL_TIP_CONTAINER : PackedScene
@export var TIPS_ENABLED = false

var icon_names_kb : Array[String]
var icon_names_gp : Array[String]

var gamepad = false


func _ready() -> void:
	Signals.display_tool_tips.connect(display_tool_tips)
	Signals.remove_tool_tips.connect(remove_tool_tips)
	
func _input(event: InputEvent):
	if event is InputEventKey or event is InputEventMouse:
		gamepad = false
		#print("keyboard")

	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		gamepad = true
		#print("gamepad")

# TO-DO (advanced): use control binds in the input settings for icon displays
func display_tool_tips(tool_tips_kb: Dictionary[Texture2D, String], tool_tips_gp: Dictionary[Texture2D, String], owner_name : String):
	if !TIPS_ENABLED:
		return
		
	if gamepad:
		for icon in tool_tips_gp:
			var new_tip = TOOL_TIP_CONTAINER.instantiate()
			$VBoxContainer.add_child(new_tip)
			var h_box = new_tip.get_child(0)
			
			var tip_icon : TextureRect = h_box.get_child(0)
			var tool_tip : Label = h_box.get_child(1)
			tool_tip.name = owner_name
		
			tip_icon.texture = icon
			tool_tip.text = tool_tips_gp.get(icon)
	else:
		for icon in tool_tips_kb:
			var new_tip = TOOL_TIP_CONTAINER.instantiate()
			$VBoxContainer.add_child(new_tip)
			var h_box = new_tip.get_child(0)
			
			var tip_icon : TextureRect = h_box.get_child(0)
			var tool_tip : Label = h_box.get_child(1)
			tool_tip.name = owner_name
		
			tip_icon.texture = icon
			tool_tip.text = tool_tips_kb.get(icon)
	
# TO-DO: remove spaghetti, perhaps by assigning owners to each created tip, then the owner calls the tip to be deleted
func remove_tool_tips(owner_name : String):
	for tip in $VBoxContainer.get_children():
		if tip.get_child(0).get_child(1).name == owner_name:
			tip.queue_free()

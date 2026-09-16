extends RayCast3D

class_name InteractionScript


@export var GRAB_SCRIPT : GrabScript

@export var RETICLE_IDLE : MarginContainer
@export var RETICLE_ACTIVE : MarginContainer

var current_interactable : Interactable

func _process(_delta: float) -> void:
	var collider : Interactable = get_collider() if get_collider() is Interactable else null
	
	if collider: # TO-DO: Clean up this code
		#GRAB_SCRIPT.unselect_all()
		if collider != current_interactable:
			if current_interactable:
				current_interactable.on_lose_focus()
				
			current_interactable = get_collider()
			current_interactable.on_focus()
			
	elif current_interactable:
		current_interactable.on_lose_focus()
		current_interactable = null
		
	# Handle interaction reticle
	if enabled:
		RETICLE_ACTIVE.visible = current_interactable != null
		RETICLE_IDLE.visible = !RETICLE_ACTIVE.visible
	else:
		RETICLE_ACTIVE.visible = false
		RETICLE_IDLE.visible = false
		
		
	if current_interactable:
		if Input.is_action_just_pressed("interact"):
			if current_interactable.GRAB_ONLY:
				GRAB_SCRIPT.use_item()
			else:
				current_interactable.on_interact()
			
		if Input.is_action_just_pressed("pick") and current_interactable.IS_GRABBABLE:
			GRAB_SCRIPT.grab_item(current_interactable)
			current_interactable = null
	else:
		if Input.is_action_just_pressed("interact"):
			GRAB_SCRIPT.use_item()

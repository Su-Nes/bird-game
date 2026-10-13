extends Node3D


@export var TARGET_STATE : String = "FlyState"
@export var MINIMUM_VELOCITY : float = 12
@export var VELOCIY_ADD : float = 25
@export var FACE_PLAYER_FORWARD = false
@export var DIR_MARKER : Marker3D
@export var SLOWNESS_TEXT : Node3D
var ring_enabled = false

var player_controller : CharacterBody3D

func _ready() -> void:
	SLOWNESS_TEXT.hide()
	
	Signals.player_changed_state.connect(enable_ring)
	
func enable_ring(state: String):
	ring_enabled = state.to_lower() == TARGET_STATE.to_lower()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_controller = body
		ring_collected()
		
func ring_collected():
	if player_controller.velocity.length() >= MINIMUM_VELOCITY and ring_enabled:
		var dir = player_controller.velocity.normalized()
		
		if FACE_PLAYER_FORWARD:
			dir = -DIR_MARKER.global_basis.z
			if player_controller.velocity.normalized().angle_to(dir) > PI / 2:
				dir *= -1
			
		player_controller.velocity += dir * VELOCIY_ADD
		
		Signals.player_change_state.emit("FlyState")

		$RingCorrect.play()
	else:
		show_text()
		
		$RingWrong.play()
		Signals.player_change_state.emit("CrashState")
		
func show_text():
	SLOWNESS_TEXT.show()
	
	await get_tree().create_timer(1).timeout
	
	SLOWNESS_TEXT.hide()

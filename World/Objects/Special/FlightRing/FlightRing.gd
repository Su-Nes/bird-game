extends Node3D


@export var TARGET_STATE : String
var ring_enabled = false

func _ready() -> void:
	Signals.player_changed_state.connect(enable_ring)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		ring_collected()
		
func enable_ring(state: String):
	ring_enabled = state.to_lower() == TARGET_STATE.to_lower()

func ring_collected():
	if ring_enabled:
		$RingCorrect.play()
	else:
		$RingWrong.play()

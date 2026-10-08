extends CanvasLayer


signal loading_screen_ready

@export var ANIMATOR : AnimationPlayer

@export var ANIM_TEXTURE : TextureRect
var anim_atlas : AtlasTexture
@export var SPRITE_REGION_ANIM : Array[Rect2]

func _ready() -> void:
	anim_atlas = ANIM_TEXTURE.texture
	
	await ANIMATOR.animation_finished
	loading_screen_ready.emit()
	
func on_progress_changed(_new_value: float):
	var progress_index = roundi((SPRITE_REGION_ANIM.size() - 1) * (1.0 - _new_value))
	
	anim_atlas.region = SPRITE_REGION_ANIM[progress_index]
	
func on_load_finished():
	ANIMATOR.play_backwards("Transition")
	await ANIMATOR.animation_finished
	queue_free()

extends Resource

class_name SavedData


@export_category("Shared data")
@export var file_path : String
@export var tree_path : String
@export var tf : Transform3D
@export var parent_path : String

@export_category("Placeable data")
@export var is_placed : bool
@export var is_grabbed : bool

@export_category("Nest data")
@export var nest_completed : bool

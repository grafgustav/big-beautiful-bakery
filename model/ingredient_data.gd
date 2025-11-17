class_name IngredientData
extends Resource

@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
@export var price: int

# immutable scene path
@export var scene_path: String:
	set(value):
		if scene_path == "":
			scene_path = value


func _to_string() -> String:
	return display_name

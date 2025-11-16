class_name IngredientComponent
extends Node

@export var ingredient: IngredientData


func _to_string() -> String:
	return str("Component:", ingredient.display_name)

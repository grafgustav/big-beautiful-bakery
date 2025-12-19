class_name IngredientComponent
extends Node

@export var ingredient: IngredientData


func _ready() -> void:
	ItemManager.register_ingredient(self)


func _to_string() -> String:
	return str("Component:", ingredient.display_name)


func _exit_tree() -> void:
	ItemManager.deregister_ingredient(self)


func hide() -> void:
	get_parent().hide()


func show() -> void:
	get_parent().show()

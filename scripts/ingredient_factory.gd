class_name IngredientFactoryClass
extends Node


func instantiate_from_model(model: IngredientData) -> Node:
	var scene := load(model.scene_path)
	return scene.instantiate()

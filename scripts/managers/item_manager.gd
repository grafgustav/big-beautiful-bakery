class_name ItemManagerClass
extends Node


var ingredient_list: Array[IngredientComponent] = []


func register_ingredient(ingredient: IngredientComponent) -> void:
	ingredient_list.append(ingredient)


func deregister_ingredient(ingredient: IngredientComponent) -> void:
	ingredient_list.erase(ingredient)


func hide_all_ingredients() -> void:
	print("Hiding ", ingredient_list.size(), " ingredients")
	for ingredient in ingredient_list:
		ingredient.hide()


func show_all_ingredients() -> void:
	print("Hiding ", ingredient_list.size(), " ingredients")
	for ingredient in ingredient_list:
		ingredient.show()

# this helper class unifies operations we need on the ingredient list, like appending elements, 
# counting, etc
class_name IngredientsList
extends Resource

var ingredient_list : Array[IngredientData] = []


func clear() -> void:
	ingredient_list = []


func count(ingredient: IngredientData) -> int:
	return ingredient_list.count(ingredient)


func append(ingredient: IngredientData) -> void:
	ingredient_list.append(ingredient)


func is_empty() -> bool:
	return ingredient_list.is_empty()


func _to_string() -> String:
	return str(ingredient_list)

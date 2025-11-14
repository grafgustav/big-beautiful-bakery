# this helper class unifies operations we need on the ingredient list, like appending elements, 
# counting, etc
class_name IngredientsList
extends Resource

var ingredient_list : Array[IngredientData] = []


func count(ingredient: IngredientData) -> int:
	return ingredient_list.count(ingredient)


func append(ingredient: IngredientData) -> void:
	ingredient_list.append(ingredient)

class_name RecipeManager
extends Node

@export var all_recipes: Array[RecipeData] = []


# Returns recipes where all requirements are fully met
func get_fully_completed_recipes(ingredient_list: IngredientsList) -> Array[RecipeData]:
	var completed: Array[RecipeData] = []
	
	for recipe in all_recipes:
		if _is_recipe_complete(recipe, ingredient_list):
			completed.append(recipe)
	return completed


func _is_recipe_complete(recipe: RecipeData, ingredient_list: IngredientsList) -> bool:
	for req in recipe.inputs:
		var ingredient = req.ingredient
		if ingredient_list.count(ingredient) != req.amount:
			return false
	return true

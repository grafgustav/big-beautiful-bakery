class_name RecipeData
extends Resource

@export var recipe_id : StringName
@export var display_name : String

@export var icon : Texture2D

@export var inputs : Array[IngredientAmount]
@export var outputs : Array[IngredientAmount]

@export var processing_time : float


func _to_string() -> String:
	return display_name


func expand_outputs() -> Array[IngredientData]:
	var expanded: Array[IngredientData] = []
	for ingredient_amount in outputs:
		for i in ingredient_amount.amount:
			expanded.append(ingredient_amount.ingredient)
	return expanded

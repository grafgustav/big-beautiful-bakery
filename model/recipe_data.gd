class_name RecipeData
extends Resource

@export var recipe_id : StringName
@export var display_name : String

@export var icon : Texture2D

@export var inputs : Array[IngredientAmount]
@export var outputs : Array[IngredientAmount]

@export var processing_time : float


class IngredientAmount extends Resource:
	@export var ingredient: IngredientData
	@export var amount: int

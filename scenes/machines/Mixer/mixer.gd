class_name Mixer
extends Node2D


var animation_player : AnimatedSprite2D
var state_machine : MixerStateMachine
var ingredient_list : IngredientsList
var is_clickable : bool = false
var recipe : RecipeData = null


func _ready() -> void:
	animation_player = %AnimatedSprite2D
	state_machine = %MixerStateMachine
	state_machine.init(self, animation_player)
	ingredient_list = IngredientsList.new()


func _process(_delta: float) -> void:
	state_machine.update()


func _physics_process(_delta: float) -> void:
	state_machine.physics_update()


func drop_ingredient(ingredient: IngredientData) -> bool:
	# TODO: Can any machine accept ANY input and then just have rubbish products?
	# currently yes.
	ingredient_list.append(ingredient)
	print("Ingredient dropped, list:")
	print(ingredient_list)
	return true # ingredient accepted


func has_empty_ingredient_list() -> bool:
	return ingredient_list.is_empty()


func find_recipe_to_process() -> RecipeData:
	var reci = RecipeManager.get_fully_completed_recipes(ingredient_list)
	print("Recipes: ", reci)
	return reci[0]


func _on_click_area_mouse_entered() -> void:
	is_clickable = true


func _on_click_area_mouse_exited() -> void:
	is_clickable = false

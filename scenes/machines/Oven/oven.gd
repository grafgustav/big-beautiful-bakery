class_name Oven
extends Node2D


var animation_player : AnimatedSprite2D
var state_machine : MachineStateMachine
var ingredient_list : IngredientsList
var is_clickable : bool = false
var recipe : RecipeData = null

var machine_type: Types.MachineTypes = Types.MachineTypes.BAKING


func _ready() -> void:
	animation_player = %AnimatedSprite2D
	state_machine = %BakingStateMachine
	state_machine.init(self, animation_player)
	ingredient_list = IngredientsList.new()


func _process(_delta: float) -> void:
	state_machine.update()


func _physics_process(_delta: float) -> void:
	state_machine.physics_update()


func drop_ingredient(ingredient: IngredientData) -> bool:
	return state_machine.drop_ingredient(ingredient)


func add_ingredient(ingredient: IngredientData) -> void:
	ingredient_list.append(ingredient)
	print("Ingredient List: ", ingredient_list)


func has_empty_ingredient_list() -> bool:
	return ingredient_list.is_empty()


func find_recipe_to_process() -> RecipeData:
	var reci = RecipeManager.get_first_completed_or_junk_recipe_for_machine_type(ingredient_list, machine_type)
	print("Recipe: ", reci)
	return reci


func _on_click_area_mouse_entered() -> void:
	is_clickable = true


func _on_click_area_mouse_exited() -> void:
	is_clickable = false

class_name Mixer
extends Node2D


var animation_player : AnimatedSprite2D
var state_machine : MixerStateMachine
var ingredient_list : IngredientsList


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
	# update ingredient list
	# TODO: Can any machine accept ANY input and then just have rubbish products?
	# currently yes.
	ingredient_list.append(ingredient)
	print("Ingredient dropped, list:")
	print(ingredient_list)
	return true # accepted?


func has_empty_ingredient_list() -> bool:
	return ingredient_list.is_empty()

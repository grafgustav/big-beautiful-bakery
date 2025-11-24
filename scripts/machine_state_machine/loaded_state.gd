class_name LoadedState
extends MachineState


@export var processing_state : MachineState


func update() -> MachineState:
	if !parent_ref.is_clickable:
		return null
	
	if Input.is_action_just_pressed("dragging"):
		var recipe = parent_ref.find_recipe_to_process()
		if recipe:
			parent_ref.recipe = recipe
			return processing_state
			
	return null


func drop_ingredient(ingredient: IngredientData) -> bool:
	parent_ref.add_ingredient(ingredient)
	return true

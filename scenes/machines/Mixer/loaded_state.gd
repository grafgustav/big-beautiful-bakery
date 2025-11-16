class_name LoadedState
extends MixerState


@export var mixing_state : MixerState


func update() -> MixerState:
	if !parent_ref.is_clickable:
		return null
	
	if Input.is_action_just_pressed("dragging"):
		var recipe = parent_ref.find_recipe_to_process()
		if recipe:
			parent_ref.recipe = recipe
			return mixing_state
			
	return null

class_name IdleState
extends MixerState


@export var loadedState : MixerState


func update() -> MixerState:
	if !parent_ref.has_empty_ingredient_list():
		return loadedState
	return null

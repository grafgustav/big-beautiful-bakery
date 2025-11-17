class_name IdleState
extends MachineState


@export var loadedState : MachineState


func update() -> MachineState:
	if !parent_ref.has_empty_ingredient_list():
		return loadedState
	return null

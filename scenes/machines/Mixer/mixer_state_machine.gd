class_name MixerStateMachine
extends Node


@export var starting_state : MixerState
var current_state : MixerState


func init(parent_ref : Node2D, animation_player : AnimatedSprite2D) -> void:
	for child in get_children():
		if child is MixerState:
			child.parent_ref = parent_ref
			child.animation_player = animation_player
	change_state(starting_state)


func change_state(new_state : MixerState) -> void:
	print("Changing state from ", current_state, " to ", new_state)
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()


func update() -> void:
	var new_state = current_state.update()
	if new_state:
		change_state(new_state)


func physics_update() -> void:
	var new_state = current_state.physics_update()
	if new_state:
		change_state(new_state)


func drop_item(item: Types.Items) -> bool:
	# TODO: use recipes and models and ingredient_lists
	var new_state = current_state.drop_item(item)
	if new_state:
		change_state(new_state)
		return true
	else:
		return false

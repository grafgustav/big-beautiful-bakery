class_name MixerState
extends Node


@export var animation : String
@export var input_criteria : Dictionary[Types.Items, MixerState] = {}

var parent_ref : Mixer
var animation_player : AnimatedSprite2D


func enter() -> void:
	animation_player.play(animation)


func exit() -> void:
	pass


func update() -> MixerState:
	return null


func physics_update() -> MixerState:
	return null


func process_input(event: InputEvent) -> void:
	pass


func drop_item(item: Types.Items) -> MixerState:
	return input_criteria.get(item)

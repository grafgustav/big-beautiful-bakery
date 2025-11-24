class_name MachineState
extends Node


@export var animation : String

var parent_ref : Node
var animation_player : AnimatedSprite2D


func enter() -> void:
	animation_player.play(animation)


func exit() -> void:
	pass


func update() -> MachineState:
	return null


func physics_update() -> MachineState:
	return null


func drop_ingredient(ingredient: IngredientData) -> bool:
	return false

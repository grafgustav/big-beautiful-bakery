class_name DroppableComponent
extends Area2D

@export var dropping_type : Types.DroppableTypes = Types.DroppableTypes.FREEDROP

var parent_ref : Node2D


func _ready() -> void:
	parent_ref = get_parent()


func is_snap_to_grid() -> bool:
	return dropping_type == Types.DroppableTypes.GRIDSNAP


func is_vanishing() -> bool:
	return dropping_type == Types.DroppableTypes.VANISHING


func is_free_dropping() -> bool:
	return dropping_type == Types.DroppableTypes.FREEDROP


func drop_item(item : Types.Items) -> bool:
	if parent_ref.has_method("drop_item"):
		return parent_ref.drop_item(item)
	return true

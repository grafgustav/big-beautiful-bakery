class_name DroppableComponent
extends Area2D

@export var dropping_type : Types.DroppableTypes = Types.DroppableTypes.FREEDROP

func is_snap_to_grid() -> bool:
	return dropping_type == Types.DroppableTypes.GRIDSNAP
	
func is_vanishing() -> bool:
	return dropping_type == Types.DroppableTypes.VANISHING
	
func is_free_dropping() -> bool:
	return dropping_type == Types.DroppableTypes.FREEDROP
	

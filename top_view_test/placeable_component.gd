class_name PlaceableComponent
extends Node2D

## placeable component that adds a highlight box
# Usage: The placeable component adds a grid occupancy to the scene
# the "collision" is of the bottom-left corner of the object.
# then we check the occupancy of the data array using the mapping function
# then we draw a rectangle in red or green on the ground (z-index of tilemap +1)

@export var g_width: int
@export var g_height: int


func _ready() -> void:
	_validate_size()


func _validate_size() -> void:
	if g_width == 0 || g_height == 0:
		print("Placeable Component has 0 size")
		push_error("Placeable Component has 0 size")

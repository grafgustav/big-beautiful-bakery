class_name PlaceableComponent
extends Area2D

## placeable component that adds a highlight box

@export var grid_width: int
@export var grid_height: int

var rect_box: Rect2
var rect_size: Vector2

var border_color: Color = Color(1.0, 1.0, 1.0)
var border_width: float = 4.0


func _ready() -> void:
	_validate_size()
	var coll_box: CollisionShape2D = find_child("CollisionShape2D")
	var new_rect: Rect2
	var coll_box_rect = coll_box.shape.get_rect()
	rect_size = coll_box_rect.size
	new_rect.size = rect_size
	new_rect.position = coll_box.position - rect_size / 2
	rect_box = new_rect
	
	print("Rect determined: Size: ", rect_size, "; position: ", rect_box.position)
	print("Coll box pos: ", coll_box.position)


func _validate_size() -> void:
	if grid_width == 0 || grid_height == 0:
		print("Placeable Component has 0 size")
		push_error("Placeable Component has 0 size")


func _draw_highlight_box() -> void:
	draw_rect(rect_box, border_color, false, border_width)


func _draw() -> void:
	_draw_highlight_box()

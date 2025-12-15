class_name GridComponent
extends Area2D


@export var grid_width: int
@export var grid_height: int

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var grid_drawn: bool = false


# API FUNCTIONS
func _ready() -> void:
	GridManager.init_grid(self)


func _input(event: InputEvent) -> void:
	if event && event.is_action_pressed("dragging"):
		pass


func _draw() -> void:
	if grid_drawn:
		_draw_grid()


# PUBLIC FUNCTIONS
func draw_grid() -> void:
	print("Drawing grid...")
	grid_drawn = true
	pass


func hide_grid() -> void:
	print("Hiding grid...")
	grid_drawn = false
	pass


# PRIVATE FUNCTIONS
func _draw_grid() -> void:
	pass

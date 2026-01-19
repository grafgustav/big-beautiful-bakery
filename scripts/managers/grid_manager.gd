class_name GridManagerClass
extends Node


## This class manages the creation of grids
## on scene change a method is called that scans the scene for grids (Node with CollisionShape)
## the Collision Shape is then divided into a grid
## when a toggle method is called, the grid is toggled (in)visible
## also this manager contains a method that takes in coordinates to highlight a certain area of the grid
## also this manager manages all the data handling of the grid?

var grids: Array[GridComponent] = []


# API FUNCTIONS
func _ready() -> void:
	GameManager.building_mode_switched.connect(_connect_to_building_mode_switch)
	DragManager.drag_cursor_moved.connect(_highlight_grid_cell)
	DragManager.drag_stopped.connect(_clear_highlights)


# PUBLIC FUNCTIONS
func init_grid(grid_component: GridComponent) -> void:
	print("Adding Grid")
	grids.append(grid_component)
	print("Grids Init'ed")


func activate_grids() -> void:
	for grid in grids:
		grid.activate_droppable()


func deactivate_grids() -> void:
	for grid in grids:
		grid.deactivate_droppable()


# PRIVATE FUNCTIONS
func _connect_to_building_mode_switch(building_mode: bool) -> void:
	print("Event consumed: building_mode_switched")
	for grid in grids:
		if building_mode:
			_draw_view_grid(grid)
		else:
			_hide_view_grid(grid)


func _draw_view_grid(grid: GridComponent) -> void:
	grid.draw_grid()


func _hide_view_grid(grid: GridComponent) -> void:
	grid.hide_grid()


func _highlight_grid_cell(draggable: DraggableComponent) -> void:
	if GameManager.building_mode:
		var placeable_component: PlaceableComponent = draggable.get_parent().find_child("PlaceableComponent")
		var p_width: int = placeable_component.g_width if placeable_component else 1
		var p_height: int = placeable_component.g_height if placeable_component else 1
		print("Width: ", p_width, "; Height: ", p_height)
		_draw_highlighted_cell(draggable.global_position, p_width, p_height)


func _draw_highlighted_cell(pos: Vector2, p_width: int, p_height: int) -> void:
		# TODO: Check for placeable component
		for grid in grids:
			grid.highlight_cell_world_coords(pos, p_width, p_height)


func _clear_highlights() -> void:
	if GameManager.building_mode:
		for grid in grids:
			grid.clear_highlighted_cells()

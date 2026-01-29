class_name GridComponent
extends DroppableComponent

const GRID_COLOR := Color(0.534, 0.639, 0.886)
const HIGHLIGHT_COLOR := Color(0.919, 0.538, 0.113)
const INVALID_HIGHLIGHT := Color(0.844, 0.0, 0.176)
const GRID_THICCCNESS := 5.0

## The grid width in steps (how many columns)
@export var grid_width: int
## The grid height in steps (how many rows)
@export var grid_height: int

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var grid_drawn: bool = false

var grid_start: Vector2
var grid_batch_size: Vector2
var grid_transform: Transform2D

# data grid -> keep data and track occupancy
var data_grid: Array = []

var highlighted_cells: Array[Vector2i] = []
var invalid_cells: Array[Vector2i] = []


# API FUNCTIONS
func _ready() -> void:
	GridManager.init_grid(self)
	_init_grid()


func _draw() -> void:
	if grid_drawn:
		draw_set_transform_matrix(grid_transform)
		_draw_grid()
		_draw_highlighted_cells()
		_draw_invalid_cells()
		draw_set_transform_matrix(Transform2D.IDENTITY)


# PUBLIC FUNCTIONS
func draw_grid() -> void:
	print("Drawing grid...")
	grid_drawn = true
	queue_redraw()


func hide_grid() -> void:
	print("Hiding grid...")
	grid_drawn = false
	queue_redraw()


func highlight_cells(cells: Array[Vector2i]) -> void:
	# TODO: Only append cells INSIDE the grid
	highlighted_cells.append_array(cells)
	queue_redraw()


func highlight_cell(vec: Vector2i) -> void:
	# TODO: Only append cells INSIDE the grid
	highlighted_cells.append(vec)
	queue_redraw()


func highlight_cell_world_coords(vec: Vector2, width: int = 1, height: int = 1) -> void:
	# TODO: Only append cells INSIDE the grid
	var translated_vector: Vector2i = _map_pos_to_data_grid(vec)
	highlighted_cells = []
	invalid_cells = []
	for w in width:
		for h in height:
			var new_vec = Vector2i(translated_vector.x + w, translated_vector.y + h)
			if _is_inside_grid(new_vec) && _is_empty_cell(new_vec):
				highlighted_cells.append(new_vec)
			else:
				invalid_cells.append(new_vec)
	queue_redraw()


func get_highlighted_cells() -> Array[Vector2i]:
	return highlighted_cells


func remove_highlighted_cell(vec: Vector2i) -> void:
	highlighted_cells.erase(vec)
	invalid_cells.erase(vec)
	queue_redraw()


func clear_highlighted_cells() -> void:
	highlighted_cells.clear()
	invalid_cells.clear()
	queue_redraw()


func activate_droppable() -> void:
	monitorable = true


func deactivate_droppable() -> void:
	monitorable = false


func get_global_pos_center_from_grid_cell(vec: Vector2i) -> Vector2:
	var res = _map_data_grid_to_global_pos(vec)
	res = res + grid_transform.basis_xform(grid_batch_size / 2)
	return res


# PRIVATE FUNCTIONS
func _init_grid() -> void:
	print("Init Grid")
	_init_view_grid(grid_width, grid_height)
	_init_data_grid(grid_width, grid_height)
	# _print_data_grid()
	print("Grid Init'ed")


func _init_view_grid(h_size: int, v_size: int) -> void:
	print("Init View Grid from Collision Box")
	
	# take dimensions of collision box
	var d_shape = find_child("CollisionShape2D*")
	if !d_shape:
		print("No collision shape found!")
		push_error("No collision shape found!")
		return
	
	var rect = d_shape.shape.get_rect()
	grid_start = d_shape.global_position - (rect.size / 2)
	print("Origin of grid: ", grid_start)
	
	var shape_size = rect.size / Vector2(h_size, v_size)
	print("Grid batch size: ", shape_size)
	grid_batch_size = shape_size
	
	var transf: Transform2D = d_shape.get_global_transform()
	transf.origin = transf * rect.position
	grid_transform = transf


func _increment_data_cell(vec: Vector2) -> void:
	data_grid[int(vec.y)][int(vec.x)] += 1
	_print_data_grid()


func _map_pos_to_data_grid(vec: Vector2) -> Vector2i:
	var res: Vector2 = Vector2i()
	vec = grid_transform.affine_inverse() * vec # get local point from global point
	var new_x = vec.x / grid_batch_size.x
	var new_y = vec.y / grid_batch_size.y
	res.x = int(new_x)
	res.y = int(new_y)
	# print("Translating ", vec, " to ", res)
	return res


func _map_data_grid_to_global_pos(vec: Vector2i) -> Vector2:
	var res: Vector2 = Vector2()
	var new_x = vec.x * grid_batch_size.x
	var new_y = vec.y * grid_batch_size.y
	res.x = int(new_x)
	res.y = int(new_y)
	res = grid_transform * res
	# print("Translating ", vec, " to ", res)
	return res


func _init_data_grid(v_size: int, h_size: int) -> void:
	print("Init 2D array of dimensions ", v_size, ",", h_size)
	var res = []
	for i in h_size:
		res.append(_init_arr(v_size))
	data_grid = res


func _init_arr(size: int) -> Array:
	var res = []
	for i in size:
		res.append(0) # TODO: I read resize might be more efficient?
	return res


func _print_data_grid() -> void:
	print("Printing 2D Array")
	var out: String = ""
	if !data_grid:
		return
	for i in data_grid.size():
		out += "\n"
		for j in data_grid[i].size():
			if j == 0:
				out += "["
			out += str(data_grid[i][j])
			if j == data_grid[i].size() - 1:
				out += "]"
			else:
				out += ",\t"
	print(out)


func _draw_grid() -> void:
	for i in grid_width:
		for j in grid_height:
			var rect: Rect2
			var pos: Vector2 = Vector2(i * grid_batch_size.x, j * grid_batch_size.y)
			rect.position = pos
			rect.size = grid_batch_size
			draw_rect(rect, GRID_COLOR, false, GRID_THICCCNESS)


func _draw_highlighted_cells() -> void:
	for cell in highlighted_cells:
		var rect: Rect2
		var pos: Vector2 = Vector2(
			cell.x * grid_batch_size.x,
			cell.y * grid_batch_size.y
		)
		rect.position = pos
		rect.size = grid_batch_size
		draw_rect(rect, HIGHLIGHT_COLOR, false, GRID_THICCCNESS)


func _draw_invalid_cells() -> void:
	for cell in invalid_cells:
		var rect: Rect2
		var pos: Vector2 = Vector2(
			cell.x * grid_batch_size.x,
			cell.y * grid_batch_size.y
		)
		rect.position = pos
		rect.size = grid_batch_size
		draw_rect(rect, INVALID_HIGHLIGHT, false, GRID_THICCCNESS)


## checks if vec is inside grid borders
func _is_inside_grid(vec: Vector2i) -> bool:
	if vec.x >= 0 && vec.y >= 0 && vec.x < grid_width && vec.y < grid_height:
		return true
	return false


func _is_empty_cell(vec: Vector2i) -> bool:
	if data_grid[vec.y][vec.x] == 0:
		return true
	return false

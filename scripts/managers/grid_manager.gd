class_name GridManagerClass
extends Node


## This class manages the creation of grids
## on scene change a method is called that scans the scene for grids (Node with CollisionShape)
## the Collision Shape is then divided into a grid
## when a toggle method is called, the grid is toggled (in)visible
## also this manager contains a method that takes in coordinates to highlight a certain area of the grid
## also this manager manages all the data handling of the grid?

# view grid -> height, width and origin vector in pixel space
var view_grid: GridComponent
var grid_width: int
var grid_height: int
var grid_start: Vector2

var grid_batch_size: Vector2

# data grid -> keep data and track occupancy
var grid: Array = []


# PUBLIC FUNCTIONS
func init_grid(grid_component: GridComponent) -> void:
	print("Init Grids")
	var width: int = grid_component.grid_width
	var height: int = grid_component.grid_height
	view_grid = _init_view_grid(grid_component, width, height)
	grid = _init_data_grid(width, height)
	_print_2d_array(grid)
	print("Grids Init'ed")


func draw_view_grid() -> void:
	view_grid.draw_grid()


# PRIVATE FUNCTIONS
func _init_view_grid(grid_component: GridComponent, h_size: int, v_size: int) -> GridComponent:
	print("Init View Grid from Collision Box")
	
	# take dimensions of collision box
	var d_shape = grid_component.find_child("CollisionShape2D*")
	if !d_shape:
		print("No collision shape found!")
		push_error("No collision shape found!")
		return
	
	var rect = d_shape.shape.get_rect()
	grid_start = d_shape.global_position - (rect.size / 2)
	print("Origin of grid: ", grid_start)
	
	var shape_size = rect.size / Vector2(h_size, v_size)
	print("grid batch size: ", shape_size)
	
	# cut into pieces
	for i in h_size:
		for j in v_size:
			# add new collision box with shape to component
			var new_col_shape: CollisionShape2D = CollisionShape2D.new()
			var new_shape: Shape2D = RectangleShape2D.new()
			new_shape.size = shape_size
			new_col_shape.shape = new_shape
			var new_x = grid_start.x + i * shape_size.x + shape_size.x / 2
			var new_y = grid_start.y + j * shape_size.y + shape_size.y / 2
			new_col_shape.global_position = Vector2(new_x, new_y)
			new_col_shape.debug_color = Color(1.0, 0.49, 1.0, 0.133)
			# spawn new Collision Boxes as children with position calculated
			grid_component.add_child(new_col_shape)
	# delete original one?
	d_shape.queue_free()
	grid_batch_size = shape_size
	return grid_component


func _increment_data_cell(vec: Vector2) -> void:
	grid[int(vec.y)][int(vec.x)] += 1
	_print_2d_array(grid)


func _map_pos_to_data_grid(vec: Vector2) -> Vector2:
	print("Mapping ", vec)
	var res: Vector2 = Vector2()
	var new_x = vec.x - grid_start.x
	new_x /= grid_batch_size.x
	var new_y = vec.y - grid_start.y
	new_y /= grid_batch_size.y
	res.x = int(new_x)
	res.y = int(new_y)
	print("to ", res)
	return res


func _init_data_grid(v_size: int, h_size: int) -> Array:
	print("Init 2D array of dimensions ", v_size, ",", h_size)
	var res = []
	for i in h_size:
		res.append(_init_arr(v_size))
	return res


func _init_arr(size: int) -> Array:
	var res = []
	for i in size:
		res.append(0) # TODO: I read resize might be more efficient?
	return res


func _print_2d_array(arr: Array) -> void:
	print("Printing 2D Array")
	var str: String
	if !arr:
		return
	for i in arr.size():
		str += "\n"
		for j in arr[i].size():
			if j == 0:
				str += "["
			str += str(arr[i][j])
			if j == arr[i].size() - 1:
				str += "]"
			else:
				str += ",\t"
	print(str)

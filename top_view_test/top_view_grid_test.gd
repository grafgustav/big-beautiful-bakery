class_name TopViewGridTest
extends Node2D


# toggle bau mode
var bau_modus: bool = false

# view grid -> height, width and origin vector in pixel space
var view_grid: TopViewGrid
var grid_width: int
var grid_height: int
var grid_start: Vector2

var grid_batch_size: Vector2

# data grid -> keep data and track occupancy
var grid: Array = []

var tilemap: TileMapLayer
var draw_tile: bool = false


func _ready() -> void:
	# init values
	view_grid = %TopViewGrid
	tilemap = %TileMapLayer
	grid_width = view_grid.h_size
	grid_height = view_grid.v_size
	var col_shape: CollisionShape2D = view_grid.find_child("CollisionShape2D")
	if col_shape:
		var rect = col_shape.shape.get_rect()
		grid_start = col_shape.global_position - (rect.size / 2)
		print("Origin of grid: ", grid_start)
	
	# init data grid
	grid = _init_2d_array(grid_width, grid_height)
	_print_2d_array(grid)
	
	# init view grid with collision boxes
	# var d_comp = _init_view_grid(grid_width, grid_height)
	# status quo: one big collision shape that covers the entire grid area
	# status wanted: each cell has their own collision shape (and thus is a grid snap droppable)
	# first try: build the grid and track clicks, then map to data grid and track clicks as increment
	# pass component, connect to click event, map to data grid


func _input(event: InputEvent) -> void:
	if false: #event.is_action_pressed("dragging"):
		print("Dragging just pressed")
		var mouse_pos := get_viewport().get_mouse_position()
		_increment_data_cell(_map_pos_to_data_grid(mouse_pos))


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


func _init_view_grid(h_size: int, v_size: int) -> DroppableComponent:
	print("Init View Grid from Droppable Collision Box")
	# take dimensions of collision box
	var d_comp: DroppableComponent = find_child("DroppableComponent")
	if !d_comp:
		push_error("No droppable component found!")
		return
	
	var d_shape = d_comp.find_child("CollisionShape2D*")
	if !d_shape:
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
			d_comp.add_child(new_col_shape)
	# delete original one?
	d_shape.queue_free()
	grid_batch_size = shape_size
	return d_comp


func _init_2d_array(h_size: int, v_size: int) -> Array:
	print("Init 2D array of dimensions ", h_size, ",", v_size)
	var res = []
	for i in v_size:
		res.append(_init_arr(h_size))
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


func _on_button_pressed() -> void:
	print("Toggling bau mode. Old: ", bau_modus)
	bau_modus = !bau_modus

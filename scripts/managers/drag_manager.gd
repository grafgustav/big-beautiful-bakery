class_name DragManagerClass
extends Node

## this class provides all the functionality for the drag & drop
## all DraggableComponents register here, as well as DroppableComponents
## when an event is registered where a Draggable is being picked up
## the ref is stored here
## when a Droppable is hovered, those refs are also stored here
## to highlight a Droppable, 

signal drag_cursor_moved(draggable: DraggableComponent)
signal drag_stopped

var dragged_object_ref: DraggableComponent


# NODE API
func _physics_process(_delta: float) -> void:
	if GameManager.is_ui_scene():
		return
	# execute actions depending on user input
	if Input.is_action_just_pressed("dragging"):
		init_dragging()
	if !dragged_object_ref:
		return
	if Input.is_action_pressed("dragging"):
		dragged_object_ref.move_to_pos(get_viewport().get_mouse_position(), false)
		drag_cursor_moved.emit(dragged_object_ref)
	if Input.is_action_just_released("dragging"):
		_process_dropping()
		drag_stopped.emit()


# PUBLIC FUNCTIONS
func init_dragging() -> void:
	print("Trying to drag")
	if !dragged_object_ref:
		dragged_object_ref = physics_collider_draggable()
	if !dragged_object_ref:
		# return in case there is no collision with a draggable object
		return
	print("Started dragging: ", dragged_object_ref)
	dragged_object_ref.set_initial_position()
	dragged_object_ref.set_position_offset()


func init_extracted_draggable(draggable: DraggableComponent) -> void:
	dragged_object_ref = draggable
	dragged_object_ref.process_mode = Node.PROCESS_MODE_ALWAYS


func is_dragging() -> bool:
	return dragged_object_ref != null


# PRIVATE FUNCTIONS
func _process_dropping():
	# choose a drop candidate and try dropping an ingredient
	var top_candidate: DroppableComponent = physics_collider_droppable()
	if !top_candidate:
		dragged_object_ref.snap_back_to_initial_position()
		_clean_up_after_drop()
		return
	
	if top_candidate.has_method("drop_ingredient"):
		var _ingredient_dropped: bool = top_candidate.drop_ingredient(_get_ingredient(dragged_object_ref))
		# TODO: What to do with the returned bool?
	
	var vanishing: bool = false
	
	match top_candidate.dropping_type:
		Types.DroppableTypes.FREEDROP:
			dragged_object_ref.tween_to_pos(get_viewport().get_mouse_position(), false)
		Types.DroppableTypes.VANISHING:
			dragged_object_ref.vanish()
			vanishing = true
		Types.DroppableTypes.GRIDSNAP:
			dragged_object_ref.tween_to_pos(_get_grid_snap(top_candidate), false)
		_:
			pass
	
	_clean_up_after_drop(vanishing)


## get the space of the scene and check for intersecting objects on collision 
## layer 2. maybe make the collision layer a parameter and then have different
## layers for draggable and droppable
## TODO: Basically ALWAYS drop on the first droppable we find.
## So this function should just return the top droppable of all colliders
## if it's null, we handle this in another function above
func physics_collider_droppable() -> DroppableComponent:
	print("Physics collider func for obj: ", dragged_object_ref)
	var space := dragged_object_ref.get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_viewport().get_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = 2
	
	var results := space.intersect_point(query)
	results.sort_custom(
		func(a,b):
			return a.collider.z_index > b.collider.z_index
	)
	results = results.filter(
		func(a):
			return a.collider is DroppableComponent
	)
	print("Physics collider results: ", results)
	print("Returning: ", results.front())
	if results.is_empty():
		return null
	else:
		return results.front().collider


func physics_collider_draggable() -> DraggableComponent:
	print("Physics collider func for obj: ", dragged_object_ref)
	var space := GameManager.get_current_physics_space()
	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_viewport().get_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = 2
	
	var results := space.intersect_point(query)
	results.sort_custom(
		func(a,b):
			return a.collider.z_index > b.collider.z_index
	)
	results = results.filter(
		func(a):
			return a.collider is DraggableComponent
	)
	print("Physics collider results: ", results)
	if results.is_empty():
		return null
	else:
		print("Returning: ", results.front())
		return results.front().collider


func _clean_up_after_drop(vanishing: bool = false) -> void:
	# cleaning up draggable ref
	dragged_object_ref = null


func _get_ingredient(draggable: DraggableComponent) -> IngredientData:
	var in_comp = draggable.get_parent().find_child("IngredientComponent") as IngredientComponent
	if in_comp:
		return in_comp.ingredient
	else:
		return null


func _sort_by_z_index(a: Node2D, b: Node2D) -> bool:
	return a.z_index > b.z_index


func _get_top_node(nodes: Array) -> Node2D:
	nodes.sort_custom(_sort_by_z_index)
	return nodes.front()


# GRID SNAPPING
func _get_grid_snap(droppable: DroppableComponent) -> Vector2:
	if droppable is GridComponent:
		return _get_snap_in_grid(droppable)
	else:
		return _get_snap_point_on_surface(droppable)


func _get_snap_in_grid(droppable: DroppableComponent) -> Vector2:
	var grid: GridComponent = droppable
	# determine the snap-point in the grid (highlighted cell)
	var highlighted_cells: Array[Vector2i] = grid.get_highlighted_cells()
	# TODO: what to do, if there are more?
	var first_cell: Vector2i = highlighted_cells.front()
	var res = grid.get_global_pos_center_from_grid_cell(first_cell)
	
	# determine the y-offset we need for the object we are dropping
	
	# return the vector
	return res


func _get_snap_point_on_surface(droppable: DroppableComponent) -> Vector2:
	var collision_shapes_to_collide_with : Array = droppable.find_children("*", "CollisionShape2D")
	var own_collision_shape = dragged_object_ref.find_child("CollisionShape2D")
	var max_collision_shape = _get_max_intersection_collision_shape(own_collision_shape, collision_shapes_to_collide_with)
	var snap_point = max_collision_shape.global_position
	return snap_point


func _get_max_intersection_collision_shape(dings: CollisionShape2D, collisions : Array) -> CollisionShape2D:
	var max_shape: CollisionShape2D = null
	var max_intersection: float = 0.0
	for target_shape in collisions:
		var intersection = _calculate_intersection(dings, target_shape)
		if intersection > max_intersection:
			max_intersection = intersection
			max_shape = target_shape
	return max_shape


func _calculate_intersection(shape_a: CollisionShape2D, shape_b: CollisionShape2D) -> float:
	var poly_a := _shape_to_polygon(shape_a)
	var poly_b := _shape_to_polygon(shape_b)

	if poly_a.size() == 0 or poly_b.size() == 0:
		return 0.0

	var intersection := Geometry2D.intersect_polygons(poly_a, poly_b)
	if intersection.size() == 0:
		return 0.0
	return _polygon_area(intersection[0])


func _shape_to_polygon(shape: CollisionShape2D) -> PackedVector2Array:
	var poly := PackedVector2Array()
	var t := shape.global_transform
	if shape.shape is RectangleShape2D:
			var s = shape.shape.size * 0.5
			poly.append(t * Vector2(-s.x, -s.y))
			poly.append(t * Vector2(s.x, -s.y))
			poly.append(t * Vector2(s.x, s.y))
			poly.append(t * Vector2(-s.x, s.y))
	elif shape.shape is CircleShape2D:
			var r = shape.shape.radius
			var segments := 16
			for i in range(segments):
				var angle := TAU * i / segments
				var local_point = Vector2(cos(angle), sin(angle)) * r
				var world_point = t.origin + t.basis_xform(local_point)
				poly.append(world_point)
	else:
		push_error("Shape type not supported for intersection calculation: ", shape.shape)
	return poly


func _polygon_area(points: PackedVector2Array) -> float:
	var area := 0.0
	var n := points.size()
	for i in range(n):
		var j := (i + 1) % n
		area += points[i].x * points[j].y
		area -= points[j].x * points[i].y
	return abs(area) * 0.5

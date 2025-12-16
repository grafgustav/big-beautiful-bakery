class_name DragManagerClass
extends Node

## this class provides all the functionality for the drag & drop
## all DraggableComponents register here, as well as DroppableComponents
## when an event is registered where a Draggable is being picked up
## the ref is stored here
## when a Droppable is hovered, those refs are also stored here
## to highlight a Droppable, 

signal drag_cursor_moved(pos: Vector2)
signal drag_stopped

var drag_candidates: Array = []
var drop_candidates: Array = []

# to retain hovered draggable-droppable relations Draggable -> Array[Droppables]
var shadow_drop_candidates: Dictionary[DraggableComponent, Array] = {}

var dragged_object_ref: DraggableComponent


# NODE API
func _physics_process(delta: float) -> void:
	# do nothing if no candidate
	if drag_candidates.is_empty():
		return
	
	# execute actions depending on user input
	if Input.is_action_just_pressed("dragging"):
		init_dragging()
	if Input.is_action_pressed("dragging"):
		dragged_object_ref.move_to_pos(get_viewport().get_mouse_position(), true)
		drag_cursor_moved.emit(get_viewport().get_mouse_position())
	if Input.is_action_just_released("dragging"):
		_process_dropping()
		drag_stopped.emit()


# PUBLIC FUNCTIONS
func init_dragging() -> void:
	if !dragged_object_ref:
		dragged_object_ref = _get_top_node(drag_candidates)
	dragged_object_ref.set_initial_position()
	dragged_object_ref.set_position_offset()
	drop_candidates = shadow_drop_candidates.get(dragged_object_ref, [])


func init_extracted_draggable(draggable: DraggableComponent) -> void:
	drag_candidates.append(draggable)
	dragged_object_ref = draggable


func register_draggable(draggable: DraggableComponent) -> void:
	draggable.connect("mouse_entered_draggable", _mouse_entered_draggable)
	draggable.connect("mouse_exited_draggable", _mouse_exited_draggable)
	draggable.connect("draggable_entered_droppable", _area_entered_droppable)
	draggable.connect("draggable_exited_droppable", _area_exited_droppable)


func is_dragging() -> bool:
	return dragged_object_ref != null


# PRIVATE FUNCTIONS
func _process_dropping():
	if drop_candidates.is_empty():
		dragged_object_ref.snap_back_to_initial_position()
		dragged_object_ref = null
		return
	
	# choose a drop candidate and try dropping an ingredient
	var top_candidate: DroppableComponent = _get_top_node(drop_candidates)
	var ingredient_dropped: bool = top_candidate.drop_ingredient(_get_ingredient(dragged_object_ref))
	# TODO: What to do with the returned bool?
	
	var vanishing: bool = false
	
	match top_candidate.dropping_type:
		Types.DroppableTypes.FREEDROP:
			dragged_object_ref.tween_to_pos(get_viewport().get_mouse_position(), false)
		Types.DroppableTypes.VANISHING:
			shadow_drop_candidates.erase(dragged_object_ref)
			drop_candidates.erase(top_candidate)
			dragged_object_ref.vanish()
			vanishing = true
		Types.DroppableTypes.GRIDSNAP:
			dragged_object_ref.tween_to_pos(_get_grid_snap(top_candidate), false)
		_:
			pass
	
	_clean_up_after_drop(vanishing)


func _clean_up_after_drop(vanishing: bool = false) -> void:
	# cleaning up the droppable_candidates
	if !vanishing:
		shadow_drop_candidates[dragged_object_ref] = drop_candidates.duplicate()
	drop_candidates.clear()
	
	# cleaning up draggable ref
	drag_candidates.erase(dragged_object_ref)
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


func _reset_candidates() -> void:
	# reset all candidates and check again, if any are being hovered right now
	drag_candidates = drag_candidates.filter(
		func(c: DraggableComponent): return is_instance_valid(c) and c.mouse_hovered
	)


# EVENT HANDLER
func _mouse_entered_draggable(draggable: DraggableComponent) -> void:
	if !dragged_object_ref:
		drag_candidates.append(draggable)


func _mouse_exited_draggable(draggable: DraggableComponent) -> void:
	if !dragged_object_ref:
		drag_candidates.erase(draggable)


func _area_entered_droppable(draggable: DraggableComponent, droppable: DroppableComponent) -> void:
	if draggable == dragged_object_ref:
		drop_candidates.append(droppable)


func _area_exited_droppable(draggable: DraggableComponent, droppable: DroppableComponent) -> void:
	if draggable == dragged_object_ref:
		drop_candidates.erase(droppable)


# GRID SNAPPING
func _get_grid_snap(droppable: DroppableComponent) -> Vector2:
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

class_name DraggableComponent
extends Area2D

var parent_ref : Node2D
#hier noch ein süßer kommiii
var is_draggable : bool = false

var position_offset : Vector2
var initial_position : Vector2

var droppable_body_ref : Node2D

# use static resource variable instead of global autoload script variable?
static var static_object_dragged : Node2D


func _ready() -> void:
	# merge commit test
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	var parent = self.get_parent()
	if parent && parent is Node2D:
		parent_ref = parent


func _process(delta: float) -> void:
	if is_draggable:
		# snapback functionality needs initial position
		if Input.is_action_just_pressed("dragging"):
			initial_position = parent_ref.global_position
			position_offset = get_global_mouse_position() - parent_ref.global_position
		# following the cursor
		if Input.is_action_pressed("dragging"):
			parent_ref.global_position = get_global_mouse_position() - position_offset
		# logic to either snap back, snap to grid, vanish etc.
		if Input.is_action_just_released("dragging"):
			_process_dropping()


func _process_dropping() -> void:
	# DEBUGS
	print("Processing the DROPPPP")
	print(droppable_body_ref)
	if droppable_body_ref:
		print(_has_body_droppable_component(droppable_body_ref))
		
	if droppable_body_ref == null:
		var tween = get_tree().create_tween()
		tween.tween_property(parent_ref, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)
		return

	if _has_body_droppable_component(droppable_body_ref):
		var droppable_component = _get_droppable_component(droppable_body_ref)
		print("Is Droppable Component")
		match droppable_component.dropping_type:
			Types.DroppableTypes.FREEDROP:
				print("Free dropping")
				global_position = get_global_mouse_position() - position_offset
			Types.DroppableTypes.VANISHING:
				print("Vanishing drop")
				var tween = get_tree().create_tween()
				tween.tween_property(parent_ref, "scale", Vector2(0.1, 0.1), 0.2).set_ease(Tween.EASE_OUT)
				await tween.finished
				parent_ref.queue_free()
			Types.DroppableTypes.GRIDSNAP:
				print("Snapping to grid")
				_get_grid_snap(droppable_component)


func _get_grid_snap(body: DroppableComponent) -> Vector2:
	var collision_shapes_to_collide_with : Array = body.find_children("*", "CollisionShape2D")
	print("Collision shapes found: ", collision_shapes_to_collide_with.size())
	var own_collision_shape = find_child("CollisionShape2D")
	print("Collision shape: ", own_collision_shape)
	var max_collision_shape = _get_max_intersection_collision_shape(own_collision_shape, collision_shapes_to_collide_with)
	print("Max Collision shape: ", max_collision_shape)
	return Vector2(0,0)


func _get_max_intersection_collision_shape(dings: CollisionShape2D, collisions : Array) -> CollisionShape2D:
	var max_shape : CollisionShape2D = null
	var max_intersection : float = 0.0
	for target_shape in collisions:
		var intersection = _calculate_intersection(dings, target_shape)
		if intersection > max_intersection:
			max_intersection = intersection
			max_shape = target_shape
	return max_shape


func shape_to_polygon(shape: CollisionShape2D) -> PackedVector2Array:
	print("Checking shape.shape: ", shape.shape)
	var poly := PackedVector2Array()
	var t := shape.global_transform
	if shape.shape is RectangleShape2D:
			var s = shape.shape.size * 0.5
			print(s)
			poly.append(t * Vector2(-s.x, -s.y))
			poly.append(t * Vector2(s.x, -s.y))
			poly.append(t * Vector2(s.x, s.y))
			poly.append(t * Vector2(-s.x, s.y))
	elif shape.shape is CircleShape2D:
			var r = shape.shape.radius
			var segments := 16  # increase for smoother circle
			for i in range(segments):
				var angle := TAU * i / segments
				poly.append(t * Vector2(cos(angle), sin(angle)) * r)
	else:
			print("Shape type not supported for intersection calculation: ", shape.shape)
	print("Returning poly: ", poly)
	return poly


func polygon_area(points: PackedVector2Array) -> float:
	var area := 0.0
	var n := points.size()
	for i in range(n):
		var j := (i + 1) % n
		area += points[i].x * points[j].y
		area -= points[j].x * points[i].y
	return abs(area) * 0.5


func _calculate_intersection(shape_a: CollisionShape2D, shape_b: CollisionShape2D) -> float:
	var poly_a := shape_to_polygon(shape_a)
	var poly_b := shape_to_polygon(shape_b)

	if poly_a.size() == 0 or poly_b.size() == 0:
		return 0.0

	var intersection := Geometry2D.intersect_polygons(poly_a, poly_b)
	if intersection.size() == 0:
		return 0.0
	return polygon_area(intersection[0])


func _on_mouse_entered() -> void:
	if static_object_dragged:
		return
	static_object_dragged = self
	is_draggable = true
	parent_ref.scale = Vector2(1.1, 1.1)
	scale = Vector2(1.5, 1.5) # when moving the cursor too quickly, we leave the hitbox and lose the dragged object :(


func _on_mouse_exited() -> void:
	if static_object_dragged == self:
		static_object_dragged = null
	is_draggable = false
	parent_ref.scale = Vector2(1, 1)
	scale = Vector2(1, 1)


func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.get_parent().name)
	if _has_body_droppable_component(body.get_parent()):
		droppable_body_ref = body.get_parent()


func _on_body_exited(body: Node2D) -> void:
	# reset values without condition to be safe?
	droppable_body_ref = null


func _get_rect_overlap() -> float:
	# TODO: Implement
	return 0.0


func _has_body_droppable_component(body: Node2D) -> bool:
	var child = body.find_child("DroppableComponent")
	return child != null


func _get_droppable_component(body: Node2D) -> DroppableComponent:
	var child = body.find_child("DroppableComponent")
	return child
	

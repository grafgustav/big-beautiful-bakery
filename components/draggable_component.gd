class_name DraggableComponent
extends Area2D


var parent_ref : Node2D
var is_draggable : bool = false # if it is possible to drag the object
var is_dragging : bool = false # if the object is currently being dragged

var position_offset : Vector2
var initial_position : Vector2

# make it a list or dict
var hovered_droppable_bodies: Array[Node2D]

# use static resource variable instead of global autoload script variable?
static var static_object_dragged : Node2D # the object that is currently being dragged


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	hovered_droppable_bodies = []
	
	var parent = self.get_parent()
	if parent && parent is Node2D:
		parent_ref = parent


func _process(_delta: float) -> void:
	if is_draggable:
		if Input.is_action_just_pressed("dragging"):
			initial_position = parent_ref.global_position
			position_offset = get_global_mouse_position() - parent_ref.global_position
			is_dragging = true
		if Input.is_action_pressed("dragging"):
			parent_ref.global_position = get_global_mouse_position() - position_offset
		if Input.is_action_just_released("dragging"):
			_process_dropping()


func _get_ingredient() -> IngredientData:
	var in_comp = parent_ref.find_child("IngredientComponent") as IngredientComponent
	if in_comp:
		return in_comp.ingredient
	else:
		push_error("Parent does not contain an Ingredient Component")
		return null


func _process_dropping() -> void:
	is_dragging = false
	if hovered_droppable_bodies.is_empty():
		_snap_back_to_initial_position()
	else:
		var closest_droppable_body = _get_closest_droppable_body(hovered_droppable_bodies)
		var droppable_component = _get_droppable_component(closest_droppable_body)
		var dropped: bool = droppable_component.drop_ingredient(_get_ingredient())
		if !dropped:
			_snap_back_to_initial_position()
			return
		match droppable_component.dropping_type:
			Types.DroppableTypes.FREEDROP:
				global_position = get_global_mouse_position() - position_offset
			Types.DroppableTypes.VANISHING:
				var tween = get_tree().create_tween()
				tween.tween_property(parent_ref, "scale", Vector2(0.1, 0.1), 0.2).set_ease(Tween.EASE_OUT)
				await tween.finished
				parent_ref.queue_free()
			Types.DroppableTypes.GRIDSNAP:
				var tween = get_tree().create_tween()
				tween.tween_property(parent_ref, "global_position", _get_grid_snap(droppable_component), 0.2).set_ease(Tween.EASE_OUT)


func _get_closest_droppable_body(bodies: Array[Node2D]) -> Node2D:
	# TODO: Evaluate, if this is even necessary
	# get the bodies droppable children
	
	# get their collision shapes
	
	# get max collision shape intersection
	
	# return the original body of that...
	return bodies[0]


func _snap_back_to_initial_position() -> void:
	if initial_position:
		var tween = get_tree().create_tween()
		tween.tween_property(parent_ref, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)
	else:
		parent_ref.queue_free()


func _get_grid_snap(body: DroppableComponent) -> Vector2:
	var collision_shapes_to_collide_with : Array = body.find_children("*", "CollisionShape2D")
	var own_collision_shape = find_child("CollisionShape2D")
	var max_collision_shape = _get_max_intersection_collision_shape(own_collision_shape, collision_shapes_to_collide_with)
	var snap_point = max_collision_shape.global_position
	return snap_point


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


func _on_mouse_exited() -> void:
	if is_dragging:
		return
	if static_object_dragged == self:
		static_object_dragged = null
	is_draggable = false
	parent_ref.scale = Vector2(1, 1)


func _on_area_entered(body: Node2D) -> void:
	# auch hier muss man eigentlich schnittmengen berechnen
	print("Area entered: ", body)
	if _has_body_droppable_component(body.get_parent()):
		print("Is droppable -> Setting body_ref")
		hovered_droppable_bodies.append(body.get_parent())
		print("Hovered bodies: ", hovered_droppable_bodies)


func _on_area_exited(body: Node2D) -> void:
	print("Area exited: ", body)
	hovered_droppable_bodies.erase(body.get_parent())
	print("Hovered bodies: ", hovered_droppable_bodies)


func _has_body_droppable_component(body: Node2D) -> bool:
	var child = body.find_child("DroppableComponent")
	return child != null


func _get_droppable_component(body: Node2D) -> DroppableComponent:
	var child = body.find_child("DroppableComponent")
	return child


func set_initial_position(pos: Vector2) -> void:
	initial_position = pos

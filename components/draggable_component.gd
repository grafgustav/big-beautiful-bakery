class_name DraggableComponent
extends Area2D

@export var item : Types.Items

var parent_ref : Node2D
var is_draggable : bool = false # if it is possible to drag the object
var is_dragging : bool = false # if the object is currently being dragged

var position_offset : Vector2
var initial_position : Vector2

var droppable_body_ref : Node2D

# use static resource variable instead of global autoload script variable?
static var static_object_dragged : Node2D


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
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


func _process_dropping() -> void:
	is_dragging = false
	if droppable_body_ref == null:
		_snap_back_to_initial_position()
	else:
		var droppable_component = _get_droppable_component(droppable_body_ref)
		var dropped: bool = droppable_component.drop_item(item)
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
	var snap_point = _calculate_snapping_point(max_collision_shape)
	return snap_point


func _calculate_snapping_point(shape: CollisionShape2D) -> Vector2:
	# calculates the center point of the collisionshape
	return shape.global_position


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
	# when moving the cursor too quickly, we leave the hitbox and lose the dragged object :(
	# so I scale the hitbox of the cursor, but maybe there are better solutions...
	scale = Vector2(1.5, 1.5) 


func _on_mouse_exited() -> void:
	if is_dragging:
		return
	if static_object_dragged == self:
		static_object_dragged = null
	is_draggable = false
	parent_ref.scale = Vector2(1, 1)
	scale = Vector2(1, 1)


func _on_area_entered(body: Node2D) -> void:
	if _has_body_droppable_component(body.get_parent()):
		droppable_body_ref = body.get_parent()


func _on_area_exited(_body: Node2D) -> void:
	# reset values without condition to be safe?
	droppable_body_ref = null


# I don't think we need this, because of the mask we KNOW it is a droppable component, no?
# except, actually, we use the same mask and layer for both droppables and draggables
# also an idea was to design your own bakery later, that's when this modular system comes in handy
func _has_body_droppable_component(body: Node2D) -> bool:
	var child = body.find_child("DroppableComponent")
	return child != null


func _get_droppable_component(body: Node2D) -> DroppableComponent:
	var child = body.find_child("DroppableComponent")
	return child

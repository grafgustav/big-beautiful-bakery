#helloooo
class_name DraggableComponent
extends Area2D

var parent_ref : Node2D

var is_draggable : bool = false
var is_droppable : bool = false

var position_offset : Vector2
var initial_position : Vector2

var droppable_body_ref : Node2D

# use static resource variable instead of global autoload script variable?
static var static_object_dragged : Node2D


func _ready() -> void:
	
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
	if droppable_body_ref is DroppableComponent:
		pass # TODO: Implement Droppables
	var tween = get_tree().create_tween()
	if is_droppable:
		tween.tween_property(parent_ref, "global_position", droppable_body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(parent_ref, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)
	

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
	if _has_body_droppable_component(body):
		is_droppable = true
		droppable_body_ref = body


func _on_body_exited(body: Node2D) -> void:
	# reset values without condition to be safe?
	is_droppable = false
	droppable_body_ref = null


# actually: maybe get shape with highest overlap instead, inputting a list of shapes?
# Area2D -> [CollisionShape2D]
func _get_nearest_droppable_shape(droppable_area : Area2D, colliding_area : Node2D) -> CollisionShape2D:
	var droppable_shapes = droppable_area.find_children("*", "CollisionShape2D")
	if droppable_shapes.size() == 1:
		return droppable_shapes[0]
	var winner_overlap : float = 0.0
	var winner_shape : CollisionShape2D = null
	# get all children that are shapes
	var all_shapes = droppable_area.get
	#for cur_shape in 
	
	# calculate overlap of children (save only highest and value)
	
	# return child with highest overlap
	return null


func _has_body_droppable_component(body: Node2D) -> bool:
	var child = body.get_parent().find_child("DroppableComponent")
	return child != null

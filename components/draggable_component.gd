class_name DraggableComponent
extends Area2D

var parent_ref : Node2D

var is_draggable : bool = false
var is_droppable : bool = false

var position_offset : Vector2
var initial_position : Vector2

var droppable_body_ref : Node2D


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
		pass
	var tween = get_tree().create_tween()
	if is_droppable:
		tween.tween_property(parent_ref, "global_position", droppable_body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(parent_ref, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)
	

func _on_mouse_entered() -> void:
	if Global.dragged_object:
		return
	Global.dragged_object = self
	is_draggable = true
	parent_ref.scale = Vector2(1.1, 1.1)
	scale = Vector2(1.5, 1.5) # when moving the cursor too quickly, we leave the hitbox and lose the dragged object :(


func _on_mouse_exited() -> void:
	if Global.dragged_object == self:
		Global.dragged_object = null
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


func _has_body_droppable_component(body: Node2D) -> bool:
	var child = body.find_child("DroppableComponent")
	print("body has children: ", child)
	return child != null

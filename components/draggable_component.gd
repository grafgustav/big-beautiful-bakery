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
		print("parent_ref set: " + parent_ref.to_string())


func _physics_process(delta: float) -> void:
	if is_draggable:
		if Input.is_action_just_pressed("dragging"):
			initial_position = parent_ref.global_position
			position_offset = get_global_mouse_position() - parent_ref.global_position
		if Input.is_action_pressed("dragging"):
			parent_ref.global_position = get_global_mouse_position() - position_offset
		if Input.is_action_just_released("dragging"):
			var tween = get_tree().create_tween()
			if is_droppable:
				tween.tween_property(parent_ref, "global_position", droppable_body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(parent_ref, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)


func _on_mouse_entered() -> void:
	print("Mouse entered")
	is_draggable = true
	parent_ref.scale = Vector2(1.1, 1.1)


func _on_mouse_exited() -> void:
	print("Mouse exited")
	is_draggable = false
	parent_ref.scale = Vector2(1, 1)


func _on_body_entered(body: Node2D) -> void:
	print("Body entered")
	is_droppable = true
	droppable_body_ref = body


func _on_body_exited(body: Node2D) -> void:
	print("Body exited")
	is_droppable = false
	droppable_body_ref = null

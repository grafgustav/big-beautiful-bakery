class_name DoughClass
extends Node2D

var is_draggable : bool = false
var is_droppable : bool = false
var dragging : bool = false
var position_offset : Vector2
var body_ref : Node2D
var initial_position : Vector2

func _process(_delta: float) -> void:
	if is_draggable:
		if Input.is_action_just_pressed("dragging"):
			initial_position = global_position
			position_offset = get_global_mouse_position() - global_position
		if Input.is_action_pressed("dragging"):
			global_position = get_global_mouse_position() - position_offset
		if Input.is_action_just_released("dragging"):
			var tween = get_tree().create_tween()
			if is_droppable:
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)


func _on_area_2d_mouse_entered() -> void:
	is_draggable = true
	scale = Vector2(1.1, 1.1)


func _on_area_2d_mouse_exited() -> void:
	is_draggable = false
	scale = Vector2(1, 1)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Body entered")
	is_droppable = true
	body_ref = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Body exited")
	is_droppable = false
	body_ref = null

class_name DraggableComponent
extends Area2D


var parent_ref : Node2D
var position_offset : Vector2
var initial_position : Vector2

var mouse_hovered: bool = false


# NODE API OVERRIDES
func _ready() -> void:
	var parent = self.get_parent()
	if parent && parent is Node2D:
		parent_ref = parent


# PUBLIC FUNCTIONS
func vanish() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(parent_ref, "scale", Vector2(0.1, 0.1), 0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	parent_ref.queue_free()


func snap_back_to_initial_position() -> void:
	if initial_position:
		var tween = get_tree().create_tween()
		tween.tween_property(parent_ref, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)
	else:
		parent_ref.queue_free()


func set_initial_position(pos: Vector2 = get_parent().global_position) -> void:
	initial_position = pos


func set_position_offset() -> void:
	position_offset = get_global_mouse_position() - parent_ref.global_position


func move_to_pos(pos: Vector2, use_offset: bool) -> void:
	var target = pos - position_offset if use_offset else pos
	get_parent().global_position = target


func tween_to_pos(pos: Vector2, use_offset: bool) -> void:
	var tween = get_tree().create_tween()
	var target = pos - position_offset if use_offset else pos
	tween.tween_property(parent_ref, "global_position", target, 0.2).set_ease(Tween.EASE_OUT)


# PRIVATE FUNCTIONS
func _get_ingredient() -> IngredientData:
	var in_comp = parent_ref.find_child("IngredientComponent") as IngredientComponent
	if in_comp:
		return in_comp.ingredient
	else:
		push_error("Parent does not contain an Ingredient Component")
		return null

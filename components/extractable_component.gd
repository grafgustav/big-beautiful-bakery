class_name ExtractableComponent
extends Area2D


signal extracted

@export var extractable_ingredient : IngredientData
var is_extractable : bool = false


func _ready() -> void:
	input_pickable = true
	connect("input_event", _on_input_event)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_extractable and event.is_action_pressed("dragging") && !GameManager.building_mode:
		_start_drag()


func _get_scene_node() -> Node:
	return IngredientFactory.instantiate_from_model(extractable_ingredient)


func _start_drag() -> void:
	if extractable_ingredient == null:
		push_error("No extractable_ingredient defined for ExtractableComponent.")
		return
	
	if DragManager.is_dragging():
		print("Already dragging some object")
		return

	var _dragged_item = _get_scene_node()
	if not _dragged_item:
		push_error("extractable_ingredient must be a Node2D scene.")
		return

	get_tree().current_scene.add_child(_dragged_item)
	_dragged_item.global_position = get_global_mouse_position()
	var drag_comp := _dragged_item.find_child("DraggableComponent")
	DragManager.init_extracted_draggable(drag_comp)
	
	extracted.emit()


func _on_mouse_entered() -> void:
	is_extractable = true


func _on_mouse_exited() -> void:
	is_extractable = false

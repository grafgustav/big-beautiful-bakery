class_name ExtractableComponent
extends Area2D


signal extracted

@export var extractable_item : PackedScene
var _dragging := false
var _dragged_item : Node2D = null


func _ready() -> void:
	input_pickable = true
	connect("input_event", Callable(self, "_on_input_event"))


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("dragging"):
		_start_drag()


func _start_drag() -> void:
	if extractable_item == null:
		push_error("No extractable_item defined for ExtractableComponent.")
		return

	if _dragging:
		return

	_dragging = true

	_dragged_item = extractable_item.instantiate() as Node2D
	if not _dragged_item:
		push_error("extractable_item must be a Node2D scene.")
		_dragging = false
		return

	get_tree().current_scene.add_child(_dragged_item)
	_dragged_item.global_position = get_global_mouse_position()
	
	extracted.emit()

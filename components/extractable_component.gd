class_name ExtractableComponent
extends Area2D


signal extracted

@export var extractable_item : PackedScene
var _dragging := false
var _dragged_item : Node2D = null


func _ready() -> void:
	# Make sure we can receive input events (clicks)
	input_pickable = true
	connect("input_event", Callable(self, "_on_input_event"))


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Handle mouse press to start dragging
	if event.is_action("dragging"):
		_start_drag()


func _start_drag() -> void:
	if extractable_item == null:
		push_warning("No extractable_item defined for ExtractableComponent.")
		return

	if _dragging:
		return

	_dragging = true

	# Instantiate the extractable item
	_dragged_item = extractable_item.instantiate() as Node2D
	if not _dragged_item:
		push_error("extractable_item must be a Node2D scene.")
		_dragging = false
		return

	# Add to the scene (usually to the same parent or to a top-level node)
	get_tree().current_scene.add_child(_dragged_item)
	_dragged_item.global_position = get_global_mouse_position()
	
	extracted.emit()

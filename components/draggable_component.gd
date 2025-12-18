class_name DraggableComponent
extends Area2D


signal mouse_entered_draggable(draggable: DraggableComponent)
signal mouse_exited_draggable(draggable: DraggableComponent)
signal draggable_entered_droppable(draggable: DraggableComponent, droppable: DroppableComponent)
signal draggable_exited_droppable(draggable: DraggableComponent, droppable: DroppableComponent)


var parent_ref : Node2D
var position_offset : Vector2
var initial_position : Vector2

var mouse_hovered: bool = false


# NODE API OVERRIDES
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	var parent = self.get_parent()
	if parent && parent is Node2D:
		parent_ref = parent
	
	DragManager.register_draggable(self)


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


func _has_body_droppable_component(body: Node2D) -> bool:
	var child = body.find_child("DroppableComponent")
	return child != null


# EVENT HANDLERS
func _on_mouse_entered() -> void:
	mouse_entered_draggable.emit(self)
	mouse_hovered = true
	# parent_ref.scale = Vector2(1.1, 1.1)


func _on_mouse_exited() -> void:
	mouse_exited_draggable.emit(self)
	mouse_hovered = false
	parent_ref.scale = Vector2(1, 1)


func _on_area_entered(body: Node2D) -> void:
	if _has_body_droppable_component(body.get_parent()):
		draggable_entered_droppable.emit(self, body)


func _on_area_exited(body: Node2D) -> void:
	if _has_body_droppable_component(body.get_parent()):
		draggable_exited_droppable.emit(self, body)

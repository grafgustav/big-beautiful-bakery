class_name DragManagerClass
extends Node


## this class provides all the functionality for the drag & drop
## all DraggableComponents register here, as well as DroppableComponents
## when an event is registered where a Draggable is being picked up
## the ref is stored here
## when a Droppable is hovered, those refs are also stored here
## to highlight a Droppable, 

var dragged_object_ref: Node


func register_draggable(draggable: DraggableComponent) -> void:
	draggable.connect("drag_started", _start_dragging)


func _start_dragging(ref: DraggableComponent) -> void:
	dragged_object_ref = ref


func register_droppable(droppable: DroppableComponent) -> void:
	pass

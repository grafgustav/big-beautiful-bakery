class_name DebugCanvasLayer
extends CanvasLayer

@onready var mouse_label: Label = %CoordinatesLabel

func _process(_delta):
	var global_pos = get_viewport().get_mouse_position()
	mouse_label.text = "(%.1f, %.1f)" % [global_pos.x, global_pos.y]

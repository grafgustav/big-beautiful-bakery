class_name DialogManagerClass
extends Node

# handles dialog creation
var confirm_dialog: Control = preload("res://ui/confirm_dialog.tscn").instantiate()
var func_to_execute: Callable


func _ready() -> void:
	init_dialog()


func init_dialog() -> void:
	add_child(confirm_dialog)
	confirm_dialog.z_index = RenderingServer.CANVAS_ITEM_Z_MAX
	confirm_dialog.hide()
	confirm_dialog.cancelled.connect(hide_confirm_dialog)
	confirm_dialog.confirmed.connect(_execute_confirm_action)


func show_confirm_dialog(ex: Callable) -> void:
	func_to_execute = ex
	confirm_dialog.show()


func hide_confirm_dialog() -> void:
	confirm_dialog.hide()


func _execute_confirm_action() -> void:
	if func_to_execute:
		func_to_execute.call()
	hide_confirm_dialog()

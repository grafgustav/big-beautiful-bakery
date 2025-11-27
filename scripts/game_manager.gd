class_name GameManagerClass
extends Node
# manages the game state and the main game loop
# switches between menu and game levels


var main_menu_scene_file: String = "res://ui/main_menu.tscn"
var confirm_dialog: Control = preload("res://ui/confirm_dialog.tscn").instantiate()

var current_scene: Node
var building_mode: bool = false


func _ready() -> void:
	add_child(confirm_dialog)
	confirm_dialog.z_index = RenderingServer.CANVAS_ITEM_Z_MAX
	confirm_dialog.hide()
	confirm_dialog.confirmed.connect(change_to_main_menu)
	confirm_dialog.cancelled.connect(hide_confirm_dialog)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		show_confirm_dialog()


func show_confirm_dialog() -> void:
	confirm_dialog.show()


func hide_confirm_dialog() -> void:
	confirm_dialog.hide()


func change_to_main_menu() -> void:	
	print("Changing to main menu")
	get_tree().change_scene_to_file(main_menu_scene_file)
	hide_confirm_dialog()

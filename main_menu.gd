class_name MainMenu
extends CanvasLayer


signal bakery_scene_button_pressed
signal test_scene_button_pressed


@export var main_scene: PackedScene
@export var test_scene: PackedScene


func _on_main_scene_button_pressed() -> void:
	print("emitting signal main")
	bakery_scene_button_pressed.emit()


func _on_test_scene_button_pressed() -> void:
	print("emitting signal test")
	test_scene_button_pressed.emit()


func _on_shop_button_pressed() -> void:
	pass # Replace with function body.


func _on_building_mode_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()

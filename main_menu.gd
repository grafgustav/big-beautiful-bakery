class_name MainMenu
extends Control


@export var main_scene: PackedScene
@export var test_scene: PackedScene


func _on_main_scene_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)


func _on_test_scene_button_pressed() -> void:
	get_tree().change_scene_to_packed(test_scene)


func _on_shop_button_pressed() -> void:
	pass # Replace with function body.


func _on_building_mode_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()

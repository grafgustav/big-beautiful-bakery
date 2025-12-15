class_name TopViewGridTest
extends Node2D


func _on_button_pressed() -> void:
	print("Toggling bau mode.")
	GameManager.toggle_building_mode()

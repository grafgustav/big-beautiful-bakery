extends CanvasLayer


func _on_exit_button_pressed() -> void:
	GameManager.poll_exit()

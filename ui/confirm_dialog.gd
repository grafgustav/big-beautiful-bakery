class_name ConfirmDialog
extends Control


signal confirmed
signal cancelled


func _on_confirm_button_pressed() -> void:
	confirmed.emit()


func _on_cancel_button_pressed() -> void:
	cancelled.emit()

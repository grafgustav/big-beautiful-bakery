class_name ConfirmDialog
extends CanvasLayer


signal confirmed
signal cancelled


func show_dialog() -> void:
	self.show()


func hide_dialog() -> void:
	self.hide()


func _on_confirm_button_pressed() -> void:
	confirmed.emit()


func _on_cancel_button_pressed() -> void:
	cancelled.emit()

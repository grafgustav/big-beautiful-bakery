class_name DebugCanvasLayer
extends CanvasLayer


@onready var mouse_label: Label = %CoordinatesLabel
@onready var money_label: Label = %MoneyLabel
@onready var xp_label: Label = %XPLabel


func _process(_delta):
	var global_pos = get_viewport().get_mouse_position()
	mouse_label.text = "(%.1f, %.1f)" % [global_pos.x, global_pos.y]
	money_label.text = str(PlayerManager.money, "$")
	xp_label.text = str(PlayerManager.xp, "XP")


func _on_bau_button_pressed() -> void:
	print("Switching to BAUMODUS!")
	GameManager.toggle_building_mode()


func _on_exit_button_pressed() -> void:
	print("Exiting")
	GameManager.poll_exit()

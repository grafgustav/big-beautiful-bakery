class_name Shop
extends CanvasLayer


var selected_item: int

@onready var left_panel := %LeftItemList


func _ready() -> void:
	# TODO: Load everything from a central register of items (ItemManager?)
	pass

func _on_exit_button_pressed() -> void:
	GameManager.poll_exit()


func _change_selected_item(item: int) -> void:
	_untoggle_other_buttons(1)


func _on_mixer_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_change_selected_item(1)
		print("Mixer selected")
	else:
		print("Mixer deselected")


func _untoggle_other_buttons(button: int) -> void:
	var item_buttons := left_panel.find_children("*Button")
	print("Buttons found in Panel: ", item_buttons)

class_name InventoryButton
extends CustomIconButton


signal inventory_button_pressed(item: InventoryItem)

@export var item: InventoryItem


var amount: int:
	set(value):
		if value < 0:
			push_error("Inventory amount cannot be negative!")
		else:
			amount = value


func _handle_button_pressed() -> void:
	print("Handling button event for item: ", item)
	inventory_button_pressed.emit(item)

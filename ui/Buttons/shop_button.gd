class_name ShopButton
extends CustomIconButton


signal shop_button_pressed(toggled: bool, item: ShopItem)


var item: ShopItem


func _ready() -> void:
	connect("toggled", _handle_button_toggled)


func _handle_button_toggled(toggled: bool) -> void:
	print("Handling button event for item: ", item)
	shop_button_pressed.emit(toggled, item)

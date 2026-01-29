class_name InventoryOverlay
extends CanvasLayer


var inventory_button_scene := preload("res://ui/Buttons/inventory_button.tscn")
@onready var hbox = $PanelContainer/HBoxContainer

var item_list: Array[InventoryItem]


func _ready() -> void:
	InventoryManager.connect("inventory_changed", _rebuild_inventory)
	GameManager.connect("building_mode_switched", _handle_building_mode_change)
	_rebuild_inventory()


func _rebuild_inventory() -> void:
	# get list of inventory
	item_list = InventoryManager.get_inventory()
	print("Rebuilding inventory with items: ", item_list)
	
	# clear list of items
	for child in hbox.get_children():
		child.queue_free()
	
	# for each item -> create new Texture Button
	for i in item_list.size():
		var item: InventoryItem = item_list[i]
		print("Adding item: ", item)
		var button: InventoryButton = inventory_button_scene.instantiate()
		button.custom_icon = item.icon
		button.custom_text = str(item.quantity)
		button.item = item
		
		button.connect("inventory_button_pressed", _handle_button_pressed)
		
		hbox.add_child(button)


func _handle_building_mode_change(bm: bool) -> void:
	if bm:
		_rebuild_inventory()


func _handle_button_pressed(item: InventoryItem) -> void:
	print("Inventory Overlay handling button pressed")
	InventoryManager.extract_item(item)

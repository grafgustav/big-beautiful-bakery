class_name InventoryOverlay
extends CanvasLayer


var inventory_button_scene := preload("res://ui/InventoryButton.tscn") # TODO: define inventory button scene
@onready var hbox = $PanelContainer/HBoxContainer

var item_list: Array[InventoryItem]

func _ready() -> void:
	InventoryManager.connect("inventory_changed", _rebuild_inventory)
	_rebuild_inventory()


func _rebuild_inventory() -> void:
	# get list of inventory
	item_list = InventoryManager.get_inventory()
	
	# clear list of items
	for child in hbox.get_children():
		child.queue_free()
	
	# for each item -> create new Texture Button
	for i in item_list.size():
		var item = item_list[i]
		print("Adding item: ", item)
		var button = inventory_button_scene.instantiate()
		button.icon = item.data.icon
		button.text = str(item.quantity)
		button.list_id = i
		
		button.connect("inventory_button_pressed", _handle_button_pressed)
		
		hbox.add_child(button)


func _handle_button_pressed(list_id: int) -> void:
	print("Inventory Overlay handling button pressed")
	InventoryManager.extract_item(item_list[list_id])

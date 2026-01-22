class_name InventoryManagerClass
extends Node

## This manager manages the inventory.
## Nice and descriptive docs!

signal inventory_changed

var _inventory: Array[InventoryItem] = []

var inventory_container: HBoxContainer


# API FUNCTIONS
func _ready() -> void:
	_create_sample_data()
	pass


# PUBLIC FUNCTIONS
func show_inventory() -> void:
	pass


func hide_inventory() -> void:
	pass


func get_inventory() -> Array:
	return _inventory


func get_inventory_count() -> int:
	return _inventory.size()


func add_item(data: MachineData, amount: int = 1) -> void:
	for item in _inventory:
		if item.data == data && item.quantity <= item.data.max_stack:
			item.quantity += amount
			return
	
	var new_item := InventoryItem.new()
	new_item.data = data
	new_item.quantity = amount
	_inventory.append(new_item)
	
	inventory_changed.emit()


func remove_item(item: InventoryItem) -> void:
	_inventory.erase(item)
	inventory_changed.emit()


func has_item(item: InventoryItem) -> bool:
	return _inventory.has(item)


func extract_item(item: InventoryItem) -> void:
	print("Extracting item: ", item)
	if item == null:
		push_error("No extractable_ingredient defined for ExtractableComponent.")
		return
	
	if DragManager.is_dragging():
		print("Already dragging some object")
		return

	var _dragged_item = _instantiate_from_model(item)
	if not _dragged_item:
		push_error("Data must contain a Node2D scene.")
		return

	var current_scene = GameManager.get_current_scene()
	current_scene.add_child(_dragged_item)
	_dragged_item.global_position = get_viewport().get_mouse_position()
	
	var drop_com := _dragged_item.find_child("DroppableComponent")
	if drop_com:
		drop_com.process_mode = Node.PROCESS_MODE_DISABLED
	
	var drag_comp := _dragged_item.find_child("DraggableComponent")
	DragManager.init_extracted_draggable(drag_comp)
	
	print("Drag Comp extracted with collision: ", drag_comp.collision_layer, " &mask: ", drag_comp.collision_mask)
	
	_decrease_item_quantity(item)


# PRIVATE FUNCTIONS
func _create_sample_data() -> void:
	var table_mixer_data = preload("res://scenes/machines/Mixer/table_mixer.tres")
	add_item(table_mixer_data, 1)
	
	var salt_bag_data = preload("res://scenes/decorations/saltbag.tres")
	add_item(salt_bag_data, 3)
	
	var flour_bag_data = preload("res://scenes/decorations/flourbag.tres")
	add_item(flour_bag_data, 2)


func _instantiate_from_model(model: InventoryItem) -> Node:
	var scene := model.data.machine_scene
	return scene.instantiate()


func _decrease_item_quantity(item: InventoryItem) -> void:
	# decrease the quantity of the item
	item.quantity -= 1
	if item.quantity <= 0:
		remove_item(item)

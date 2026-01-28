class_name ItemManagerClass
extends Node


var ingredient_list: Array[IngredientComponent] = []
var machine_list: Array[Node2D] = []
var draggable_list: Array[DraggableComponent] = []
var droppable_list: Array[DroppableComponent] = []


func register_ingredient(ingredient: IngredientComponent) -> void:
	ingredient_list.append(ingredient)


func deregister_ingredient(ingredient: IngredientComponent) -> void:
	ingredient_list.erase(ingredient)


func register_machine(machine: Node2D) -> void:
	print("Registering machine: ", machine)
	machine_list.append(machine)
	var draggable: DraggableComponent = machine.find_child("DraggableComponent")
	if draggable:
		draggable_list.append(draggable)
		draggable.process_mode = Node.PROCESS_MODE_ALWAYS


func deregister_machine(machine: Node2D) -> void:
	machine_list.erase(machine)
	var draggable: DraggableComponent = machine.find_child("DraggableComponent")
	if draggable:
		draggable_list.erase(draggable)


func hide_all_ingredients() -> void:
	print("Hiding ", ingredient_list.size(), " ingredients")
	for ingredient in ingredient_list:
		ingredient.hide()


func show_all_ingredients() -> void:
	print("Hiding ", ingredient_list.size(), " ingredients")
	for ingredient in ingredient_list:
		ingredient.show()


func activate_draggable_on_machines() -> void:
	for draggable in draggable_list:
		draggable.process_mode = Node.PROCESS_MODE_ALWAYS


func deactivate_draggable_on_machines() -> void:
	for draggable in draggable_list:
		draggable.process_mode = Node.PROCESS_MODE_DISABLED


func deactivate_droppables_on_machines() -> void:
	print("Deactivating droppables")
	var furniture_list: Array[Node] = get_tree().get_nodes_in_group("furniture")
	print("Furnitures: ", furniture_list)
	for machine in furniture_list:
		var droppable: DroppableComponent = machine.find_child("DroppableComponent")
		if droppable:
			droppable_list.append(droppable)
			droppable.process_mode = Node.PROCESS_MODE_DISABLED


func activate_droppables_on_machines() -> void:
	print("Activating droppables")
	for droppable in droppable_list:
		droppable.process_mode = Node.PROCESS_MODE_ALWAYS

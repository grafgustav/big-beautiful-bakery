class_name ItemManagerClass
extends Node


var ingredient_list: Array[IngredientComponent] = []
var machine_list: Array[Node2D] = []
var draggable_list: Array[DraggableComponent] = []


func register_ingredient(ingredient: IngredientComponent) -> void:
	ingredient_list.append(ingredient)


func deregister_ingredient(ingredient: IngredientComponent) -> void:
	ingredient_list.erase(ingredient)


func register_machine(machine: Node2D) -> void:
	machine_list.append(machine)


func deregister_machine(machine: Node2D) -> void:
	machine_list.erase(machine)


func hide_all_ingredients() -> void:
	print("Hiding ", ingredient_list.size(), " ingredients")
	for ingredient in ingredient_list:
		ingredient.hide()


func show_all_ingredients() -> void:
	print("Hiding ", ingredient_list.size(), " ingredients")
	for ingredient in ingredient_list:
		ingredient.show()


func activate_draggable_on_machines() -> void:
	var machine_list: Array[Node] = get_tree().get_nodes_in_group("furniture")
	print("Furnitures: ", machine_list)
	for machine in machine_list:
		var draggable: DraggableComponent = machine.find_child("DraggableComponent")
		if draggable:
			draggable_list.append(draggable)
			draggable.process_mode = Node.PROCESS_MODE_ALWAYS
	

func deactivate_draggable_on_machines() -> void:
	for draggable in draggable_list:
		draggable.process_mode = Node.PROCESS_MODE_DISABLED

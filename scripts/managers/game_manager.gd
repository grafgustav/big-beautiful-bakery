class_name GameManagerClass
extends Node
# manages the game state and the main game loop
# switches between menu and game levels

signal building_mode_switched(building_mode: bool)
signal exit_polled

var current_scene: Node
var building_mode: bool = false


# PUBLIC FUNCTIONS
func toggle_building_mode() -> void:
	building_mode = !building_mode
	if building_mode:
		print("Building Mode switched on")
		ItemManager.hide_all_ingredients()
		ItemManager.deactivate_droppables_on_machines()
		ItemManager.activate_draggable_on_machines()
		GridManager.activate_grids()
		InventoryManager.show_inventory()
	else:
		print("Building Mode switched off")
		ItemManager.show_all_ingredients()
		ItemManager.deactivate_draggable_on_machines()
		ItemManager.activate_droppables_on_machines()
		GridManager.deactivate_grids()
		InventoryManager.hide_inventory()
	building_mode_switched.emit(building_mode)


func get_current_scene() -> Node:
	return current_scene


func get_current_physics_space() -> PhysicsDirectSpaceState2D:
	if current_scene is Node2D:
		return current_scene.get_world_2d().direct_space_state
	return null


func is_ui_scene() -> bool:
	if current_scene is CanvasLayer:
		return true
	return false


func set_current_scene(scene: Node) -> void:
	current_scene = scene


func poll_exit() -> void:
	exit_polled.emit()

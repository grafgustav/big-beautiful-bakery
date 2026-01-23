class_name Main
extends Node

# this class is the TOP, the BABO, the JEFE
# this Node is the entry point for the game
# maybe here we initialize all the "autoloads" that we probably don't even need as Singletons, 
# let's see
# or maybe we add all possible scenes as child nodes and then hide() and show()
# The child-nodes are interchangeable
# Like this we can always have some sexy debug code about scene transitions in here
# first purpose: scene transitions and GUI rendering

var world_node: Node
var gui_node: Node

# SCENES
# WORLD
var bakery_scene: Node
var test_scene: Node
var iso_test_scene: Node
var inventory_scene: Node
# GUI
var main_menu_scene: Node
var debug_overlay_scene: Node
var shop_scene: Node
var confirmation_dialog_scene: Node

var build_mode: bool = false
var ingredient_nodes: Array[Node] = []

var current_scene: Node
var current_ui: Node

var confirmation_action: Callable

# WORLD
@export var bakery_packed_scene: PackedScene
@export var test_packed_scene: PackedScene
@export var iso_test_packed_scene: PackedScene
# GUI
@export var main_menu_packed_scene: PackedScene
@export var inventory_packed_scene: PackedScene
@export var shop_packed_scene: PackedScene
@export var confirmation_dialog_packed_scene: PackedScene

@export var debug_overlay_packed_scene: PackedScene


# API FUNCTIONS
func _ready() -> void:
	world_node = %World
	gui_node = %GUI
	instantiate_scenes()
	_connect_to_events()
	_start_up_application()


# PUBLIC FUNCTIONS
func instantiate_scenes() -> void:
	print("Instantiating Scenes")
	# instantiate the scenes only once
	# WORLD
	bakery_scene = bakery_packed_scene.instantiate()
	_add_scene_to_tree(bakery_scene, world_node)
	test_scene = test_packed_scene.instantiate()
	_add_scene_to_tree(test_scene, world_node)
	iso_test_scene = iso_test_packed_scene.instantiate()
	_add_scene_to_tree(iso_test_scene, world_node)
	# GUI
	main_menu_scene = main_menu_packed_scene.instantiate()
	_add_scene_to_tree(main_menu_scene, gui_node)
	inventory_scene = inventory_packed_scene.instantiate()
	_add_scene_to_tree(inventory_scene, gui_node)
	debug_overlay_scene = debug_overlay_packed_scene.instantiate()
	_add_scene_to_tree(debug_overlay_scene, gui_node)
	shop_scene = shop_packed_scene.instantiate()
	_add_scene_to_tree(shop_scene, gui_node)
	confirmation_dialog_scene = confirmation_dialog_packed_scene.instantiate()
	_add_scene_to_tree(confirmation_dialog_scene, gui_node)
	hide_all_scenes()
	print("All scenes instantiated and hidden")


func hide_all_scenes() -> void:
	# hides all scenes
	bakery_scene.hide()
	bakery_scene.process_mode = Node.PROCESS_MODE_DISABLED
	test_scene.hide()
	test_scene.process_mode = Node.PROCESS_MODE_DISABLED
	iso_test_scene.hide()
	iso_test_scene.process_mode = Node.PROCESS_MODE_DISABLED
	main_menu_scene.hide()
	main_menu_scene.process_mode = Node.PROCESS_MODE_DISABLED
	inventory_scene.hide()
	inventory_scene.process_mode = Node.PROCESS_MODE_DISABLED
	debug_overlay_scene.hide()
	debug_overlay_scene.process_mode = Node.PROCESS_MODE_DISABLED
	shop_scene.hide()
	shop_scene.process_mode = Node.PROCESS_MODE_DISABLED
	confirmation_dialog_scene.hide()
	confirmation_dialog_scene.process_mode = Node.PROCESS_MODE_DISABLED


# PRIVATE FUNCTIONS
func _start_up_application() -> void:
	print("Starting up application")
	# load player data from persistence
	_change_to_main_menu_scene()
	current_scene = main_menu_scene
	GameManager.set_current_scene(current_scene)


func _add_scene_to_tree(scene: Node, par: Node) -> void:
	par.add_child(scene)


func _connect_to_events() -> void:
	main_menu_scene.connect("bakery_scene_button_pressed", _change_to_bakery_scene)
	main_menu_scene.connect("test_scene_button_pressed", _change_to_iso_test_scene)
	main_menu_scene.connect("shop_scene_button_pressed", _change_to_shop_scene)
	
	confirmation_dialog_scene.connect("cancelled", _hide_confirmation_dialog_scene)
	confirmation_dialog_scene.connect("confirmed", _execute_confirmation_action)
	
	GameManager.connect("building_mode_switched", _change_building_mode)
	GameManager.connect("exit_polled", _show_confirmation_dialog_scene)


func _change_to_bakery_scene() -> void:
	hide_all_scenes()
	bakery_scene.show()
	bakery_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	current_scene = bakery_scene
	GameManager.set_current_scene(current_scene)


func _change_to_test_scene() -> void:
	hide_all_scenes()
	test_scene.show()
	test_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	current_scene = test_scene
	GameManager.set_current_scene(current_scene)


func _change_to_iso_test_scene() -> void:
	hide_all_scenes()
	iso_test_scene.show()
	iso_test_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	current_scene = iso_test_scene
	GameManager.set_current_scene(current_scene)
	_show_debug_overlay()


func _change_to_main_menu_scene() -> void:
	hide_all_scenes()
	main_menu_scene.show()
	main_menu_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	current_scene = main_menu_scene
	GameManager.set_current_scene(current_scene)
	_hide_debug_overlay()


func _change_to_shop_scene() -> void:
	hide_all_scenes()
	shop_scene.show()
	shop_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	current_scene = shop_scene
	GameManager.set_current_scene(current_scene)


func _show_debug_overlay() -> void:
	debug_overlay_scene.show()
	debug_overlay_scene.process_mode = Node.PROCESS_MODE_ALWAYS


func _hide_debug_overlay() -> void:
	debug_overlay_scene.hide()
	debug_overlay_scene.process_mode = Node.PROCESS_MODE_DISABLED


func _show_inventory_scene() -> void:
	inventory_scene.show()
	inventory_scene.process_mode = Node.PROCESS_MODE_ALWAYS


func _hide_inventory_scene() -> void:
	inventory_scene.hide()
	inventory_scene.process_mode = Node.PROCESS_MODE_DISABLED


func _show_confirmation_dialog_scene() -> void:
	confirmation_dialog_scene.show()
	confirmation_dialog_scene.process_mode = Node.PROCESS_MODE_ALWAYS


func _hide_confirmation_dialog_scene() -> void:
	confirmation_dialog_scene.hide()
	confirmation_dialog_scene.process_mode = Node.PROCESS_MODE_DISABLED


func _execute_confirmation_action() -> void:
	_change_to_main_menu_scene()
	_hide_confirmation_dialog_scene()


func _change_building_mode(mode: bool) -> void:
	if mode:
		_show_inventory_scene()
	else:
		_hide_inventory_scene()

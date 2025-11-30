class_name Main
extends Node

# this class is the TOP, the BABO, the JEFE
# this Node is the entry point for the game
# maybe here we initialize all the "autoloads" that we probably don't even need as Singletons, let's see
# or maybe we add all possible scenes as child nodes and then hide() and show()
# The child-nodes are interchangeable
# Like this we can always have some sexy debug code about scene transitions in here
# first purpose: scene transitions and GUI rendering

var world_node: Node
var gui_node: Node

var bakery_scene: Node
var main_menu_scene: Node
var test_scene: Node

var build_mode: bool = false
var ingredient_nodes: Array[Node] = []

@export var bakery_packed_scene: PackedScene
@export var main_menu_packed_scene: PackedScene
@export var test_packed_scene: PackedScene


func _ready() -> void:
	world_node = %World
	gui_node = %GUI
	instantiate_scenes()
	connect_to_events()
	start_up_application()


func instantiate_scenes() -> void:
	print("Instantiating Scenes")
	# instantiate the scenes only once
	bakery_scene = bakery_packed_scene.instantiate()
	add_scene_to_tree(bakery_scene, world_node)
	main_menu_scene = main_menu_packed_scene.instantiate()
	add_scene_to_tree(main_menu_scene, gui_node)
	test_scene = test_packed_scene.instantiate()
	add_scene_to_tree(test_scene, world_node)
	hide_all_scenes()
	print("All scenes instantiated and hidden")


func add_scene_to_tree(scene: Node, par: Node) -> void:
	par.add_child(scene)


func hide_all_scenes() -> void:
	# hides all scenes
	bakery_scene.hide()
	test_scene.hide()
	main_menu_scene.hide()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		DialogManager.show_confirm_dialog(_change_to_main_menu_scene)
		# for now we use this to switch back to main menu
		# on mobile we need a new thing obv


func connect_to_events() -> void:
	main_menu_scene.connect("bakery_scene_button_pressed", _change_to_bakery_scene)
	main_menu_scene.connect("test_scene_button_pressed", _change_to_test_scene)


func start_up_application() -> void:
	print("Starting up application")
	# load player data from persistence
	main_menu_scene.show()


func _change_to_bakery_scene() -> void:
	hide_all_scenes()
	bakery_scene.show()


func _change_to_test_scene() -> void:
	hide_all_scenes()
	test_scene.show()


func _change_to_main_menu_scene() -> void:
	hide_all_scenes()
	main_menu_scene.show()


func toggle_build_mode() -> void:
	print("Toggling build mode")
	# toggle flag
	build_mode = !build_mode
	if build_mode:
		print("Entering Build Mode")
		ingredient_nodes = _get_ingredient_nodes()
		_hide_ingredient_nodes()
	else:
		print("Exiting Build Mode")
		_show_ingredient_nodes()


func _get_ingredient_nodes() -> Array[Node]:
	return []


func _hide_ingredient_nodes() -> void:
	pass


func _show_ingredient_nodes() -> void:
	pass

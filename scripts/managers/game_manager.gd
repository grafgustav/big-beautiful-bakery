class_name GameManagerClass
extends Node
# manages the game state and the main game loop
# switches between menu and game levels


var current_scene: Node
var building_mode: bool = false


# PUBLIC FUNCTIONS
func toggle_building_mode() -> void:
	building_mode = !building_mode
	if building_mode:
		print("Building Mode switched on")
		_draw_building_grid()
		# _hide_all_ingredients()
	else:
		print("Building Mode switched off")
		pass


# PRIVATE FUNCTIONS
func _hide_all_ingredients() -> void:
	print("Hiding all ingredients")
	print("Parent: ", get_parent())
	print("Siblings: ", get_parent().get_children())
	print("Children: ", get_children())
	
	var ingredient_components = get_parent().find_children("*", "IngredientComponent")
	print(ingredient_components.size()," Ingredients found")
	for n in ingredient_components:
		print("Hiding ", n)
		n.get_parent().hide()


func _draw_building_grid() -> void:
	GridManager.draw_view_grid()

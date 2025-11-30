class_name PlayerManagerClass
extends Node

# this class manages all player state
# including money, exerience, available recipes, etc
# TODO: Look into persistence
var xp: int = 0
var money: int = 0


# methods to connect the PlayerManager to objects when spawning
func connect_to_recipe_finished_event(node: Node) -> void:
	node.connect("recipe_finished", _on_process_finished)


func _on_process_finished(recipe: RecipeData) -> void:
	print("Adding xp: ", recipe.xp_earned)
	earn_xp(recipe.xp_earned)


func earn_xp(amount: int):
	xp += amount


func spend_xp(amount: int):
	xp -= amount


func earn_money(amount: int):
	money += amount


func spend_money(amount: int):
	money -= amount


func can_spend_money(amount: int) -> bool:
	return money >= amount

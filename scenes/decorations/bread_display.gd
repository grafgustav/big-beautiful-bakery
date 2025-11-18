class_name BreadDisplay
extends Node2D


# we use this for now to sell items - directly returns money
# this serves to implement global player management


func drop_ingredient(ingredient: IngredientData) -> bool:
	print("Selling item: ", ingredient)
	PlayerManager.earn_money(ingredient.price || 0)
	return true

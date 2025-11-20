class_name BreadDisplay
extends Node2D


# we use this for now to sell items - directly returns money
# this serves to implement global player management


func drop_ingredient(ingredient: IngredientData) -> bool:
	print("Selling item: ", ingredient, " for ", ingredient.price)
	var profit := ingredient.price if ingredient.price else 0
	PlayerManager.earn_money(profit)
	return true

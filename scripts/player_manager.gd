class_name PlayerManagerClass
extends Node

# this class manages all player state
# including money, exerience, available recipes, etc
# TODO: Look into persistence

var money: int = 0


func earn_money(amount: int):
	money += amount


func spend_money(amount: int):
	money -= amount


func can_spend_money(amount: int) -> bool:
	return money >= amount

class_name BaseItem
extends Resource

## This class is the base representation of any useable, moveable or clickable
## item in the game. This includes ingredients and machines.


@export var _id: String
@export var display_name: String
@export var description: String
@export var base_price: float
@export var icon: Texture2D
@export var scene: PackedScene

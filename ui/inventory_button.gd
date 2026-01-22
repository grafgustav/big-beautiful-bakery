class_name InventoryButton
extends TextureButton


signal inventory_button_pressed(list_id: int)

var icon: Texture2D:
	set(value):
		icon = value
		if is_node_ready():
			icon_node.texture = value

var text: String:
	set(value):
		text = value
		if is_node_ready():
			label_node.text = value

var list_id: int = -1

@export var pressed_scale := Vector2(0.92, 0.92)
@export var scale_speed := 15.0

@onready var icon_node: TextureRect = $Icon
@onready var label_node: Label = $Label
@onready var border_node: TextureRect = $Border


func _ready():
	# Disable TextureButton textures – we draw everything ourselves
	texture_normal = null
	texture_pressed = null
	texture_hover = null
	texture_disabled = null

	icon_node.texture = icon
	label_node.text = text
	
	button_down.connect(_on_pressed)

	# Layout defaults
	icon_node.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon_node.anchor_left = 0
	icon_node.anchor_top = 0
	icon_node.anchor_right = 1
	icon_node.anchor_bottom = 1

	label_node.anchor_right = 1
	label_node.anchor_bottom = 1
	label_node.offset_right = -6
	label_node.offset_bottom = -4
	label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label_node.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM


func _on_pressed() -> void:
	print("Inventory button pressed")
	inventory_button_pressed.emit(list_id)

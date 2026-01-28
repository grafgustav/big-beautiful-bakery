class_name CustomIconButton
extends Button


## This button class is used to represent an item from base class @BaseItem

var custom_icon: Texture2D:
	set(value):
		custom_icon = value
		if is_node_ready():
			icon_node.texture = value

var custom_text: String:
	set(value):
		custom_text = value
		if is_node_ready():
			label_node.text = value

@onready var icon_node: TextureRect = $Icon
@onready var label_node: Label = $Label
@onready var border_node: TextureRect = $Border


func _ready():
	# set default icon and text to non-values
	icon = null
	text = ""

	icon_node.texture = custom_icon
	label_node.text = custom_text
	
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
	
	connect("button_down", _handle_button_pressed)


func _handle_button_pressed() -> void:
	pass

class_name Shop
extends CanvasLayer


var selected_item: ShopItem

var button_group: ButtonGroup

var shop_button_scene := preload("res://ui/Buttons/shop_button.tscn")

# TODO: Build more complex logic to add the buttons to the list
@onready var target_h_box := %HBoxContainer
@onready var left_panel := %LeftItemList
@onready var right_panel := %RightControlBar


func _ready() -> void:
	# TODO: Load everything from a central register of items (ItemManager?)
	var table_mixer := load("res://scenes/machines/Mixer/table_mixer.tres")
	var shop_table_mixer: ShopItem = ShopItem.from_base_item(table_mixer)
	var table_oven := load("res://scenes/machines/Mixer/table_oven.tres")
	var shop_table_oven: ShopItem = ShopItem.from_base_item(table_oven)
	
	var example_list = [shop_table_mixer, shop_table_oven]
	
	populate_buttons_from_list(example_list)


func _on_exit_button_pressed() -> void:
	GameManager.poll_exit()


func _untoggle_other_buttons(button: int) -> void:
	var item_buttons := left_panel.find_children("*Button")
	print("Buttons found in Panel: ", item_buttons)


func populate_buttons_from_list(list: Array) -> void:
	# create Button group
	var new_button_group := ButtonGroup.new()
	
	# iterate over list, create button for each item
	# add button to button group
	for item in list:
		var butt: ShopButton = shop_button_scene.instantiate()
		butt.custom_icon = item.icon
		butt.item = item
		butt.connect("shop_button_pressed", _handle_item_clicked)
		butt.button_group = new_button_group
		target_h_box.add_child(butt)
	
	button_group = new_button_group


func _handle_item_clicked(toggled: bool, item: ShopItem) -> void:
	print("Item clicked: ", item)
	print("Toggled: ", toggled)
	if toggled:
		show_item_info(item)
	else:
		hide_item_info()


func show_item_info(item: ShopItem) -> void:
	var name_label: Label = right_panel.find_child("NameLabel")
	name_label.text = item.display_name
	
	var description_label: RichTextLabel = right_panel.find_child("DescriptionLabel")
	description_label.text = item.description
	
	# TODO: Fix (currently only shows 0.0)
	print("item price: ", item.price)
	var price_label: Label = right_panel.find_child("PriceLabel")
	price_label.text = str(item.price)


func hide_item_info() -> void:
	var name_label: Label = right_panel.find_child("NameLabel")
	name_label.text = ""
	
	var description_label: RichTextLabel = right_panel.find_child("DescriptionLabel")
	description_label.text = ""
	
	var price_label: Label = right_panel.find_child("PriceLabel")
	price_label.text = ""
	

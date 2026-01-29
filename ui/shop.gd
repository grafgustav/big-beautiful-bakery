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


func populate_buttons_from_list(list: Array) -> void:
	# create Button group
	var new_button_group := ButtonGroup.new()
	
	# iterate over list, create button for each item
	# add button to button group
	for item in list:
		var butt: ShopButton = shop_button_scene.instantiate()
		target_h_box.add_child(butt)
		butt.item = item
		butt.custom_icon = item.icon
		butt.custom_text = str(item.price)
		#butt.button_group = new_button_group
		
		
		butt.connect("shop_button_pressed", _handle_item_clicked)
	
	button_group = new_button_group


func _handle_item_clicked(toggled: bool, item: ShopItem) -> void:
	if toggled:
		show_item_info(item)
		selected_item = item
	else:
		hide_item_info()
		selected_item = null


func show_item_info(item: ShopItem) -> void:
	var name_label: Label = right_panel.find_child("NameLabel")
	name_label.text = item.display_name
	
	var description_label: RichTextLabel = right_panel.find_child("DescriptionLabel")
	description_label.text = item.description
	
	var price_label: Label = right_panel.find_child("PriceLabel")
	price_label.text = str(item.price)


func hide_item_info() -> void:
	var name_label: Label = right_panel.find_child("NameLabel")
	name_label.text = ""
	
	var description_label: RichTextLabel = right_panel.find_child("DescriptionLabel")
	description_label.text = ""
	
	var price_label: Label = right_panel.find_child("PriceLabel")
	price_label.text = ""


func _on_buy_button_pressed() -> void:
	print("Trying to buy item: ", selected_item)
	if PlayerManager.can_spend_money(selected_item.price):
		var base_item: BaseItem = ShopItem.to_base_item(selected_item)
		InventoryManager.add_item(base_item)
		PlayerManager.spend_money(selected_item.price)
	else:
		print("Player is broke")

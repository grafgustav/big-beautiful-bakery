class_name ShopItem
extends BaseItem


@export var price: float
@export var purchasable: bool


## creates a new shop item from a base item
static func from_base_item(b_item: BaseItem) -> ShopItem:
	var new_item: ShopItem = ShopItem.new()
	new_item._id = b_item._id
	new_item.display_name = b_item.display_name
	new_item.description = b_item.description
	new_item.base_price = b_item.base_price
	new_item.icon = b_item.icon
	new_item.scene = b_item.scene
	new_item.price = b_item.base_price
	new_item.purchasable = false
	return new_item


## creates a new base item from a shop item
static func to_base_item(b_item: ShopItem) -> BaseItem:
	var new_item: BaseItem = BaseItem.new()
	new_item._id = b_item._id
	new_item.display_name = b_item.display_name
	new_item.description = b_item.description
	new_item.base_price = b_item.base_price
	new_item.icon = b_item.icon
	new_item.scene = b_item.scene
	return new_item

class_name IdleState
extends MixerState

@onready
var saltLoadedState := $"../SaltLoadedState"
@onready
var flourLoadedState := $"../FlourLoadedState"
@onready
var waterLoadedState := $"../WaterLoadedState"


func drop_item(item: Types.Items) -> MixingState:
	print("Dropping item: ", item)
	match item:
		Types.Items.SALT:
			return saltLoadedState
		Types.Items.FLOUR:
			return flourLoadedState
		Types.Items.WATER:
			return waterLoadedState
		_:
			return null

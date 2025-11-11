class_name WaterLoadedState
extends MixerState


@onready
var flourWaterLoadedState := $"../FlourWaterLoadedState"
@onready
var saltWaterLoadedState := $"../SaltWaterLoadedState"


func drop_item(item: Types.Items) -> MixingState:
	print("Dropping item: ", item)
	match item:
		Types.Items.SALT:
			return saltWaterLoadedState
		Types.Items.FLOUR:
			return flourWaterLoadedState
		_:
			return null

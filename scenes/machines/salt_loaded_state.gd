class_name SaltLoadedState
extends MixerState


@onready
var saltWaterLoadedState := $"../SaltWaterLoadedState"
@onready
var saltFlourLoadedState := $"../SaltFlourLoadedState"


func drop_item(item: Types.Items) -> MixingState:
	print("Dropping item: ", item)
	match item:
		Types.Items.FLOUR:
			return saltFlourLoadedState
		Types.Items.WATER:
			return saltWaterLoadedState
		_:
			return null

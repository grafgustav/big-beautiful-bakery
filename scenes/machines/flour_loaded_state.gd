class_name FlourLoadedState
extends MixerState


@onready
var flourWaterLoadedState := $"../FlourWaterLoadedState"
@onready
var saltFlourLoadedState := $"../SaltFlourLoadedState"


func drop_item(item: Types.Items) -> MixingState:
	print("Dropping item: ", item)
	match item:
		Types.Items.SALT:
			return saltFlourLoadedState
		Types.Items.WATER:
			return flourWaterLoadedState
		_:
			return null

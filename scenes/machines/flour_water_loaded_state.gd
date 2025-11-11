class_name FlourWaterLoadedState
extends MixerState


@onready
var mixingState := $"../MixingState"


func drop_item(item: Types.Items) -> MixingState:
	print("Dropping item: ", item)
	match item:
		Types.Items.SALT:
			return mixingState
		_:
			return null

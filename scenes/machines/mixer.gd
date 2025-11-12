class_name Mixer
extends Node2D


var animation_player : AnimatedSprite2D
var state_machine : MixerStateMachine


func _ready() -> void:
	animation_player = %AnimatedSprite2D
	state_machine = %MixerStateMachine
	state_machine.init(self, animation_player)
	

func _process(_delta: float) -> void:
	state_machine.update()
	
	
func _physics_process(_delta: float) -> void:
	state_machine.physics_update()


func drop_item(item: Types.Items) -> bool:
	return state_machine.drop_item(item)

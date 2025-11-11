class_name MixingState
extends MixerState


@export var countdown_time : int = 10

var timer : Timer
var progress_bar : ProgressBar

@onready var finishedState := $"../FinishedState"


func enter() -> void:
	super() # play animation
	# construct new timer and start
	timer = _create_timer(countdown_time)
	progress_bar = _create_progress_bar(countdown_time)
	timer.start()
	
	
func exit() -> void:
	# deconstruct timer
	timer.queue_free()
	progress_bar.queue_free()
	timer = null
	progress_bar = null


func physics_update() -> MixerState:
	if timer:
		progress_bar.value = timer.time_left
		if timer.is_stopped():
			return finishedState
	return null


func _create_timer(duration: int) -> Timer:
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()
	parent_ref.add_child(timer)
	return timer


func _create_progress_bar(duration: int) -> ProgressBar:
	# Create and configure the progress bar
	var progress_bar = ProgressBar.new()
	progress_bar.min_value = 0
	progress_bar.max_value = duration
	progress_bar.value = duration
	progress_bar.anchor_left = 0.5
	progress_bar.anchor_top = 0
	progress_bar.offset_left = -100  # half of width
	progress_bar.offset_top = 10
	progress_bar.size_flags_horizontal = Control.SIZE_FILL
	progress_bar.custom_minimum_size = Vector2(200, 20)
	progress_bar.add_theme_color_override("fg_color", Color(0.2, 0.8, 0.2))
	progress_bar.add_theme_color_override("bg_color", Color(0.1, 0.1, 0.1))

	# Wrap in a container to center it on the parent
	var canvas = CanvasLayer.new()
	canvas.layer = 100  # draw above everything
	canvas.add_child(progress_bar)
	parent_ref.add_child(canvas)
	
	return progress_bar

class_name ProcessingState
extends MachineState


var timer : Timer
var prog_bar : ProgressBar

@export var finishedState : MachineState


func enter() -> void:
	super()
	var countdown_time = parent_ref.recipe.processing_time
	
	timer = _create_timer(countdown_time)
	prog_bar = _create_progress_bar(countdown_time)
	timer.start()


func exit() -> void:
	timer.queue_free()
	prog_bar.queue_free()
	timer = null
	prog_bar = null


func physics_update() -> MachineState:
	if timer:
		prog_bar.value = timer.time_left
		if timer.is_stopped():
			return finishedState
	return null


func _create_timer(duration: float) -> Timer:
	var timer_instance = Timer.new()
	timer_instance.wait_time = duration
	timer_instance.one_shot = true
	parent_ref.add_child(timer_instance)
	timer_instance.start()
	
	return timer_instance


func _create_progress_bar(duration: int) -> ProgressBar:
	# Create and configure the progress bar
	# TODO: Center progress bar above parent object
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

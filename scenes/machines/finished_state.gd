class_name FinishedState
extends MixerState


var extractable_scene := preload("res://components/ExtractableComponent.tscn")
var extractable_component: ExtractableComponent

@export var idle_state: MixerState
@export var process_result: PackedScene
var extracted: bool = false


func enter() -> void:
	super()
	print("Entering Finished State")
	if !parent_ref:
		print("No parent ref set!")
		return
	
	extractable_component = extractable_scene.instantiate() as ExtractableComponent
	if !extractable_component:
		print("Extractable component could not be instantiated")
		return
	
	extractable_component.extractable_item = process_result
	
	parent_ref.add_child(extractable_component)
	extractable_component.global_position = parent_ref.global_position
	
	# add collision shape of parent
	var parent_collision_shape = _find_parents_collision_shape()
	if parent_collision_shape and parent_collision_shape is CollisionShape2D:
		var cloned_shape = CollisionShape2D.new()
		cloned_shape.shape = parent_collision_shape.shape.duplicate()
		cloned_shape.position = parent_collision_shape.position
		cloned_shape.rotation = parent_collision_shape.rotation
		cloned_shape.scale = parent_collision_shape.scale
		extractable_component.add_child(cloned_shape)
	else:
		print("No appropriate parent collision shape found")
		return
	
	if extractable_component.has_signal("extracted"):
		extractable_component.connect("extracted", _on_extracted)
		
	print("Extraction Component successfully added to parent node")


func exit() -> void:
	print("Exiting Finished State")
	# destroy Extractable Component
	if extractable_component:
		print("Removing Extractable component")
		extractable_component.queue_free()
		extractable_component = null


func update() -> MixerState:
	if extracted:
		return idle_state
	return null


func _on_extracted() -> void:
	print("Item extracted")
	extracted = true


func _find_parents_collision_shape() -> CollisionShape2D:
	var ret = parent_ref.find_children("*", "CollisionShape2D")
	print("CollisionShape found: ", ret)
	return ret[0]

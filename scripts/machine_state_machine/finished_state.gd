class_name FinishedState
extends MachineState


var extractable_scene := preload("res://components/ExtractableComponent.tscn")
var extractable_component: ExtractableComponent

@export var idle_state: MachineState

var output_list_expanded: Array[IngredientData] = []
var output_list_expanded_size: int = -1
var extraction_counter: int = -1


func enter() -> void:
	super()
	
	if !parent_ref:
		push_error("No parent ref set!")
		return
	
	extractable_component = extractable_scene.instantiate() as ExtractableComponent
	if !extractable_component:
		push_error("Extractable component could not be instantiated")
		return
	
	output_list_expanded = parent_ref.recipe.expand_outputs()
	output_list_expanded_size = output_list_expanded.size()
	extraction_counter = 0
	
	_set_extraction_model()
	
	parent_ref.add_child(extractable_component)
	extractable_component.global_position = parent_ref.global_position
	
	var parent_collision_shape = _find_parents_collision_shape()
	if parent_collision_shape and parent_collision_shape is CollisionShape2D:
		var cloned_shape = CollisionShape2D.new()
		cloned_shape.shape = parent_collision_shape.shape.duplicate()
		cloned_shape.position = parent_collision_shape.position
		cloned_shape.rotation = parent_collision_shape.rotation
		cloned_shape.scale = parent_collision_shape.scale
		cloned_shape.skew = parent_collision_shape.skew
		extractable_component.add_child(cloned_shape)
	else:
		push_error("No appropriate parent collision shape found")
		return
	
	if extractable_component.has_signal("extracted"):
		extractable_component.connect("extracted", _on_extracted)


func _set_extraction_model() -> void:
	var ingredient_data_extracted = output_list_expanded[extraction_counter]
	extractable_component.extractable_ingredient = ingredient_data_extracted


func exit() -> void:
	if extractable_component:
		extractable_component.queue_free()
		extractable_component = null
		extraction_counter = -1


func update() -> MachineState:
	if extraction_counter == output_list_expanded_size:
		_clean_parent_data()
		return idle_state
	return null


func _clean_parent_data() -> void:
	parent_ref.ingredient_list.clear()
	parent_ref.recipe = null


func _on_extracted() -> void:
	extraction_counter += 1
	if extraction_counter < output_list_expanded_size:
		_set_extraction_model()


func _find_parents_collision_shape() -> CollisionShape2D:
	var ret = parent_ref.find_children("*", "CollisionShape2D")
	return ret[0]

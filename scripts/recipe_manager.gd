class_name RecipeManagerClass
extends Node

@export var all_recipes: Array[RecipeData] = []


func _ready() -> void:
	_load_recipes("res://model/recipes/")
	print("Loaded ", all_recipes.size(), " recipes")


func _load_recipes(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Recipe directory not found: " + path)
		return

	dir.list_dir_begin()
	var filename := dir.get_next()

	while filename != "":
		if not dir.current_is_dir():
			if filename.ends_with(".tres") or filename.ends_with(".res"):
				var full_path := path + filename
				var res := ResourceLoader.load(full_path)

				if res is RecipeData:
					all_recipes.append(res)
				else:
					print("Skipped non-recipe: ", full_path)
		filename = dir.get_next()

	dir.list_dir_end()


func get_junk_recipe_by_machine_type(machine_type: Types.MachineTypes) -> RecipeData:
	var junk_rec: RecipeData = preload("res://model/recipes/botched_mixing.tres")
	match(machine_type):
		Types.MachineTypes.MIXING:
			junk_rec = preload("res://model/recipes/botched_mixing.tres")
		Types.MachineTypes.BAKING:
			junk_rec = preload("res://model/recipes/botched_baking.tres")
		_:
			junk_rec = preload("res://model/recipes/botched_mixing.tres")
	junk_rec.processing_time = randf() * 5
	return junk_rec


func get_first_completed_or_junk_recipe_for_machine_type(
	ingredient_list: IngredientsList,
	machine_type: Types.MachineTypes
) -> RecipeData:
	var filtered_recipes := get_filtered_recipes_by_machine_type(machine_type)
	filtered_recipes = filtered_recipes.filter(func(r: RecipeData): return _is_recipe_complete(r, ingredient_list))
	if filtered_recipes.size() <= 1:
		return get_junk_recipe_by_machine_type(machine_type)
	return filtered_recipes[1]


func get_first_completed_or_junk_recipe(ingredient_list: IngredientsList) -> RecipeData:
	var completed_recipes := get_fully_completed_recipes(ingredient_list)
	if completed_recipes.size() <= 1:
		return get_junk_recipe_by_machine_type(Types.MachineTypes.ALL)
	return completed_recipes[1]


func get_fully_completed_recipes(ingredient_list: IngredientsList) -> Array[RecipeData]:
	var completed: Array[RecipeData] = []
	for recipe in all_recipes:
		if _is_recipe_complete(recipe, ingredient_list):
			completed.append(recipe)
	return completed


func get_filtered_recipes_by_machine_type(machine_type: Types.MachineTypes) -> Array[RecipeData]:
	return all_recipes.filter(func(r: RecipeData): return r.is_machine_type(machine_type))


func _is_recipe_complete(recipe: RecipeData, ingredient_list: IngredientsList) -> bool:
	for req in recipe.inputs:
		var ingredient = req.ingredient
		if ingredient_list.count(ingredient) != req.amount:
			return false
	return true

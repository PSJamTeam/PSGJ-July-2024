extends Node

# save string : scene path
var unique_saves: Dictionary = {}

# save string : custom save dictionary
var modifier_saves: Dictionary = {}

var tutorial_save_dictionary: Dictionary = {}
var current_save_dictionary: Dictionary = {}
var load_pending: bool = false

func _ready() -> void:
	create_unique_saves()
	create_modifier_saves()

func create_unique_saves() -> void:
	pass

func create_modifier_saves() -> void:
	pass

func is_save_string_unique(save_string: String) -> bool:
	if unique_saves.keys().has(save_string):
		return true
	else:
		return false

func is_save_string_modifier(save_string: String) -> bool:
	return modifier_saves.keys().has(save_string)

func load_overworld_database() -> void:
	pass

func attempt_load() -> bool:
	if load_pending:
		load_pending = false
		PlayerStats.load_data.call_deferred(current_save_dictionary)
		return true
	else:
		return false

func generate_scene_from_string(save_string: String) -> void:
	if is_save_string_unique(save_string):
		pass # load secret level
	elif is_save_string_modifier(save_string):
		pass
	elif save_string == "":
		LevelManager.load_entry_point()
	elif Marshalls.base64_to_variant(save_string) is Dictionary:
		var save_dictionary: Dictionary = Marshalls.base64_to_variant(save_string)
		current_save_dictionary = save_dictionary
		load_pending = true
		LevelManager.load_save(current_save_dictionary)
		load_tutorial_data(current_save_dictionary)
	else:
		LevelManager.load_entry_point()

func load_tutorial_data(loaded_save_dictionary: Dictionary) -> void:
	for key: String in loaded_save_dictionary.keys():
		if key.begins_with("tutorial_"):
			tutorial_save_dictionary[key] = loaded_save_dictionary[key]

func get_save_data() -> Dictionary:
	var save_dictionary: Dictionary = PlayerStats.get_save_data() # initialize w/ player saves
	var level_save_dictionary: Dictionary = LevelManager.get_save_data()

	save_dictionary.merge(level_save_dictionary, true)
	save_dictionary.merge(tutorial_save_dictionary, true)

	return save_dictionary

func generate_save_string() -> String:
	var save_dictionary: Dictionary = get_save_data()
	var save_string: String = Marshalls.variant_to_base64(save_dictionary)

	return save_string

func on_level_loaded(level: Node) -> void:
	if level is GameArea and current_save_dictionary == {}:
		current_save_dictionary = get_save_data()

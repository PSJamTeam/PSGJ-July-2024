class_name BattlefieldRecipeController
extends Control

signal pressed(ability_name: String)

@onready var configurations: Array[Control] = [
	%Config1, %Config2, %Config3, %Config4, %Config5
]

var _current_config: int = -1

func _ready() -> void:
	for config: Control in configurations:
		for child: BattlefieldRecipePage in config.get_children():
			child.pressed.connect(
				func() -> void:
					pressed.emit(child.get_ability_name())
			)
		config.hide()

func set_data(data: Array[Dictionary]) -> void:
	if data.is_empty() or data.size() > 5: return

	var idx: int = 0
	for recipe_page: BattlefieldRecipePage in configurations[data.size()-1].get_children():
		recipe_page.set_data(
			data[idx]["name"],
			data[idx]["type"] as TypeChart.ResonateType,
			data[idx]["textures"]
		)
		idx += 1
	_current_config = data.size() - 1
	for child: BattlefieldRecipePage in configurations[_current_config].get_children():
		child.show()
	configurations[_current_config].show()


func hide_pages() -> void:
	if _current_config < 0: return

	for child: BattlefieldRecipePage in configurations[_current_config].get_children():
		child.hide()
	configurations[_current_config].hide()
	_current_config = -1
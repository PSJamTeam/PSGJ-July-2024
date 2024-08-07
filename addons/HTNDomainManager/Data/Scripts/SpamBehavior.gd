extends HTNTask
# IMPORTANT: For more information on what these functions do, refer to the
# documentation by pressing F1 on your keyboard and searching
# for HTNTask`. Happy scripting! :D

func run_operation(HTN_finished_op_callback: Callable, agent: Node, world_state: Dictionary) -> void:
	var enemy: BattlefieldAIEntity = agent as BattlefieldAIEntity
	var ability_idx: int = enemy.get_cheapest_ability()
	while ability_idx > -1:
		await enemy.activate_ability(ability_idx)
		await enemy.ability_finished
		ability_idx = enemy.get_cheapest_ability()
	HTN_finished_op_callback.call()

func apply_effects(world_state: Dictionary) -> void:
	pass # Replace with function body

func apply_expected_effects(world_state: Dictionary) -> void:
	pass # Replace with function body

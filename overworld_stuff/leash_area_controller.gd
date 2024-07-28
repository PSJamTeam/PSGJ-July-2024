class_name LeashArea
extends Area2D

@export_enum("None", "Item", "Shadow") var disable_type: String = "None"

@export var hint_dialogue: Dialogue

@export var redirect_marker: Marker2D
@export var disable_leash_name: String

func _ready() -> void:
	body_exited.connect(on_body_exited)
	LevelManager.world_event_occurred.connect(on_world_event)
	is_disabled()

func is_disabled() -> bool:
	match disable_type:
		"Item":
			var items: Dictionary = PlayerStats.get_inventory_items()
			if items.keys().has(disable_leash_name):
				queue_free()
				return true
			else:
				return false
		"Shadow":
			var unlocked_shadows: PackedStringArray = PlayerStats.get_all_unlocked_shadows()
			if unlocked_shadows.has(disable_leash_name):
				queue_free()
				return true
			else:
				return false
		_:
			return true

func is_player_in_area() -> bool:
	var detected_bodies: Array[Node2D] = get_overlapping_bodies()
	for body: Node2D in detected_bodies:
		if body is Player:
			return true
	
	return false

func on_body_exited(exited_body: Node2D) -> void:
	if not is_disabled() and not LevelManager.is_transitioning and exited_body is Player:
		redirect_player()

func redirect_player() -> void:
	if hint_dialogue != null:
		PlayerStats.player.play_hint(hint_dialogue)
	PlayerStats.player.redirect(redirect_marker.get_global_position())

func on_world_event(event_name:String, args: Array) -> void:
	if event_name == "battle_finished" and disable_type == "Shadow":
		if args[0]["shadow_name"] == disable_leash_name:
			queue_free()
	elif event_name == "item_get:"+disable_leash_name and disable_type == "Item":
		queue_free()

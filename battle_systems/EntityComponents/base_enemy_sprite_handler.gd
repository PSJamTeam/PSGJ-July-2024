class_name BattlefieldEnemySpriteHandler
extends Node2D

signal captured

@onready var shadow: Sprite2D = %Shadow
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var _original_shadow_frame_idx: int

func _ready() -> void:
	_original_shadow_frame_idx = shadow.frame
	animation_player.animation_finished.connect( func(__: String) -> void: captured.emit() )

func set_shadow_frame(frame_idx: int) -> void:
	if frame_idx < 0 or frame_idx > (shadow.hframes * shadow.vframes): return

	shadow.frame = frame_idx

func reset() -> void:
	shadow.frame = _original_shadow_frame_idx

func capture() -> void:
	animation_player.play("Capture")

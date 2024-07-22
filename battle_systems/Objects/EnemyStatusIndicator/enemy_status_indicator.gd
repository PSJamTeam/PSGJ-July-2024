class_name BattlefieldEnemyStatusIndicator
extends Control

@onready var resonate_indicator: BattlefieldResonateBar = %ResonateIndicator
@onready var primary: ProgressBar = %Primary
@onready var secondary: ProgressBar = %Secondary
@onready var hp_timer: Timer = %HPTimer

var _damage_pooled: int = 0
var _tween: Tween

func set_health_data(max_health: int) -> void:
	primary.max_value = max_health
	primary.value = max_health
	secondary.max_value = max_health
	secondary.value = max_health

func update_health(damage: int) -> void:
	_damage_pooled += damage
	primary.value -= damage
	if primary.value <= 0:
		_on_hp_timer_timeout()
	hp_timer.start()

func set_resonate(type: TypeChart.ResonateType) -> void:
	resonate_indicator.set_data(type)

func _on_hp_timer_timeout() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(secondary, "value", secondary.value - _damage_pooled, 0.25)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	_damage_pooled = 0

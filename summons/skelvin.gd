extends Node3D
class_name Skelvin


@onready var movement := $WanderMovement
@onready var attack_range := $AttackRange


func _on_character_turn_listener_on_turn():
	var attack_success = attack_range.attack_any()
	if attack_success:
		GlobalEvents.end_turn()

	movement.rand()
	GlobalEvents.end_turn()


func _on_health_health_depleted():
	queue_free()

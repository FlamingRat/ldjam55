extends Node3D
class_name Skelvin


@onready var movement := $CharacterMovementController
@onready var attack_range := $AttackRange


var actions = {
	1: func(): movement.move_right(),
	2: func(): movement.move_left(),
	3: func(): movement.move(Vector3.FORWARD),
	4: func(): movement.move(Vector3.BACK),
}


func _on_character_turn_listener_on_turn():
	var dir = randi_range(1, 4)
	actions[dir].call()
	attack_range.attack_any()

	GlobalEvents.end_turn()


func _on_health_health_depleted():
	queue_free()

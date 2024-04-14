extends Node3D
class_name Badgy


@onready var sight := $Sight
@onready var attack_range := $AttackRange
@onready var movement := $CharacterMovementController


func _on_character_turn_listener_on_turn():
	var attack_success = attack_range.attack_any()
	if attack_success:
		GlobalEvents.end_turn()
		return

	for area in sight.get_overlapping_areas():
		var body = area.get_parent()
		if body is Badgy:
			continue

		var dir: Vector3 = (body.global_position - global_position).normalized()
		var is_x = dir.x > dir.z
		var mult = -1 if (dir.x if is_x else dir.z) < 0 else 1
		movement.move((Vector3.RIGHT if is_x else Vector3.BACK) * mult)
		await get_tree().create_timer(0.4).timeout
		GlobalEvents.end_turn()
		return

	GlobalEvents.end_turn()


func _on_health_health_depleted():
	queue_free()

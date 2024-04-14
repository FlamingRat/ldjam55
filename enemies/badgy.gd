extends Node3D
class_name Badgy


@onready var sight := $Sight
@onready var attack_range := $AttackRange
@onready var movement := $CharacterMovementController
@onready var wander := $WanderMovement
@onready var alignment := $Alignment
var faction_self: Alignment.Faction:
	get:
		return alignment.faction


func _on_character_turn_listener_on_turn():
	var attack_success = attack_range.attack_any()
	if attack_success:
		GlobalEvents.end_turn()
		return

	for area in sight.get_overlapping_areas():
		var body = area.get_parent()
		print('detected ', body)
		var alignment: Alignment = body.get_node('Alignment')
		if not alignment or alignment.faction != faction_self:
			var dir: Vector3 = (body.global_position - global_position).normalized()
			print(dir)
			var is_x = abs(dir.x) > abs(dir.z)
			var mult = -1 if (dir.x if is_x else dir.z) < 0 else 1
			print(is_x, ' ', mult)
			movement.move((Vector3.RIGHT if is_x else Vector3.BACK) * mult)
			await get_tree().create_timer(0.4).timeout
			GlobalEvents.end_turn()
			return

	wander.rand()
	GlobalEvents.end_turn()


func _on_health_health_depleted():
	queue_free()

extends Node3D
class_name Spawner


@export var spawn: PackedScene
@export var spawn_cooldown: int
@onready var turn_counter = spawn_cooldown


func _on_character_turn_listener_on_turn():
	if turn_counter >= spawn_cooldown:
		var inst = spawn.instantiate()
		get_parent().add_child(inst)
		inst.global_position = global_position
		turn_counter = 0
	else:
		turn_counter += 1

	GlobalEvents.end_turn()

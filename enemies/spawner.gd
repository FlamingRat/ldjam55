extends Node3D
class_name Spawner


@export var spawn: PackedScene
@export var spawn_cooldown: int
@export var spawn_range: int
@export var spawn_per_turn: int
@export var turns_per_spawn_per_turn_increase: int
@onready var turn_counter = spawn_cooldown
var total_turn_counter = 0


func _on_character_turn_listener_on_turn():
	total_turn_counter += 1
	if not (total_turn_counter % turns_per_spawn_per_turn_increase):
		spawn_per_turn += 1
	
	if turn_counter >= spawn_cooldown:
		spawn_units()
		turn_counter = 0
	else:
		turn_counter += 1

	GlobalEvents.end_turn()


func spawn_units():
	for i in spawn_per_turn:
		var inst = spawn.instantiate()
		get_parent().add_child(inst)
		var randpos = Vector3(randi_range(0, spawn_range), 0, randi_range(0, spawn_range))
		inst.global_position = global_position + randpos

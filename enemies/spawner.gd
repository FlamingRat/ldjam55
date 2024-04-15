extends Node3D
class_name Spawner


@export var spawn: PackedScene
@export var spawn_cooldown: int
@export var spawn_range: int
@export var spawn_per_turn: int
@export var turns_per_spawn_per_turn_increase: int
@onready var turn_counter = spawn_cooldown
@onready var spawn_checker = $SpawnChecker
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
		var randpos = random_spawn()
		while not valid_spawn(randpos):
			randpos = random_spawn()

		inst.global_position = global_position + randpos


func random_spawn():
	return Vector3(randi_range(-spawn_range, spawn_range), 0, randi_range(-spawn_range, spawn_range))


func valid_spawn(pos: Vector3):
	spawn_checker.global_position = pos + Vector3.DOWN * 5
	spawn_checker.force_raycast_update()

	var collisions = []
	while spawn_checker.get_collider():
		spawn_checker.force_raycast_update()

		var coll = spawn_checker.get_collider()
		if not coll:
			continue

		collisions.append(coll)
		spawn_checker.add_exception(coll)

	spawn_checker.clear_exceptions()
	return not collisions.any(is_hitbox)


func is_hitbox(coll: Area3D):
	return coll is Hitbox

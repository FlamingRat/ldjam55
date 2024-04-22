extends Node3D
class_name Spawner


@export var spawn: PackedScene
@export var spawn_indicator: PackedScene
@export var spawn_range: int
@export var spawn_per_turn: int
@export var turns_per_spawn_per_turn_increase: int
@onready var spawn_checker = $SpawnChecker
var total_turn_counter = 1
var spawn_positions: Array[Node3D] = []


func _on_character_turn_listener_on_turn():
    if not (total_turn_counter % turns_per_spawn_per_turn_increase):
        spawn_per_turn += 1

    spawn_units()
    announce_next_spawn_positions()

    Store.dispatch(Store.Action.END_TURN)


func announce_next_spawn_positions():
    spawn_positions = []
    print('spawning ', spawn_per_turn)
    for i in spawn_per_turn:
        var randpos: Vector3 = random_spawn()
        while not valid_spawn(randpos):
            randpos = random_spawn()

        var indicator: Node3D = spawn_indicator.instantiate()
        get_parent().add_child(indicator)
        indicator.global_position = randpos
        spawn_positions.append(indicator)
    


func spawn_units():
    for indicator in spawn_positions:
        var inst = spawn.instantiate()
        get_parent().add_child.call_deferred(inst)
        inst.global_position = indicator.global_position
        indicator.queue_free()


func random_spawn() -> Vector3:
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

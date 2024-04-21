extends Node
class_name CharacterMovementController


@export var animation_tree: AnimationTree
@export var collision_detector: RayCast3D
@export var sfx: AudioStreamPlayer
var facing_right = true
var moving_direction = Vector3.ZERO


func snap_to_grid():
    var parent: Node3D = get_parent()
    if moving_direction.x and not is_integer(parent.global_position.x):
        if moving_direction.x > 0:
            parent.global_position.x = ceil(parent.global_position.x)
        else:
            parent.global_position.x = floor(parent.global_position.x)

    if moving_direction.z and not is_integer(parent.global_position.z):
        if moving_direction.z > 0:
            parent.global_position.z = ceil(parent.global_position.z)
        else:
            parent.global_position.z = floor(parent.global_position.z)


func is_integer(n: float):
    var integer = floor(n)
    return n - integer == 0


func move(dir: Vector3) -> void:
    var move_tween := create_tween()
    var parent = get_parent()
    if not movement_allowed(dir):
        return

    if sfx:
        sfx.play()

    snap_to_grid()
    moving_direction = dir
    var target: Vector3 = parent.global_position + dir
    move_tween.tween_property(parent, "global_position", target, 0.3)
    Store.dispatch(Store.Action.UPDATE_CAMERA_POSITION, target)

    if dir.x < 0 and facing_right:
        animation_tree.set('parameters/turn_left/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
        facing_right = false

    if dir.x > 0 and not facing_right:
        animation_tree.set('parameters/turn_right/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
        facing_right = true

    await get_tree().create_timer(.5).timeout

    if sfx:
        sfx.stop()


func movement_allowed(direction: Vector3):
    if not collision_detector:
        printerr('Warn: Collision detector missing at ', self)
        return true

    var current_pos = get_parent().global_position
    if abs((current_pos + direction).x) > Store.state.level.size.x / 2:
        return false

    if abs((current_pos + direction).z) > Store.state.level.size.y / 2:
        return false

    collision_detector.global_position = current_pos
    collision_detector.target_position = direction * 1.25
    var collisions = []
    collision_detector.force_raycast_update()
    while collision_detector.get_collider():
        collision_detector.force_raycast_update()

        var coll := collision_detector.get_collider()
        if not coll:
            continue

        collisions.append(coll)
        collision_detector.add_exception(coll)

    collision_detector.clear_exceptions()
    return not collisions.any(is_hitbox)


func is_hitbox(coll: Area3D):
    return coll is Hitbox and coll.get_parent() != get_parent()

extends Node
class_name CharacterMovementController


@export var animation_tree: AnimationTree
@export var collision_detector: RayCast3D
var facing_right = true


func move(dir: Vector3) -> void:
	var move_tween := create_tween()
	var parent = get_parent()
	if not movement_allowed(dir):
		## TODO: play movement blocked sound
		return

	move_tween.tween_property(parent, "global_position", parent.global_position + dir, 0.3)

	if dir.x < 0 and facing_right:
		animation_tree.set('parameters/turn_left/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		facing_right = false

	if dir.x > 0 and not facing_right:
		animation_tree.set('parameters/turn_right/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		facing_right = true

	await get_tree().create_timer(.5).timeout


func movement_allowed(direction: Vector3):
	if not collision_detector:
		print('Warn: Collision detector missing at ', self)
		return true

	collision_detector.global_position = get_parent().global_position
	collision_detector.target_position = direction
	var collisions = []
	while collision_detector.get_collider():
		collision_detector.force_raycast_update()

		var coll = collision_detector.get_collider()
		collisions.append(coll)
		collision_detector.add_exception(coll)

	collision_detector.clear_exceptions()
	print('Checking colliders ', collisions)

	return not collisions.any(is_hitbox)


func is_hitbox(coll: Area3D):
	return coll is Hitbox and coll.get_parent() != get_parent()

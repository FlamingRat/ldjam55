extends Node
class_name CharacterMovementController


@export var animation_tree: AnimationTree
var facing_right = true


func move(dir: Vector3) -> void:
	var move_tween := create_tween()
	var parent = get_parent()
	move_tween.tween_property(parent, "global_position", parent.global_position + dir, 0.3)

	if dir.x < 0 and facing_right:
		animation_tree.set('parameters/turn_left/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		facing_right = false

	if dir.x > 0 and not facing_right:
		animation_tree.set('parameters/turn_right/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		facing_right = true

	await get_tree().create_timer(.5).timeout

extends Node
class_name CharacterMovementController


@export var animation_tree: AnimationTree
var facing_right = true


func move(dir: Vector3) -> void:
	var move_tween := create_tween()
	var parent = get_parent()
	move_tween.tween_property(parent, "global_position", parent.global_position + dir, 0.3)


func move_left() -> void:
	move(Vector3.LEFT)
	if not facing_right: return
	
	animation_tree.set('parameters/turn_left/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	facing_right = false


func move_right() -> void:
	move(Vector3.RIGHT)
	if facing_right: return

	animation_tree.set('parameters/turn_right/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	facing_right = true

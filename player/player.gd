extends Node3D
class_name Player


@onready var animation_tree = $AnimationTree


var facing_right = true


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		move(Vector3.FORWARD)
		
	if Input.is_action_just_pressed("ui_down"):
		move(Vector3.BACK)
		
	if Input.is_action_just_pressed("ui_left"):
		move(Vector3.LEFT)
		if facing_right:
			animation_tree.set('parameters/turn_left/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

		facing_right = false

	if Input.is_action_just_pressed("ui_right"):
		move(Vector3.RIGHT)
		if not facing_right:
			animation_tree.set('parameters/turn_right/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

		facing_right = true


func move(dir: Vector3) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + dir, 0.3)

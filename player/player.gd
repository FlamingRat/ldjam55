extends Node3D
class_name Player


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		move(Vector3.FORWARD)
		
	if Input.is_action_just_pressed("ui_down"):
		move(Vector3.BACK)
		
	if Input.is_action_just_pressed("ui_left"):
		move(Vector3.LEFT)
		
	if Input.is_action_just_pressed("ui_right"):
		move(Vector3.RIGHT)


func move(dir: Vector3) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + dir, 0.3)

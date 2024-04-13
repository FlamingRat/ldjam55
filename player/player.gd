extends Node3D
class_name Player


@onready var movement = $CharacterMovementController


var actions = {
	"ui_up": func(): movement.move(Vector3.FORWARD),
	"ui_down": func(): movement.move(Vector3.BACK),
	"ui_left": func(): movement.move_left(),
	"ui_right": func(): movement.move_right(),
}


func _process(_delta):
	for action in actions:
		if Input.is_action_just_pressed(action):
			actions[action].call()
			GlobalEvents.end_turn()

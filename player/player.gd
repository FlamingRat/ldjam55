extends Node3D
class_name Player


@onready var movement = $CharacterMovementController
var turn_actions = false


var actions = {
	"ui_up": func(): movement.move(Vector3.FORWARD),
	"ui_down": func(): movement.move(Vector3.BACK),
	"ui_left": func(): movement.move_left(),
	"ui_right": func(): movement.move_right(),
}


func _process(_delta):
	if turn_actions:
		turn_input_listener()


func _on_character_turn_listener_on_turn():
	turn_actions = true


func turn_input_listener():
	for action in actions:
		if Input.is_action_just_pressed(action):
			actions[action].call()
			turn_actions = false
			GlobalEvents.end_turn()

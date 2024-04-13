extends Node3D
class_name Player


enum PlayerState {
	WALKING,
	SUMMONING,
}


@export var skelvin: PackedScene
@onready var movement := $CharacterMovementController
@onready var summons := $SummonController
var turn_actions = false
var action_lock = false
var player_state = PlayerState.WALKING


var actions = {
	"ui_up": func(): return movement.move(Vector3.FORWARD),
	"ui_down": func(): return movement.move(Vector3.BACK),
	"ui_left": func(): return movement.move_left(),
	"ui_right": func(): return movement.move_right(),
	"ui_accept": start_summon,
}


func _process(_delta):
	action_lock = false
	if turn_actions and player_state == PlayerState.WALKING:
		turn_input_listener()


func _on_character_turn_listener_on_turn():
	turn_actions = true


func turn_input_listener():
	for action in actions:
		if not Input.is_action_just_pressed(action):
			continue

		action_lock = true
		var done = actions[action].call()
		if done:
			end_turn()


func start_summon():
	player_state = PlayerState.SUMMONING
	summons.start_summon(Vector3.RIGHT if movement.facing_right else Vector3.LEFT)
	return false


func summon(pos: Vector3):
	player_state = PlayerState.WALKING
	var inst_skelvin: Skelvin = skelvin.instantiate()
	get_parent().add_child(inst_skelvin)
	inst_skelvin.global_position = pos
	end_turn()


func end_turn():
	turn_actions = false
	GlobalEvents.end_turn()

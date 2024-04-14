extends Node3D
class_name Player


@export var skelvin: PackedScene
@export var movement_speed: int
@export var mana: int = 1
@export var summon_range: int = 2
@onready var movement := $CharacterMovementController
@onready var summons := $SummonController
@onready var collision_detector := $CollisionDetector
@onready var steps_available = movement_speed
@onready var current_mana = mana


var turn_actions: bool:
	get:
		return GlobalEvents.current_turn_unit == self


var actions = {
	"ui_up": move_up,
	"ui_down": move_down,
	"ui_left": move_left,
	"ui_right": move_right,
	"ui_accept": start_summon,
	"end_turn": end_turn,
}


func _process(_delta):
	if GlobalEvents.current_turn_unit == self:
		turn_input_listener()


func _on_character_turn_listener_on_turn():
	steps_available = movement_speed
	current_mana = mana


func turn_input_listener():
	for action in actions:
		if not Input.is_action_just_pressed(action):
			continue

		actions[action].call()


func start_summon():
	if not current_mana or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
		return

	GlobalEvents.player_state = GlobalEvents.PlayerState.SUMMONING
	summons.start_summon(Vector3.RIGHT if movement.facing_right else Vector3.LEFT)


func summon(pos: Vector3):
	GlobalEvents.player_state = GlobalEvents.PlayerState.WALKING
	var inst_skelvin: Skelvin = skelvin.instantiate()
	get_parent().add_child(inst_skelvin)
	inst_skelvin.global_position = pos
	current_mana -= 1


func move_up():
	if not steps_available or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
		return

	if not movement.movement_allowed(Vector3.FORWARD):
		return

	movement.move(Vector3.FORWARD)
	steps_available -= 1


func move_down():
	if not steps_available or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
		return

	if not movement.movement_allowed(Vector3.BACK):
		return

	movement.move(Vector3.BACK)
	steps_available -= 1


func move_left():
	if not steps_available or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
		return

	if not movement.movement_allowed(Vector3.LEFT):
		return

	movement.move(Vector3.LEFT)
	steps_available -= 1


func move_right():
	if not steps_available or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
		return

	if not movement.movement_allowed(Vector3.RIGHT):
		return

	movement.move(Vector3.RIGHT)
	steps_available -= 1


func end_turn():
	GlobalEvents.end_turn()


func _on_health_health_depleted():
	queue_free()

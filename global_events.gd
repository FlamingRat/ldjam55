extends Node


const TURN_TIME: float = 5


enum PlayerState {
	WALKING,
	SUMMONING,
}


signal next_turn(unit: Node3D)
signal next_turn_announced(unit: Node3D)
signal attack(attacker: AttackRange, health: Health)


var level_size = Vector2(21, 15)
var timer = TURN_TIME
var units = []
var current_turn: int = 0
var current_turn_unit: Node3D:
	get:
		if not len(units):
			return

		if current_turn > len(units) - 1:
			current_turn = 0

		return units[current_turn]
var player_state = PlayerState.WALKING


func end_turn():
	current_turn += 1

	next_turn_announced.emit(current_turn_unit)


func start_turn():
	next_turn.emit(current_turn_unit)	


func register_unit(unit: Node3D):
	units.append(unit)
	unit.tree_exiting.connect(func(): unregister_unit(unit))


func unregister_unit(unit: Node3D):
	units.remove_at(units.find(unit))

extends Node


signal next_turn(unit: Node3D)
signal next_turn_announced(unit: Node3D)
signal attack(attacker: AttackRange, health: Health)


const TURN_TIME: float = 5


var timer = TURN_TIME
var units = []
var current_turn: int = 0
var current_turn_unit: Node3D:
	get:
		if current_turn > len(units) - 1:
			current_turn = 0

		return units[current_turn]


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

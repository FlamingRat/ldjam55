extends Node
class_name GlobalEventsNode


signal next_turn


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

	await get_tree().create_timer(0.5).timeout
	print(current_turn_unit)
	next_turn.emit(current_turn_unit)


func register_unit(unit: Node3D):
	units.append(unit)
	unit.tree_exiting.connect(func(): unregister_unit(unit))


func unregister_unit(unit: Node3D):
	units.remove_at(units.find(unit))

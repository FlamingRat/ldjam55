extends Node
class_name GlobalEventsNode


signal next_turn


const TURN_TIME: float = 5


var timer = TURN_TIME
var units = []
var current_turn: int = 0


func end_turn():
	current_turn += 1
	if current_turn > len(units) - 1:
		current_turn = 0

	await get_tree().create_timer(0.5).timeout
	print(units[current_turn])
	next_turn.emit(units[current_turn])


func register_unit(unit):
	units.append(unit)
	next_turn.emit(units[current_turn])

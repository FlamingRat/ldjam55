extends TextEdit
class_name BattleLog


func _ready():
	GlobalEvents.next_turn.connect(announce_turn)
	text += unit_name(GlobalEvents.current_turn_unit) + "'s turn!"

	GlobalEvents.attack.connect(announce_attack)


func announce_turn(unit: Node3D):
	if unit is Spawner:
		return

	text += '\n' + unit_name(unit) + "'s turn!"
	set_caret_line(get_line_count())


func unit_name(unit: Node3D):
	var char_turn: CharacterTurnListener = unit.get_node('CharacterTurnListener')
	var name = char_turn.unit_name if char_turn else unit.name
	return name


func announce_attack(attacker, target):
	var attacker_name = unit_name(attacker.get_parent())
	var target_name = unit_name(target.get_parent())
	text += '\n' + attacker_name + ' attacks ' + target_name + '!'
	set_caret_line(get_line_count())

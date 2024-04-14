extends TextEdit


func _ready():
	GlobalEvents.next_turn.connect(announce_turn)
	text += GlobalEvents.current_turn_unit.name + "'s turn!"

	GlobalEvents.attack.connect(announce_attack)


func announce_turn(unit: Node3D):
	if unit is Spawner:
		return

	text += '\n' + unit.name + "'s turn!"
	set_caret_line(get_line_count())


func announce_attack(attacker: AttackRange, target: Health):
	text += '\n' + attacker.get_parent().name + ' attacks ' + target.get_parent().name + '!'

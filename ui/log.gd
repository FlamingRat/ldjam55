extends TextEdit
class_name BattleLog


func _ready():
	Store.update.connect(update)


func update(state: Store.State):
	text = state.battle_log
	set_caret_line(get_line_count())

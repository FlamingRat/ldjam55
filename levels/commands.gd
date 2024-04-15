extends RichTextLabel


const BASE_COMMANDS = "[WASD/Arrow keys] Move
[1] Summon Skelvin
[Space] End turn"
const SUMMONING = "[WASD/Arrow keys] Move cursor
[Space] Confirm summon"


var player = true


func _ready():
	GlobalEvents.next_turn.connect(_on_turn)


func _process(_delta):
	if not player:
		text = ""
		return

	if GlobalEvents.player_state == GlobalEvents.PlayerState.SUMMONING:
		text = SUMMONING
	else:
		text = BASE_COMMANDS


func _on_turn(unit):
	player = unit is Player

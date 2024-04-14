extends RichTextLabel


const BASE_COMMANDS = "[Arrow keys] Move
[Space] Summon Skelvin
[E] End turn"
const SUMMONING = "[Arrow keys] Select summon placement
[Space] Confirm summoning"


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

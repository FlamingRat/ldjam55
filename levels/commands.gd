extends RichTextLabel


const BASE_COMMANDS = "[WASD/Arrow keys] Move
[1-2] Summon
[Space] End turn"
const SUMMONING = "[WASD/Arrow keys] Move cursor
[Space] Confirm summon"


var unit: Node3D


func _process(_delta):
    if not (unit is Player):
        text = ""
        return

    if unit.player_state == Player.PlayerState.SUMMONING:
        text = SUMMONING
    else:
        text = BASE_COMMANDS


func _on_turn(unit):
    unit = unit

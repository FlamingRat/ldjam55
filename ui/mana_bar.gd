extends ProgressBar
class_name ManaBar


@export var player: Player


func _process(_delta):
	max_value = player.mana
	value = player.current_mana

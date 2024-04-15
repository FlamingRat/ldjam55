extends ProgressBar
class_name ManaBar


@export var player: Player


func _process(_delta):
	if weakref(player).get_ref():
		max_value = player.mana
		value = player.current_mana

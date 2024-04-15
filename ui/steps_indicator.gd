extends Label
class_name StepsIndicator


@export var text_template: String = "Steppes: {}"
@export var player: Player


func _process(_delta):
	var steps_text = str(player.steps_available) + '/' + str(player.movement_speed)
	text = text_template.replace('{}', steps_text)

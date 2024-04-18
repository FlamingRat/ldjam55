extends Label
class_name StepsIndicator


@export var text_template: String = "Steppes: {}"
@export var player: Player


func _process(_delta):
    if not weakref(player).get_ref():
        return

    var steps_text = str(player.steps_available) + '/' + str(player.movement_speed)
    text = text_template.replace('{}', steps_text)

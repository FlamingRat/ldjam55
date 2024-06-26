extends ProgressBar
class_name HealthBar


@export var player: Player
@onready var health: Health = player.get_node('Health')


func _process(_delta):
    if weakref(health).get_ref():
        max_value = health.max_health
        value = health.current_health

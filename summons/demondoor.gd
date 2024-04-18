extends Node3D
class_name Demondoor


@onready var health := $Health


func _on_health_health_depleted():
    queue_free()


func _on_character_turn_listener_on_turn():
    health.current_health = min(health.max_health, health.current_health + 1)
    Store.dispatch(Store.Action.END_TURN)

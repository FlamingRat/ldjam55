extends Node
class_name Health


signal damaged(hit: int)
signal health_depleted


@export var max_health: int = 10
@export var current_health: int = 10
var percent: float:
	get:
		return float(current_health) / float(max_health)


func damage(hit: int):
	current_health -= hit
	damaged.emit(hit)
	if current_health <= 0:
		current_health = 0
		health_depleted.emit()

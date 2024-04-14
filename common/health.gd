extends Node
class_name Health


signal damaged(hit: int)
signal health_depleted


@export var max_health: int = 10
@export var animation_tree: AnimationTree
@onready var current_health: int = max_health
var percent: float:
	get:
		return float(current_health) / float(max_health)


func damage(hit: int):
	current_health -= hit
	if animation_tree:
		animation_tree.set('parameters/take_damage/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	damaged.emit(hit)
	if current_health <= 0:
		current_health = 0
		health_depleted.emit()

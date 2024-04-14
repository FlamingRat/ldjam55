extends Node
class_name WanderMovement


@export var movement_controller: CharacterMovementController


var actions = {
	1: func(): movement_controller.move(Vector3.RIGHT),
	2: func(): movement_controller.move(Vector3.LEFT),
	3: func(): movement_controller.move(Vector3.FORWARD),
	4: func(): movement_controller.move(Vector3.BACK),
}


func rand():
	var dir = randi_range(1, 4)
	actions[dir].call()

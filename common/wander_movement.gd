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
	var directions = allowed_directions()
	if not len(directions):
		return

	movement_controller.move(directions.pick_random())


func allowed_directions():
	var directions = []
	for dir in [Vector3.FORWARD, Vector3.LEFT, Vector3.BACK, Vector3.RIGHT]:
		if movement_controller.movement_allowed(dir):
			directions.append(dir)

	return directions

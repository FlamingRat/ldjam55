extends Node
class_name WanderMovement


@export var movement_controller: CharacterMovementController


func rand():
    var directions = allowed_directions()
    if not len(directions):
        return

    await movement_controller.move(directions.pick_random())


func allowed_directions():
    var directions = []
    for dir in [Vector3.FORWARD, Vector3.LEFT, Vector3.BACK, Vector3.RIGHT]:
        if movement_controller.movement_allowed(dir):
            directions.append(dir)

    print(directions)
    return directions

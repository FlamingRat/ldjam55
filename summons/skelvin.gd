extends Node3D
class_name Skelvin


@onready var movement := $WanderMovement
@onready var attack_range := $AttackRange


func _on_character_turn_listener_on_turn():
    var attack_success = await attack_range.attack_any()

    await movement.rand()
    if not attack_success:
        await attack_range.attack_any()

    Store.dispatch(Store.Action.END_TURN)


func _on_health_health_depleted():
    queue_free()

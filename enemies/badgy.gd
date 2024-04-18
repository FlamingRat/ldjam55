extends Node3D
class_name Badgy


@onready var sight := $Sight
@onready var attack_range := $AttackRange
@onready var movement := $CharacterMovementController
@onready var wander := $WanderMovement
@onready var alignment := $Alignment
@export var movement_speed: int
var faction_self: Alignment.Faction:
    get:
        return alignment.faction


func _on_character_turn_listener_on_turn():
    var attack_success = await attack_range.attack_any()

    for _loop in movement_speed:
        await step()

        if not attack_success:
            attack_success = await attack_range.attack_any()

    GlobalEvents.end_turn()


func step():
    for area in sight.get_overlapping_areas():
        var body = area.get_parent()
        var opp_alignment: Alignment = body.get_node('Alignment')
        if opp_alignment and opp_alignment.faction == faction_self:
            continue

        var dir: Vector3 = (body.global_position - global_position).normalized()
        var is_x = abs(dir.x) > abs(dir.z)
        var mult = -1 if (dir.x if is_x else dir.z) < 0 else 1
        var move_direction = (Vector3.RIGHT if is_x else Vector3.BACK) * mult

        if movement.movement_allowed(move_direction):
            movement.move(move_direction)
        else:
            wander.rand()

        await get_tree().create_timer(0.4).timeout
        return

    wander.rand()
    await get_tree().create_timer(0.4).timeout


func _on_health_health_depleted():
    queue_free()

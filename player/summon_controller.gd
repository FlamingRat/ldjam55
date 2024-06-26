extends Node
class_name SummonController


var summon_controls = {
    "move_up": up,
    "move_down": down,
    "move_left": left,
    "move_right": right,
    "confirm": confirm_summon,
}


@export var summon_indicator: PackedScene
@export var sfx: AudioStreamPlayer
@onready var player: Player = get_parent()
@onready var summon_position_validator := $SummonPositionValidator
var indicator: Node3D
var frame_lock = false


func _process(_delta):
    var summoning = player.player_state == player.PlayerState.SUMMONING
    if not summoning or frame_lock:
        frame_lock = false
        return

    for action in summon_controls:
        if not Input.is_action_just_pressed(action):
            continue

        summon_controls[action].call()


func start_summon():
    frame_lock = true
    indicator = summon_indicator.instantiate()
    player.add_child(indicator)
    indicator.position = Vector3.ZERO


func up():
    var intent = indicator.position + Vector3.FORWARD
    if intent.length() >= player.summon_range:
        return

    indicator.position = intent


func down():
    var intent = indicator.position + Vector3.BACK
    if intent.length() >= player.summon_range:
        return

    indicator.position = intent


func left():
    var intent = indicator.position + Vector3.LEFT
    if intent.length() >= player.summon_range:
        return

    indicator.position = intent


func right():
    var intent = indicator.position + Vector3.RIGHT
    if intent.length() >= player.summon_range:
        return

    indicator.position = intent


func confirm_summon():
    if not summon_allowed():
        return

    player.summon(player.global_position + indicator.position)
    indicator.queue_free()
    indicator = null
    sfx.play()


func summon_allowed():
    if not summon_position_validator:
        printerr('Warn: Summon validator missing at ', self)
        return true

    var current_pos = indicator.global_position
    if abs(current_pos.x) > Store.state.level.size.x / 2:
        return false

    if abs(current_pos.z) > Store.state.level.size.y / 2:
        return false

    var collisions = []
    summon_position_validator.global_position = Vector3.DOWN * 5 + current_pos
    summon_position_validator.force_raycast_update()
    while summon_position_validator.get_collider():
        var coll = summon_position_validator.get_collider()
        if not coll:
            continue

        collisions.append(coll)
        summon_position_validator.add_exception(coll)
        summon_position_validator.force_raycast_update()

    print(collisions)
    summon_position_validator.clear_exceptions()
    return not collisions.any(is_hitbox)


func is_hitbox(coll: Area3D):
    return coll is Hitbox
